import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'ads/ad_config.dart';
import 'ads/ad_entitlements.dart';
import 'ads/ad_manager.dart';
import 'ads/ad_service.dart';
import 'ads/interstitial_policy.dart';
import 'ads/network/admob/admob_network.dart';
import 'core/app_flavor.dart';
import 'core/app_licenses.dart';
import 'core/app_locale.dart';
import 'core/app_navigator.dart';
import 'core/app_theme.dart';
import 'core/app_theme_mode.dart';
import 'core/app_sounds.dart';
import 'core/onboarding_preferences.dart';
import 'core/play_mode.dart';
import 'data/hive_nonogram_local_service.dart';
import 'data/nonogram_puzzle_source.dart';
import 'data/nonogram_repository.dart';
import 'l10n/app_localizations.dart';
import 'premium/play_billing_gateway.dart';
import 'premium/premium_controller.dart';
import 'tester/tester_purchase_gateway.dart';
import 'tester/tester_settings.dart';
import 'checkin/check_in_service.dart';
import 'checkin/game_clock.dart';
import 'checkin/trusted_clock.dart';
import 'rating/app_rating.dart';
import 'screens/home/app_home_page.dart';
import 'screens/play_mode/play_mode_selection_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  registerAppLicenses();

  final flavor = AppFlavor.current;
  final android = !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  // Công cụ tester (tua giờ, cửa hàng giả, giải ngay...): chỉ bản `dev`.
  final tester = flavor.hasTesterTools ? await TesterSettings.load() : null;
  // Gói "Chơi không quảng cáo" bán qua Google Play: chỉ có trên Android (bản
  // `dev` thì có thêm cửa hàng giả của tester trên mọi nền tảng).
  final PremiumController? premium;
  if (tester != null) {
    premium = await PremiumController.load(
      gateway: TesterPurchaseGateway(
        settings: tester,
        real: android ? PlayBillingGateway() : null,
      ),
    );
  } else if (android) {
    premium = await PremiumController.load(gateway: PlayBillingGateway());
  } else {
    premium = null;
  }
  // Giờ của game theo giờ mạng (điểm danh, hạn của lượt trong ngày).
  final clock = await GameClock.load(
    trusted: NetworkTrustedClock(),
    debugShift: tester?.dayShift,
  );
  final checkIn = await CheckInService.load(
    clock: clock,
    isPremium: () => premium?.isPremium ?? false,
  );
  final launcher = AppLauncher(
    flavor: flavor,
    adService: createAdService(flavor, premium, tester: tester),
    premium: premium,
    tester: tester,
    clock: clock,
    checkIn: checkIn,
    // Lời mời đánh giá mở CH Play: chỉ có trên Android.
    rating:
        !kIsWeb && defaultTargetPlatform == TargetPlatform.android
            ? await AppRatingController.load()
            : null,
    themeMode: await AppThemeModeController.load(),
    sounds: await AppSoundController.load(),
    locale: await AppLocaleController.load(),
    onboarding: await OnboardingPreferences.load(),
    playModes: await PlayModePreferences.load(),
  );
  await launcher.launch();
}

/// Quảng cáo AdMob chỉ có trên Android (chưa cấu hình cho iOS). Bản `store`
/// dùng ID thật, bản `dev` dùng ID thử nghiệm (xem [AdConfig.forFlavor]).
/// Mua gói không quảng cáo ([premium]) thì tắt quảng cáo xen kẽ.
/// Công cụ tester ([tester]) bỏ được giãn cách quảng cáo xen kẽ.
AdService createAdService(
  AppFlavor flavor,
  PremiumController? premium, {
  TesterSettings? tester,
}) {
  final android = !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  if (!android) return NoAdService();
  final config = AdConfig.forFlavor(flavor);
  return AdManager(
    network: AdMobNetwork(),
    config: config,
    entitlements: premium ?? const NoAdEntitlements(),
    policy: InterstitialPolicy(
      config: config.interstitial,
      ignoreInterval: tester == null ? null : () => tester.adsNoInterval,
    ),
  );
}

/// Khởi động app: flavor `dev` hiện màn chọn chế độ chơi trước, flavor
/// `store` vào thẳng bộ màn có bản quyền (chế độ người dùng).
class AppLauncher {
  AppLauncher({
    required this.flavor,
    required this.adService,
    this.premium,
    this.tester,
    required this.clock,
    required this.checkIn,
    this.rating,
    required this.themeMode,
    required this.sounds,
    required this.locale,
    required this.onboarding,
    required this.playModes,
  });

  final AppFlavor flavor;
  final AdService adService;
  final PremiumController? premium;
  final TesterSettings? tester;
  final GameClock clock;
  final CheckInService checkIn;
  final AppRatingController? rating;
  final AppThemeModeController themeMode;
  final AppSoundController sounds;
  final AppLocaleController locale;
  final OnboardingPreferences onboarding;
  final PlayModePreferences playModes;

  Future<void> launch() async {
    // Không chặn lúc mở app: hỏi Google Play và đồng bộ giờ ở nền.
    final premium = this.premium;
    if (premium != null) {
      premium.addListener(checkIn.premiumChanged);
      premium.initialize();
    }
    checkIn.initialize();
    if (flavor.hasPlayModeSelection) {
      showModeSelection();
    } else {
      await start(PlayMode.user);
    }
  }

  void showModeSelection() {
    runApp(
      PlayModeSelectionApp(
        themeMode: themeMode,
        locale: locale,
        lastMode: playModes.lastMode,
        loadStats: loadPlayModeStats,
        onSelected: (mode) async {
          await playModes.save(mode);
          await start(mode);
        },
      ),
    );
  }

  Future<void> start(PlayMode mode) async {
    final localService = HiveNonogramLocalService(
      boxName: mode.progressBoxName,
    );
    await localService.initialize();

    // Bài hướng dẫn tự mở một lần, chỉ với người chưa giải màn nào. Đánh dấu
    // ngay từ đây để không bị mở lại dù người chơi thoát app giữa chừng.
    final completed = await localService.getCompletedProgress();
    final showTutorial = !onboarding.tutorialSeen && completed.isEmpty;
    await onboarding.markTutorialSeen();

    final repository = NonogramRepository(
      AssetNonogramPuzzleSource(basePath: mode.levelsPath),
      localService,
      today: () => clock.today,
    );

    runApp(
      NonogramApp(
        repository: repository,
        themeMode: themeMode,
        sounds: sounds,
        locale: locale,
        adService: adService,
        premium: premium,
        tester: tester,
        checkIn: checkIn,
        clock: clock,
        rating: rating,
        onboarding: onboarding,
        showTutorialOnStart: showTutorial,
        playModeSwitcher:
            flavor.hasPlayModeSelection
                ? PlayModeSwitcher(current: mode, switchMode: showModeSelection)
                : null,
      ),
    );

    checkIn.attach(repository);

    // Sau khi app đã hiện: hộp thoại xin đồng ý (nếu cần) nằm trên giao
    // diện game, và việc tải quảng cáo không làm chậm lúc mở app.
    adService.initialize();
  }

  /// Số màn đã giải / tổng số màn của một chế độ, hiện trên màn chọn chế độ.
  static Future<PlayModeStats> loadPlayModeStats(PlayMode mode) async {
    var total = 0;
    var solved = 0;
    try {
      total =
          await AssetNonogramPuzzleSource(
            basePath: mode.levelsPath,
          ).totalLevels();
    } catch (_) {}
    try {
      final local = HiveNonogramLocalService(boxName: mode.progressBoxName);
      await local.initialize();
      solved = (await local.getCompletedProgress()).length;
    } catch (_) {}
    return (solved: solved, total: total);
  }
}

/// Theme và chuỗi dịch dùng chung cho mọi MaterialApp của app.
class _AppMaterial extends StatelessWidget {
  const _AppMaterial({
    required this.themeMode,
    required this.locale,
    required this.home,
    this.navigatorKey,
  });

  final AppThemeModeController themeMode;
  final AppLocaleController locale;
  final Widget home;
  final GlobalKey<NavigatorState>? navigatorKey;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([themeMode, locale]),
      builder:
          (context, _) => MaterialApp(
            navigatorKey: navigatorKey,
            onGenerateTitle:
                (context) => AppLocalizations.of(context)!.appTitle,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode.value,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            // null = theo ngôn ngữ của máy (chọn bằng resolveAppLocale).
            locale: locale.value,
            localeListResolutionCallback: resolveAppLocale,
            home: home,
          ),
    );
  }
}

/// App rút gọn chỉ có màn chọn chế độ chơi.
class PlayModeSelectionApp extends StatelessWidget {
  const PlayModeSelectionApp({
    super.key,
    required this.themeMode,
    required this.locale,
    required this.onSelected,
    required this.loadStats,
    this.lastMode,
  });

  final AppThemeModeController themeMode;
  final AppLocaleController locale;
  final ValueChanged<PlayMode> onSelected;
  final PlayModeStatsLoader loadStats;
  final PlayMode? lastMode;

  @override
  Widget build(BuildContext context) {
    return _AppMaterial(
      themeMode: themeMode,
      locale: locale,
      home: PlayModeSelectionPage(
        onSelected: onSelected,
        loadStats: loadStats,
        lastMode: lastMode,
      ),
    );
  }
}

class NonogramApp extends StatelessWidget {
  const NonogramApp({
    super.key,
    required this.repository,
    required this.themeMode,
    required this.locale,
    this.sounds,
    this.adService,
    this.premium,
    this.tester,
    this.checkIn,
    this.clock,
    this.rating,
    this.onboarding,
    this.showTutorialOnStart = false,
    this.playModeSwitcher,
  });

  final NonogramRepository repository;
  final AppThemeModeController themeMode;
  final AppLocaleController locale;

  /// Null trong test: không phát tiếng.
  final AppSoundController? sounds;

  /// Null trong test: không có quảng cáo.
  final AdService? adService;

  /// Null trên iOS, web và trong test: không hỏi đánh giá.
  final AppRatingController? rating;

  /// Null trên iOS, web và trong test: không bán gói không quảng cáo.
  final PremiumController? premium;

  /// Chỉ có ở flavor `dev`: công cụ tester.
  final TesterSettings? tester;

  /// Null trong test: không có điểm danh.
  final CheckInService? checkIn;
  final GameClock? clock;

  /// Null trong test: không tự hiện hướng dẫn thao tác khi vào màn chơi.
  final OnboardingPreferences? onboarding;
  final bool showTutorialOnStart;

  /// Null ở flavor `store` (và trong test): không có lối đổi chế độ chơi.
  final PlayModeSwitcher? playModeSwitcher;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: repository),
        // ValueNotifier: phải dùng ChangeNotifierProvider, Provider thường
        // báo lỗi (assert) ngay khi khởi động ở bản debug.
        ChangeNotifierProvider.value(value: themeMode),
        ChangeNotifierProvider.value(value: locale),
        if (sounds != null) ChangeNotifierProvider.value(value: sounds!),
        Provider<AdService>.value(value: adService ?? NoAdService()),
        if (rating != null) Provider.value(value: rating!),
        if (premium != null) ChangeNotifierProvider.value(value: premium!),
        if (tester != null) ChangeNotifierProvider.value(value: tester!),
        if (checkIn != null) ChangeNotifierProvider.value(value: checkIn!),
        if (clock != null) ChangeNotifierProvider.value(value: clock!),
        if (onboarding != null) Provider.value(value: onboarding!),
        if (playModeSwitcher != null) Provider.value(value: playModeSwitcher!),
      ],
      child: ToastificationWrapper(
        child: _AppMaterial(
          themeMode: themeMode,
          locale: locale,
          navigatorKey: AppNavigator.navigatorKey,
          home: AppHomePage(showTutorialOnStart: showTutorialOnStart),
        ),
      ),
    );
  }
}

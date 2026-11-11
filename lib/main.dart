import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'core/app_flavor.dart';
import 'core/app_licenses.dart';
import 'core/app_navigator.dart';
import 'core/app_theme.dart';
import 'core/app_theme_mode.dart';
import 'core/onboarding_preferences.dart';
import 'core/play_mode.dart';
import 'data/hive_nonogram_local_service.dart';
import 'data/nonogram_puzzle_source.dart';
import 'data/nonogram_repository.dart';
import 'l10n/app_localizations.dart';
import 'screens/dashboard/nonogram_dashboard_page.dart';
import 'screens/play_mode/play_mode_selection_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  registerAppLicenses();

  final launcher = AppLauncher(
    flavor: AppFlavor.current,
    themeMode: await AppThemeModeController.load(),
    onboarding: await OnboardingPreferences.load(),
    playModes: await PlayModePreferences.load(),
  );
  await launcher.launch();
}

/// Khởi động app: flavor `dev` hiện màn chọn chế độ chơi trước, flavor
/// `store` vào thẳng bộ màn có bản quyền (chế độ người dùng).
class AppLauncher {
  AppLauncher({
    required this.flavor,
    required this.themeMode,
    required this.onboarding,
    required this.playModes,
  });

  final AppFlavor flavor;
  final AppThemeModeController themeMode;
  final OnboardingPreferences onboarding;
  final PlayModePreferences playModes;

  Future<void> launch() async {
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
    );

    runApp(
      NonogramApp(
        repository: repository,
        themeMode: themeMode,
        onboarding: onboarding,
        showTutorialOnStart: showTutorial,
        playModeSwitcher:
            flavor.hasPlayModeSelection
                ? PlayModeSwitcher(current: mode, switchMode: showModeSelection)
                : null,
      ),
    );
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
    required this.home,
    this.navigatorKey,
  });

  final AppThemeModeController themeMode;
  final Widget home;
  final GlobalKey<NavigatorState>? navigatorKey;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeMode,
      builder:
          (context, mode, _) => MaterialApp(
            navigatorKey: navigatorKey,
            onGenerateTitle:
                (context) => AppLocalizations.of(context)!.appTitle,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: mode,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
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
    required this.onSelected,
    required this.loadStats,
    this.lastMode,
  });

  final AppThemeModeController themeMode;
  final ValueChanged<PlayMode> onSelected;
  final PlayModeStatsLoader loadStats;
  final PlayMode? lastMode;

  @override
  Widget build(BuildContext context) {
    return _AppMaterial(
      themeMode: themeMode,
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
    this.onboarding,
    this.showTutorialOnStart = false,
    this.playModeSwitcher,
  });

  final NonogramRepository repository;
  final AppThemeModeController themeMode;

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
        if (onboarding != null) Provider.value(value: onboarding!),
        if (playModeSwitcher != null) Provider.value(value: playModeSwitcher!),
      ],
      child: ToastificationWrapper(
        child: _AppMaterial(
          themeMode: themeMode,
          navigatorKey: AppNavigator.navigatorKey,
          home: NonogramDashboardPage(showTutorialOnStart: showTutorialOnStart),
        ),
      ),
    );
  }
}

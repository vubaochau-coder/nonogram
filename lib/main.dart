import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import 'core/app_navigator.dart';
import 'core/app_theme.dart';
import 'core/app_theme_mode.dart';
import 'core/onboarding_preferences.dart';
import 'data/hive_nonogram_local_service.dart';
import 'data/nonogram_puzzle_source.dart';
import 'data/nonogram_repository.dart';
import 'l10n/app_localizations.dart';
import 'screens/dashboard/nonogram_dashboard_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final localService = HiveNonogramLocalService();
  await localService.initialize();
  final themeMode = await AppThemeModeController.load();

  // Bài hướng dẫn tự mở một lần, chỉ với người chưa giải màn nào. Đánh dấu
  // ngay từ đây để không bị mở lại dù người chơi thoát app giữa chừng.
  final onboarding = await OnboardingPreferences.load();
  final completed = await localService.getCompletedProgress();
  final showTutorial = !onboarding.tutorialSeen && completed.isEmpty;
  await onboarding.markTutorialSeen();

  final repository = NonogramRepository(
    AssetNonogramPuzzleSource(),
    localService,
  );

  runApp(
    NonogramApp(
      repository: repository,
      themeMode: themeMode,
      onboarding: onboarding,
      showTutorialOnStart: showTutorial,
    ),
  );
}

class NonogramApp extends StatelessWidget {
  const NonogramApp({
    super.key,
    required this.repository,
    required this.themeMode,
    this.onboarding,
    this.showTutorialOnStart = false,
  });

  final NonogramRepository repository;
  final AppThemeModeController themeMode;

  /// Null trong test: không tự hiện hướng dẫn thao tác khi vào màn chơi.
  final OnboardingPreferences? onboarding;
  final bool showTutorialOnStart;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: repository),
        // ValueNotifier: phải dùng ChangeNotifierProvider, Provider thường
        // báo lỗi (assert) ngay khi khởi động ở bản debug.
        ChangeNotifierProvider.value(value: themeMode),
        if (onboarding != null) Provider.value(value: onboarding!),
      ],
      child: ToastificationWrapper(
        child: ValueListenableBuilder<ThemeMode>(
          valueListenable: themeMode,
          builder:
              (context, mode, _) => MaterialApp(
                navigatorKey: AppNavigator.navigatorKey,
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
                home: NonogramDashboardPage(
                  showTutorialOnStart: showTutorialOnStart,
                ),
              ),
        ),
      ),
    );
  }
}

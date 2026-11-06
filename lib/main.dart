import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:toastification/toastification.dart';

import 'core/app_navigator.dart';
import 'core/app_theme.dart';
import 'core/app_theme_mode.dart';
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

  final repository = NonogramRepository(
    AssetNonogramPuzzleSource(),
    localService,
  );

  runApp(NonogramApp(repository: repository, themeMode: themeMode));
}

class NonogramApp extends StatelessWidget {
  const NonogramApp({
    super.key,
    required this.repository,
    required this.themeMode,
  });

  final NonogramRepository repository;
  final AppThemeModeController themeMode;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: repository),
        RepositoryProvider.value(value: themeMode),
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
                home: const NonogramDashboardPage(),
              ),
        ),
      ),
    );
  }
}

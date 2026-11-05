import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:toastification/toastification.dart';

import 'core/app_navigator.dart';
import 'core/app_theme.dart';
import 'data/hive_nonogram_local_service.dart';
import 'data/nonogram_puzzle_source.dart';
import 'data/nonogram_repository.dart';
import 'l10n/app_localizations.dart';
import 'screens/dashboard/nonogram_dashboard_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final localService = HiveNonogramLocalService();
  await localService.initialize();

  final repository = NonogramRepository(
    AssetNonogramPuzzleSource(),
    localService,
  );

  runApp(NonogramApp(repository: repository));
}

class NonogramApp extends StatelessWidget {
  const NonogramApp({super.key, required this.repository});

  final NonogramRepository repository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: repository,
      child: ToastificationWrapper(
        child: MaterialApp(
          navigatorKey: AppNavigator.navigatorKey,
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/checkin/check_in_page.dart';
import 'package:nonogram/checkin/check_in_service.dart';
import 'package:nonogram/checkin/game_clock.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/app_theme_mode.dart';
import 'package:nonogram/data/nonogram_repository.dart';
import 'package:nonogram/l10n/app_localizations.dart';
import 'package:nonogram/models/power_up_inventory.dart';
import 'package:nonogram/screens/dashboard/nonogram_dashboard_page.dart';
import 'package:provider/provider.dart';

import '../mocks/fake_nonogram_repository.dart';
import '../mocks/fake_purchase_gateway.dart';

void main() {
  late GameClock clock;
  late FakeNonogramRepository repository;
  late CheckInService service;

  Future<void> pump(WidgetTester tester, {bool showTutorial = false}) async {
    tester.view.physicalSize = const Size(412, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<NonogramRepository>.value(value: repository),
          ChangeNotifierProvider.value(
            value: AppThemeModeController.inMemory(),
          ),
          ChangeNotifierProvider.value(value: service),
          ChangeNotifierProvider.value(value: clock),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          locale: const Locale('vi'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: NonogramDashboardPage(showTutorialOnStart: showTutorial),
        ),
      ),
    );
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  setUp(() {
    final device = DateTime(2026, 11, 13, 9);
    clock = GameClock.inMemory(
      trusted: FakeTrustedClock(null),
      device: () => device,
    );
    repository = FakeNonogramRepository(today: () => clock.today);
    service = CheckInService.inMemory(clock: clock)..attach(repository);
  });

  tearDown(() => service.dispose());

  testWidgets('the home page no longer opens check-in by itself', (
    tester,
  ) async {
    await pump(tester);
    expect(find.byType(CheckInTab), findsNothing);
    expect(find.byKey(const ValueKey('dashboard-check-in')), findsNothing);
  });

  testWidgets('reminds premium players of unused today-only uses', (
    tester,
  ) async {
    await repository.savePowerUps(
      const PowerUpInventory(
        hints: 0,
        wands: 0,
      ).withDaily(hints: 2, wands: 1, day: clock.today),
    );
    await pump(tester);
    expect(
      find.byKey(const ValueKey('dashboard-daily-reminder')),
      findsOneWidget,
    );
    expect(find.textContaining('2 gợi ý · 1 gậy phép'), findsOneWidget);

    // Dùng hết: thẻ nhắc biến mất.
    await repository.savePowerUps(const PowerUpInventory(hints: 0, wands: 0));
    await tester.pump();
    expect(
      find.byKey(const ValueKey('dashboard-daily-reminder')),
      findsNothing,
    );
  });
}

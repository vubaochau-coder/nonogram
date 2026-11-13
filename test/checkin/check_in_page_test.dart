import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/checkin/check_in_page.dart';
import 'package:nonogram/checkin/check_in_service.dart';
import 'package:nonogram/checkin/game_clock.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/data/nonogram_repository.dart';
import 'package:nonogram/l10n/app_localizations.dart';
import 'package:nonogram/models/power_up_inventory.dart';
import 'package:provider/provider.dart';

import '../mocks/fake_nonogram_repository.dart';
import '../mocks/fake_purchase_gateway.dart';

void main() {
  late DateTime device;
  late GameClock clock;
  late FakeNonogramRepository repository;

  Future<CheckInService> pump(
    WidgetTester tester, {
    bool premium = false,
    int daysSinceStart = 0,
  }) async {
    device = DateTime(2026, 11, 13, 9);
    clock = GameClock.inMemory(
      trusted: FakeTrustedClock(null),
      device: () => device,
    );
    repository = FakeNonogramRepository(today: () => clock.today);
    await repository.savePowerUps(const PowerUpInventory(hints: 0, wands: 0));
    final service = CheckInService.inMemory(
      clock: clock,
      isPremium: () => premium,
      startDay: clock.today - daysSinceStart,
    )..attach(repository);
    addTearDown(service.dispose);
    tester.view.physicalSize = const Size(412, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<NonogramRepository>.value(value: repository),
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
          home: const CheckInPage(),
        ),
      ),
    );
    await tester.pump();
    return service;
  }

  testWidgets('check in once; button then says done', (tester) async {
    final service = await pump(tester);
    expect(find.text('Điểm danh'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('check-in-button')));
    await tester.pump();
    await tester.pump();
    expect(service.checkedInToday, isTrue);
    expect(find.text('Hôm nay đã điểm danh'), findsOneWidget);
    final button = tester.widget<ButtonStyleButton>(
      find.byKey(const ValueKey('check-in-button')),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('gift badges sit on the projected milestone days', (
    tester,
  ) async {
    await pump(tester);
    // Chưa điểm danh lần nào, hôm nay 13/11: lần thứ 5 là 17/11, thứ 10 là
    // 22/11.
    expect(find.byKey(const ValueKey('check-in-gift-17')), findsOneWidget);
    expect(find.byKey(const ValueKey('check-in-gift-22')), findsOneWidget);
    expect(find.byKey(const ValueKey('check-in-gift-16')), findsNothing);
    expect(find.byKey(const ValueKey('check-in-premium-today')), findsNothing);
  });

  testWidgets('premium sees today\'s card and today-only totals', (
    tester,
  ) async {
    await pump(tester, premium: true);
    expect(
      find.byKey(const ValueKey('check-in-premium-today')),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const ValueKey('check-in-button')));
    await tester.pump();
    await tester.pump();
    expect(find.byKey(const ValueKey('check-in-total-hint-daily')), findsOne);
    final total = tester.widget<Text>(
      find.byKey(const ValueKey('check-in-total-hint-daily')),
    );
    // 13..30/11 = 18 ngày × 2.
    expect(total.data, '2/36');
  });

  testWidgets('months before install cannot be opened', (tester) async {
    await pump(tester, daysSinceStart: 20);
    final prev = find.byKey(const ValueKey('check-in-prev-month'));
    expect(tester.widget<IconButton>(prev).onPressed, isNotNull);
    await tester.tap(prev);
    await tester.pump();
    final material = MaterialLocalizations.of(
      tester.element(find.byType(CheckInPage)),
    );
    expect(
      find.text(material.formatMonthYear(DateTime(2026, 10))),
      findsOneWidget,
    );
    expect(tester.widget<IconButton>(prev).onPressed, isNull);
    final next = find.byKey(const ValueKey('check-in-next-month'));
    await tester.tap(next);
    await tester.pump();
    expect(tester.widget<IconButton>(next).onPressed, isNull);
  });
}

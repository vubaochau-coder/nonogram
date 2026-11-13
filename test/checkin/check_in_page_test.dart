import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/checkin/check_in_page.dart';
import 'package:nonogram/checkin/check_in_policy.dart';
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
    int previousCheckIns = 0,
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
      startDay: clock.today - max(daysSinceStart, previousCheckIns),
      history: {
        for (var i = 1; i <= previousCheckIns; i++)
          clock.today - i: const <CheckInReward>[],
      },
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
          home: const CheckInTab(),
        ),
      ),
    );
    await tester.pump();
    return service;
  }

  /// Chạy hết hiệu ứng điểm danh (không có quà).
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 25; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  testWidgets('check in: the stamp lands on today, then the button hides', (
    tester,
  ) async {
    final service = await pump(tester);
    expect(find.text('Hôm nay chưa điểm danh'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('check-in-button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    // Đã lưu, nhưng ô hôm nay chờ quả cầu bay tới mới đổi.
    expect(service.checkedInToday, isTrue);
    expect(find.byKey(const ValueKey('check-in-checked-13')), findsNothing);

    await settle(tester);
    expect(find.byKey(const ValueKey('check-in-checked-13')), findsOneWidget);
    expect(find.text('Hôm nay đã điểm danh'), findsOneWidget);
    expect(find.byKey(const ValueKey('check-in-button')), findsNothing);
  });

  testWidgets('reduced motion checks in at once', (tester) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    final service = await pump(tester);
    await tester.tap(find.byKey(const ValueKey('check-in-button')));
    await tester.pump();
    await tester.pump();
    expect(service.checkedInToday, isTrue);
    expect(find.byKey(const ValueKey('check-in-checked-13')), findsOneWidget);
    expect(find.byKey(const ValueKey('check-in-gift-collect')), findsNothing);
    await settle(tester);
  });

  testWidgets('milestone day: the gift opens and is collected into totals', (
    tester,
  ) async {
    // 4 lần trước đó: lần điểm danh hôm nay là lần thứ 5, có quà gợi ý.
    final service = await pump(tester, previousCheckIns: 4);
    String hints() =>
        tester
            .widget<Text>(
              find.byKey(const ValueKey('check-in-total-hint-kept')),
            )
            .data!;
    final before = hints();
    expect(find.text('Hôm nay có quà!'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('check-in-button')));
    for (var i = 0; i < 34; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(service.checkedInToday, isTrue);
    final collect = find.byKey(const ValueKey('check-in-gift-collect'));
    expect(collect, findsOneWidget);
    // Chưa bấm "Nhận": tổng quà tháng chưa cộng.
    expect(hints(), before);

    await tester.tap(collect);
    await settle(tester);
    expect(collect, findsNothing);
    expect(hints(), isNot(before));
    expect(find.byKey(const ValueKey('check-in-button')), findsNothing);
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
    await settle(tester);
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
      tester.element(find.byType(CheckInTab)),
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

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/ads/ad_service.dart';
import 'package:nonogram/checkin/check_in_page.dart';
import 'package:nonogram/checkin/check_in_policy.dart';
import 'package:nonogram/checkin/check_in_service.dart';
import 'package:nonogram/checkin/game_clock.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/data/nonogram_repository.dart';
import 'package:nonogram/l10n/app_localizations.dart';
import 'package:nonogram/models/power_up_inventory.dart';
import 'package:provider/provider.dart';

import '../mocks/fake_ad_service.dart';
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
    AdService? ads,
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
          if (ads != null) Provider<AdService>.value(value: ads),
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

  /// Chạy hiệu ứng thêm [ms] mili giây.
  Future<void> run(WidgetTester tester, int ms) async {
    for (var i = 0; i < ms ~/ 100; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Finder day(int d, String status) =>
      find.byKey(ValueKey('check-in-day-$d-$status'));
  Finder node(int m, String state) =>
      find.byKey(ValueKey('check-in-milestone-$m-$state'));
  final collect = find.byKey(const ValueKey('check-in-gift-collect'));

  testWidgets('check in: the stamp lands on today, then the button is done', (
    tester,
  ) async {
    final service = await pump(tester);
    expect(find.text('Điểm danh hôm nay'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('check-in-button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    // Đã lưu, nhưng ô hôm nay chờ quả cầu bay tới mới đổi.
    expect(service.checkedInToday, isTrue);
    expect(day(13, 'today'), findsOneWidget);

    await run(tester, 2000);
    expect(day(13, 'checked'), findsOneWidget);
    expect(find.text('Hôm nay đã điểm danh'), findsOneWidget);
    expect(find.text('Chuỗi 1 ngày'), findsOneWidget);
  });

  testWidgets('reduced motion checks in at once', (tester) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    final service = await pump(tester, previousCheckIns: 6);
    await tester.tap(find.byKey(const ValueKey('check-in-button')));
    await tester.pump();
    await tester.pump();
    expect(service.checkedInToday, isTrue);
    expect(day(13, 'checked'), findsOneWidget);
    expect(collect, findsNothing);
    expect(node(7, 'claimed'), findsOneWidget);
    await run(tester, 2500);
  });

  testWidgets('7 days in a row: the gift jumps out of the milestone', (
    tester,
  ) async {
    final service = await pump(tester, previousCheckIns: 6);
    expect(find.text('Hôm nay có quà!'), findsOneWidget);
    expect(node(7, 'next'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('check-in-button')));
    // Đóng dấu xong, thanh chạy tới mốc 7: mốc chờ mở quà.
    await run(tester, 2700);
    expect(node(7, 'ready'), findsOneWidget);
    await run(tester, 2000);
    expect(collect, findsOneWidget);
    expect(service.claimedMilestones(2026, 11), {7});

    await tester.tap(collect);
    await run(tester, 1000);
    expect(collect, findsNothing);
    expect(node(7, 'claimed'), findsOneWidget);
    expect(node(14, 'next'), findsOneWidget);
    expect(
      (await repository.getPowerUps()).hints,
      CheckInPolicy.streakReward(7).amount,
    );
  });

  testWidgets('calendar: checked, missed, today and locked days', (
    tester,
  ) async {
    // Bắt đầu 8/11; điểm danh 8–11, bỏ lỡ 12; hôm nay 13 chưa điểm danh.
    final service = await pump(tester, daysSinceStart: 5);
    expect(day(7, 'beforeStart'), findsOneWidget);
    expect(day(8, 'missed'), findsOneWidget);
    expect(day(13, 'today'), findsOneWidget);
    expect(day(14, 'future'), findsOneWidget);
    expect(service.streak(2026, 11).missed, hasLength(5));
    // Nhắc bù ngày: chuỗi có thể nối thành 5 ngày.
    expect(
      find.byKey(const ValueKey('check-in-streak-make-up')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('check-in-streak-potential')), findsOne);
  });

  testWidgets('make up a missed day after watching an ad', (tester) async {
    final ads = FakeAdService();
    final service = await pump(tester, daysSinceStart: 3, ads: ads);
    final missed = clock.today - 2;
    await tester.tap(find.byKey(const ValueKey('check-in-make-up-11')));
    await tester.pumpAndSettle();
    expect(find.text('Xem quảng cáo'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('check-in-make-up-watch')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(ads.rewardedShown, [AdPlacement.checkInMakeUp]);
    expect(service.isChecked(missed), isTrue);
    await run(tester, 2000);
    expect(day(11, 'checked'), findsOneWidget);
    // Bù xong vẫn còn lượt điểm danh hôm nay.
    expect(find.text('Điểm danh hôm nay'), findsOneWidget);
  });

  testWidgets('make-up: no reward without finishing the ad', (tester) async {
    final ads = FakeAdService(earnReward: false);
    final service = await pump(tester, daysSinceStart: 3, ads: ads);
    await tester.tap(find.byKey(const ValueKey('check-in-make-up-11')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('check-in-make-up-watch')));
    await tester.pumpAndSettle();
    expect(ads.rewardedShown, hasLength(1));
    expect(service.isChecked(clock.today - 2), isFalse);
    expect(day(11, 'missed'), findsOneWidget);
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

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/checkin/check_in_service.dart';
import 'package:nonogram/checkin/game_clock.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/data/nonogram_repository.dart';
import 'package:nonogram/l10n/app_localizations.dart';
import 'package:nonogram/premium/premium_controller.dart';
import 'package:nonogram/screens/me/me_page.dart';
import 'package:nonogram/tester/tester_purchase_gateway.dart';
import 'package:nonogram/tester/tester_settings.dart';
import 'package:nonogram/tester/tester_tools_page.dart';
import 'package:provider/provider.dart';

import '../mocks/fake_nonogram_repository.dart';
import '../mocks/fake_purchase_gateway.dart';

void main() {
  late TesterSettings settings;
  late GameClock clock;
  late FakeNonogramRepository repository;
  late CheckInService checkIn;
  late PremiumController premium;

  setUp(() async {
    settings = TesterSettings.inMemory();
    clock = GameClock.inMemory(
      trusted: FakeTrustedClock(null),
      device: () => DateTime(2026, 11, 13, 9),
      debugShift: settings.dayShift,
    );
    repository = FakeNonogramRepository(today: () => clock.today);
    premium = PremiumController.inMemory(
      gateway: TesterPurchaseGateway(settings: settings),
    );
    checkIn = CheckInService.inMemory(
      clock: clock,
      isPremium: () => premium.isPremium,
    )..attach(repository);
  });

  tearDown(() {
    checkIn.dispose();
    premium.dispose();
  });

  Future<void> pump(
    WidgetTester tester,
    Widget home, {
    bool withTester = true,
  }) async {
    tester.view.physicalSize = const Size(360, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await premium.initialize();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<NonogramRepository>.value(value: repository),
          ChangeNotifierProvider.value(value: clock),
          ChangeNotifierProvider.value(value: checkIn),
          ChangeNotifierProvider.value(value: premium),
          if (withTester) ChangeNotifierProvider.value(value: settings),
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
          home: home,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('me page links to the tools only in the dev build', (
    tester,
  ) async {
    await pump(tester, const MePage(), withTester: false);
    expect(find.byKey(const ValueKey('me-tester-tools')), findsNothing);

    await pump(tester, const MePage());
    await tester.tap(find.byKey(const ValueKey('me-tester-tools')));
    await tester.pumpAndSettle();
    expect(find.byType(TesterToolsPage), findsOneWidget);
  });

  testWidgets('time travel, fast check-in and fake purchase', (tester) async {
    await pump(tester, const TesterToolsPage());
    expect(find.text('13/11/2026'), findsOneWidget);

    await tester.tap(find.text('+1 ngày'));
    await tester.pumpAndSettle();
    expect(find.text('14/11/2026  (tua +1 ngày)'), findsOneWidget);

    await tester.tap(find.text('Điểm danh 5 ngày (tới quà mốc)'));
    await tester.pumpAndSettle();
    expect(checkIn.count, 5);

    await tester.tap(find.text('Bấm mua'));
    await tester.pumpAndSettle();
    expect(premium.isPremium, isTrue);
    expect(find.text('ĐÃ MUA'), findsOneWidget);

    await tester.tap(find.text('Hoàn tiền / thu hồi'));
    await tester.pumpAndSettle();
    expect(premium.isPremium, isFalse);

    // Chờ thông báo dưới đáy màn hình tắt (nó che các nút ở đáy).
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('+10 gợi ý'), 200);
    await tester.tap(find.text('+10 gợi ý'));
    await tester.pumpAndSettle();
    expect((await repository.getPowerUps()).hints, greaterThanOrEqualTo(10));
  });
}

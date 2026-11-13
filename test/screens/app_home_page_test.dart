import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/checkin/check_in_page.dart';
import 'package:nonogram/checkin/check_in_service.dart';
import 'package:nonogram/checkin/game_clock.dart';
import 'package:nonogram/core/app_sounds.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/app_theme_mode.dart';
import 'package:nonogram/data/nonogram_repository.dart';
import 'package:nonogram/l10n/app_localizations.dart';
import 'package:nonogram/screens/dashboard/nonogram_dashboard_page.dart';
import 'package:nonogram/screens/home/app_home_page.dart';
import 'package:nonogram/screens/me/me_page.dart';
import 'package:provider/provider.dart';

import '../mocks/fake_nonogram_repository.dart';
import '../mocks/fake_purchase_gateway.dart';

void main() {
  late GameClock clock;
  late FakeNonogramRepository repository;
  late CheckInService checkIn;
  late AppThemeModeController themeMode;
  late AppSoundController sounds;

  setUp(() {
    clock = GameClock.inMemory(
      trusted: FakeTrustedClock(null),
      device: () => DateTime(2026, 11, 13, 9),
    );
    repository = FakeNonogramRepository(today: () => clock.today);
    checkIn = CheckInService.inMemory(clock: clock)..attach(repository);
    themeMode = AppThemeModeController.inMemory();
    sounds = AppSoundController.inMemory();
  });

  tearDown(() => checkIn.dispose());

  Future<void> pump(WidgetTester tester, {bool withCheckIn = true}) async {
    tester.view.physicalSize = const Size(412, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<NonogramRepository>.value(value: repository),
          ChangeNotifierProvider.value(value: themeMode),
          ChangeNotifierProvider.value(value: sounds),
          ChangeNotifierProvider.value(value: clock),
          if (withCheckIn) ChangeNotifierProvider.value(value: checkIn),
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
          home: const AppHomePage(),
        ),
      ),
    );
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  bool dotVisible(WidgetTester tester) =>
      tester
          .widget<Badge>(
            find.descendant(
              of: find.byKey(const ValueKey('home-tab-checkIn')),
              matching: find.byType(Badge),
            ),
          )
          .isLabelVisible;

  testWidgets('three tabs; the check-in tab has a dot until checked in', (
    tester,
  ) async {
    await pump(tester);
    expect(find.byType(NonogramDashboardPage), findsOneWidget);
    expect(find.text('Chính'), findsOneWidget);
    expect(find.text('Tôi'), findsOneWidget);
    expect(dotVisible(tester), isTrue);

    await tester.tap(find.byKey(const ValueKey('home-tab-checkIn')));
    await tester.pump();
    expect(find.byType(CheckInTab).hitTestable(), findsOneWidget);

    await checkIn.checkIn();
    await tester.pump();
    expect(dotVisible(tester), isFalse);
  });

  testWidgets('without check-in there are only two tabs', (tester) async {
    await pump(tester, withCheckIn: false);
    expect(find.byKey(const ValueKey('home-tab-checkIn')), findsNothing);
    expect(find.byKey(const ValueKey('home-tab-me')), findsOneWidget);
  });

  testWidgets('me tab: theme switches at once, sound can be turned off', (
    tester,
  ) async {
    await pump(tester);
    await tester.tap(find.byKey(const ValueKey('home-tab-me')));
    await tester.pump();
    expect(find.byType(MePage).hitTestable(), findsOneWidget);

    expect(themeMode.isDark, isFalse);
    await tester.tap(find.byKey(const ValueKey('me-theme')));
    await tester.pumpAndSettle();
    expect(themeMode.isDark, isTrue);
    expect(find.text('Tối'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('me-sound')));
    await tester.pump();
    expect(sounds.enabled, isFalse);
  });
}

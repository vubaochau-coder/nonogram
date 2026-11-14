import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/checkin/check_in_service.dart';
import 'package:nonogram/checkin/game_clock.dart';
import 'package:nonogram/core/app_sounds.dart';
import 'package:nonogram/screens/home/app_home_page.dart';
import 'package:nonogram/core/app_locale.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/app_theme_mode.dart';
import 'package:nonogram/data/nonogram_repository.dart';
import 'package:nonogram/l10n/app_localizations.dart';
import 'package:nonogram/models/nonogram_completed_progress.dart';
import 'package:nonogram/models/nonogram_puzzle.dart';
import 'package:nonogram/rating/app_rating_dialog.dart';
import 'package:nonogram/screens/dashboard/nonogram_dashboard_page.dart';
import 'package:nonogram/screens/guide/nonogram_guide_page.dart';
import 'package:nonogram/screens/history/nonogram_history_detail_page.dart';
import 'package:nonogram/screens/history/nonogram_history_page.dart';
import 'package:nonogram/screens/play/nonogram_play_page.dart';
import 'package:nonogram/screens/play/sections/nonogram_completion_result_section.dart';
import 'package:nonogram/screens/tutorial/nonogram_tutorial_page.dart';
import 'package:provider/provider.dart';

import '../mocks/fake_purchase_gateway.dart';
import '../mocks/fake_nonogram_local_service.dart';
import '../mocks/fake_nonogram_puzzle_source.dart';

/// Dựng các màn chính bằng từng ngôn ngữ trên điện thoại nhỏ, với font
/// Nunito thật, để bắt chữ dịch dài bị tràn (lỗi overflow làm test hỏng).
void main() {
  setUpAll(() async {
    final loader = FontLoader('Nunito');
    for (final weight in ['Regular', 'SemiBold', 'Bold', 'ExtraBold']) {
      final bytes = File('assets/fonts/Nunito-$weight.ttf').readAsBytesSync();
      loader.addFont(Future.value(ByteData.sublistView(bytes)));
    }
    await loader.load();
  });

  Future<void> pump(
    WidgetTester tester,
    Locale locale,
    Widget home, {
    Size size = const Size(360, 640),
    bool withHistory = false,
    bool withCheckIn = false,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final levels = [
      for (var r = 0; r < 10; r++) [for (var c = 0; c < 10; c++) (r * c) % 2],
    ];
    final local = FakeNonogramLocalService();
    if (withHistory) {
      for (var level = 1; level <= 3; level++) {
        await local.saveCompletedProgress(
          NonogramCompletedProgress(
            puzzleId: 'p-$level',
            level: level,
            bestCompletionMs: 3723000 + level * 1000,
            completedAt: DateTime(2026, 9, 28),
            lastPlayedAt: DateTime(2026, 9, 28),
          ),
        );
      }
    }
    final repository = NonogramRepository(
      FakeNonogramPuzzleSource(solution: levels),
      local,
    );
    final clock = GameClock.inMemory(
      trusted: FakeTrustedClock(null),
      device: () => DateTime(2026, 11, 13, 9),
    );
    final checkIn =
        withCheckIn
            ? (CheckInService.inMemory(clock: clock)..attach(repository))
            : null;
    if (checkIn != null) addTearDown(checkIn.dispose);
    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<NonogramRepository>.value(value: repository),
          if (checkIn != null) ...[
            ChangeNotifierProvider.value(value: clock),
            ChangeNotifierProvider.value(value: checkIn),
            ChangeNotifierProvider.value(value: AppSoundController.inMemory()),
          ],
          ChangeNotifierProvider.value(
            value: AppThemeModeController.inMemory(),
          ),
          ChangeNotifierProvider.value(value: AppLocaleController.inMemory()),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          locale: locale,
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
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  for (final language in appLanguages) {
    final locale = language.locale;
    group(language.tag, () {
      testWidgets('dashboard', (tester) async {
        await pump(tester, locale, const NonogramDashboardPage());
        expect(tester.takeException(), isNull);
      });

      testWidgets('home tabs: check-in and me', (tester) async {
        await pump(tester, locale, const AppHomePage(), withCheckIn: true);
        expect(tester.takeException(), isNull);
        await tester.tap(find.byKey(const ValueKey('home-tab-checkIn')));
        await tester.pump();
        expect(tester.takeException(), isNull);
        await tester.tap(find.byKey(const ValueKey('home-tab-me')));
        await tester.pump();
        expect(tester.takeException(), isNull);
      });

      testWidgets('play page, settings and language picker', (tester) async {
        await pump(tester, locale, const NonogramPlayPage());
        expect(tester.takeException(), isNull);
        await tester.tap(find.byIcon(LucideIcons.settings));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.tap(find.byKey(const ValueKey('app-language')));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });

      testWidgets('play page in landscape', (tester) async {
        await pump(
          tester,
          locale,
          const NonogramPlayPage(),
          size: const Size(640, 360),
        );
        expect(tester.takeException(), isNull);
      });

      testWidgets('dashboard and results with solved puzzles', (tester) async {
        await pump(
          tester,
          locale,
          const NonogramDashboardPage(),
          withHistory: true,
        );
        expect(tester.takeException(), isNull);
        await pump(
          tester,
          locale,
          const NonogramHistoryPage(),
          withHistory: true,
        );
        expect(tester.takeException(), isNull);
        await pump(
          tester,
          locale,
          const NonogramHistoryDetailPage(level: 2),
          withHistory: true,
        );
        expect(tester.takeException(), isNull);
      });

      testWidgets('completion screen and rating dialog', (tester) async {
        final puzzle = NonogramPuzzle(
          id: 'p-1',
          title: 'Crafting Graphic Design Measurement Ruler',
          author: 'Tester',
          difficulty: '10/10',
          difficultyScore: 0.9,
          level: 1061,
          solution: const [
            [1, 0],
            [0, 1],
          ],
        );
        for (final size in const [Size(360, 640), Size(640, 360)]) {
          await pump(
            tester,
            locale,
            Scaffold(
              body: SafeArea(
                child: NonogramCompletionResultSection(
                  puzzle: puzzle,
                  completionDuration: const Duration(minutes: 59, seconds: 59),
                  onNextLevel: () {},
                  onDashboard: () {},
                ),
              ),
            ),
            size: size,
          );
          expect(tester.takeException(), isNull, reason: '$size');
        }
        await pump(
          tester,
          locale,
          const Scaffold(body: Center(child: AppRatingDialog())),
        );
        expect(tester.takeException(), isNull);
      });

      testWidgets('tutorial and guide', (tester) async {
        await pump(tester, locale, const NonogramTutorialPage());
        expect(tester.takeException(), isNull);
        await pump(tester, locale, const NonogramGuidePage());
        expect(tester.takeException(), isNull);
      });
    });
  }
}

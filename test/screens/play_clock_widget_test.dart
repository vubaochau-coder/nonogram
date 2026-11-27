import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/app_theme_mode.dart';
import 'package:nonogram/data/nonogram_repository.dart';
import 'package:nonogram/l10n/app_localizations.dart';
import 'package:nonogram/screens/play/bloc/nonogram_play_bloc.dart';
import 'package:nonogram/screens/play/clock/nonogram_play_clock.dart';
import 'package:nonogram/screens/play/clock/play_clock_visibility.dart';
import 'package:nonogram/screens/play/nonogram_play_screen.dart';
import 'package:nonogram/screens/play/sections/landscape_info_panel_visibility.dart';
import 'package:nonogram/screens/play/sections/nonogram_board_viewport.dart';
import 'package:provider/provider.dart';

import '../mocks/fake_nonogram_repository.dart';

const _clock = ValueKey('nonogram-clock');

Future<void> _pumpPlay(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<NonogramRepository>.value(
          value: FakeNonogramRepository(),
        ),
        ChangeNotifierProvider.value(value: AppThemeModeController.inMemory()),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('en'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const NonogramPlayScreen(),
      ),
    ),
  );
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

NonogramPlayClock _playClock(WidgetTester tester) => tester
    .element(find.byType(NonogramBoardViewport))
    .read<NonogramPlayBloc>()
    .clock;

/// The portrait top row: clock, hint, wand, rotate, fullscreen.
List<Finder> _topRow() => [
  find.byKey(_clock),
  find.byIcon(LucideIcons.lightbulb),
  find.byKey(const ValueKey('nonogram-wand')),
  find.byKey(const ValueKey('nonogram-rotate-screen')),
  find.byIcon(LucideIcons.maximize2),
];

void main() {
  testWidgets('portrait top row fits a 320 dp phone with large text and an '
      'hour-long time', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.3;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await _pumpPlay(tester, const Size(320, 640));
    _playClock(
      tester,
    ).start(const Duration(hours: 3, minutes: 59).inMilliseconds);
    await tester.pump(const Duration(seconds: 1));

    expect(find.textContaining('3:59:'), findsOneWidget);
    for (final finder in _topRow()) {
      final rect = tester.getRect(finder);
      expect(rect.left, greaterThanOrEqualTo(0), reason: '$finder');
      expect(rect.right, lessThanOrEqualTo(320), reason: '$finder');
    }
  });

  testWidgets('at 320 dp the buttons keep their full size', (tester) async {
    await _pumpPlay(tester, const Size(320, 640));
    expect(
      tester.getSize(find.byKey(const ValueKey('nonogram-wand'))).height,
      40,
    );
  });

  testWidgets('tapping the clock pauses: the board is covered and the tools '
      'are locked until Resume', (tester) async {
    await _pumpPlay(tester, const Size(400, 800));
    final clock = _playClock(tester);
    expect(clock.isRunning, isTrue);

    await tester.tap(find.byKey(_clock));
    await tester.pump(const Duration(milliseconds: 300));
    expect(clock.isPausedByUser, isTrue);
    expect(find.byKey(const ValueKey('nonogram-pause-overlay')), findsOne);
    final lock = tester.widget<IgnorePointer>(
      find
          .ancestor(
            of: find.byKey(const ValueKey('nonogram-undo')),
            matching: find.byType(IgnorePointer),
          )
          .first,
    );
    expect(lock.ignoring, isTrue);

    await tester.tap(find.byKey(const ValueKey('nonogram-clock-resume')));
    await tester.pump(const Duration(milliseconds: 300));
    expect(clock.isRunning, isTrue);
    expect(find.byKey(const ValueKey('nonogram-pause-overlay')), findsNothing);
  });

  testWidgets('the clock stops while the app is in the background', (
    tester,
  ) async {
    await _pumpPlay(tester, const Size(400, 800));
    final clock = _playClock(tester);
    // The same steps as a real phone going to the background and back.
    for (final state in [
      AppLifecycleState.inactive,
      AppLifecycleState.hidden,
      AppLifecycleState.paused,
    ]) {
      tester.binding.handleAppLifecycleStateChanged(state);
    }
    await tester.pump();
    expect(clock.isRunning, isFalse);
    expect(clock.isPausedByUser, isFalse, reason: 'an automatic pause');
    for (final state in [
      AppLifecycleState.hidden,
      AppLifecycleState.inactive,
      AppLifecycleState.resumed,
    ]) {
      tester.binding.handleAppLifecycleStateChanged(state);
    }
    await tester.pump();
    expect(clock.isRunning, isTrue);
  });

  testWidgets('opening Settings stops the clock; the clock can be hidden', (
    tester,
  ) async {
    addTearDown(() => PlayClockVisibility.set(true));
    await _pumpPlay(tester, const Size(400, 800));
    final clock = _playClock(tester);

    await tester.tap(find.byIcon(LucideIcons.settings));
    await tester.pumpAndSettle();
    expect(clock.isRunning, isFalse);

    await tester.tap(find.byKey(const ValueKey('nonogram-clock-toggle')));
    await tester.pump();
    expect(PlayClockVisibility.notifier.value, isFalse);
    Navigator.of(tester.element(find.byType(Dialog))).pop();
    await tester.pumpAndSettle();
    expect(clock.isRunning, isTrue, reason: 'hidden, it still counts');
    expect(find.byKey(_clock), findsNothing);
  });

  testWidgets('landscape: the clock sits in the info card, and under the '
      'info button once the card is folded', (tester) async {
    LandscapeInfoPanelVisibility.notifier.value = true;
    addTearDown(() => LandscapeInfoPanelVisibility.notifier.value = true);
    await _pumpPlay(tester, const Size(900, 400));
    final card = find.byKey(const ValueKey('nonogram-landscape-info-panel'));
    expect(
      find.descendant(of: card, matching: find.byKey(_clock)),
      findsOneWidget,
    );
    expect(find.byKey(_clock), findsOneWidget, reason: 'not twice');

    await tester.tap(
      find.byKey(const ValueKey('nonogram-landscape-info-hide')),
    );
    await tester.pumpAndSettle();
    final clock = tester.getCenter(find.byKey(_clock));
    final info = tester.getCenter(
      find.byKey(const ValueKey('nonogram-landscape-info')),
    );
    expect(clock.dx, lessThan(60));
    expect(
      clock.dy,
      greaterThan(info.dy),
      reason: 'just below the info button',
    );
    expect(
      clock.dy,
      lessThan(tester.getCenter(find.byIcon(LucideIcons.settings)).dy),
    );
  });
}

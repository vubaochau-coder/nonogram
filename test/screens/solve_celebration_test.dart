import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/app_theme_mode.dart';
import 'package:nonogram/data/nonogram_puzzle_source.dart';
import 'package:nonogram/data/nonogram_repository.dart';
import 'package:nonogram/l10n/app_localizations.dart';
import 'package:nonogram/models/nonogram_puzzle.dart';
import 'package:nonogram/screens/play/bloc/nonogram_play_bloc.dart';
import 'package:nonogram/screens/play/bloc/nonogram_play_event.dart';
import 'package:nonogram/screens/play/celebration/solve_celebration.dart';
import 'package:nonogram/screens/play/nonogram_play_page.dart';
import 'package:nonogram/screens/play/sections/nonogram_board_viewport.dart';
import 'package:nonogram/screens/play/sections/nonogram_completion_result_section.dart';

import '../mocks/fake_nonogram_local_service.dart';

/// Màn 3x3 chỉ có ô giữa được tô: chạm một ô là giải xong.
class _TinyPuzzleSource implements NonogramPuzzleSource {
  @override
  Future<int> totalLevels() async => 1;

  @override
  Future<NonogramPuzzle?> puzzleByLevel(int level) async {
    if (level != 1) return null;
    return NonogramPuzzle(
      id: 'tiny',
      title: 'Tiny',
      author: '',
      difficulty: '',
      difficultyScore: 0,
      level: 1,
      solution: const [
        [0, 0, 0],
        [0, 1, 0],
        [0, 0, 0],
      ],
    );
  }
}

Future<void> _pumpPlay(WidgetTester tester, {bool reduceMotion = false}) async {
  tester.view.physicalSize = const Size(400, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  if (reduceMotion) {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
  }

  await tester.pumpWidget(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<NonogramRepository>.value(
          value: NonogramRepository(
            _TinyPuzzleSource(),
            FakeNonogramLocalService(),
          ),
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
        home: const NonogramPlayPage(),
      ),
    ),
  );
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

Future<void> _solve(WidgetTester tester) async {
  tester
      .element(find.byType(NonogramBoardViewport))
      .read<NonogramPlayBloc>()
      .add(const CellTapped(1, 1, offsetX: 0, offsetY: 0));
  // Lưu tiến độ (bất đồng bộ) rồi mới báo giải xong.
  for (var i = 0; i < 4; i++) {
    await tester.pump(const Duration(milliseconds: 10));
  }
}

SolveCelebration _celebration(WidgetTester tester) =>
    Provider.of(tester.element(find.byType(Scaffold).first), listen: false);

void main() {
  testWidgets('solving plays the wave on the board, then flies the picture '
      'into the result screen', (tester) async {
    await _pumpPlay(tester);
    await _solve(tester);

    // Sóng: vẫn ở bàn chơi, chưa sang màn kết quả.
    expect(_celebration(tester).phase, SolveCelebrationPhase.wave);
    expect(find.byKey(const ValueKey('solve-wave')), findsOneWidget);
    expect(find.byType(NonogramCompletionResultSection), findsNothing);

    await tester.pump(SolveCelebration.waveDuration);
    expect(find.byType(NonogramCompletionResultSection), findsNothing);

    // Hết sóng: sang màn kết quả, tranh đang bay.
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();
    expect(find.byType(NonogramCompletionResultSection), findsOneWidget);
    expect(find.byType(NonogramBoardViewport), findsNothing);
    expect(_celebration(tester).phase, SolveCelebrationPhase.flight);
    expect(_celebration(tester).flightTo, isNotNull);

    // Bay tới nơi: tranh trong ô kết quả hiện ra.
    await tester.pump(SolveCelebration.flightDuration);
    await tester.pump(const Duration(milliseconds: 50));
    expect(_celebration(tester).phase, SolveCelebrationPhase.done);
    await tester.pumpAndSettle();
  });

  testWidgets('reduced motion goes straight to the result screen', (
    tester,
  ) async {
    await _pumpPlay(tester, reduceMotion: true);
    await _solve(tester);
    await tester.pump();

    expect(_celebration(tester).phase, SolveCelebrationPhase.idle);
    expect(find.byType(NonogramCompletionResultSection), findsOneWidget);
    await tester.pumpAndSettle();
  });

  test('the wave starts at the bottom-left and ends at the top-right', () {
    double at(double t, int row, int col) => SolveWavePainter.cellProgress(
      t: t,
      row: row,
      col: col,
      rows: 5,
      cols: 5,
    );

    expect(at(0.05, 4, 0), greaterThan(0));
    expect(at(0.05, 0, 4), 0);
    expect(at(0.5, 4, 0), 1);
    expect(at(0.9, 0, 4), lessThan(1));
    expect(at(1, 0, 4), 1);
  });
}

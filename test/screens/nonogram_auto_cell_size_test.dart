import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/models/nonogram_board_snapshot.dart';
import 'package:nonogram/models/nonogram_interaction_mode.dart';
import 'package:nonogram/models/nonogram_puzzle.dart';
import 'package:nonogram/screens/play/bloc/nonogram_play_bloc.dart';
import 'package:nonogram/screens/play/bloc/nonogram_play_event.dart';
import 'package:nonogram/screens/play/engine/nonogram_board_layout.dart';
import 'package:nonogram/screens/play/engine/nonogram_engine.dart';

import '../mocks/fake_nonogram_repository.dart';

NonogramPuzzle _square(int n) => NonogramPuzzle(
  id: 'sq-$n',
  title: 'Square $n',
  author: '',
  difficulty: '',
  difficultyScore: 0,
  level: 1,
  // Hàng xen kẽ 1010... để mỗi hàng/cột có nhiều gợi ý.
  solution: List.generate(n, (r) => List.generate(n, (c) => (r + c) % 2)),
);

void main() {
  const engine = NonogramEngine();
  const phone = Size(390, 700);

  group('fitCellSize', () {
    test('small puzzle uses the largest cell size', () {
      expect(
        engine.fitCellSize(puzzle: _square(4), viewport: phone),
        NonogramBoardLayout.maxCellSize,
      );
    });

    test('medium puzzle shrinks to fit, within the allowed range', () {
      // 8×8, 4 gợi ý mỗi hàng: khung rộng 390 không đủ cho cỡ 44 nhưng
      // thừa cho cỡ 28.
      final size = engine.fitCellSize(
        puzzle: _square(8),
        viewport: const Size(390, 900),
      );
      expect(size, greaterThan(NonogramBoardLayout.minCellSize));
      expect(size, lessThan(NonogramBoardLayout.maxCellSize));
    });

    test('large puzzle never goes below the minimum tap size', () {
      expect(
        engine.fitCellSize(puzzle: _square(45), viewport: phone),
        NonogramBoardLayout.minCellSize,
      );
    });
  });

  group('bloc auto cell size', () {
    late NonogramPlayBloc bloc;

    setUp(() => bloc = NonogramPlayBloc(repository: FakeNonogramRepository()));
    tearDown(() => bloc.close());

    test('fresh large puzzle uses the fitted size once measured', () async {
      bloc.add(const BoardViewportMeasured(width: 390, height: 700));
      bloc.add(Started(puzzle: _square(45)));
      await bloc.stream.firstWhere((s) => s.puzzle != null);
      expect(bloc.state.cellSize, NonogramBoardLayout.minCellSize);
    });

    test('measurement arriving after start still fits the board', () async {
      bloc.add(Started(puzzle: _square(45)));
      await bloc.stream.firstWhere((s) => s.puzzle != null);
      expect(bloc.state.cellSize, NonogramBoardLayout.maxCellSize);

      bloc.add(const BoardViewportMeasured(width: 390, height: 700));
      await bloc.stream.firstWhere(
        (s) => s.cellSize == NonogramBoardLayout.minCellSize,
      );
    });

    test('fresh start has no saved viewport (board uses its start)', () async {
      bloc.add(const BoardViewportMeasured(width: 390, height: 700));
      bloc.add(Started(puzzle: _square(45)));
      await bloc.stream.firstWhere((s) => s.puzzle != null);
      expect(bloc.takePendingViewport(), isNull);
    });

    test('restored game uses the fitted size, not the saved one', () async {
      final puzzle = _square(45);
      bloc.add(const BoardViewportMeasured(width: 390, height: 700));
      bloc.add(
        Started(
          puzzle: puzzle,
          snapshot: NonogramBoardSnapshot(
            puzzleId: puzzle.id,
            level: puzzle.level,
            gridData: const [],
            startTime: DateTime(2026),
            interactionMode: NonogramInteractionMode.fill,
            cellSize: 80,
            viewportOffsetX: -120,
            viewportOffsetY: -80,
          ),
        ),
      );
      await bloc.stream.firstWhere((s) => s.puzzle != null);
      expect(bloc.state.cellSize, NonogramBoardLayout.minCellSize);
      expect(bloc.takePendingViewport(), const Offset(-120, -80));
    });

    test('rotating the screen refits the cell size', () async {
      // 13 × 8: dọc thì phải kéo (cỡ nhỏ nhất), ngang thì vừa ở cỡ lớn hơn.
      final puzzle = NonogramPuzzle(
        id: 'wide',
        title: '',
        author: '',
        difficulty: '',
        difficultyScore: 0,
        level: 1,
        solution: List.generate(8, (r) => List.generate(13, (c) => c % 2)),
      );
      bloc.add(const BoardViewportMeasured(width: 412, height: 780));
      bloc.add(Started(puzzle: puzzle));
      await bloc.stream.firstWhere((s) => s.puzzle != null);
      final portrait = bloc.state.cellSize;
      expect(portrait, NonogramBoardLayout.minCellSize);

      bloc.add(const BoardViewportMeasured(width: 900, height: 412));
      await bloc.stream.firstWhere((s) => s.cellSize != portrait);
      expect(bloc.state.cellSize, greaterThan(portrait));
      expect(
        bloc.state.cellSize,
        lessThanOrEqualTo(NonogramBoardLayout.maxCellSize),
      );
    });
  });
}

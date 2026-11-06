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
      // 8×8, 4 gợi ý mỗi hàng/cột, khung 390 rộng. Cỡ 40: dải trái 4 × 26 =
      // 104, (390 - 8 - 104 - 16) / 8 = 32.75 < 40 -> không vừa. Cỡ 38:
      // dải 4 × 24.7 = 98.8, (390 - 8 - 98.8 - 16) / 8 = 33.4 < 38 ... nên
      // chạm sàn 36; cao 700 thì thừa. Với khung rộng 440 thì vừa ở 39.
      final size = engine.fitCellSize(
        puzzle: _square(8),
        viewport: const Size(440, 900),
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

    test('zoom stays within the allowed cell size range', () async {
      bloc.add(const BoardViewportMeasured(width: 390, height: 700));
      bloc.add(Started(puzzle: _square(45)));
      await bloc.stream.firstWhere((s) => s.puzzle != null);

      bloc.add(const CellSizePreviewed(80));
      await bloc.stream.firstWhere(
        (s) => s.cellSize == NonogramBoardLayout.maxCellSize,
      );
      bloc.add(const CellSizeChanged(cellSize: 10, offsetX: 0, offsetY: 0));
      await bloc.stream.firstWhere(
        (s) => s.cellSize == NonogramBoardLayout.minCellSize,
      );
    });

    test('restored game keeps its saved cell size', () async {
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
            cellSize: 40,
            viewportOffsetX: -120,
            viewportOffsetY: -80,
          ),
        ),
      );
      await bloc.stream.firstWhere((s) => s.puzzle != null);
      expect(bloc.state.cellSize, 40);
      expect(bloc.takePendingViewport(), const Offset(-120, -80));
    });

    test('a game saved with an old out-of-range size is clamped', () async {
      final puzzle = _square(45);
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
          ),
        ),
      );
      await bloc.stream.firstWhere((s) => s.puzzle != null);
      expect(bloc.state.cellSize, NonogramBoardLayout.maxCellSize);
    });
  });
}

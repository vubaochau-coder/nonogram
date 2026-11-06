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
    test('small puzzle keeps the preferred size', () {
      expect(
        engine.fitCellSize(puzzle: _square(4), viewport: phone, preferred: 40),
        40,
      );
    });

    test('medium puzzle shrinks to fit the width', () {
      // 5 cột gợi ý, mỗi cột dày 0.65 × cỡ ô. Ở cỡ 32: dải trái 104px,
      // (450 - 8 - 104 - 16) / 10 = 32.2 >= 32; ở cỡ 33 thì không vừa.
      final size = engine.fitCellSize(
        puzzle: _square(10),
        viewport: const Size(450, 900),
        preferred: 40,
      );
      expect(size, 32);
    });

    test('large puzzle never goes below the minimum tap size', () {
      expect(
        engine.fitCellSize(puzzle: _square(45), viewport: phone, preferred: 40),
        NonogramBoardLayout.minAutoCellSize,
      );
    });

    test('a smaller preferred size is respected', () {
      expect(
        engine.fitCellSize(puzzle: _square(45), viewport: phone, preferred: 16),
        16,
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
      expect(bloc.state.cellSize, NonogramBoardLayout.minAutoCellSize);
    });

    test('measurement arriving after start still fits the board', () async {
      bloc.add(Started(puzzle: _square(45)));
      await bloc.stream.firstWhere((s) => s.puzzle != null);
      expect(bloc.state.cellSize, 40);

      bloc.add(const BoardViewportMeasured(width: 390, height: 700));
      await bloc.stream.firstWhere(
        (s) => s.cellSize == NonogramBoardLayout.minAutoCellSize,
      );
    });

    test('fresh start has no saved viewport (board uses its start)', () async {
      bloc.add(const BoardViewportMeasured(width: 390, height: 700));
      bloc.add(Started(puzzle: _square(45)));
      await bloc.stream.firstWhere((s) => s.puzzle != null);
      expect(bloc.takePendingViewport(), isNull);
    });

    test('zoom changes the cell size but not the preferred size', () async {
      bloc.add(const BoardViewportMeasured(width: 390, height: 700));
      bloc.add(Started(puzzle: _square(4)));
      await bloc.stream.firstWhere((s) => s.puzzle != null);

      bloc.add(const CellSizePreviewed(60));
      await bloc.stream.firstWhere((s) => s.cellSize == 60);
      bloc.add(
        const CellSizeChanged(
          cellSize: 60,
          offsetX: 0,
          offsetY: 0,
          isZoom: true,
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 20));

      // Màn mới vẫn dùng cỡ 40 (cỡ người chơi chọn), không phải 60.
      bloc.add(Started(puzzle: _square(5)));
      await bloc.stream.firstWhere((s) => s.puzzle?.id == 'sq-5');
      expect(bloc.state.cellSize, 40);
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
            interactionMode: NonogramInteractionMode.draw,
            cellSize: 32,
            viewportOffsetX: -120,
            viewportOffsetY: -80,
          ),
        ),
      );
      await bloc.stream.firstWhere((s) => s.puzzle != null);
      expect(bloc.state.cellSize, 32);
      expect(bloc.takePendingViewport(), const Offset(-120, -80));
    });
  });
}

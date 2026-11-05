import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/models/nonogram_board_snapshot.dart';
import 'package:nonogram/models/nonogram_interaction_mode.dart';
import 'package:nonogram/models/nonogram_puzzle.dart';
import 'package:nonogram/screens/play/bloc/nonogram_play_bloc.dart';
import 'package:nonogram/screens/play/bloc/nonogram_play_event.dart';
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
      // 10 cột + 5 cột gợi ý = 15 cột.
      final size = engine.fitCellSize(
        puzzle: _square(10),
        viewport: const Size(600, 900),
        preferred: 40,
      );
      // (600 - 32) / 15 = 37.8 -> 37
      expect(size, 37);
    });

    test('large puzzle never goes below the minimum tap size', () {
      expect(
        engine.fitCellSize(puzzle: _square(45), viewport: phone, preferred: 40),
        NonogramEngine.minAutoCellSize,
      );
    });

    test('a smaller preferred size is respected', () {
      expect(
        engine.fitCellSize(puzzle: _square(45), viewport: phone, preferred: 16),
        16,
      );
    });
  });

  group('initialViewportOffset', () {
    test('board that fits stays at the origin', () {
      expect(
        engine.initialViewportOffset(
          puzzle: _square(4),
          cellSize: 40,
          viewport: phone,
        ),
        Offset.zero,
      );
    });

    test('wide board keeps only part of the left clues on screen', () {
      final puzzle = _square(45);
      const cell = 24.0;
      final offset = engine.initialViewportOffset(
        puzzle: puzzle,
        cellSize: cell,
        viewport: phone,
      );
      final leftClueWidth =
          puzzle.leftClues
              .map((c) => c.length)
              .reduce((a, b) => a > b ? a : b) *
          cell;
      // Phần gợi ý còn thấy = 40% chiều rộng khung nhìn.
      expect(
        offset.dx,
        closeTo(-(16 + leftClueWidth - phone.width * 0.4), 0.01),
      );
      expect(offset.dy, lessThan(0));
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
      expect(bloc.state.cellSize, NonogramEngine.minAutoCellSize);
    });

    test('measurement arriving after start still fits the board', () async {
      bloc.add(Started(puzzle: _square(45)));
      await bloc.stream.firstWhere((s) => s.puzzle != null);
      expect(bloc.state.cellSize, 40);

      bloc.add(const BoardViewportMeasured(width: 390, height: 700));
      await bloc.stream.firstWhere(
        (s) => s.cellSize == NonogramEngine.minAutoCellSize,
      );
    });

    test('fresh start prepares a viewport offset once measured', () async {
      bloc.add(const BoardViewportMeasured(width: 390, height: 700));
      bloc.add(Started(puzzle: _square(45)));
      await bloc.stream.firstWhere((s) => s.puzzle != null);
      final offset = bloc.takePendingViewport();
      expect(offset, isNotNull);
      expect(offset!.dx, lessThan(0));
      expect(bloc.takePendingViewport(), isNull);
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

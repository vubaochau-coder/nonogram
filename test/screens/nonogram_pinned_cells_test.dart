import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/models/nonogram_cell_state.dart';
import 'package:nonogram/models/nonogram_puzzle.dart';
import 'package:nonogram/screens/play/bloc/nonogram_play_bloc.dart';
import 'package:nonogram/screens/play/bloc/nonogram_play_event.dart';
import 'package:nonogram/screens/play/engine/nonogram_solver.dart';

import '../mocks/fake_nonogram_repository.dart';

void main() {
  // Đường chéo 2x2: hai nghiệm (chéo chính / chéo phụ) nếu không ghim ô nào.
  const diagonal = [
    [1, 0],
    [0, 1],
  ];

  group('pinned cells in level data', () {
    Map<String, dynamic> json(Object? pinned) => {
      'id': 'L1',
      'level': 1,
      'solution': ['10', '01'],
      if (pinned != null) 'pinned': pinned,
    };

    test('are parsed as row/column pairs', () {
      final puzzle = NonogramPuzzle.fromAssetJson(
        json([
          [0, 0],
          [1, 0],
        ]),
      );
      expect(puzzle.pinnedCells, {(row: 0, col: 0), (row: 1, col: 0)});
      expect(puzzle.pinnedValues, {(row: 0, col: 0): 1, (row: 1, col: 0): 0});
    });

    test('are optional', () {
      expect(NonogramPuzzle.fromAssetJson(json(null)).pinnedCells, isEmpty);
    });

    test('reject cells outside the grid, duplicates and bad shapes', () {
      for (final bad in [
        [
          [2, 0],
        ],
        [
          [0, 0],
          [0, 0],
        ],
        [
          [0],
        ],
        'x',
      ]) {
        expect(
          () => NonogramPuzzle.fromAssetJson(json(bad)),
          throwsFormatException,
          reason: '$bad',
        );
      }
    });
  });

  test('a pinned cell makes an ambiguous puzzle unique', () {
    final puzzle = NonogramPuzzle(
      id: 'p',
      title: '',
      author: '',
      difficulty: '',
      difficultyScore: 0,
      level: 1,
      solution: diagonal,
      pinnedCells: const {(row: 0, col: 0)},
    );
    const solver = NonogramSolver();
    expect(
      solver.countSolutions(
        rowClues: puzzle.leftClues,
        colClues: puzzle.topClues,
      ),
      2,
    );
    expect(
      solver.countSolutions(
        rowClues: puzzle.leftClues,
        colClues: puzzle.topClues,
        fixedCells: puzzle.pinnedValues,
      ),
      1,
    );
  });

  group('play bloc', () {
    late NonogramPlayBloc bloc;

    setUp(() {
      bloc = NonogramPlayBloc(
        repository: FakeNonogramRepository(
          solution: diagonal,
          pinnedCells: const {(row: 0, col: 0), (row: 0, col: 1)},
        ),
      );
    });

    tearDown(() => bloc.close());

    test(
      'pinned cells start shown and locked, and stay after a reset',
      () async {
        bloc.add(const LevelLoadRequested());
        final loaded = await bloc.stream.firstWhere((s) => s.puzzle != null);

        expect(loaded.gridData[0][0], NonogramCellState.filled);
        expect(loaded.gridData[0][1], NonogramCellState.marked);
        expect(loaded.isLocked(0, 0), isTrue);
        expect(loaded.isLocked(0, 1), isTrue);
        expect(loaded.isLocked(1, 1), isFalse);

        // Chạm vào ô ghim: không đổi.
        bloc.add(const CellTapped(0, 0, offsetX: 0, offsetY: 0));
        await Future<void>.delayed(Duration.zero);
        expect(bloc.state.gridData[0][0], NonogramCellState.filled);

        bloc.add(const CellTapped(1, 1, offsetX: 0, offsetY: 0));
        await bloc.stream.firstWhere((s) => s.isSolved);

        bloc.add(const BoardReset(offsetX: 0, offsetY: 0));
        final reset = await bloc.stream.firstWhere((s) => !s.isSolved);
        expect(reset.gridData[0][0], NonogramCellState.filled);
        expect(reset.gridData[0][1], NonogramCellState.marked);
        expect(reset.gridData[1][1], NonogramCellState.empty);
      },
    );
  });
}

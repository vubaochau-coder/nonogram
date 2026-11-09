import 'dart:math';

import 'package:nonogram/models/nonogram_cell_state.dart';
import 'package:nonogram/models/nonogram_puzzle.dart';
import 'package:nonogram/screens/play/engine/nonogram_engine.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/painting.dart';

void main() {
  const engine = NonogramEngine();

  final puzzle = NonogramPuzzle(
    id: 'engine-test',
    title: 'Engine Test',
    author: 'Tester',
    difficulty: 'Easy',
    difficultyScore: 1.0,
    level: 1,
    solution: const [
      [1, 0, 1, 0, 1],
      [1, 1, 1, 0, 0],
      [0, 0, 0, 0, 0],
    ],
  );

  group('NonogramEngine clue satisfaction', () {
    test('deriveLineRuns groups contiguous filled cells', () {
      final line = [
        NonogramCellState.filled,
        NonogramCellState.empty,
        NonogramCellState.filled,
        NonogramCellState.filled,
        NonogramCellState.empty,
      ];

      expect(engine.deriveLineRuns(line), [1, 2]);
    });

    test('deriveLineRuns treats marked cells as non-filled gaps', () {
      final line = [
        NonogramCellState.filled,
        NonogramCellState.marked,
        NonogramCellState.filled,
        NonogramCellState.empty,
        NonogramCellState.filled,
      ];

      expect(engine.deriveLineRuns(line), [1, 1, 1]);
    });

    test('1-1-1 clue is satisfied by three separated single cells', () {
      final line = [
        NonogramCellState.filled,
        NonogramCellState.empty,
        NonogramCellState.filled,
        NonogramCellState.empty,
        NonogramCellState.filled,
      ];

      expect(
        engine.isLineSatisfied(line: line, clues: const [1, 1, 1]),
        isTrue,
      );
    });

    test('1-1-1 clue is not satisfied by merged runs', () {
      final line = [
        NonogramCellState.filled,
        NonogramCellState.filled,
        NonogramCellState.empty,
        NonogramCellState.filled,
        NonogramCellState.empty,
      ];

      expect(
        engine.isLineSatisfied(line: line, clues: const [1, 1, 1]),
        isFalse,
      );
    });

    test('marked cells do not satisfy clues without enough filled cells', () {
      final line = [
        NonogramCellState.filled,
        NonogramCellState.marked,
        NonogramCellState.marked,
        NonogramCellState.empty,
        NonogramCellState.filled,
      ];

      expect(
        engine.isLineSatisfied(line: line, clues: const [1, 1, 1]),
        isFalse,
      );
    });

    test('deriveSatisfiedLines returns row and column satisfaction maps', () {
      final grid = [
        [
          NonogramCellState.filled,
          NonogramCellState.empty,
          NonogramCellState.filled,
          NonogramCellState.empty,
          NonogramCellState.filled,
        ],
        [
          NonogramCellState.filled,
          NonogramCellState.filled,
          NonogramCellState.filled,
          NonogramCellState.empty,
          NonogramCellState.empty,
        ],
        List.generate(5, (_) => NonogramCellState.empty),
      ];

      final satisfied = engine.deriveSatisfiedLines(
        puzzle: puzzle,
        gridData: grid,
      );

      expect(satisfied.rows, [true, true, true]);
      expect(satisfied.cols, [true, true, true, true, true]);
    });

    test('canFillCell blocks new fill in satisfied row or column only', () {
      final grid = [
        [
          NonogramCellState.filled,
          NonogramCellState.empty,
          NonogramCellState.filled,
          NonogramCellState.empty,
          NonogramCellState.filled,
        ],
        List.generate(5, (_) => NonogramCellState.empty),
        List.generate(5, (_) => NonogramCellState.empty),
      ];

      expect(
        engine.canFillCell(
          row: 0,
          col: 1,
          gridData: grid,
          satisfiedRows: const [true, false, false],
          satisfiedCols: const [false, false, false, false, false],
        ),
        isFalse,
      );

      expect(
        engine.canFillCell(
          row: 0,
          col: 0,
          gridData: grid,
          satisfiedRows: const [true, false, false],
          satisfiedCols: const [false, false, false, false, false],
        ),
        isTrue,
      );
    });

    test('canFillCell blocks marked cells from refilling a satisfied line', () {
      final grid = [
        [
          NonogramCellState.filled,
          NonogramCellState.marked,
          NonogramCellState.filled,
          NonogramCellState.empty,
          NonogramCellState.filled,
        ],
      ];

      expect(
        engine.canFillCell(
          row: 0,
          col: 1,
          gridData: grid,
          satisfiedRows: const [true],
          satisfiedCols: const [false, false, false, false, false],
        ),
        isFalse,
      );
    });

    test('canMarkCell only allows empty cells to become marked', () {
      final grid = [
        [
          NonogramCellState.empty,
          NonogramCellState.filled,
          NonogramCellState.marked,
        ],
      ];

      expect(engine.canMarkCell(row: 0, col: 0, gridData: grid), isTrue);
      expect(engine.canMarkCell(row: 0, col: 1, gridData: grid), isFalse);
      expect(engine.canMarkCell(row: 0, col: 2, gridData: grid), isFalse);
    });

    test('isSolved allows marked cells where solution expects empty', () {
      final grid = [
        [
          NonogramCellState.filled,
          NonogramCellState.marked,
          NonogramCellState.filled,
          NonogramCellState.empty,
          NonogramCellState.filled,
        ],
        [
          NonogramCellState.filled,
          NonogramCellState.filled,
          NonogramCellState.filled,
          NonogramCellState.marked,
          NonogramCellState.empty,
        ],
        [
          NonogramCellState.marked,
          NonogramCellState.empty,
          NonogramCellState.marked,
          NonogramCellState.empty,
          NonogramCellState.empty,
        ],
      ];

      expect(engine.isSolved(puzzle: puzzle, gridData: grid), isTrue);
    });
  });

  group('NonogramEngine Hints', () {
    test('pickHintCells picks up to 5 unfilled cells of the solution', () {
      // Solution:
      // [1, 0, 1, 0, 1],
      // [1, 1, 1, 0, 0],
      // [0, 0, 0, 0, 0],
      final grid = List.generate(
        3,
        (_) => List.filled(5, NonogramCellState.empty),
      );
      grid[0][0] = NonogramCellState.filled; // đã tô: không chọn lại
      grid[1][1] = NonogramCellState.marked; // đánh X nhầm: được chọn

      final cells = engine.pickHintCells(
        puzzle: puzzle,
        gridData: grid,
        random: Random(1),
      );
      expect(cells.length, 5);
      expect(cells.toSet().length, 5);
      for (final c in cells) {
        expect(puzzle.solution[c.row][c.col], 1);
        expect(grid[c.row][c.col], isNot(NonogramCellState.filled));
      }
      // Chỉ còn 5 ô cần tô nên phải chọn đúng cả 5.
      expect(cells.toSet(), {
        (row: 0, col: 2),
        (row: 0, col: 4),
        (row: 1, col: 0),
        (row: 1, col: 1),
        (row: 1, col: 2),
      });
    });

    test('pickHintCells returns fewer cells near the end, none when done', () {
      final grid = [
        for (final row in puzzle.solution)
          [
            for (final v in row)
              v == 1 ? NonogramCellState.filled : NonogramCellState.empty,
          ],
      ];
      expect(engine.pickHintCells(puzzle: puzzle, gridData: grid), isEmpty);
      grid[1][2] = NonogramCellState.empty;
      grid[0][4] = NonogramCellState.empty;
      expect(engine.pickHintCells(puzzle: puzzle, gridData: grid).toSet(), {
        (row: 1, col: 2),
        (row: 0, col: 4),
      });
    });

    test('pickHintCells spreads across the whole board', () {
      final big = NonogramPuzzle(
        id: 'big',
        title: '',
        author: '',
        difficulty: '',
        difficultyScore: 0,
        level: 1,
        solution: List.generate(10, (_) => List.filled(10, 1)),
      );
      final grid = List.generate(
        10,
        (_) => List.filled(10, NonogramCellState.empty),
      );
      final rows = <int>{};
      for (var seed = 0; seed < 20; seed++) {
        rows.addAll(
          engine
              .pickHintCells(puzzle: big, gridData: grid, random: Random(seed))
              .map((c) => c.row),
        );
      }
      expect(rows.length, greaterThan(5));
    });

    test('revealLine updates grid correctly for rows', () {
      final grid = List.generate(
        3,
        (_) => List.filled(5, NonogramCellState.empty),
      );
      final newGrid = engine.revealLine(
        axis: Axis.horizontal,
        index: 0,
        puzzle: puzzle,
        gridData: grid,
      );

      // Solution Row 0: [1, 0, 1, 0, 1]
      expect(newGrid[0][0], NonogramCellState.filled);
      expect(newGrid[0][1], NonogramCellState.marked); // 0 becomes marked
      expect(newGrid[0][2], NonogramCellState.filled);
      expect(newGrid[0][3], NonogramCellState.marked);
      expect(newGrid[0][4], NonogramCellState.filled);
    });

    test('revealLine updates grid correctly for columns', () {
      final grid = List.generate(
        3,
        (_) => List.filled(5, NonogramCellState.empty),
      );
      final newGrid = engine.revealLine(
        axis: Axis.vertical,
        index: 1,
        puzzle: puzzle,
        gridData: grid,
      );

      // Solution Col 1: [0, 1, 0]
      expect(newGrid[0][1], NonogramCellState.marked);
      expect(newGrid[1][1], NonogramCellState.filled);
      expect(newGrid[2][1], NonogramCellState.marked);
    });
  });
}

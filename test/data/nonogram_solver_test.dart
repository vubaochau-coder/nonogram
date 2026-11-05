import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/models/nonogram_puzzle.dart';
import 'package:nonogram/screens/play/engine/nonogram_solver.dart';

void main() {
  const solver = NonogramSolver();

  group('solveLine', () {
    test('fills the overlap of a long block', () {
      // 5 ô, gợi ý [4]: 3 ô giữa chắc chắn tô.
      expect(solver.solveLine(List.filled(5, -1), [4]), [-1, 1, 1, 1, -1]);
    });

    test('empty clue marks the whole line empty', () {
      expect(solver.solveLine(List.filled(3, -1), []), [0, 0, 0]);
    });

    test('returns null on contradiction', () {
      expect(solver.solveLine([1, 1, 1], [1]), isNull);
    });
  });

  test('matches brute force on random small grids', () {
    final random = Random(42);
    for (var t = 0; t < 300; t++) {
      final rows = 1 + random.nextInt(4);
      final cols = 1 + random.nextInt(4);
      final grid = [
        for (var r = 0; r < rows; r++)
          [for (var c = 0; c < cols; c++) random.nextInt(2)],
      ];
      final rowClues = [
        for (final row in grid) NonogramPuzzle.deriveClues(row),
      ];
      final colClues = [
        for (var c = 0; c < cols; c++)
          NonogramPuzzle.deriveClues([for (final row in grid) row[c]]),
      ];

      final expected = min(_bruteForceCount(rows, cols, rowClues, colClues), 2);
      expect(
        solver.countSolutions(rowClues: rowClues, colClues: colClues),
        expected,
        reason: 'grid $grid',
      );
    }
  });
}

int _bruteForceCount(
  int rows,
  int cols,
  List<List<int>> rowClues,
  List<List<int>> colClues,
) {
  var count = 0;
  final cells = rows * cols;
  for (var mask = 0; mask < (1 << cells); mask++) {
    final grid = [
      for (var r = 0; r < rows; r++)
        [for (var c = 0; c < cols; c++) (mask >> (r * cols + c)) & 1],
    ];
    var ok = true;
    for (var r = 0; r < rows && ok; r++) {
      ok = _eq(NonogramPuzzle.deriveClues(grid[r]), rowClues[r]);
    }
    for (var c = 0; c < cols && ok; c++) {
      ok = _eq(
        NonogramPuzzle.deriveClues([for (final row in grid) row[c]]),
        colClues[c],
      );
    }
    if (ok) count++;
  }
  return count;
}

bool _eq(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

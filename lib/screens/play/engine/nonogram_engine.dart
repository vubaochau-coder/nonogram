import 'dart:math';

import 'package:flutter/painting.dart';
import 'package:nonogram/models/nonogram_cell_state.dart';
import 'package:nonogram/models/nonogram_puzzle.dart';
import 'package:nonogram/models/nonogram_board_snapshot.dart';
import 'package:nonogram/screens/play/engine/nonogram_board_layout.dart';

/// A stateless rule engine for Nonogram logic.
/// It provides pure functions to calculate next states based on inputs.
final class NonogramEngine {
  const NonogramEngine();

  /// Cỡ ô cho màn mới: lớn nhất có thể để cả lưới vừa khung nhìn (sau khi
  /// trừ hai dải gợi ý), trong khoảng [NonogramBoardLayout.minCellSize] ..
  /// [NonogramBoardLayout.maxCellSize]; lưới lớn hơn thì kéo để xem.
  double fitCellSize({required NonogramPuzzle puzzle, required Size viewport}) {
    return NonogramBoardLayout.forPuzzle(
      puzzle: puzzle,
      cellSize: NonogramBoardLayout.maxCellSize,
      viewport: viewport,
    ).fitCellSize();
  }

  List<int> deriveLineRuns(List<NonogramCellState> line) {
    final runs = <int>[];
    var currentRun = 0;

    for (final cell in line) {
      if (cell == NonogramCellState.filled) {
        currentRun++;
        continue;
      }

      if (currentRun > 0) {
        runs.add(currentRun);
        currentRun = 0;
      }
    }

    if (currentRun > 0) runs.add(currentRun);

    return runs;
  }

  bool isLineSatisfied({
    required List<NonogramCellState> line,
    required List<int> clues,
  }) {
    final runs = deriveLineRuns(line);
    if (runs.length != clues.length) return false;

    for (var i = 0; i < runs.length; i++) {
      if (runs[i] != clues[i]) return false;
    }

    return true;
  }

  ({List<bool> rows, List<bool> cols}) deriveSatisfiedLines({
    required NonogramPuzzle puzzle,
    required List<List<NonogramCellState>> gridData,
  }) {
    final rows = List<bool>.generate(puzzle.rows, (row) {
      return isLineSatisfied(line: gridData[row], clues: puzzle.leftClues[row]);
    }, growable: false);

    final cols = List<bool>.generate(puzzle.cols, (col) {
      final line = List<NonogramCellState>.generate(
        puzzle.rows,
        (row) => gridData[row][col],
        growable: false,
      );

      return isLineSatisfied(line: line, clues: puzzle.topClues[col]);
    }, growable: false);

    return (rows: rows, cols: cols);
  }

  bool canFillCell({
    required int row,
    required int col,
    required List<List<NonogramCellState>> gridData,
    required List<bool> satisfiedRows,
    required List<bool> satisfiedCols,
  }) {
    // Already filled cells can always be toggled back to empty
    if (gridData[row][col] == NonogramCellState.filled) return true;

    // If it's empty or marked, we can only fill it if the line is not satisfied
    if (row < satisfiedRows.length && satisfiedRows[row]) return false;
    if (col < satisfiedCols.length && satisfiedCols[col]) return false;
    return true;
  }

  bool canMarkCell({
    required int row,
    required int col,
    required List<List<NonogramCellState>> gridData,
  }) {
    // Only empty cells can be marked via long press
    return gridData[row][col] == NonogramCellState.empty;
  }

  /// Creates a new grid filled with [NonogramCellState.empty].
  List<List<NonogramCellState>> createEmptyGrid({
    required int rows,
    required int cols,
  }) {
    return List.generate(
      rows,
      (_) => List.generate(cols, (_) => NonogramCellState.empty),
    );
  }

  /// Updates a specific cell and returns a NEW grid instance.
  /// Follows the immutable pattern.
  List<List<NonogramCellState>> setCell({
    required List<List<NonogramCellState>> gridData,
    required int row,
    required int col,
    required NonogramCellState value,
  }) {
    if (row < 0 ||
        row >= gridData.length ||
        col < 0 ||
        col >= gridData[0].length) {
      return gridData;
    }

    // Create a new representation
    final newGrid =
        gridData.map((r) => List<NonogramCellState>.from(r)).toList();
    newGrid[row][col] = value;

    return newGrid;
  }

  /// Số ô gợi ý tô giúp mỗi lần.
  static const int hintCellCount = 5;

  /// Gợi ý: chọn ngẫu nhiên tối đa [count] ô trên toàn bàn mà đáp án là tô
  /// nhưng người chơi chưa tô (ô trống hoặc đang đánh X nhầm). Rỗng nếu mọi
  /// ô cần tô đều đã tô.
  List<({int row, int col})> pickHintCells({
    required NonogramPuzzle puzzle,
    required List<List<NonogramCellState>> gridData,
    int count = hintCellCount,
    Random? random,
  }) {
    final candidates = [
      for (var r = 0; r < puzzle.rows; r++)
        for (var c = 0; c < puzzle.cols; c++)
          if (puzzle.solution[r][c] == 1 &&
              gridData[r][c] != NonogramCellState.filled)
            (row: r, col: c),
    ];
    candidates.shuffle(random ?? Random());
    return candidates.take(count).toList();
  }

  /// Tô các ô [cells].
  List<List<NonogramCellState>> fillCells({
    required List<List<NonogramCellState>> gridData,
    required Iterable<({int row, int col})> cells,
  }) {
    final newGrid =
        gridData.map((r) => List<NonogramCellState>.from(r)).toList();
    for (final cell in cells) {
      newGrid[cell.row][cell.col] = NonogramCellState.filled;
    }
    return newGrid;
  }

  /// Số ô sai so với đáp án trên một hàng ([Axis.horizontal]) hoặc cột:
  /// ô phải tô mà chưa tô, hoặc ô không được tô mà đang tô.
  int lineMismatchCount({
    required Axis axis,
    required int index,
    required NonogramPuzzle puzzle,
    required List<List<NonogramCellState>> gridData,
  }) {
    final length = axis == Axis.horizontal ? puzzle.cols : puzzle.rows;
    var mismatch = 0;
    for (var i = 0; i < length; i++) {
      final r = axis == Axis.horizontal ? index : i;
      final c = axis == Axis.horizontal ? i : index;
      final filled = gridData[r][c] == NonogramCellState.filled;
      if ((puzzle.solution[r][c] == 1) != filled) mismatch++;
    }
    return mismatch;
  }

  /// Reveals a whole line based on the solution.
  List<List<NonogramCellState>> revealLine({
    required Axis axis,
    required int index,
    required NonogramPuzzle puzzle,
    required List<List<NonogramCellState>> gridData,
  }) {
    final newGrid =
        gridData.map((r) => List<NonogramCellState>.from(r)).toList();

    if (axis == Axis.horizontal) {
      for (int c = 0; c < puzzle.cols; c++) {
        newGrid[index][c] =
            puzzle.solution[index][c] == 1
                ? NonogramCellState.filled
                : NonogramCellState.marked;
      }
    } else {
      for (int r = 0; r < puzzle.rows; r++) {
        newGrid[r][index] =
            puzzle.solution[r][index] == 1
                ? NonogramCellState.filled
                : NonogramCellState.marked;
      }
    }

    return newGrid;
  }

  /// Validates if the current [gridData] matches the [puzzle] solution.
  bool isSolved({
    required NonogramPuzzle puzzle,
    required List<List<NonogramCellState>> gridData,
  }) {
    if (gridData.length != puzzle.rows) return false;

    for (int r = 0; r < puzzle.rows; r++) {
      for (int c = 0; c < puzzle.cols; c++) {
        final solutionValue = puzzle.solution[r][c];
        final cellState = gridData[r][c];

        if (solutionValue == 1) {
          // Cell must be filled
          if (cellState != NonogramCellState.filled) return false;
        } else {
          // Cell must NOT be filled (can be empty or marked)
          if (cellState == NonogramCellState.filled) return false;
        }
      }
    }
    return true;
  }

  /// Restores grid data from a snapshot if available and valid.
  /// Otherwise, returns a fresh empty grid.
  List<List<NonogramCellState>> restoreGrid({
    required NonogramPuzzle puzzle,
    required NonogramBoardSnapshot? snapshot,
  }) {
    final grid =
        snapshot != null &&
                snapshot.puzzleId == puzzle.id &&
                snapshot.gridData.length == puzzle.rows &&
                snapshot.gridData.every((row) => row.length == puzzle.cols)
            ? snapshot.gridData
                .map((row) => List<NonogramCellState>.from(row))
                .toList()
            : createEmptyGrid(rows: puzzle.rows, cols: puzzle.cols);
    applyPinnedCells(puzzle: puzzle, grid: grid);
    return grid;
  }

  /// Đặt các ô ghim sẵn của màn đúng theo đáp án (ô tô hoặc ô X).
  void applyPinnedCells({
    required NonogramPuzzle puzzle,
    required List<List<NonogramCellState>> grid,
  }) {
    for (final cell in puzzle.pinnedCells) {
      grid[cell.row][cell.col] =
          puzzle.solution[cell.row][cell.col] == 1
              ? NonogramCellState.filled
              : NonogramCellState.marked;
    }
  }
}

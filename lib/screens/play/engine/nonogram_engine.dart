import 'package:flutter/painting.dart';
import 'package:nonogram/models/nonogram_cell_state.dart';
import 'package:nonogram/models/nonogram_puzzle.dart';
import 'package:nonogram/models/nonogram_board_snapshot.dart';

/// A stateless rule engine for Nonogram logic.
/// It provides pure functions to calculate next states based on inputs.
final class NonogramEngine {
  const NonogramEngine();

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

  /// Calculates which line should be hinted.
  /// Uses "minimum mismatch count" rule, prioritizing rows over cols, then smaller index.
  ({Axis axis, int index})? calculateHintLine({
    required NonogramPuzzle puzzle,
    required List<List<NonogramCellState>> gridData,
  }) {
    ({Axis axis, int index, int mismatchCount})? bestCandidate;

    void updateBest(Axis axis, int index, int mismatchCount) {
      if (mismatchCount == 0) return;

      if (bestCandidate == null ||
          mismatchCount < bestCandidate!.mismatchCount) {
        bestCandidate = (
          axis: axis,
          index: index,
          mismatchCount: mismatchCount,
        );
      }
    }

    // Check rows
    for (int r = 0; r < puzzle.rows; r++) {
      int mismatch = 0;
      for (int c = 0; c < puzzle.cols; c++) {
        final solutionValue = puzzle.solution[r][c];
        final cellState = gridData[r][c];
        final isMismatch =
            (solutionValue == 1)
                ? (cellState != NonogramCellState.filled)
                : (cellState == NonogramCellState.filled);

        if (isMismatch) {
          mismatch++;
        }
      }
      updateBest(Axis.horizontal, r, mismatch);
    }

    // Check columns
    for (int c = 0; c < puzzle.cols; c++) {
      int mismatch = 0;
      for (int r = 0; r < puzzle.rows; r++) {
        final solutionValue = puzzle.solution[r][c];
        final cellState = gridData[r][c];
        final isMismatch =
            (solutionValue == 1)
                ? (cellState != NonogramCellState.filled)
                : (cellState == NonogramCellState.filled);

        if (isMismatch) {
          mismatch++;
        }
      }
      updateBest(Axis.vertical, c, mismatch);
    }

    if (bestCandidate == null) return null;
    return (axis: bestCandidate!.axis, index: bestCandidate!.index);
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
    if (snapshot != null &&
        snapshot.puzzleId == puzzle.id &&
        snapshot.gridData.length == puzzle.rows &&
        snapshot.gridData.every((row) => row.length == puzzle.cols)) {
      return snapshot.gridData
          .map((row) => List<NonogramCellState>.from(row))
          .toList();
    }

    return createEmptyGrid(rows: puzzle.rows, cols: puzzle.cols);
  }
}

import 'package:nonogram/models/nonogram_board_snapshot.dart';
import 'package:nonogram/models/nonogram_cell_state.dart';
import 'nonogram_play_state.dart';

class NonogramSnapshotMapper {
  static NonogramBoardSnapshot? fromState(
    NonogramPlayState state, {
    double? viewportOffsetX,
    double? viewportOffsetY,
  }) {
    final puzzle = state.puzzle;
    if (puzzle == null) return null;
    if (state.isSolved) return null;
    if (state.isLoading) return null;

    return NonogramBoardSnapshot(
      puzzleId: puzzle.id,
      level: puzzle.level,
      gridData:
          state.gridData
              .map((row) => List<NonogramCellState>.from(row))
              .toList(),
      startTime: state.startTime,
      interactionMode: state.interactionMode,
      viewportOffsetX: viewportOffsetX ?? 0,
      viewportOffsetY: viewportOffsetY ?? 0,
      cellSize: state.cellSize,
      lockedCells: state.lockedCells,
    );
  }
}

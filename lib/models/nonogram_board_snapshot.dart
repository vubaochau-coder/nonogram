import 'package:nonogram/models/nonogram_cell_state.dart';
import 'package:nonogram/models/nonogram_interaction_mode.dart';

/// Represents a persistent save state of the nonogram grid and all runtime session info.
/// Used at Phase 4.1 to allow players to resume their current progress.
class NonogramBoardSnapshot {
  final String puzzleId;
  final int level;
  final List<List<NonogramCellState>> gridData;
  final DateTime startTime;
  final NonogramInteractionMode interactionMode;
  final double viewportOffsetX;
  final double viewportOffsetY;
  final double cellSize;
  final int remainingHints;

  const NonogramBoardSnapshot({
    required this.puzzleId,
    required this.level,
    required this.gridData,
    required this.startTime,
    required this.interactionMode,
    this.viewportOffsetX = 0,
    this.viewportOffsetY = 0,
    this.cellSize = 40.0,
    this.remainingHints = 3,
  });

  Map<String, dynamic> toMap() {
    return {
      'puzzleId': puzzleId,
      'level': level,
      'gridData':
          gridData.map((row) => row.map((e) => e.index).toList()).toList(),
      'startTime': startTime.toIso8601String(),
      'interactionMode': interactionMode.index,
      'viewportOffsetX': viewportOffsetX,
      'viewportOffsetY': viewportOffsetY,
      'cellSize': cellSize,
      'remainingHints': remainingHints,
    };
  }

  factory NonogramBoardSnapshot.fromMap(Map<String, dynamic> map) {
    return NonogramBoardSnapshot(
      puzzleId: map['puzzleId'] as String,
      level: map['level'] as int,
      gridData:
          (map['gridData'] as List).map((row) {
            return (row as List)
                .map((e) => NonogramCellState.values[e as int])
                .toList();
          }).toList(),
      startTime: DateTime.parse(map['startTime'] as String),
      interactionMode:
          NonogramInteractionMode.values[map['interactionMode'] as int],
      viewportOffsetX: (map['viewportOffsetX'] as num).toDouble(),
      viewportOffsetY: (map['viewportOffsetY'] as num).toDouble(),
      cellSize: (map['cellSize'] as num?)?.toDouble() ?? 40.0,
      remainingHints: (map['remainingHints'] as int?) ?? 3,
    );
  }
}

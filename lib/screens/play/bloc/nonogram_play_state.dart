import 'package:flutter/material.dart';
import 'package:nonogram/models/nonogram_cell_state.dart';
import 'package:nonogram/models/nonogram_interaction_mode.dart';
import 'package:nonogram/models/nonogram_puzzle.dart';
import 'package:equatable/equatable.dart';

class NonogramPlayState extends Equatable {
  final bool isLoading;

  final NonogramPuzzle? puzzle;
  final int level;
  final DateTime startTime;

  final List<List<NonogramCellState>> gridData;
  final List<bool> satisfiedRows;
  final List<bool> satisfiedCols;
  final NonogramInteractionMode interactionMode;
  final double cellSize;
  final bool isFullscreen;
  final bool isSolved;

  /// Số lượt gợi ý còn trong kho dùng chung (xem `PowerUpInventory`).
  final int remainingHints;

  /// Số lượt gậy phép còn lại (chọn một hàng / cột để hiện đáp án).
  final int remainingWands;

  /// Đang chờ người chơi chọn hàng / cột cho gậy phép.
  final bool isWandActive;

  /// Ô đã mở bằng gợi ý / gậy phép: không đổi được, và giữ lại khi chơi lại
  /// từ đầu (người chơi đã "trả" lượt cho chúng).
  final Set<({int row, int col})> lockedCells;

  const NonogramPlayState({
    required this.isLoading,
    this.puzzle,
    required this.level,
    required this.startTime,
    required this.gridData,
    this.satisfiedRows = const [],
    this.satisfiedCols = const [],
    this.interactionMode = NonogramInteractionMode.fill,
    this.cellSize = 40.0,
    this.isFullscreen = false,
    this.isSolved = false,
    this.remainingHints = 0,
    this.remainingWands = 0,
    this.isWandActive = false,
    this.lockedCells = const {},
  });

  bool isLocked(int row, int col) => lockedCells.contains((row: row, col: col));

  factory NonogramPlayState.initial({int initialLevel = 1}) {
    return NonogramPlayState(
      isLoading: true,
      level: initialLevel,
      startTime: DateTime.now(),
      gridData: const [],
    );
  }

  NonogramPlayState copyWith({
    bool? isLoading,
    NonogramPuzzle? puzzle,
    int? level,
    DateTime? startTime,
    List<List<NonogramCellState>>? gridData,
    List<bool>? satisfiedRows,
    List<bool>? satisfiedCols,
    NonogramInteractionMode? interactionMode,
    double? cellSize,
    bool? isFullscreen,
    bool? isSolved,
    int? remainingHints,
    int? remainingWands,
    bool? isWandActive,
    Set<({int row, int col})>? lockedCells,
  }) {
    return NonogramPlayState(
      isLoading: isLoading ?? this.isLoading,
      puzzle: puzzle ?? this.puzzle,
      level: level ?? this.level,
      startTime: startTime ?? this.startTime,
      gridData: gridData ?? this.gridData,
      satisfiedRows: satisfiedRows ?? this.satisfiedRows,
      satisfiedCols: satisfiedCols ?? this.satisfiedCols,
      interactionMode: interactionMode ?? this.interactionMode,
      cellSize: cellSize ?? this.cellSize,
      isFullscreen: isFullscreen ?? this.isFullscreen,
      isSolved: isSolved ?? this.isSolved,
      remainingHints: remainingHints ?? this.remainingHints,
      remainingWands: remainingWands ?? this.remainingWands,
      isWandActive: isWandActive ?? this.isWandActive,
      lockedCells: lockedCells ?? this.lockedCells,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    puzzle,
    level,
    startTime,
    gridData,
    satisfiedRows,
    satisfiedCols,
    interactionMode,
    cellSize,
    isFullscreen,
    isSolved,
    remainingHints,
    remainingWands,
    isWandActive,
    lockedCells,
  ];
}

/// Pulse state when game completes.
class NonogramPlayCompletedState extends NonogramPlayState {
  const NonogramPlayCompletedState({
    required super.isLoading,
    required super.puzzle,
    required super.level,
    required super.startTime,
    required super.gridData,
    required super.satisfiedRows,
    required super.satisfiedCols,
    required super.interactionMode,
    required super.cellSize,
    required super.isFullscreen,
    required super.isSolved,
    required super.remainingHints,
    required super.remainingWands,
    required super.isWandActive,
    required super.lockedCells,
  });

  factory NonogramPlayCompletedState.fromState(NonogramPlayState state) {
    return NonogramPlayCompletedState(
      isLoading: state.isLoading,
      puzzle: state.puzzle,
      level: state.level,
      startTime: state.startTime,
      gridData: state.gridData,
      satisfiedRows: state.satisfiedRows,
      satisfiedCols: state.satisfiedCols,
      interactionMode: state.interactionMode,
      cellSize: state.cellSize,
      isFullscreen: state.isFullscreen,
      isSolved: true,
      remainingHints: state.remainingHints,
      remainingWands: state.remainingWands,
      isWandActive: state.isWandActive,
      lockedCells: state.lockedCells,
    );
  }
}

/// Pulse state emitted ONCE when a game is successfully restored from a snapshot.
class NonogramPlayRestoredState extends NonogramPlayState {
  final double offsetX;
  final double offsetY;

  const NonogramPlayRestoredState({
    required super.isLoading,
    required super.puzzle,
    required super.level,
    required super.startTime,
    required super.gridData,
    required super.satisfiedRows,
    required super.satisfiedCols,
    required super.interactionMode,
    required super.cellSize,
    required super.isFullscreen,
    required super.isSolved,
    required super.remainingHints,
    required super.remainingWands,
    required super.isWandActive,
    required super.lockedCells,
    required this.offsetX,
    required this.offsetY,
  });

  factory NonogramPlayRestoredState.fromState(
    NonogramPlayState state, {
    double offsetX = 0,
    double offsetY = 0,
  }) {
    return NonogramPlayRestoredState(
      isLoading: state.isLoading,
      puzzle: state.puzzle,
      level: state.level,
      startTime: state.startTime,
      gridData: state.gridData,
      satisfiedRows: state.satisfiedRows,
      satisfiedCols: state.satisfiedCols,
      interactionMode: state.interactionMode,
      cellSize: state.cellSize,
      isFullscreen: state.isFullscreen,
      isSolved: state.isSolved,
      remainingHints: state.remainingHints,
      remainingWands: state.remainingWands,
      isWandActive: state.isWandActive,
      lockedCells: state.lockedCells,
      offsetX: offsetX,
      offsetY: offsetY,
    );
  }

  @override
  List<Object?> get props => [...super.props, offsetX, offsetY];
}

/// State representing an error.
class NonogramPlayErrorState extends NonogramPlayState {
  final Object error;

  const NonogramPlayErrorState({
    required super.isLoading,
    required super.puzzle,
    required super.level,
    required super.startTime,
    required super.gridData,
    required super.satisfiedRows,
    required super.satisfiedCols,
    required super.interactionMode,
    required super.cellSize,
    required super.isFullscreen,
    required super.isSolved,
    required super.remainingHints,
    required super.remainingWands,
    required super.isWandActive,
    required super.lockedCells,
    required this.error,
  });

  factory NonogramPlayErrorState.fromState(
    NonogramPlayState state, {
    required Object error,
  }) {
    return NonogramPlayErrorState(
      isLoading: false,
      puzzle: state.puzzle,
      level: state.level,
      startTime: state.startTime,
      gridData: state.gridData,
      satisfiedRows: state.satisfiedRows,
      satisfiedCols: state.satisfiedCols,
      interactionMode: state.interactionMode,
      cellSize: state.cellSize,
      isFullscreen: state.isFullscreen,
      isSolved: state.isSolved,
      remainingHints: state.remainingHints,
      remainingWands: state.remainingWands,
      isWandActive: state.isWandActive,
      lockedCells: state.lockedCells,
      error: error,
    );
  }

  String get message => error.toString();

  @override
  List<Object?> get props => [...super.props, error];
}

/// Pulse state emitted when a whole line is revealed (magic wand).
class NonogramPlayHintAppliedState extends NonogramPlayState {
  final Axis axis;
  final int lineIndex;

  const NonogramPlayHintAppliedState({
    required super.isLoading,
    required super.puzzle,
    required super.level,
    required super.startTime,
    required super.gridData,
    required super.satisfiedRows,
    required super.satisfiedCols,
    required super.interactionMode,
    required super.cellSize,
    required super.isFullscreen,
    required super.isSolved,
    required super.remainingHints,
    required super.remainingWands,
    required super.isWandActive,
    required super.lockedCells,
    required this.axis,
    required this.lineIndex,
  });

  factory NonogramPlayHintAppliedState.fromState(
    NonogramPlayState state, {
    required Axis axis,
    required int lineIndex,
  }) {
    return NonogramPlayHintAppliedState(
      isLoading: state.isLoading,
      puzzle: state.puzzle,
      level: state.level,
      startTime: state.startTime,
      gridData: state.gridData,
      satisfiedRows: state.satisfiedRows,
      satisfiedCols: state.satisfiedCols,
      interactionMode: state.interactionMode,
      cellSize: state.cellSize,
      isFullscreen: state.isFullscreen,
      isSolved: state.isSolved,
      remainingHints: state.remainingHints,
      remainingWands: state.remainingWands,
      isWandActive: state.isWandActive,
      lockedCells: state.lockedCells,
      axis: axis,
      lineIndex: lineIndex,
    );
  }

  @override
  List<Object?> get props => [...super.props, axis, lineIndex];
}

/// Pulse state emitted when the hint fills some cells.
class NonogramPlayHintCellsAppliedState extends NonogramPlayState {
  /// Ô vừa được gợi ý tô giúp.
  final List<({int row, int col})> cells;

  const NonogramPlayHintCellsAppliedState({
    required super.isLoading,
    required super.puzzle,
    required super.level,
    required super.startTime,
    required super.gridData,
    required super.satisfiedRows,
    required super.satisfiedCols,
    required super.interactionMode,
    required super.cellSize,
    required super.isFullscreen,
    required super.isSolved,
    required super.remainingHints,
    required super.remainingWands,
    required super.isWandActive,
    required super.lockedCells,
    required this.cells,
  });

  factory NonogramPlayHintCellsAppliedState.fromState(
    NonogramPlayState state, {
    required List<({int row, int col})> cells,
  }) {
    return NonogramPlayHintCellsAppliedState(
      isLoading: state.isLoading,
      puzzle: state.puzzle,
      level: state.level,
      startTime: state.startTime,
      gridData: state.gridData,
      satisfiedRows: state.satisfiedRows,
      satisfiedCols: state.satisfiedCols,
      interactionMode: state.interactionMode,
      cellSize: state.cellSize,
      isFullscreen: state.isFullscreen,
      isSolved: state.isSolved,
      remainingHints: state.remainingHints,
      remainingWands: state.remainingWands,
      isWandActive: state.isWandActive,
      lockedCells: state.lockedCells,
      cells: cells,
    );
  }

  @override
  List<Object?> get props => [...super.props, cells];
}

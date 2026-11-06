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
  final int remainingHints;

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
    this.remainingHints = 3,
  });

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
      error: error,
    );
  }

  String get message => error.toString();

  @override
  List<Object?> get props => [...super.props, error];
}

/// Pulse state emitted when a hint is applied.
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
      axis: axis,
      lineIndex: lineIndex,
    );
  }

  @override
  List<Object?> get props => [...super.props, axis, lineIndex];
}

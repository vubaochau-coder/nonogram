import 'dart:ui' show Offset, Size;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:nonogram/core/app_bloc.dart';
import 'package:nonogram/core/toast_utils.dart';
import 'package:nonogram/models/nonogram_board_snapshot.dart';
import 'package:nonogram/models/nonogram_cell_state.dart';
import 'package:nonogram/models/nonogram_interaction_mode.dart';
import 'package:nonogram/models/nonogram_completed_progress.dart';
import 'package:nonogram/data/nonogram_repository.dart';
import 'package:nonogram/models/nonogram_puzzle.dart';
import 'package:nonogram/screens/play/engine/nonogram_board_layout.dart';
import 'package:nonogram/screens/play/engine/nonogram_engine.dart';
import 'package:nonogram/core/list_ext.dart';
import 'nonogram_play_event.dart';
import 'nonogram_play_state.dart';
import 'nonogram_snapshot_mapper.dart';

class NonogramPlayBloc extends AppBloc<NonogramPlayEvent, NonogramPlayState> {
  /// Cỡ ô người chơi chọn trong cài đặt (mặc định 40); màn lớn có thể dùng
  /// cỡ nhỏ hơn để vừa màn hình.
  double _preferredCellSize = 40;
  Size? _viewportSize;
  bool _pendingAutoFit = false;
  Offset? _pendingViewport;

  /// Vị trí lưới đã lưu của ván dở, để bàn chơi áp dụng khi dựng xong.
  /// Lấy một lần rồi xoá; null nghĩa là dùng vị trí mở màn mặc định.
  Offset? takePendingViewport() {
    final value = _pendingViewport;
    _pendingViewport = null;
    return value;
  }

  final NonogramRepository _repository;
  final NonogramEngine _engine;

  _DragSession? _dragSession;

  NonogramPlayBloc({
    required NonogramRepository repository,
    NonogramEngine? engine,
    int initialLevel = 1,
  }) : _repository = repository,
       _engine = engine ?? const NonogramEngine(),
       super(NonogramPlayState.initial(initialLevel: initialLevel)) {
    // --- System & Lifecycle Events ---
    on<InitialRequested>(_onInitialRequested, transformer: sequential());
    on<LevelLoadRequested>(_onLevelLoadRequested, transformer: sequential());
    on<NextLevelRequested>(_onNextLevelRequested, transformer: sequential());
    on<Started>(_onStarted, transformer: sequential());
    on<ViewportChanged>(_onViewportChanged, transformer: sequential());
    on<BoardViewportMeasured>(
      _onBoardViewportMeasured,
      transformer: sequential(),
    );

    // --- User Actions & Gameplay ---
    on<CellTapped>(_onCellTapped, transformer: sequential());
    on<CellLongPressed>(_onCellLongPressed, transformer: sequential());
    on<DragStarted>(_onDragStarted, transformer: sequential());
    on<DragUpdated>(_onDragUpdated, transformer: droppable());
    on<DragEnded>(_onDragEnded, transformer: sequential());
    on<InteractionModeChanged>(
      _onInteractionModeChanged,
      transformer: sequential(),
    );
    on<CellSizeChanged>(_onCellSizeChanged, transformer: sequential());
    on<CellSizePreviewed>(_onCellSizePreviewed, transformer: sequential());
    on<FullscreenToggled>(_onFullscreenToggled, transformer: sequential());
    on<BoardReset>(_onBoardReset, transformer: sequential());
    on<HintRequested>(_onHintRequested, transformer: sequential());

    // --- Internal/Orchestration Events ---
    on<CurrentProgressSaveRequested>(
      _onCurrentProgressSaveRequested,
      transformer: sequential(),
    );
    on<SolveCheckRequested>(_onSolveCheckRequested, transformer: sequential());
    on<PuzzleSolved>(_onPuzzleSolved, transformer: sequential());
  }

  _onInitialRequested(InitialRequested event, Emitter emit) async {
    emit(state.copyWith(level: state.level, isLoading: true, isSolved: false));
    add(const LevelLoadRequested());
  }

  _onLevelLoadRequested(LevelLoadRequested event, Emitter emit) async {
    final targetLevel = state.level;

    try {
      NonogramBoardSnapshot? matchedSnapshot;
      final snapshot = await _repository.getCurrentProgress();
      if (snapshot != null && snapshot.level == targetLevel) {
        final completed = await _repository.getCompletedProgress();
        final isAlreadyCompleted = completed.any(
          (e) => e.level == snapshot.level,
        );
        if (!isAlreadyCompleted) {
          matchedSnapshot = snapshot;
        }
      }

      final puzzle = await _repository.getPuzzleByLevel(targetLevel);
      if (puzzle == null) {
        if (state.isSolved && state.puzzle != null) {
          emit(state.copyWith(level: state.puzzle!.level, isLoading: false));
          ToastUtils.info(title: l10n.nonogramPlayNoNextLevelToast);
          return;
        }

        emit(
          NonogramPlayErrorState.fromState(
            state,
            error: 'Puzzle level $targetLevel not found',
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          level: targetLevel,
          isLoading: true,
          isSolved: false,
          gridData: const [],
          satisfiedRows: const [],
          satisfiedCols: const [],
        ),
      );

      add(Started(puzzle: puzzle, snapshot: matchedSnapshot));
    } catch (e) {
      emit(NonogramPlayErrorState.fromState(state, error: e));
    }
  }

  _onNextLevelRequested(NextLevelRequested event, Emitter emit) async {
    if (!state.isSolved) return;
    emit(state.copyWith(level: state.level + 1, isLoading: true));
    add(const LevelLoadRequested());
  }

  _onStarted(Started event, Emitter emit) async {
    final puzzle = event.puzzle;
    final snapshot = event.snapshot;

    final initialGrid = _engine.restoreGrid(puzzle: puzzle, snapshot: snapshot);

    final startTime = snapshot?.startTime ?? DateTime.now();
    final interactionMode = snapshot?.interactionMode ?? state.interactionMode;
    // Ván dở giữ cỡ ô đã lưu; màn mới tự co theo khung nhìn (nếu đã biết).
    final double cellSize;
    if (snapshot != null) {
      cellSize = snapshot.cellSize;
      _pendingAutoFit = false;
    } else {
      cellSize = _autoCellSize(puzzle);
      _pendingAutoFit = _viewportSize == null;
    }
    final remainingHints = snapshot?.remainingHints ?? 3;

    final offsetX = snapshot?.viewportOffsetX ?? 0.0;
    final offsetY = snapshot?.viewportOffsetY ?? 0.0;
    // Ván dở: vị trí đã lưu. Màn mới: null = bàn chơi tự đặt ở vị trí đầu.
    _pendingViewport = snapshot != null ? Offset(offsetX, offsetY) : null;
    final satisfied = _engine.deriveSatisfiedLines(
      puzzle: puzzle,
      gridData: initialGrid,
    );

    final readyState = state.copyWith(
      isLoading: false,
      puzzle: puzzle,
      level: puzzle.level,
      startTime: startTime,
      gridData: initialGrid.toUnmodifiable2D(),
      satisfiedRows: satisfied.rows,
      satisfiedCols: satisfied.cols,
      interactionMode: interactionMode,
      cellSize: cellSize,
      isFullscreen: state.isFullscreen,
      isSolved: _engine.isSolved(puzzle: puzzle, gridData: initialGrid),
      remainingHints: remainingHints,
    );

    if (snapshot != null) {
      emit(
        NonogramPlayRestoredState.fromState(
          readyState,
          offsetX: offsetX,
          offsetY: offsetY,
        ),
      );
    }

    emit(readyState);
  }

  _onCellTapped(CellTapped event, Emitter emit) {
    if (state.isLoading || state.isSolved || state.puzzle == null) return;
    if (state.interactionMode != NonogramInteractionMode.draw) return;
    if (!_engine.canFillCell(
      row: event.row,
      col: event.col,
      gridData: state.gridData,
      satisfiedRows: state.satisfiedRows,
      satisfiedCols: state.satisfiedCols,
    )) {
      return;
    }

    final currentCell = state.gridData[event.row][event.col];
    final targetState =
        currentCell == NonogramCellState.filled
            ? NonogramCellState.empty
            : NonogramCellState.filled;

    final newGrid = _engine.setCell(
      gridData: state.gridData,
      row: event.row,
      col: event.col,
      value: targetState,
    );

    final nextState = _buildGridDerivedState(
      sourceState: state,
      gridData: newGrid.toUnmodifiable2D(),
    );
    emit(nextState);

    // Side effects via events
    add(
      CurrentProgressSaveRequested(
        sourceState: nextState,
        offsetX: event.offsetX,
        offsetY: event.offsetY,
      ),
    );
    add(const SolveCheckRequested());
  }

  _onCellLongPressed(CellLongPressed event, Emitter emit) {
    if (state.isLoading || state.isSolved || state.puzzle == null) return;
    if (state.interactionMode != NonogramInteractionMode.draw) return;

    if (!_engine.canMarkCell(
      row: event.row,
      col: event.col,
      gridData: state.gridData,
    )) {
      return;
    }

    final newGrid = _engine.setCell(
      gridData: state.gridData,
      row: event.row,
      col: event.col,
      value: NonogramCellState.marked,
    );

    final nextState = _buildGridDerivedState(
      sourceState: state,
      gridData: newGrid.toUnmodifiable2D(),
    );
    emit(nextState);

    add(
      CurrentProgressSaveRequested(
        sourceState: nextState,
        offsetX: event.offsetX,
        offsetY: event.offsetY,
      ),
    );
    add(const SolveCheckRequested());
  }

  _onDragStarted(DragStarted event, Emitter emit) {
    if (state.isLoading || state.isSolved || state.puzzle == null) return;
    if (state.interactionMode != NonogramInteractionMode.draw) return;

    final currentCell = state.gridData[event.row][event.col];
    final targetState =
        currentCell == NonogramCellState.filled
            ? NonogramCellState.empty
            : NonogramCellState.filled;

    _dragSession = _DragSession(targetState: targetState);

    _applyCellChange(event.row, event.col, emit);
  }

  _onDragUpdated(DragUpdated event, Emitter emit) {
    if (state.isLoading || state.isSolved || state.puzzle == null) return;
    if (state.interactionMode != NonogramInteractionMode.draw) return;
    if (_dragSession == null) return;

    _applyCellChange(event.row, event.col, emit);
  }

  _onDragEnded(DragEnded event, Emitter emit) {
    _dragSession = null;

    add(
      CurrentProgressSaveRequested(
        sourceState: state,
        offsetX: event.offsetX,
        offsetY: event.offsetY,
      ),
    );
    add(const SolveCheckRequested());
  }

  _onInteractionModeChanged(InteractionModeChanged event, Emitter emit) {
    if (state.isSolved) return;
    _dragSession = null;
    final nextMode =
        state.interactionMode == NonogramInteractionMode.explore
            ? NonogramInteractionMode.draw
            : NonogramInteractionMode.explore;

    final nextState = state.copyWith(interactionMode: nextMode);
    emit(nextState);

    add(
      CurrentProgressSaveRequested(
        sourceState: nextState,
        offsetX: event.offsetX,
        offsetY: event.offsetY,
      ),
    );
  }

  double _autoCellSize(NonogramPuzzle puzzle) {
    final viewport = _viewportSize;
    if (viewport == null) return _preferredCellSize;
    return _engine.fitCellSize(
      puzzle: puzzle,
      viewport: viewport,
      preferred: _preferredCellSize,
    );
  }

  _onBoardViewportMeasured(BoardViewportMeasured event, Emitter emit) {
    final size = Size(event.width, event.height);
    if (size == _viewportSize || size.isEmpty) return;
    _viewportSize = size;

    // Màn mới đã bắt đầu trước khi đo được khung nhìn: co lại ngay.
    final puzzle = state.puzzle;
    if (_pendingAutoFit && puzzle != null && !state.isLoading) {
      _pendingAutoFit = false;
      emit(state.copyWith(cellSize: _autoCellSize(puzzle)));
    }
  }

  /// Cập nhật cỡ ô liên tục khi đang chụm/zoom, chưa lưu.
  _onCellSizePreviewed(CellSizePreviewed event, Emitter emit) {
    if (state.puzzle == null || state.isLoading) return;
    _pendingAutoFit = false;
    emit(
      state.copyWith(
        cellSize: event.cellSize.clamp(
          NonogramBoardLayout.minZoomCellSize,
          NonogramBoardLayout.maxZoomCellSize,
        ),
      ),
    );
  }

  _onCellSizeChanged(CellSizeChanged event, Emitter emit) {
    final nextCellSize = event.cellSize.clamp(
      NonogramBoardLayout.minZoomCellSize,
      NonogramBoardLayout.maxZoomCellSize,
    );
    // Zoom chỉ áp dụng cho màn này; cỡ chọn trong cài đặt thì nhớ cho các
    // màn sau.
    if (!event.isZoom) _preferredCellSize = nextCellSize;
    _pendingAutoFit = false;
    final nextState = state.copyWith(cellSize: nextCellSize);
    emit(nextState);

    add(
      CurrentProgressSaveRequested(
        sourceState: nextState,
        offsetX: event.offsetX,
        offsetY: event.offsetY,
      ),
    );
  }

  _onFullscreenToggled(FullscreenToggled event, Emitter emit) {
    final nextFullscreen = !state.isFullscreen;
    final nextState = state.copyWith(isFullscreen: nextFullscreen);
    emit(nextState);

    // UI preference, no persistence by default at Phase 4.3 as decided.
  }

  _onBoardReset(BoardReset event, Emitter emit) {
    if (state.puzzle == null) return;
    _dragSession = null;

    final emptyGrid = _engine.createEmptyGrid(
      rows: state.puzzle!.rows,
      cols: state.puzzle!.cols,
    );

    final nextState = _buildGridDerivedState(
      sourceState: state,
      startTime: DateTime.now(),
      gridData: emptyGrid.toUnmodifiable2D(),
      isLoading: false,
      isSolved: false,
    );

    emit(nextState);

    add(
      CurrentProgressSaveRequested(
        sourceState: nextState,
        offsetX: event.offsetX,
        offsetY: event.offsetY,
      ),
    );
  }

  _onViewportChanged(ViewportChanged event, Emitter emit) {
    if (state.isSolved || state.isLoading) return;
    add(
      CurrentProgressSaveRequested(
        sourceState: state,
        offsetX: event.offsetX,
        offsetY: event.offsetY,
      ),
    );
  }

  _onHintRequested(HintRequested event, Emitter emit) {
    if (state.isLoading ||
        state.isSolved ||
        state.puzzle == null ||
        state.remainingHints <= 0) {
      return;
    }

    final hintLine = _engine.calculateHintLine(
      puzzle: state.puzzle!,
      gridData: state.gridData,
    );

    if (hintLine == null) return;

    final newGrid = _engine.revealLine(
      axis: hintLine.axis,
      index: hintLine.index,
      puzzle: state.puzzle!,
      gridData: state.gridData,
    );

    final nextState = _buildGridDerivedState(
      sourceState: state,
      gridData: newGrid.toUnmodifiable2D(),
      remainingHints: state.remainingHints - 1,
    );

    // Pulse animation state
    emit(
      NonogramPlayHintAppliedState.fromState(
        nextState,
        axis: hintLine.axis,
        lineIndex: hintLine.index,
      ),
    );

    emit(nextState);

    add(
      CurrentProgressSaveRequested(
        sourceState: nextState,
        offsetX: event.offsetX,
        offsetY: event.offsetY,
      ),
    );
    add(const SolveCheckRequested());
  }

  // --- Internal Handlers ---

  _onCurrentProgressSaveRequested(
    CurrentProgressSaveRequested event,
    Emitter emit,
  ) async {
    final snapshot = NonogramSnapshotMapper.fromState(
      event.sourceState,
      viewportOffsetX: event.offsetX,
      viewportOffsetY: event.offsetY,
    );
    if (snapshot != null) {
      await _repository.saveCurrentProgress(snapshot);
    }
  }

  _onSolveCheckRequested(SolveCheckRequested event, Emitter emit) {
    if (state.isSolved || state.puzzle == null) return;

    if (_engine.isSolved(puzzle: state.puzzle!, gridData: state.gridData)) {
      add(const PuzzleSolved());
    }
  }

  _onPuzzleSolved(PuzzleSolved event, Emitter emit) async {
    final puzzle = state.puzzle!;
    final now = DateTime.now();
    final duration = now.difference(state.startTime);
    final completionMs = duration.inMilliseconds;

    // Persist completed progress
    final existing = await _repository.getCompletedProgress();
    final levelRecord = existing.cast<NonogramCompletedProgress?>().firstWhere(
      (e) => e?.level == puzzle.level,
      orElse: () => null,
    );

    final bestTime =
        levelRecord == null
            ? completionMs
            : (completionMs < levelRecord.bestCompletionMs
                ? completionMs
                : levelRecord.bestCompletionMs);

    await _repository.saveCompletedProgress(
      NonogramCompletedProgress(
        puzzleId: puzzle.id,
        level: puzzle.level,
        bestCompletionMs: bestTime,
        completedAt: now,
        lastPlayedAt: now,
      ),
    );

    // Clear current session
    await _repository.clearCurrentProgress();

    final nextState = state.copyWith(isSolved: true);

    emit(NonogramPlayCompletedState.fromState(nextState));

    // Transition to final solved state
    emit(nextState);
  }

  // --- Helpers ---

  void _applyCellChange(int row, int col, Emitter emit) {
    final session = _dragSession;
    if (state.puzzle == null || session == null) return;
    if (row < 0 || row >= state.puzzle!.rows) return;
    if (col < 0 || col >= state.puzzle!.cols) return;

    final cellKey = '$row-$col';
    if (session.processedCells.contains(cellKey)) return;

    if (!_engine.canFillCell(
      row: row,
      col: col,
      gridData: state.gridData,
      satisfiedRows: state.satisfiedRows,
      satisfiedCols: state.satisfiedCols,
    )) {
      return;
    }

    final currentCell = state.gridData[row][col];
    if (currentCell == session.targetState) {
      session.processedCells.add(cellKey);
      return;
    }

    final newGrid = _engine.setCell(
      gridData: state.gridData,
      row: row,
      col: col,
      value: session.targetState,
    );

    session.processedCells.add(cellKey);

    emit(
      _buildGridDerivedState(
        sourceState: state,
        gridData: newGrid.toUnmodifiable2D(),
      ),
    );
  }

  NonogramPlayState _buildGridDerivedState({
    required NonogramPlayState sourceState,
    required List<List<NonogramCellState>> gridData,
    DateTime? startTime,
    bool? isLoading,
    bool? isSolved,
    int? remainingHints,
  }) {
    final puzzle = sourceState.puzzle;
    if (puzzle == null) {
      return sourceState.copyWith(
        gridData: gridData,
        startTime: startTime,
        isLoading: isLoading,
        isSolved: isSolved,
        remainingHints: remainingHints,
      );
    }

    final satisfied = _engine.deriveSatisfiedLines(
      puzzle: puzzle,
      gridData: gridData,
    );

    return sourceState.copyWith(
      startTime: startTime,
      gridData: gridData,
      satisfiedRows: satisfied.rows,
      satisfiedCols: satisfied.cols,
      isLoading: isLoading,
      isSolved: isSolved,
      remainingHints: remainingHints,
    );
  }
}

/// Private class to manage drag interaction state.
class _DragSession {
  final NonogramCellState targetState;
  final Set<String> processedCells = {};

  _DragSession({required this.targetState});
}

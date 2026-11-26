part of 'nonogram_play_bloc.dart';

/// Level lifecycle: loading and starting a level, viewport and fullscreen,
/// board reset, saving progress and detecting the solve.
mixin _LevelHandlers on _PlayBlocBase {
  Future<void> _onInitialRequested(InitialRequested event, Emitter emit) async {
    emit(state.copyWith(level: state.level, isLoading: true, isSolved: false));
    add(const LevelLoadRequested());
  }

  Future<void> _onLevelLoadRequested(
    LevelLoadRequested event,
    Emitter emit,
  ) async {
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

  Future<void> _onNextLevelRequested(
    NextLevelRequested event,
    Emitter emit,
  ) async {
    if (!state.isSolved) return;
    emit(state.copyWith(level: state.level + 1, isLoading: true));
    add(const LevelLoadRequested());
  }

  Future<void> _onStarted(Started event, Emitter emit) async {
    final puzzle = event.puzzle;
    final snapshot = event.snapshot;

    final saved = snapshot?.puzzleId == puzzle.id ? snapshot?.gridData : null;
    final initialGrid = _engine.restoreGrid(puzzle: puzzle, savedGrid: saved);

    final startTime = snapshot?.startTime ?? DateTime.now();
    final interactionMode = snapshot?.interactionMode ?? state.interactionMode;
    // Cỡ ô không do người chơi chọn: luôn là cỡ vừa khung nhìn hiện tại
    // (kể cả ván dở), cập nhật lại khi khung nhìn đổi (xoay màn hình...).
    final cellSize = _autoCellSize(puzzle);
    // Kho dùng chung cho mọi màn, không theo ván.
    final powerUps = _inventory = await _repository.getPowerUps();

    final offsetX = snapshot?.viewportOffsetX ?? 0.0;
    final offsetY = snapshot?.viewportOffsetY ?? 0.0;
    // Ván dở: vị trí đã lưu. Màn mới: null = bàn chơi tự đặt ở vị trí đầu.
    _pendingViewport = snapshot != null ? Offset(offsetX, offsetY) : null;
    final satisfied = _engine.deriveSatisfiedLines(
      puzzle: puzzle,
      gridData: initialGrid,
    );

    _clearUndo();
    final readyState = state.copyWith(
      canUndo: false,
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
      remainingHints: powerUps.totalHints,
      remainingWands: powerUps.totalWands,
      dailyHints: powerUps.dailyHints,
      dailyWands: powerUps.dailyWands,
      isWandActive: false,
      // Ô ghim sẵn của màn luôn khoá, cùng với các ô mở bằng gợi ý / gậy phép.
      lockedCells: {
        ..._validLocked(snapshot?.lockedCells, puzzle),
        ...puzzle.pinnedCells,
      },
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

  /// Ô khoá đọc từ ván lưu, bỏ các ô nằm ngoài bàn (phòng dữ liệu hỏng).
  static Set<({int row, int col})> _validLocked(
    Set<({int row, int col})>? cells,
    NonogramPuzzle puzzle,
  ) {
    if (cells == null || cells.isEmpty) return const {};
    return {
      for (final c in cells)
        if (c.row >= 0 &&
            c.row < puzzle.rows &&
            c.col >= 0 &&
            c.col < puzzle.cols)
          c,
    };
  }

  double _autoCellSize(NonogramPuzzle puzzle) {
    final viewport = _viewportSize;
    if (viewport == null) return NonogramBoardLayout.maxCellSize;
    return NonogramBoardLayout.fitCellSizeFor(puzzle, viewport);
  }

  /// Khung nhìn đổi (lần đo đầu, xoay màn hình, bật/tắt toàn màn hình):
  /// tính lại cỡ ô cho vừa.
  void _onBoardViewportMeasured(BoardViewportMeasured event, Emitter emit) {
    final size = Size(event.width, event.height);
    if (size == _viewportSize || size.isEmpty) return;
    _viewportSize = size;

    final puzzle = state.puzzle;
    if (puzzle == null || state.isLoading) return;
    final cellSize = _autoCellSize(puzzle);
    if (cellSize != state.cellSize) emit(state.copyWith(cellSize: cellSize));
  }

  void _onFullscreenToggled(FullscreenToggled event, Emitter emit) {
    final nextFullscreen = !state.isFullscreen;
    final nextState = state.copyWith(isFullscreen: nextFullscreen);
    emit(nextState);

    // UI preference, no persistence by default at Phase 4.3 as decided.
  }

  void _onBoardReset(BoardReset event, Emitter emit) {
    if (state.puzzle == null) return;
    _dragSession = null;
    _clearUndo();

    // Xoá bàn nhưng giữ các ô khoá (mở bằng gợi ý / gậy phép).
    final puzzle = state.puzzle!;
    final emptyGrid = _engine.createEmptyGrid(
      rows: puzzle.rows,
      cols: puzzle.cols,
    );
    for (final cell in state.lockedCells) {
      emptyGrid[cell.row][cell.col] = puzzle.solution[cell.row][cell.col] == 1
          ? NonogramCellState.filled
          : NonogramCellState.marked;
    }

    final nextState = _buildGridDerivedState(
      sourceState: state,
      startTime: DateTime.now(),
      gridData: emptyGrid.toUnmodifiable2D(),
      isLoading: false,
      isSolved: false,
    ).copyWith(canUndo: false);

    emit(nextState);

    add(
      CurrentProgressSaveRequested(
        sourceState: nextState,
        offsetX: event.offsetX,
        offsetY: event.offsetY,
      ),
    );
  }

  void _onViewportChanged(ViewportChanged event, Emitter emit) {
    if (state.isSolved || state.isLoading) return;
    add(
      CurrentProgressSaveRequested(
        sourceState: state,
        offsetX: event.offsetX,
        offsetY: event.offsetY,
      ),
    );
  }

  // --- Internal Handlers ---

  void _onCurrentProgressSaveRequested(
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

  void _onSolveCheckRequested(SolveCheckRequested event, Emitter emit) {
    if (state.isSolved || state.puzzle == null) return;

    if (_engine.isSolved(puzzle: state.puzzle!, gridData: state.gridData)) {
      add(const PuzzleSolved());
    }
  }

  Future<void> _onPuzzleSolved(PuzzleSolved event, Emitter emit) async {
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

    final bestTime = levelRecord == null
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
}

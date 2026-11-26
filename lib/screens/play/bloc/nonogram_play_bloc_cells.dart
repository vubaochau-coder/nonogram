part of 'nonogram_play_bloc.dart';

/// Editing cells: tap, long press, drag, interaction mode and undo.
mixin _CellHandlers on _PlayBlocBase {
  void _onCellTapped(CellTapped event, Emitter emit) {
    if (state.isLoading || state.isSolved || state.puzzle == null) return;
    // Ô khoá (mở bằng gợi ý / gậy phép) không đổi được.
    if (state.isLocked(event.row, event.col)) return;

    final currentCell = state.gridData[event.row][event.col];
    final NonogramCellState targetState;
    if (state.interactionMode == NonogramInteractionMode.mark) {
      // Chế độ X: bỏ X nếu đang có, còn lại đánh X (kể cả ô đang tô).
      targetState = currentCell == NonogramCellState.marked
          ? NonogramCellState.empty
          : NonogramCellState.marked;
    } else {
      if (!_engine.canFillCell(
        row: event.row,
        col: event.col,
        gridData: state.gridData,
        satisfiedRows: state.satisfiedRows,
        satisfiedCols: state.satisfiedCols,
      )) {
        return;
      }
      targetState = currentCell == NonogramCellState.filled
          ? NonogramCellState.empty
          : NonogramCellState.filled;
    }

    _commitCell(
      event.row,
      event.col,
      targetState,
      event.offsetX,
      event.offsetY,
      emit,
    );
  }

  void _commitCell(
    int row,
    int col,
    NonogramCellState value,
    double offsetX,
    double offsetY,
    Emitter emit,
  ) {
    _pushUndo(state.gridData);
    final newGrid = _engine.setCell(
      gridData: state.gridData,
      row: row,
      col: col,
      value: value,
    );

    final nextState = _buildGridDerivedState(
      sourceState: state,
      gridData: newGrid.toUnmodifiable2D(),
    ).copyWith(canUndo: true);
    emit(nextState);

    add(
      CurrentProgressSaveRequested(
        sourceState: nextState,
        offsetX: offsetX,
        offsetY: offsetY,
      ),
    );
    add(const SolveCheckRequested());
  }

  /// Nhấn giữ làm việc ngược với chế độ hiện tại: chế độ tô thì đánh X vào
  /// ô trống, chế độ X thì tô ô.
  void _onCellLongPressed(CellLongPressed event, Emitter emit) {
    if (state.isLoading || state.isSolved || state.puzzle == null) return;
    if (state.isLocked(event.row, event.col)) return;

    final NonogramCellState targetState;
    if (state.interactionMode == NonogramInteractionMode.mark) {
      if (state.gridData[event.row][event.col] == NonogramCellState.filled ||
          !_engine.canFillCell(
            row: event.row,
            col: event.col,
            gridData: state.gridData,
            satisfiedRows: state.satisfiedRows,
            satisfiedCols: state.satisfiedCols,
          )) {
        return;
      }
      targetState = NonogramCellState.filled;
    } else {
      if (!_engine.canMarkCell(
        row: event.row,
        col: event.col,
        gridData: state.gridData,
      )) {
        return;
      }
      targetState = NonogramCellState.marked;
    }

    _commitCell(
      event.row,
      event.col,
      targetState,
      event.offsetX,
      event.offsetY,
      emit,
    );
  }

  void _onDragStarted(DragStarted event, Emitter emit) {
    if (state.isLoading || state.isSolved || state.puzzle == null) return;

    final currentCell = state.gridData[event.row][event.col];
    final mark = state.interactionMode == NonogramInteractionMode.mark;
    final active = mark ? NonogramCellState.marked : NonogramCellState.filled;
    // Bắt đầu kéo từ ô khoá: coi như ô trống (tô / đánh X), để không biến
    // thành xoá các ô phía sau.
    final targetState =
        currentCell == active && !state.isLocked(event.row, event.col)
        ? NonogramCellState.empty
        : active;

    _dragSession = _DragSession(targetState: targetState, marking: mark);
    _dragBefore = state.gridData;

    _applyCellChange(event.row, event.col, emit);
  }

  void _onDragUpdated(DragUpdated event, Emitter emit) {
    if (state.isLoading || state.isSolved || state.puzzle == null) return;
    if (_dragSession == null) return;

    _applyCellChange(event.row, event.col, emit);
  }

  void _onDragEnded(DragEnded event, Emitter emit) {
    _dragSession = null;
    // Cả lần kéo là một bước hoàn tác (chỉ khi có ô đổi).
    final before = _dragBefore;
    _dragBefore = null;
    if (before != null && !identical(before, state.gridData)) {
      _pushUndo(before);
      emit(state.copyWith(canUndo: true));
    }

    add(
      CurrentProgressSaveRequested(
        sourceState: state,
        offsetX: event.offsetX,
        offsetY: event.offsetY,
      ),
    );
    add(const SolveCheckRequested());
  }

  void _onInteractionModeChanged(InteractionModeChanged event, Emitter emit) {
    // Gậy phép đang chờ chọn hàng / cột: các thao tác khác bị chặn.
    if (state.isSolved || state.isWandActive) return;
    _dragSession = null;
    final nextMode = state.interactionMode == NonogramInteractionMode.mark
        ? NonogramInteractionMode.fill
        : NonogramInteractionMode.mark;

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

  void _onUndoRequested(UndoRequested event, Emitter emit) {
    final puzzle = state.puzzle;
    if (puzzle == null || state.isLoading || state.isSolved) return;
    if (state.isWandActive || _dragSession != null) return;
    if (_undoHistory.isEmpty) return;

    final grid = [for (final row in _undoHistory.removeLast()) List.of(row)];
    // Ô khoá mở sau thao tác đó vẫn giữ nguyên.
    for (final cell in state.lockedCells) {
      grid[cell.row][cell.col] = state.gridData[cell.row][cell.col];
    }
    final nextState = _buildGridDerivedState(
      sourceState: state,
      gridData: grid.toUnmodifiable2D(),
    ).copyWith(canUndo: _undoHistory.isNotEmpty);
    emit(nextState);

    add(
      CurrentProgressSaveRequested(
        sourceState: nextState,
        offsetX: event.offsetX,
        offsetY: event.offsetY,
      ),
    );
  }

  void _applyCellChange(int row, int col, Emitter emit) {
    final session = _dragSession;
    if (state.puzzle == null || session == null) return;
    if (row < 0 || row >= state.puzzle!.rows) return;
    if (col < 0 || col >= state.puzzle!.cols) return;

    final cellKey = '$row-$col';
    if (session.processedCells.contains(cellKey)) return;
    if (state.isLocked(row, col)) {
      session.processedCells.add(cellKey);
      return;
    }

    if (session.marking) {
      // Kéo đánh X chỉ đổi ô trống (không đè lên ô đã tô); kéo bỏ X chỉ
      // đổi ô đang có X.
      final current = state.gridData[row][col];
      final from = session.targetState == NonogramCellState.marked
          ? NonogramCellState.empty
          : NonogramCellState.marked;
      session.processedCells.add(cellKey);
      if (current != from) return;
      emit(
        _buildGridDerivedState(
          sourceState: state,
          gridData: _engine
              .setCell(
                gridData: state.gridData,
                row: row,
                col: col,
                value: session.targetState,
              )
              .toUnmodifiable2D(),
        ),
      );
      return;
    }

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
}

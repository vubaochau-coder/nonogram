part of 'nonogram_play_bloc.dart';

/// Power-ups: hint, wand, rewarded extra uses and the debug solve.
mixin _PowerUpHandlers on _PlayBlocBase {
  void _onWandToggled(WandToggled event, Emitter emit) {
    if (state.isLoading || state.isSolved || state.puzzle == null) return;
    if (!state.isWandActive && _current.totalWands <= 0) {
      emit(_withInventory(state, _inventory));
      return;
    }
    _dragSession = null;
    emit(state.copyWith(isWandActive: !state.isWandActive));
  }

  /// Gậy phép: hiện đáp án của đúng hàng / cột người chơi chọn. Hàng / cột
  /// đã đúng thì không tốn lượt, vẫn giữ chế độ chọn để chọn hàng khác.
  Future<void> _onWandLineSelected(WandLineSelected event, Emitter emit) async {
    final puzzle = state.puzzle;
    if (state.isLoading ||
        state.isSolved ||
        puzzle == null ||
        !state.isWandActive ||
        state.remainingWands <= 0) {
      return;
    }
    final length = event.isRow ? puzzle.rows : puzzle.cols;
    if (event.index < 0 || event.index >= length) return;

    if (_engine.lineMismatchCount(
          isRow: event.isRow,
          index: event.index,
          puzzle: puzzle,
          gridData: state.gridData,
        ) ==
        0) {
      ToastUtils.info(
        title: event.isRow
            ? l10n.nonogramPlayWandRowSolved
            : l10n.nonogramPlayWandColSolved,
      );
      return;
    }

    final newGrid = _engine.revealLine(
      isRow: event.isRow,
      index: event.index,
      puzzle: puzzle,
      gridData: state.gridData,
    );

    final inventory = _current.consume(PowerUp.wand);
    final nextState =
        _withInventory(
          _buildGridDerivedState(
            sourceState: state,
            gridData: newGrid.toUnmodifiable2D(),
          ),
          inventory,
        ).copyWith(
          isWandActive: false,
          lockedCells: {
            ...state.lockedCells,
            // Số ô trên đường: hàng có `cols` ô, cột có `rows` ô.
            for (var i = 0; i < (event.isRow ? puzzle.cols : puzzle.rows); i++)
              event.isRow
                  ? (row: event.index, col: i)
                  : (row: i, col: event.index),
          },
        );

    emit(
      NonogramPlayHintAppliedState.fromState(
        nextState,
        axis: event.isRow ? Axis.horizontal : Axis.vertical,
        lineIndex: event.index,
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
    await _savePowerUps(inventory);
  }

  void _onPowerUpsChanged(PowerUpsChanged event, Emitter emit) {
    _inventory = event.inventory;
    if (state.puzzle == null || state.isLoading) return;
    final next = _withInventory(state, _current);
    if (next != state) emit(next);
  }

  /// Lượt dùng thêm (sau quảng cáo) chỉ có khi kho đã hết: không tích luỹ.
  Future<void> _onRewardGranted(RewardGranted event, Emitter emit) async {
    if (state.isLoading || state.isSolved || state.puzzle == null) return;
    switch (event.powerUp) {
      case PowerUp.hint:
        if (_current.totalHints > 0) return;
        await _applyHint(
          emit,
          offsetX: event.offsetX,
          offsetY: event.offsetY,
          inventoryAfter: null,
        );
      case PowerUp.wand:
        if (_current.totalWands > 0 || state.isWandActive) return;
        // Lượt này nằm trong kho cho tới khi chọn hàng / cột; huỷ chọn thì
        // vẫn giữ (đã xem quảng cáo rồi).
        _dragSession = null;
        final inventory = _current.addPermanent(PowerUp.wand, 1);
        emit(_withInventory(state, inventory).copyWith(isWandActive: true));
        await _savePowerUps(inventory);
    }
  }

  Future<void> _onHintRequested(HintRequested event, Emitter emit) async {
    // Gậy phép đang chờ chọn hàng / cột: không tiêu lượt gợi ý.
    if (state.isWandActive) return;
    final inventory = _current;
    if (inventory.totalHints <= 0) {
      // Lượt trong ngày vừa hết hạn: cập nhật badge (thành nút quảng cáo).
      emit(_withInventory(state, inventory));
      return;
    }
    await _applyHint(
      emit,
      offsetX: event.offsetX,
      offsetY: event.offsetY,
      inventoryAfter: inventory.consume(PowerUp.hint),
    );
  }

  /// Mở 5 ô cần tô. [inventoryAfter]: kho sau khi trừ lượt này; null khi
  /// người chơi vừa xem quảng cáo để dùng lượt này (không trừ kho).
  Future<void> _applyHint(
    Emitter emit, {
    required double offsetX,
    required double offsetY,
    required PowerUpInventory? inventoryAfter,
  }) async {
    if (state.isLoading || state.isSolved || state.puzzle == null) return;

    final cells = _engine.pickHintCells(
      puzzle: state.puzzle!,
      gridData: state.gridData,
      random: _random,
    );
    if (cells.isEmpty) {
      // Mọi ô cần tô đã tô; còn sai thì do tô thừa.
      ToastUtils.info(title: l10n.nonogramPlayHintNothingToFill);
      return;
    }

    final newGrid = _engine.fillCells(gridData: state.gridData, cells: cells);

    var nextState = _buildGridDerivedState(
      sourceState: state,
      gridData: newGrid.toUnmodifiable2D(),
    ).copyWith(lockedCells: {...state.lockedCells, ...cells});
    if (inventoryAfter != null) {
      nextState = _withInventory(nextState, inventoryAfter);
    }

    // Pulse animation state
    emit(NonogramPlayHintCellsAppliedState.fromState(nextState, cells: cells));

    emit(nextState);

    add(
      CurrentProgressSaveRequested(
        sourceState: nextState,
        offsetX: offsetX,
        offsetY: offsetY,
      ),
    );
    add(const SolveCheckRequested());
    if (inventoryAfter != null) await _savePowerUps(inventoryAfter);
  }

  void _onDebugSolveRequested(DebugSolveRequested event, Emitter emit) {
    final puzzle = state.puzzle;
    if (state.isLoading || state.isSolved || puzzle == null) return;
    _dragSession = null;
    final grid = [
      for (final row in puzzle.solution)
        [
          for (final v in row)
            v == 1 ? NonogramCellState.filled : NonogramCellState.empty,
        ],
    ];
    emit(
      _buildGridDerivedState(
        sourceState: state.copyWith(isWandActive: false),
        gridData: grid.toUnmodifiable2D(),
      ),
    );
    add(const SolveCheckRequested());
  }
}

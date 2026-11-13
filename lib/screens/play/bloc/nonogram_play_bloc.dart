import 'dart:async';
import 'dart:math' show Random;
import 'dart:ui' show Offset, Size;
import 'package:flutter/painting.dart' show Axis;
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
import 'package:nonogram/models/power_up_inventory.dart';
import 'package:nonogram/screens/play/engine/nonogram_board_layout.dart';
import 'package:nonogram/screens/play/engine/nonogram_engine.dart';
import 'package:nonogram/core/list_ext.dart';
import 'nonogram_play_event.dart';
import 'nonogram_play_state.dart';
import 'nonogram_snapshot_mapper.dart';

class NonogramPlayBloc extends AppBloc<NonogramPlayEvent, NonogramPlayState> {
  Size? _viewportSize;
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

  /// Chọn ô cho gợi ý (truyền vào để test cố định kết quả).
  final Random _random;

  _DragSession? _dragSession;
  StreamSubscription<PowerUpInventory>? _powerUpsSub;

  @override
  Future<void> close() async {
    await _powerUpsSub?.cancel();
    return super.close();
  }

  NonogramPlayBloc({
    required NonogramRepository repository,
    NonogramEngine? engine,
    Random? random,
    int initialLevel = 1,
  }) : _repository = repository,
       _engine = engine ?? const NonogramEngine(),
       _random = random ?? Random(),
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
    on<FullscreenToggled>(_onFullscreenToggled, transformer: sequential());
    on<BoardReset>(_onBoardReset, transformer: sequential());
    on<HintRequested>(_onHintRequested, transformer: sequential());
    on<WandToggled>(_onWandToggled, transformer: sequential());
    on<WandLineSelected>(_onWandLineSelected, transformer: sequential());
    on<RewardGranted>(_onRewardGranted, transformer: sequential());
    on<PowerUpsChanged>(_onPowerUpsChanged, transformer: sequential());
    _powerUpsSub = repository.powerUpChanges.listen(
      (inventory) => add(PowerUpsChanged(inventory)),
    );

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
    // Cỡ ô không do người chơi chọn: luôn là cỡ vừa khung nhìn hiện tại
    // (kể cả ván dở), cập nhật lại khi khung nhìn đổi (xoay màn hình...).
    final cellSize = _autoCellSize(puzzle);
    // Kho dùng chung cho mọi màn, không theo ván.
    final powerUps = await _repository.getPowerUps();

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
      remainingHints: powerUps.hints,
      remainingWands: powerUps.wands,
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

  _onCellTapped(CellTapped event, Emitter emit) {
    if (state.isLoading || state.isSolved || state.puzzle == null) return;
    // Ô khoá (mở bằng gợi ý / gậy phép) không đổi được.
    if (state.isLocked(event.row, event.col)) return;

    final currentCell = state.gridData[event.row][event.col];
    final NonogramCellState targetState;
    if (state.interactionMode == NonogramInteractionMode.mark) {
      // Chế độ X: bỏ X nếu đang có, còn lại đánh X (kể cả ô đang tô).
      targetState =
          currentCell == NonogramCellState.marked
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
      targetState =
          currentCell == NonogramCellState.filled
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
    final newGrid = _engine.setCell(
      gridData: state.gridData,
      row: row,
      col: col,
      value: value,
    );

    final nextState = _buildGridDerivedState(
      sourceState: state,
      gridData: newGrid.toUnmodifiable2D(),
    );
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
  _onCellLongPressed(CellLongPressed event, Emitter emit) {
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

  _onDragStarted(DragStarted event, Emitter emit) {
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

    _applyCellChange(event.row, event.col, emit);
  }

  _onDragUpdated(DragUpdated event, Emitter emit) {
    if (state.isLoading || state.isSolved || state.puzzle == null) return;
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
        state.interactionMode == NonogramInteractionMode.mark
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
    return _engine.fitCellSize(puzzle: puzzle, viewport: viewport);
  }

  /// Khung nhìn đổi (lần đo đầu, xoay màn hình, bật/tắt toàn màn hình):
  /// tính lại cỡ ô cho vừa.
  _onBoardViewportMeasured(BoardViewportMeasured event, Emitter emit) {
    final size = Size(event.width, event.height);
    if (size == _viewportSize || size.isEmpty) return;
    _viewportSize = size;

    final puzzle = state.puzzle;
    if (puzzle == null || state.isLoading) return;
    final cellSize = _autoCellSize(puzzle);
    if (cellSize != state.cellSize) emit(state.copyWith(cellSize: cellSize));
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

    // Xoá bàn nhưng giữ các ô khoá (mở bằng gợi ý / gậy phép).
    final puzzle = state.puzzle!;
    final emptyGrid = _engine.createEmptyGrid(
      rows: puzzle.rows,
      cols: puzzle.cols,
    );
    for (final cell in state.lockedCells) {
      emptyGrid[cell.row][cell.col] =
          puzzle.solution[cell.row][cell.col] == 1
              ? NonogramCellState.filled
              : NonogramCellState.marked;
    }

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

  _onWandToggled(WandToggled event, Emitter emit) {
    if (state.isLoading || state.isSolved || state.puzzle == null) return;
    if (!state.isWandActive && state.remainingWands <= 0) return;
    _dragSession = null;
    emit(state.copyWith(isWandActive: !state.isWandActive));
  }

  /// Gậy phép: hiện đáp án của đúng hàng / cột người chơi chọn. Hàng / cột
  /// đã đúng thì không tốn lượt, vẫn giữ chế độ chọn để chọn hàng khác.
  _onWandLineSelected(WandLineSelected event, Emitter emit) async {
    final puzzle = state.puzzle;
    if (state.isLoading ||
        state.isSolved ||
        puzzle == null ||
        !state.isWandActive ||
        state.remainingWands <= 0) {
      return;
    }
    final axis = event.isRow ? Axis.horizontal : Axis.vertical;
    final length = event.isRow ? puzzle.rows : puzzle.cols;
    if (event.index < 0 || event.index >= length) return;

    if (_engine.lineMismatchCount(
          axis: axis,
          index: event.index,
          puzzle: puzzle,
          gridData: state.gridData,
        ) ==
        0) {
      ToastUtils.info(
        title:
            event.isRow
                ? l10n.nonogramPlayWandRowSolved
                : l10n.nonogramPlayWandColSolved,
      );
      return;
    }

    final newGrid = _engine.revealLine(
      axis: axis,
      index: event.index,
      puzzle: puzzle,
      gridData: state.gridData,
    );

    final nextState = _buildGridDerivedState(
      sourceState: state,
      gridData: newGrid.toUnmodifiable2D(),
    ).copyWith(
      remainingWands: state.remainingWands - 1,
      isWandActive: false,
      lockedCells: {
        ...state.lockedCells,
        // Số ô trên đường: hàng có `cols` ô, cột có `rows` ô.
        for (var i = 0; i < (event.isRow ? puzzle.cols : puzzle.rows); i++)
          event.isRow ? (row: event.index, col: i) : (row: i, col: event.index),
      },
    );

    emit(
      NonogramPlayHintAppliedState.fromState(
        nextState,
        axis: axis,
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
    await _savePowerUps(nextState);
  }

  /// Còn ô cần tô để gợi ý mở không (để không bắt xem quảng cáo vô ích).
  bool get hasHintCells {
    final puzzle = state.puzzle;
    if (puzzle == null || state.isSolved) return false;
    for (var r = 0; r < puzzle.rows; r++) {
      for (var c = 0; c < puzzle.cols; c++) {
        if (puzzle.solution[r][c] == 1 &&
            state.gridData[r][c] != NonogramCellState.filled) {
          return true;
        }
      }
    }
    return false;
  }

  _onPowerUpsChanged(PowerUpsChanged event, Emitter emit) {
    if (state.puzzle == null || state.isLoading) return;
    final inventory = event.inventory;
    if (inventory.hints == state.remainingHints &&
        inventory.wands == state.remainingWands) {
      return;
    }
    emit(
      state.copyWith(
        remainingHints: inventory.hints,
        remainingWands: inventory.wands,
      ),
    );
  }

  /// Lượt dùng thêm (sau quảng cáo) chỉ có khi kho đã hết: không tích luỹ.
  _onRewardGranted(RewardGranted event, Emitter emit) async {
    if (state.isLoading || state.isSolved || state.puzzle == null) return;
    switch (event.powerUp) {
      case PowerUp.hint:
        if (state.remainingHints > 0) return;
        await _applyHint(
          emit,
          offsetX: event.offsetX,
          offsetY: event.offsetY,
          consume: false,
        );
      case PowerUp.wand:
        if (state.remainingWands > 0 || state.isWandActive) return;
        // Lượt này nằm trong kho cho tới khi chọn hàng / cột; huỷ chọn thì
        // vẫn giữ (đã xem quảng cáo rồi).
        _dragSession = null;
        final nextState = state.copyWith(remainingWands: 1, isWandActive: true);
        emit(nextState);
        await _savePowerUps(nextState);
    }
  }

  _onHintRequested(HintRequested event, Emitter emit) async {
    if (state.remainingHints <= 0) return;
    await _applyHint(
      emit,
      offsetX: event.offsetX,
      offsetY: event.offsetY,
      consume: true,
    );
  }

  /// Mở 5 ô cần tô. [consume]: trừ một lượt trong kho (false khi người chơi
  /// vừa xem quảng cáo để dùng lượt này).
  Future<void> _applyHint(
    Emitter emit, {
    required double offsetX,
    required double offsetY,
    required bool consume,
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

    final nextState = _buildGridDerivedState(
      sourceState: state,
      gridData: newGrid.toUnmodifiable2D(),
      remainingHints: consume ? state.remainingHints - 1 : null,
    ).copyWith(lockedCells: {...state.lockedCells, ...cells});

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
    if (consume) await _savePowerUps(nextState);
  }

  Future<void> _savePowerUps(NonogramPlayState from) =>
      _repository.savePowerUps(
        PowerUpInventory(
          hints: from.remainingHints,
          wands: from.remainingWands,
        ),
      );

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
    if (state.isLocked(row, col)) {
      session.processedCells.add(cellKey);
      return;
    }

    if (session.marking) {
      // Kéo đánh X chỉ đổi ô trống (không đè lên ô đã tô); kéo bỏ X chỉ
      // đổi ô đang có X.
      final current = state.gridData[row][col];
      final from =
          session.targetState == NonogramCellState.marked
              ? NonogramCellState.empty
              : NonogramCellState.marked;
      session.processedCells.add(cellKey);
      if (current != from) return;
      emit(
        _buildGridDerivedState(
          sourceState: state,
          gridData:
              _engine
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

  /// Kéo ở chế độ X (đánh / bỏ X) thay vì tô.
  final bool marking;
  final Set<String> processedCells = {};

  _DragSession({required this.targetState, this.marking = false});
}

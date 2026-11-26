import 'dart:async';
import 'dart:math' show Random;
import 'dart:ui' show Offset, Size;
import 'package:flutter/painting.dart' show Axis;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:nonogram/core/app_bloc.dart';
import 'package:nonogram/core/toast_utils.dart';
import 'package:nonogram/models/nonogram_board_snapshot.dart';
import 'package:nonogram/engine/model/nonogram_cell_state.dart';
import 'package:nonogram/models/nonogram_interaction_mode.dart';
import 'package:nonogram/models/nonogram_completed_progress.dart';
import 'package:nonogram/data/nonogram_repository.dart';
import 'package:nonogram/engine/model/nonogram_puzzle.dart';
import 'package:nonogram/models/power_up_inventory.dart';
import 'package:nonogram/screens/play/layout/nonogram_board_layout.dart';
import 'package:nonogram/engine/nonogram_engine.dart';
import 'package:nonogram/core/list_ext.dart';
import 'nonogram_play_event.dart';
import 'nonogram_play_state.dart';
import 'nonogram_snapshot_mapper.dart';

part 'nonogram_play_bloc_cells.dart';
part 'nonogram_play_bloc_level.dart';
part 'nonogram_play_bloc_power_ups.dart';

class NonogramPlayBloc extends _PlayBlocBase
    with _LevelHandlers, _CellHandlers, _PowerUpHandlers {
  /// Undo keeps at most this many boards.
  static const maxUndoSteps = 100;

  NonogramPlayBloc({
    required NonogramRepository repository,
    NonogramEngine? engine,
    Random? random,
    int initialLevel = 1,
  }) : super(
         NonogramPlayState.initial(initialLevel: initialLevel),
         repository: repository,
         engine: engine,
         random: random,
       ) {
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
    on<UndoRequested>(_onUndoRequested, transformer: sequential());
    on<HintRequested>(_onHintRequested, transformer: sequential());
    on<WandToggled>(_onWandToggled, transformer: sequential());
    on<WandLineSelected>(_onWandLineSelected, transformer: sequential());
    on<RewardGranted>(_onRewardGranted, transformer: sequential());
    on<PowerUpsChanged>(_onPowerUpsChanged, transformer: sequential());
    on<DebugSolveRequested>(_onDebugSolveRequested, transformer: sequential());
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
}

/// State and helpers shared by the event handler mixins ([_LevelHandlers],
/// [_CellHandlers], [_PowerUpHandlers]).
abstract class _PlayBlocBase
    extends AppBloc<NonogramPlayEvent, NonogramPlayState> {
  _PlayBlocBase(
    super.initialState, {
    required NonogramRepository repository,
    NonogramEngine? engine,
    Random? random,
  }) : _repository = repository,
       _engine = engine ?? const NonogramEngine(),
       _random = random ?? Random();

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

  /// Bàn trước mỗi lần chạm / nhấn giữ / kéo, mới nhất ở cuối. Ô khoá (gợi
  /// ý, gậy phép) không theo lịch sử: hoàn tác giữ nguyên chúng.
  final List<List<List<NonogramCellState>>> _undoHistory = [];

  /// Bàn lúc bắt đầu lần kéo đang diễn ra.
  List<List<NonogramCellState>>? _dragBefore;

  void _pushUndo(List<List<NonogramCellState>> grid) {
    _undoHistory.add(grid);
    if (_undoHistory.length > NonogramPlayBloc.maxUndoSteps)
      _undoHistory.removeAt(0);
  }

  void _clearUndo() {
    _undoHistory.clear();
    _dragBefore = null;
  }

  StreamSubscription<PowerUpInventory>? _powerUpsSub;

  /// Kho hiện tại (đã bỏ lượt trong ngày hết hạn).
  PowerUpInventory _inventory = const PowerUpInventory(hints: 0, wands: 0);

  /// Kho tính tới lúc này: qua nửa đêm thì lượt trong ngày cũ hết hạn.
  PowerUpInventory get _current =>
      _inventory = _inventory.activeOn(_repository.today);

  NonogramPlayState _withInventory(
    NonogramPlayState s,
    PowerUpInventory inventory,
  ) => s.copyWith(
    remainingHints: inventory.totalHints,
    remainingWands: inventory.totalWands,
    dailyHints: inventory.dailyHints,
    dailyWands: inventory.dailyWands,
  );

  Future<void> _savePowerUps(PowerUpInventory inventory) {
    _inventory = inventory;
    return _repository.savePowerUps(inventory);
  }

  @override
  Future<void> close() async {
    await _powerUpsSub?.cancel();
    return super.close();
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

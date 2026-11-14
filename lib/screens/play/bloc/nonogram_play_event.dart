import 'package:nonogram/models/power_up_inventory.dart';
import 'package:nonogram/models/nonogram_puzzle.dart';
import 'package:nonogram/models/nonogram_board_snapshot.dart';
import 'nonogram_play_state.dart';

sealed class NonogramPlayEvent {
  const NonogramPlayEvent();
}

class InitialRequested extends NonogramPlayEvent {
  const InitialRequested();
}

class Started extends NonogramPlayEvent {
  final NonogramPuzzle puzzle;
  final NonogramBoardSnapshot? snapshot;

  const Started({required this.puzzle, this.snapshot});
}

class LevelLoadRequested extends NonogramPlayEvent {
  const LevelLoadRequested();
}

class NextLevelRequested extends NonogramPlayEvent {
  const NextLevelRequested();
}

class CellTapped extends NonogramPlayEvent {
  final int row;
  final int col;
  final double offsetX;
  final double offsetY;

  const CellTapped(
    this.row,
    this.col, {
    required this.offsetX,
    required this.offsetY,
  });
}

class CellLongPressed extends NonogramPlayEvent {
  final int row;
  final int col;
  final double offsetX;
  final double offsetY;

  const CellLongPressed({
    required this.row,
    required this.col,
    this.offsetX = 0,
    this.offsetY = 0,
  });
}

class DragStarted extends NonogramPlayEvent {
  final int row;
  final int col;

  const DragStarted(this.row, this.col);
}

class DragUpdated extends NonogramPlayEvent {
  final int row;
  final int col;

  const DragUpdated(this.row, this.col);
}

class DragEnded extends NonogramPlayEvent {
  final double offsetX;
  final double offsetY;

  const DragEnded({required this.offsetX, required this.offsetY});
}

class InteractionModeChanged extends NonogramPlayEvent {
  final double offsetX;
  final double offsetY;

  const InteractionModeChanged({required this.offsetX, required this.offsetY});
}

class FullscreenToggled extends NonogramPlayEvent {
  const FullscreenToggled();
}

class BoardReset extends NonogramPlayEvent {
  final double offsetX;
  final double offsetY;

  const BoardReset({required this.offsetX, required this.offsetY});
}

class ViewportChanged extends NonogramPlayEvent {
  final double offsetX;
  final double offsetY;

  const ViewportChanged(this.offsetX, this.offsetY);
}

class HintRequested extends NonogramPlayEvent {
  final double offsetX;
  final double offsetY;

  const HintRequested({required this.offsetX, required this.offsetY});
}

/// Bật / tắt chế độ chọn hàng / cột cho gậy phép.
class WandToggled extends NonogramPlayEvent {
  const WandToggled();
}

/// Đã chọn hàng ([isRow]) hoặc cột thứ [index] để gậy phép hiện đáp án.
class WandLineSelected extends NonogramPlayEvent {
  final bool isRow;
  final int index;
  final double offsetX;
  final double offsetY;

  const WandLineSelected({
    required this.isRow,
    required this.index,
    required this.offsetX,
    required this.offsetY,
  });
}

/// Kho đã hết và người chơi đã xem xong quảng cáo có thưởng (hoặc bản không
/// có quảng cáo): dùng ngay một lượt [powerUp] mà không trừ kho. Gợi ý được
/// mở luôn; gậy phép chuyển sang chế độ chọn hàng / cột.
class RewardGranted extends NonogramPlayEvent {
  final PowerUp powerUp;
  final double offsetX;
  final double offsetY;

  const RewardGranted({
    required this.powerUp,
    required this.offsetX,
    required this.offsetY,
  });
}

/// Kho gợi ý / gậy phép vừa thay đổi ngoài màn chơi (vd. quà hằng ngày).
class PowerUpsChanged extends NonogramPlayEvent {
  final PowerUpInventory inventory;

  const PowerUpsChanged(this.inventory);
}

/// Công cụ tester (bản `dev`): tô đúng đáp án và hoàn thành màn ngay.
class DebugSolveRequested extends NonogramPlayEvent {
  const DebugSolveRequested();
}

// --- Internal/Refactor Events (Phase 4.2+) ---

class CurrentProgressSaveRequested extends NonogramPlayEvent {
  final NonogramPlayState sourceState;
  final double offsetX;
  final double offsetY;

  const CurrentProgressSaveRequested({
    required this.sourceState,
    required this.offsetX,
    required this.offsetY,
  });
}

class SolveCheckRequested extends NonogramPlayEvent {
  const SolveCheckRequested();
}

class PuzzleSolved extends NonogramPlayEvent {
  const PuzzleSolved();
}

/// Kích thước vùng hiển thị bàn chơi, để tự chọn cỡ ô cho màn mới.
class BoardViewportMeasured extends NonogramPlayEvent {
  final double width;
  final double height;

  const BoardViewportMeasured({required this.width, required this.height});
}

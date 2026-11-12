import 'package:nonogram/models/nonogram_board_snapshot.dart';
import 'package:nonogram/models/nonogram_completed_progress.dart';
import 'package:nonogram/models/power_up_inventory.dart';

/// Lưu tiến độ người chơi trên máy (ván đang chơi dở + các màn đã hoàn thành).
abstract class NonogramLocalService {
  Future<void> initialize();

  Future<NonogramBoardSnapshot?> getCurrentProgress();

  Future<void> saveCurrentProgress(NonogramBoardSnapshot snapshot);

  Future<void> clearCurrentProgress();

  Future<List<NonogramCompletedProgress>> getCompletedProgress();

  Future<void> saveCompletedProgress(NonogramCompletedProgress progress);

  /// Kho gợi ý / gậy phép; null nếu chưa lưu lần nào (người chơi mới).
  Future<PowerUpInventory?> getPowerUps();

  Future<void> savePowerUps(PowerUpInventory inventory);

  /// Xoá toàn bộ tiến độ (ván dở + lịch sử hoàn thành).
  Future<void> clearAll();
}

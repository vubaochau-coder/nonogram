import 'dart:async';
import 'dart:math';

import 'package:nonogram/data/nonogram_local_service.dart';
import 'package:nonogram/data/nonogram_puzzle_source.dart';
import 'package:nonogram/models/nonogram_board_snapshot.dart';
import 'package:nonogram/models/nonogram_completed_progress.dart';
import 'package:nonogram/models/nonogram_puzzle.dart';
import 'package:nonogram/models/power_up_inventory.dart';

/// Gom dữ liệu màn chơi (assets) và tiến độ người chơi (lưu trên máy).
/// Game chạy offline hoàn toàn: không có tài khoản, không đồng bộ.
class NonogramRepository {
  NonogramRepository(
    this._puzzleSource,
    this._localService, {
    int Function()? today,
  }) : _today = today ?? _deviceToday;

  final NonogramPuzzleSource _puzzleSource;
  final NonogramLocalService _localService;

  /// "Hôm nay" (số ngày kể từ 1970-01-01, lịch địa phương), để biết lượt
  /// trong ngày còn hạn không. App truyền giờ đã hiệu chỉnh theo giờ mạng
  /// (`GameClock`); mặc định là giờ máy.
  final int Function() _today;

  int get today => _today();

  static int _deviceToday() => dayNumberOf(DateTime.now());

  // --- Puzzles ---

  Future<NonogramPuzzle?> getPuzzleByLevel(int level) {
    return _puzzleSource.puzzleByLevel(level);
  }

  Future<int> getTotalLevels() => _puzzleSource.totalLevels();

  // --- Kho gợi ý / gậy phép ---

  /// Kho hôm nay (lượt trong ngày đã hết hạn thì bỏ). Người chơi mới (chưa
  /// lưu lần nào) nhận kho khởi đầu.
  Future<PowerUpInventory> getPowerUps() async =>
      (await _localService.getPowerUps() ?? PowerUpInventory.starter).activeOn(
        today,
      );

  Future<void> savePowerUps(PowerUpInventory inventory) async {
    await _localService.savePowerUps(inventory);
    _powerUps.add(inventory.activeOn(today));
  }

  final _powerUps = StreamController<PowerUpInventory>.broadcast(sync: true);

  /// Kho vừa được lưu (từ màn chơi, hoặc quà điểm danh), để màn chơi và
  /// trang chính đang mở cập nhật số lượt.
  Stream<PowerUpInventory> get powerUpChanges => _powerUps.stream;

  // --- Ván đang chơi dở ---

  Future<NonogramBoardSnapshot?> getCurrentProgress() {
    return _localService.getCurrentProgress();
  }

  Future<void> saveCurrentProgress(NonogramBoardSnapshot snapshot) {
    return _localService.saveCurrentProgress(snapshot);
  }

  Future<void> clearCurrentProgress() {
    return _localService.clearCurrentProgress();
  }

  // --- Màn đã hoàn thành ---

  Future<List<NonogramCompletedProgress>> getCompletedProgress() {
    return _localService.getCompletedProgress();
  }

  Future<void> saveCompletedProgress(NonogramCompletedProgress progress) {
    return _localService.saveCompletedProgress(progress);
  }

  /// Một trang lịch sử, sắp xếp level mới nhất -> cũ nhất.
  Future<({List<NonogramCompletedProgress> items, bool hasMore})>
  getCompletedResultsPage({required int loadedCount, int pageSize = 10}) async {
    final local = await _localService.getCompletedProgress();
    local.sort((a, b) => b.level.compareTo(a.level));

    final start = min(loadedCount, local.length);
    final end = min(local.length, start + pageSize);
    return (items: local.sublist(start, end), hasMore: end < local.length);
  }

  Future<({NonogramCompletedProgress record, NonogramPuzzle puzzle})?>
  getCompletedLevelDetail(int level) async {
    final local = await _localService.getCompletedProgress();
    final record = local.where((e) => e.level == level).firstOrNull;
    if (record == null) return null;

    final puzzle = await getPuzzleByLevel(level);
    if (puzzle == null) return null;

    return (record: record, puzzle: puzzle);
  }

  /// Các màn giải gần nhất (kèm puzzle để vẽ hình) và thống kê tổng.
  Future<NonogramCompletionSummary> getCompletionSummary({
    int recentLimit = 10,
  }) async {
    final completed = await _localService.getCompletedProgress();
    completed.sort((a, b) => b.completedAt.compareTo(a.completedAt));

    final recent = <NonogramSolvedPuzzle>[];
    for (final record in completed.take(recentLimit)) {
      final puzzle = await getPuzzleByLevel(record.level);
      if (puzzle != null) {
        recent.add((record: record, puzzle: puzzle));
      }
    }

    return NonogramCompletionSummary(
      recent: recent,
      totalPlayMs: completed.fold(0, (sum, e) => sum + e.bestCompletionMs),
      bestMs:
          completed.isEmpty
              ? null
              : completed.map((e) => e.bestCompletionMs).reduce(min),
    );
  }

  // --- Campaign ---

  Future<int> getCurrentLevel() async {
    final snapshot = await getCurrentProgress();
    if (snapshot != null) {
      final completed = await getCompletedProgress();
      final isCompletedLevel = completed.any((e) => e.level == snapshot.level);
      if (!isCompletedLevel) return snapshot.level;
    }
    return await getNextPlayableLevel() ?? 1;
  }

  /// Màn nhỏ nhất chưa hoàn thành; `null` khi đã chơi hết mọi màn.
  Future<int?> getNextPlayableLevel() async {
    final completed = await getCompletedProgress();
    final completedLevels = completed.map((e) => e.level).toSet();

    var level = 1;
    while (completedLevels.contains(level)) {
      level++;
    }

    final total = await getTotalLevels();
    return level <= total ? level : null;
  }

  Future<
    ({
      int currentLevel,
      int? nextPlayableLevel,
      int completedCount,
      int totalLevels,
      NonogramBoardSnapshot? currentProgress,
    })
  >
  getCampaignOverview() async {
    final snapshot = await getCurrentProgress();
    final completed = await getCompletedProgress();
    final completedLevels = completed.map((e) => e.level).toSet();
    // Snapshot của màn đã hoàn thành là "stale", không được resume.
    final inProgressSnapshot =
        snapshot != null && !completedLevels.contains(snapshot.level)
            ? snapshot
            : null;

    final nextPlayableLevel = await getNextPlayableLevel();
    final currentLevel = inProgressSnapshot?.level ?? nextPlayableLevel ?? 1;

    return (
      currentLevel: currentLevel,
      nextPlayableLevel: nextPlayableLevel,
      completedCount: completed.length,
      totalLevels: await getTotalLevels(),
      currentProgress: inProgressSnapshot,
    );
  }
}

typedef NonogramSolvedPuzzle =
    ({NonogramCompletedProgress record, NonogramPuzzle puzzle});

class NonogramCompletionSummary {
  const NonogramCompletionSummary({
    required this.recent,
    required this.totalPlayMs,
    required this.bestMs,
  });

  static const empty = NonogramCompletionSummary(
    recent: [],
    totalPlayMs: 0,
    bestMs: null,
  );

  /// Mới nhất trước.
  final List<NonogramSolvedPuzzle> recent;

  /// Tổng thời gian (kỷ lục) của mọi màn đã giải.
  final int totalPlayMs;

  /// Thời gian giải nhanh nhất trong mọi màn.
  final int? bestMs;
}

/// Số ngày kể từ 1970-01-01 theo lịch địa phương của [time].
int dayNumberOf(DateTime time) {
  final local = time.toLocal();
  return DateTime.utc(
        local.year,
        local.month,
        local.day,
      ).millisecondsSinceEpoch ~/
      Duration.millisecondsPerDay;
}

/// Ngày lịch (UTC, 0 giờ) của số ngày [day].
DateTime dateOfDayNumber(int day) =>
    DateTime.utc(1970).add(Duration(days: day));

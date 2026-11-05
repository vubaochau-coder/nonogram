import 'dart:math';

import 'package:nonogram/data/nonogram_local_service.dart';
import 'package:nonogram/data/nonogram_puzzle_source.dart';
import 'package:nonogram/models/nonogram_board_snapshot.dart';
import 'package:nonogram/models/nonogram_completed_progress.dart';
import 'package:nonogram/models/nonogram_puzzle.dart';

/// Gom dữ liệu màn chơi (assets) và tiến độ người chơi (lưu trên máy).
/// Game chạy offline hoàn toàn: không có tài khoản, không đồng bộ.
class NonogramRepository {
  NonogramRepository(this._puzzleSource, this._localService);

  final NonogramPuzzleSource _puzzleSource;
  final NonogramLocalService _localService;

  // --- Puzzles ---

  Future<NonogramPuzzle?> getPuzzleByLevel(int level) {
    return _puzzleSource.puzzleByLevel(level);
  }

  Future<int> getTotalLevels() => _puzzleSource.totalLevels();

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

import 'package:hive_flutter/hive_flutter.dart';
import 'package:nonogram/data/nonogram_local_service.dart';
import 'package:nonogram/models/nonogram_board_snapshot.dart';
import 'package:nonogram/models/nonogram_completed_progress.dart';

class HiveNonogramLocalService implements NonogramLocalService {
  /// [boxName]: mỗi chế độ chơi lưu tiến độ ở một box riêng (xem `PlayMode`).
  HiveNonogramLocalService({this.boxName = 'nonogram_offline_v1'});

  static const _currentProgressKey = 'current_progress';
  static const _completedProgressKey = 'completed_progress';

  final String boxName;
  Box<dynamic>? _box;

  @override
  Future<void> initialize() async {
    await Hive.initFlutter();
    _box = await Hive.openBox<dynamic>(boxName);
  }

  @override
  Future<NonogramBoardSnapshot?> getCurrentProgress() async {
    final raw = _requiredBox().get(_currentProgressKey);
    if (raw is! Map) return null;

    try {
      return NonogramBoardSnapshot.fromMap(Map<String, dynamic>.from(raw));
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveCurrentProgress(NonogramBoardSnapshot snapshot) async {
    await _requiredBox().put(_currentProgressKey, snapshot.toMap());
  }

  @override
  Future<void> clearCurrentProgress() async {
    await _requiredBox().delete(_currentProgressKey);
  }

  @override
  Future<List<NonogramCompletedProgress>> getCompletedProgress() async {
    final raw = _requiredBox().get(_completedProgressKey);
    if (raw is! Map) return [];

    try {
      return raw.values
          .whereType<Map>()
          .map(
            (e) =>
                NonogramCompletedProgress.fromMap(Map<String, dynamic>.from(e)),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> saveCompletedProgress(NonogramCompletedProgress progress) async {
    final raw = _requiredBox().get(_completedProgressKey);
    final map =
        raw is Map ? Map<dynamic, dynamic>.from(raw) : <dynamic, dynamic>{};

    map[progress.level.toString()] = progress.toMap();
    await _requiredBox().put(_completedProgressKey, map);
  }

  @override
  Future<void> clearAll() async {
    await _requiredBox().deleteAll([
      _currentProgressKey,
      _completedProgressKey,
    ]);
  }

  Box<dynamic> _requiredBox() {
    final box = _box;
    if (box != null) return box;
    throw StateError(
      'HiveNonogramLocalService is not initialized. Call initialize() first.',
    );
  }
}

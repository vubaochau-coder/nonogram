import 'package:nonogram/data/nonogram_local_service.dart';
import 'package:nonogram/models/nonogram_board_snapshot.dart';
import 'package:nonogram/models/nonogram_completed_progress.dart';

class FakeNonogramLocalService implements NonogramLocalService {
  NonogramBoardSnapshot? _snapshot;
  final Map<int, NonogramCompletedProgress> _completed = {};

  @override
  Future<void> initialize() async {}

  @override
  Future<NonogramBoardSnapshot?> getCurrentProgress() async => _snapshot;

  @override
  Future<void> saveCurrentProgress(NonogramBoardSnapshot snapshot) async {
    _snapshot = snapshot;
  }

  @override
  Future<void> clearCurrentProgress() async {
    _snapshot = null;
  }

  @override
  Future<List<NonogramCompletedProgress>> getCompletedProgress() async {
    return _completed.values.toList();
  }

  @override
  Future<void> saveCompletedProgress(NonogramCompletedProgress progress) async {
    _completed[progress.level] = progress;
  }

  @override
  Future<void> clearAll() async {
    _snapshot = null;
    _completed.clear();
  }
}

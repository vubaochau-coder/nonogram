import 'package:nonogram/data/nonogram_repository.dart';

import 'fake_nonogram_local_service.dart';
import 'fake_nonogram_puzzle_source.dart';

/// Repository thật, chạy trên nguồn màn chơi và bộ lưu trữ trong bộ nhớ
/// (10 màn).
class FakeNonogramRepository extends NonogramRepository {
  FakeNonogramRepository({int levelCount = 10, List<List<int>>? solution})
    : super(
        solution == null
            ? FakeNonogramPuzzleSource(levelCount: levelCount)
            : FakeNonogramPuzzleSource(
              levelCount: levelCount,
              solution: solution,
            ),
        FakeNonogramLocalService(),
      );
}

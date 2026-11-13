import 'package:nonogram/data/nonogram_repository.dart';

import 'fake_nonogram_local_service.dart';
import 'fake_nonogram_puzzle_source.dart';

/// Repository thật, chạy trên nguồn màn chơi và bộ lưu trữ trong bộ nhớ
/// (10 màn).
class FakeNonogramRepository extends NonogramRepository {
  FakeNonogramRepository({
    int levelCount = 10,
    List<List<int>>? solution,
    Set<({int row, int col})> pinnedCells = const {},
    int Function()? today,
  }) : super(
         solution == null
             ? FakeNonogramPuzzleSource(
               levelCount: levelCount,
               pinnedCells: pinnedCells,
             )
             : FakeNonogramPuzzleSource(
               levelCount: levelCount,
               solution: solution,
               pinnedCells: pinnedCells,
             ),
         FakeNonogramLocalService(),
         today: today,
       );
}

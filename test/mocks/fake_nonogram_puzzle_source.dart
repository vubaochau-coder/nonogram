import 'package:nonogram/data/nonogram_puzzle_source.dart';
import 'package:nonogram/models/nonogram_puzzle.dart';

/// Nguồn màn chơi trong bộ nhớ: [levelCount] màn giống nhau (mặc định 2x2).
class FakeNonogramPuzzleSource implements NonogramPuzzleSource {
  FakeNonogramPuzzleSource({
    this.levelCount = 10,
    this.solution = _small,
    this.pinnedCells = const {},
  });

  static const _small = [
    [1, 0],
    [0, 1],
  ];

  final int levelCount;
  final List<List<int>> solution;
  final Set<({int row, int col})> pinnedCells;

  @override
  Future<int> totalLevels() async => levelCount;

  @override
  Future<NonogramPuzzle?> puzzleByLevel(int level) async {
    if (level < 1 || level > levelCount) return null;
    return NonogramPuzzle(
      id: 'p-$level',
      title: 'Test Puzzle $level',
      author: 'Tester',
      difficulty: 'Easy',
      difficultyScore: 1.0,
      level: level,
      solution: solution,
      pinnedCells: pinnedCells,
    );
  }
}

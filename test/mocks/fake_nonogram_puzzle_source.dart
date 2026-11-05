import 'package:nonogram/data/nonogram_puzzle_source.dart';
import 'package:nonogram/models/nonogram_puzzle.dart';

/// Nguồn màn chơi trong bộ nhớ: [levelCount] màn 2x2 giống nhau.
class FakeNonogramPuzzleSource implements NonogramPuzzleSource {
  FakeNonogramPuzzleSource({this.levelCount = 10});

  final int levelCount;

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
      solution: const [
        [1, 0],
        [0, 1],
      ],
    );
  }
}

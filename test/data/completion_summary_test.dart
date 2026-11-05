import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/models/nonogram_completed_progress.dart';

import '../mocks/fake_nonogram_repository.dart';

NonogramCompletedProgress _progress(int level, int ms, DateTime at) {
  return NonogramCompletedProgress(
    puzzleId: 'p-$level',
    level: level,
    bestCompletionMs: ms,
    completedAt: at,
    lastPlayedAt: at,
  );
}

void main() {
  test('empty when nothing is solved', () async {
    final summary = await FakeNonogramRepository().getCompletionSummary();
    expect(summary.recent, isEmpty);
    expect(summary.totalPlayMs, 0);
    expect(summary.bestMs, isNull);
  });

  test('recent is newest first, with puzzles, and limited', () async {
    final repository = FakeNonogramRepository();
    final base = DateTime(2026, 1, 1);
    await repository.saveCompletedProgress(_progress(1, 5000, base));
    await repository.saveCompletedProgress(
      _progress(3, 2000, base.add(const Duration(days: 2))),
    );
    await repository.saveCompletedProgress(
      _progress(2, 9000, base.add(const Duration(days: 1))),
    );

    final summary = await repository.getCompletionSummary(recentLimit: 2);

    expect(summary.recent.map((e) => e.record.level), [3, 2]);
    expect(summary.recent.first.puzzle.level, 3);
    expect(summary.totalPlayMs, 16000);
    expect(summary.bestMs, 2000);
  });

  test('skips records whose level no longer exists', () async {
    final repository = FakeNonogramRepository(levelCount: 2);
    await repository.saveCompletedProgress(_progress(5, 1000, DateTime(2026)));

    final summary = await repository.getCompletionSummary();
    expect(summary.recent, isEmpty);
    expect(summary.totalPlayMs, 1000);
  });
}

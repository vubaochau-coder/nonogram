import 'package:nonogram/models/nonogram_board_snapshot.dart';
import 'package:nonogram/models/nonogram_completed_progress.dart';
import 'package:nonogram/models/nonogram_interaction_mode.dart';
import 'package:flutter_test/flutter_test.dart';
import '../mocks/fake_nonogram_repository.dart';

void main() {
  group('Nonogram Progression Logic Tests', () {
    late FakeNonogramRepository repository;

    setUp(() {
      repository = FakeNonogramRepository();
    });

    test('getNextPlayableLevel returns 1 for fresh user', () async {
      expect(await repository.getNextPlayableLevel(), 1);
    });

    test('getNextPlayableLevel handles consecutive completion', () async {
      await repository.saveCompletedProgress(_mockProgress(1));
      await repository.saveCompletedProgress(_mockProgress(2));

      expect(await repository.getNextPlayableLevel(), 3);
    });

    test(
      'getNextPlayableLevel handles non-consecutive completion (the gap test)',
      () async {
        // Completed level 1 and 3, but skipped 2
        await repository.saveCompletedProgress(_mockProgress(1));
        await repository.saveCompletedProgress(_mockProgress(3));

        // Should suggest level 2 as it is the first uncompleted one
        expect(await repository.getNextPlayableLevel(), 2);
      },
    );

    test('getCurrentLevel prioritizes in-progress session', () async {
      await repository.saveCompletedProgress(_mockProgress(1));

      // No session: next is 2
      expect(await repository.getCurrentLevel(), 2);

      // User starts level 5
      await repository.saveCurrentProgress(_mockSnapshot(5));

      // Should now return 5 as it is in progress
      expect(await repository.getCurrentLevel(), 5);
    });

    test('getCampaignOverview returns correct summary', () async {
      await repository.saveCompletedProgress(_mockProgress(1));
      await repository.saveCompletedProgress(_mockProgress(2));
      await repository.saveCurrentProgress(
        _mockSnapshot(2),
      ); // Re-playing level 2 dở dang

      final overview = await repository.getCampaignOverview();

      expect(overview.completedCount, 2);
      expect(overview.currentLevel, 3);
      expect(overview.currentProgress, isNull);
      expect(overview.nextPlayableLevel, 3);
    });

    test(
      'getCampaignOverview ignores stale snapshot of completed level and falls back to next playable',
      () async {
        await repository.saveCompletedProgress(_mockProgress(1));
        await repository.saveCurrentProgress(_mockSnapshot(1));

        final overview = await repository.getCampaignOverview();

        expect(overview.currentProgress, isNull);
        expect(overview.currentLevel, 2);
        expect(overview.nextPlayableLevel, 2);
      },
    );

    test('getCurrentLevel ignores stale snapshot of completed level', () async {
      await repository.saveCompletedProgress(_mockProgress(1));
      await repository.saveCurrentProgress(_mockSnapshot(1));

      expect(await repository.getCurrentLevel(), 2);
    });
  });
}

NonogramCompletedProgress _mockProgress(int level) {
  return NonogramCompletedProgress(
    puzzleId: 'p-$level',
    level: level,
    bestCompletionMs: 1000,
    completedAt: DateTime.now(),
    lastPlayedAt: DateTime.now(),
  );
}

NonogramBoardSnapshot _mockSnapshot(int level) {
  return NonogramBoardSnapshot(
    puzzleId: 'p-$level',
    level: level,
    gridData: [],
    startTime: DateTime.now(),
    interactionMode: NonogramInteractionMode.draw,
  );
}

import 'package:nonogram/models/nonogram_cell_state.dart';
import 'package:nonogram/models/nonogram_completed_progress.dart';
import 'package:nonogram/models/nonogram_interaction_mode.dart';
import 'package:nonogram/models/nonogram_board_snapshot.dart';
import 'package:nonogram/models/nonogram_puzzle.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/screens/play/bloc/nonogram_play_bloc.dart';
import 'package:nonogram/screens/play/bloc/nonogram_play_event.dart';
import 'package:nonogram/screens/play/bloc/nonogram_play_state.dart';
import '../mocks/fake_nonogram_repository.dart';

void main() {
  final dummyPuzzle = NonogramPuzzle(
    id: 'test-puzzle',
    title: 'Test Puzzle',
    author: 'Tester',
    difficulty: 'Easy',
    difficultyScore: 1.0,
    level: 1,
    solution: [
      [1, 0],
      [0, 1],
    ],
  );

  final satisfactionPuzzle = NonogramPuzzle(
    id: 'satisfaction-puzzle',
    title: 'Satisfaction Puzzle',
    author: 'Tester',
    difficulty: 'Easy',
    difficultyScore: 1.0,
    level: 99,
    // Hàng 0 có gợi ý [1, 1, 1]; hàng 1 giữ cho màn chưa giải xong khi
    // hàng 0 đã khớp.
    solution: const [
      [1, 0, 1, 0, 1],
      [1, 1, 1, 1, 1],
    ],
  );

  final dragPuzzle = NonogramPuzzle(
    id: 'drag-puzzle',
    title: 'Drag Puzzle',
    author: 'Tester',
    difficulty: 'Easy',
    difficultyScore: 1.0,
    level: 98,
    solution: const [
      [1, 1],
    ],
  );

  group('NonogramPlayBloc Phase 4.3 Completion Flow Tests', () {
    late FakeNonogramRepository repository;
    late NonogramPlayBloc bloc;

    setUp(() {
      repository = FakeNonogramRepository();
      bloc = NonogramPlayBloc(repository: repository);
    });

    tearDown(() async {
      await bloc.close();
    });

    test(
      'Solving puzzle should save completed record and clear snapshot',
      () async {
        bloc.add(const LevelLoadRequested());
        await bloc.stream.firstWhere((s) => s.puzzle != null);

        // Solve the 2x2 puzzle
        bloc.add(const CellTapped(0, 0, offsetX: 0, offsetY: 0));
        bloc.add(const CellTapped(1, 1, offsetX: 0, offsetY: 0));

        // Wait for solved state
        await expectLater(
          bloc.stream,
          emitsThrough(predicate<NonogramPlayState>((s) => s.isSolved)),
        );

        // Give a tiny moment for async repository processing if needed
        await Future.delayed(const Duration(milliseconds: 10));

        // Verify repository calls
        final completed = await repository.getCompletedProgress();
        expect(completed.length, 1);
        expect(completed.first.level, dummyPuzzle.level);

        final snapshot = await repository.getCurrentProgress();
        expect(
          snapshot,
          isNull,
          reason: 'Snapshot should be cleared after solve',
        );
      },
    );

    test(
      'LevelLoadRequested should reset state and emit loading for in-place reuse',
      () async {
        bloc = NonogramPlayBloc(repository: repository, initialLevel: 2);

        bloc.add(const LevelLoadRequested());

        await expectLater(
          bloc.stream,
          emitsThrough(
            predicate<NonogramPlayState>(
              (s) => s.isLoading == true && s.level == 2 && s.gridData.isEmpty,
            ),
          ),
        );
      },
    );

    test(
      'NextLevelRequested should load next level when repository still has next level',
      () async {
        bloc.add(const LevelLoadRequested());
        await bloc.stream.firstWhere((s) => s.puzzle != null);

        bloc.add(const CellTapped(0, 0, offsetX: 0, offsetY: 0));
        bloc.add(const CellTapped(1, 1, offsetX: 0, offsetY: 0));
        await bloc.stream.firstWhere((s) => s.isSolved);

        bloc.add(const NextLevelRequested());

        await expectLater(
          bloc.stream,
          emitsThrough(
            predicate<NonogramPlayState>((s) {
              return s.isLoading == true && s.level == 2;
            }),
          ),
        );
      },
    );

    test(
      'Solved state should still be emitted when no next level exists',
      () async {
        for (var level = 1; level <= 10; level++) {
          await repository.saveCompletedProgress(
            NonogramCompletedProgress(
              puzzleId: 'p-$level',
              level: level,
              bestCompletionMs: 1000,
              completedAt: DateTime.now(),
              lastPlayedAt: DateTime.now(),
            ),
          );
        }

        bloc.add(const LevelLoadRequested());
        await bloc.stream.firstWhere((s) => s.puzzle != null);

        bloc.add(const PuzzleSolved());
        await bloc.stream.firstWhere((s) => s.isSolved);

        final solvedState = bloc.state;

        expect(bloc.state.isSolved, true);
        expect(bloc.state.level, solvedState.level);
        expect(bloc.state.isLoading, false);
      },
    );
  });

  group('NonogramPlayBloc Core Interactions', () {
    late FakeNonogramRepository repository;
    late NonogramPlayBloc bloc;

    setUp(() {
      repository = FakeNonogramRepository();
      bloc = NonogramPlayBloc(repository: repository);
    });

    tearDown(() async {
      await bloc.close();
    });

    test('Tap cell should toggle state in Draw mode', () async {
      bloc.add(const LevelLoadRequested());
      await bloc.stream.firstWhere((s) => s.puzzle != null);

      bloc.add(const CellTapped(0, 0, offsetX: 0, offsetY: 0));

      await expectLater(
        bloc.stream,
        emitsThrough(
          predicate<NonogramPlayState>(
            (s) => s.gridData[0][0] == NonogramCellState.filled,
          ),
        ),
      );
    });

    test('Uniform Drag: first cell determines target state (Filled)', () async {
      bloc.add(Started(puzzle: dragPuzzle));
      await bloc.stream.firstWhere((s) => s.puzzle != null);

      bloc.add(const DragStarted(0, 0));
      bloc.add(const DragUpdated(0, 1));
      bloc.add(const DragEnded(offsetX: 0, offsetY: 0));

      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(bloc.state.gridData[0][0], NonogramCellState.filled);
      expect(bloc.state.gridData[0][1], NonogramCellState.filled);
    });

    test('Long press on empty cell should mark it and save progress', () async {
      bloc.add(const LevelLoadRequested());
      await bloc.stream.firstWhere((s) => s.puzzle != null);

      bloc.add(const CellLongPressed(row: 0, col: 1, offsetX: 12, offsetY: 34));

      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(bloc.state.gridData[0][1], NonogramCellState.marked);

      final snapshot = await repository.getCurrentProgress();
      expect(snapshot, isNotNull);
      expect(snapshot!.gridData[0][1], NonogramCellState.marked);
      expect(snapshot.viewportOffsetX, 12);
      expect(snapshot.viewportOffsetY, 34);
    });

    test('Long press on filled cell should be a no-op', () async {
      bloc.add(const LevelLoadRequested());
      await bloc.stream.firstWhere((s) => s.puzzle != null);

      bloc.add(const CellTapped(0, 0, offsetX: 0, offsetY: 0));
      await Future<void>.delayed(const Duration(milliseconds: 10));

      bloc.add(const CellLongPressed(row: 0, col: 0, offsetX: 0, offsetY: 0));
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(bloc.state.gridData[0][0], NonogramCellState.filled);
    });

    test('Long press on marked cell should be a no-op', () async {
      bloc.add(const LevelLoadRequested());
      await bloc.stream.firstWhere((s) => s.puzzle != null);

      bloc.add(const CellLongPressed(row: 0, col: 1, offsetX: 0, offsetY: 0));
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(bloc.state.gridData[0][1], NonogramCellState.marked);

      bloc.add(const CellLongPressed(row: 0, col: 1, offsetX: 0, offsetY: 0));
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(bloc.state.gridData[0][1], NonogramCellState.marked);
    });

    test('Tap on marked cell should fill it', () async {
      bloc.add(const LevelLoadRequested());
      await bloc.stream.firstWhere((s) => s.puzzle != null);

      bloc.add(const CellLongPressed(row: 0, col: 1, offsetX: 0, offsetY: 0));
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(bloc.state.gridData[0][1], NonogramCellState.marked);

      bloc.add(const CellTapped(0, 1, offsetX: 0, offsetY: 0));
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(bloc.state.gridData[0][1], NonogramCellState.filled);
    });

    test('Drag starting on marked cell should fill marked cells', () async {
      bloc.add(Started(puzzle: dragPuzzle));
      await bloc.stream.firstWhere((s) => s.puzzle != null);

      bloc.add(const CellLongPressed(row: 0, col: 0, offsetX: 0, offsetY: 0));
      bloc.add(const CellLongPressed(row: 0, col: 1, offsetX: 0, offsetY: 0));
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(bloc.state.gridData[0][0], NonogramCellState.marked);
      expect(bloc.state.gridData[0][1], NonogramCellState.marked);

      bloc.add(const DragStarted(0, 0));
      bloc.add(const DragUpdated(0, 1));
      bloc.add(const DragEnded(offsetX: 0, offsetY: 0));

      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(bloc.state.gridData[0][0], NonogramCellState.filled);
      expect(bloc.state.gridData[0][1], NonogramCellState.filled);
    });

    test('Long press should do nothing in explore mode', () async {
      bloc.add(const LevelLoadRequested());
      await bloc.stream.firstWhere((s) => s.puzzle != null);

      bloc.add(const InteractionModeChanged(offsetX: 0, offsetY: 0));
      await Future<void>.delayed(const Duration(milliseconds: 10));

      bloc.add(const CellLongPressed(row: 0, col: 1, offsetX: 0, offsetY: 0));
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(bloc.state.gridData[0][1], NonogramCellState.empty);
    });

    test('Marked cell can still satisfy solved puzzle semantics', () async {
      bloc.add(const LevelLoadRequested());
      await bloc.stream.firstWhere((s) => s.puzzle != null);

      bloc.add(const CellLongPressed(row: 0, col: 1, offsetX: 0, offsetY: 0));
      bloc.add(const CellLongPressed(row: 1, col: 0, offsetX: 0, offsetY: 0));
      bloc.add(const CellTapped(0, 0, offsetX: 0, offsetY: 0));
      bloc.add(const CellTapped(1, 1, offsetX: 0, offsetY: 0));

      await expectLater(
        bloc.stream,
        emitsThrough(predicate<NonogramPlayState>((s) => s.isSolved)),
      );
    });

    test(
      'Satisfied row blocks adding new filled cells but allows unfill',
      () async {
        bloc.add(Started(puzzle: satisfactionPuzzle));
        await bloc.stream.firstWhere((s) => s.puzzle != null);

        bloc.add(const CellTapped(0, 0, offsetX: 0, offsetY: 0));
        bloc.add(const CellTapped(0, 2, offsetX: 0, offsetY: 0));
        bloc.add(const CellTapped(0, 4, offsetX: 0, offsetY: 0));
        await Future<void>.delayed(const Duration(milliseconds: 10));
        expect(bloc.state.satisfiedRows.first, isTrue);

        bloc.add(const CellTapped(0, 1, offsetX: 0, offsetY: 0));
        await Future<void>.delayed(const Duration(milliseconds: 10));
        expect(bloc.state.gridData[0][1], NonogramCellState.empty);

        bloc.add(const CellTapped(0, 0, offsetX: 0, offsetY: 0));
        await Future<void>.delayed(const Duration(milliseconds: 10));
        expect(bloc.state.gridData[0][0], NonogramCellState.empty);
        expect(bloc.state.satisfiedRows.first, isFalse);
      },
    );
  });

  group('NonogramPlayBloc Hint Tests', () {
    late FakeNonogramRepository repository;
    late NonogramPlayBloc bloc;

    setUp(() {
      repository = FakeNonogramRepository();
      bloc = NonogramPlayBloc(repository: repository);
    });

    tearDown(() async {
      await bloc.close();
    });

    test('HintRequested should decrement hints and reveal a line', () async {
      bloc.add(const LevelLoadRequested());
      await bloc.stream.firstWhere((s) => s.puzzle != null);
      expect(bloc.state.remainingHints, 3);

      bloc.add(const HintRequested(offsetX: 0, offsetY: 0));

      await expectLater(
        bloc.stream,
        emitsThrough(
          predicate<NonogramPlayState>(
            (s) =>
                s.remainingHints == 2 &&
                s.gridData
                    .expand((r) => r)
                    .any((c) => c != NonogramCellState.empty),
          ),
        ),
      );

      // Verify persistence
      final snapshot = await repository.getCurrentProgress();
      expect(snapshot?.remainingHints, 2);
    });

    test('HintRequested should be ignored when hints are 0', () async {
      bloc.add(
        Started(
          puzzle: dummyPuzzle,
          snapshot: NonogramBoardSnapshot(
            puzzleId: dummyPuzzle.id,
            level: dummyPuzzle.level,
            gridData: const [
              [NonogramCellState.empty, NonogramCellState.empty],
              [NonogramCellState.empty, NonogramCellState.empty],
            ],
            startTime: DateTime.now(),
            interactionMode: NonogramInteractionMode.draw,
            remainingHints: 0,
          ),
        ),
      );
      await bloc.stream.firstWhere((s) => s.puzzle != null);

      expect(bloc.state.remainingHints, 0);

      final gridBefore = bloc.state.gridData;
      bloc.add(const HintRequested(offsetX: 0, offsetY: 0));

      await Future.delayed(const Duration(milliseconds: 10));
      expect(bloc.state.remainingHints, 0);
      expect(bloc.state.gridData, gridBefore);
    });

    test('BoardReset should NOT reset hint quota', () async {
      bloc.add(const LevelLoadRequested());
      await bloc.stream.firstWhere((s) => s.puzzle != null);

      bloc.add(const HintRequested(offsetX: 0, offsetY: 0));
      await bloc.stream.firstWhere((s) => s.remainingHints == 2);

      bloc.add(const BoardReset(offsetX: 0, offsetY: 0));
      await bloc.stream.firstWhere(
        (s) =>
            !s.gridData
                .expand((r) => r)
                .any((c) => c == NonogramCellState.filled),
      );

      expect(bloc.state.remainingHints, 2);
    });

    test('Hint progress should restore after recreating bloc', () async {
      bloc.add(const LevelLoadRequested());
      await bloc.stream.firstWhere((s) => s.puzzle != null);

      bloc.add(const HintRequested(offsetX: 12, offsetY: 34));
      await bloc.stream.firstWhere((s) => s.remainingHints == 2);
      await bloc.close();

      bloc = NonogramPlayBloc(repository: repository);
      bloc.add(const LevelLoadRequested());
      await bloc.stream.firstWhere((s) => s.puzzle != null && !s.isLoading);

      expect(bloc.state.remainingHints, 2);
      expect(
        bloc.state.gridData
            .expand((row) => row)
            .any((cell) => cell != NonogramCellState.empty),
        isTrue,
      );
    });

    test('BoardReset keeps reduced hint quota after recreating bloc', () async {
      bloc.add(const LevelLoadRequested());
      await bloc.stream.firstWhere((s) => s.puzzle != null);

      bloc.add(const HintRequested(offsetX: 0, offsetY: 0));
      await bloc.stream.firstWhere((s) => s.remainingHints == 2);
      bloc.add(const BoardReset(offsetX: 0, offsetY: 0));
      await Future<void>.delayed(const Duration(milliseconds: 10));
      await bloc.close();

      bloc = NonogramPlayBloc(repository: repository);
      bloc.add(const LevelLoadRequested());
      await bloc.stream.firstWhere((s) => s.puzzle != null && !s.isLoading);

      expect(bloc.state.remainingHints, 2);
      expect(
        bloc.state.gridData
            .expand((row) => row)
            .every((cell) => cell == NonogramCellState.empty),
        isTrue,
      );
    });

    test('Starting new level should have 3 hints', () async {
      bloc.add(
        Started(
          puzzle: dummyPuzzle,
          snapshot: NonogramBoardSnapshot(
            puzzleId: dummyPuzzle.id,
            level: dummyPuzzle.level,
            gridData: const [
              [NonogramCellState.filled, NonogramCellState.marked],
              [NonogramCellState.marked, NonogramCellState.filled],
            ],
            startTime: DateTime.now(),
            interactionMode: NonogramInteractionMode.draw,
            remainingHints: 1,
          ),
        ),
      );
      await bloc.stream.firstWhere((s) => s.puzzle != null);
      expect(bloc.state.isSolved, isTrue);
      expect(bloc.state.remainingHints, 1);

      // Go to level 2
      bloc.add(const NextLevelRequested());
      await bloc.stream.firstWhere(
        (s) => s.level == 2 && s.puzzle != null && !s.isLoading,
      );

      expect(bloc.state.remainingHints, 3);
    });
  });
}

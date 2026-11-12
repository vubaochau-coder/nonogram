import 'dart:math';

import 'package:nonogram/models/nonogram_cell_state.dart';
import 'package:nonogram/models/nonogram_completed_progress.dart';
import 'package:nonogram/models/nonogram_interaction_mode.dart';
import 'package:nonogram/models/nonogram_board_snapshot.dart';
import 'package:nonogram/models/nonogram_puzzle.dart';
import 'package:nonogram/models/power_up_inventory.dart';
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

    test('Mark mode: tap toggles X, long press fills', () async {
      bloc.add(const LevelLoadRequested());
      await bloc.stream.firstWhere((s) => s.puzzle != null);

      bloc.add(const InteractionModeChanged(offsetX: 0, offsetY: 0));
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(bloc.state.interactionMode, NonogramInteractionMode.mark);

      bloc.add(const CellTapped(0, 1, offsetX: 0, offsetY: 0));
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(bloc.state.gridData[0][1], NonogramCellState.marked);

      bloc.add(const CellTapped(0, 1, offsetX: 0, offsetY: 0));
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(bloc.state.gridData[0][1], NonogramCellState.empty);

      bloc.add(const CellLongPressed(row: 0, col: 0, offsetX: 0, offsetY: 0));
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(bloc.state.gridData[0][0], NonogramCellState.filled);
    });

    test(
      'Mark mode: dragging marks empty cells but keeps filled ones',
      () async {
        bloc.add(const LevelLoadRequested());
        await bloc.stream.firstWhere((s) => s.puzzle != null);

        bloc.add(const CellTapped(1, 1, offsetX: 0, offsetY: 0));
        bloc.add(const InteractionModeChanged(offsetX: 0, offsetY: 0));
        await Future<void>.delayed(const Duration(milliseconds: 10));

        bloc.add(const DragStarted(1, 0));
        bloc.add(const DragUpdated(1, 1));
        bloc.add(const DragEnded(offsetX: 0, offsetY: 0));
        await Future<void>.delayed(const Duration(milliseconds: 10));

        expect(bloc.state.gridData[1][0], NonogramCellState.marked);
        expect(bloc.state.gridData[1][1], NonogramCellState.filled);
      },
    );

    test('Mode switch returns to fill', () async {
      bloc.add(const LevelLoadRequested());
      await bloc.stream.firstWhere((s) => s.puzzle != null);
      expect(bloc.state.interactionMode, NonogramInteractionMode.fill);
      bloc.add(const InteractionModeChanged(offsetX: 0, offsetY: 0));
      bloc.add(const InteractionModeChanged(offsetX: 0, offsetY: 0));
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(bloc.state.interactionMode, NonogramInteractionMode.fill);
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
      // Đủ nhiều ô cần tô để một lượt gợi ý (5 ô) không giải xong màn.
      repository = FakeNonogramRepository(
        solution: const [
          [1, 1, 1, 1],
          [1, 0, 0, 1],
          [1, 0, 0, 1],
          [1, 1, 1, 1],
        ],
      );
      bloc = NonogramPlayBloc(repository: repository);
    });

    tearDown(() async {
      await bloc.close();
    });

    test('HintRequested should decrement hints and fill cells', () async {
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

      // Kho dùng chung được lưu lại.
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(
        await repository.getPowerUps(),
        const PowerUpInventory(hints: 2, wands: 1),
      );
    });

    test('HintRequested fills exactly 5 correct cells at random', () async {
      final seeded = NonogramPlayBloc(
        repository: FakeNonogramRepository(),
        random: Random(7),
      );
      addTearDown(seeded.close);
      seeded.add(Started(puzzle: satisfactionPuzzle));
      await seeded.stream.firstWhere((s) => s.puzzle != null && !s.isLoading);

      final pulse = seeded.stream.firstWhere(
        (s) => s is NonogramPlayHintCellsAppliedState,
      );
      seeded.add(const HintRequested(offsetX: 0, offsetY: 0));
      final applied = await pulse as NonogramPlayHintCellsAppliedState;

      expect(applied.cells.length, 5);
      expect(applied.remainingHints, 2);
      final filled = <({int row, int col})>{};
      for (var r = 0; r < 2; r++) {
        for (var c = 0; c < 5; c++) {
          final cell = applied.gridData[r][c];
          if (cell == NonogramCellState.filled) filled.add((row: r, col: c));
          // Không đánh X, không tô sai.
          if (satisfactionPuzzle.solution[r][c] == 0) {
            expect(cell, NonogramCellState.empty);
          }
        }
      }
      expect(filled, applied.cells.toSet());
    });

    test('out of hints: a rewarded hint is used at once, not stored', () async {
      await repository.savePowerUps(const PowerUpInventory(hints: 0, wands: 0));
      bloc.add(const LevelLoadRequested());
      await bloc.stream.firstWhere((s) => s.puzzle != null && !s.isLoading);
      expect(bloc.state.remainingHints, 0);

      bloc.add(
        const RewardGranted(powerUp: PowerUp.hint, offsetX: 0, offsetY: 0),
      );
      final applied = await bloc.stream.firstWhere(
        (s) => s is NonogramPlayHintCellsAppliedState,
      );
      expect((applied as NonogramPlayHintCellsAppliedState).cells.length, 5);
      expect(bloc.state.remainingHints, 0);
      expect(
        await repository.getPowerUps(),
        const PowerUpInventory(hints: 0, wands: 0),
      );
    });

    test('rewards are ignored while the inventory still has some', () async {
      bloc.add(const LevelLoadRequested());
      await bloc.stream.firstWhere((s) => s.puzzle != null && !s.isLoading);
      final grid = bloc.state.gridData;

      bloc.add(
        const RewardGranted(powerUp: PowerUp.hint, offsetX: 0, offsetY: 0),
      );
      bloc.add(
        const RewardGranted(powerUp: PowerUp.wand, offsetX: 0, offsetY: 0),
      );
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(bloc.state.gridData, grid);
      expect(bloc.state.remainingHints, 3);
      expect(bloc.state.remainingWands, 1);
      expect(bloc.state.isWandActive, isFalse);
    });

    test('out of wands: a rewarded wand opens selection mode', () async {
      await repository.savePowerUps(const PowerUpInventory(hints: 0, wands: 0));
      bloc.add(const LevelLoadRequested());
      await bloc.stream.firstWhere((s) => s.puzzle != null && !s.isLoading);

      bloc.add(
        const RewardGranted(powerUp: PowerUp.wand, offsetX: 0, offsetY: 0),
      );
      await bloc.stream.firstWhere((s) => s.isWandActive);
      expect(bloc.state.remainingWands, 1);

      bloc.add(
        const WandLineSelected(isRow: true, index: 0, offsetX: 0, offsetY: 0),
      );
      await bloc.stream.firstWhere((s) => s.remainingWands == 0);
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect((await repository.getPowerUps()).wands, 0);
    });

    test('HintRequested should be ignored when hints are 0', () async {
      await repository.savePowerUps(const PowerUpInventory(hints: 0, wands: 1));
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
            interactionMode: NonogramInteractionMode.fill,
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

      // Tự tô thêm một ô (không phải ô gợi ý) để xem chơi lại có xoá nó.
      final hinted = bloc.state.lockedCells;
      expect(hinted.length, 5);
      final own =
          [
            for (var r = 0; r < 4; r++)
              for (var c = 0; c < 4; c++)
                if (!hinted.contains((row: r, col: c))) (row: r, col: c),
          ].first;
      bloc.add(CellLongPressed(row: own.row, col: own.col));
      await bloc.stream.firstWhere(
        (s) => s.gridData[own.row][own.col] != NonogramCellState.empty,
      );

      bloc.add(const BoardReset(offsetX: 0, offsetY: 0));
      await bloc.stream.firstWhere(
        (s) => s.gridData[own.row][own.col] == NonogramCellState.empty,
      );

      expect(bloc.state.remainingHints, 2);
      // Ô gợi ý được giữ lại, vẫn khoá.
      expect(bloc.state.lockedCells, hinted);
      for (var r = 0; r < 4; r++) {
        for (var c = 0; c < 4; c++) {
          expect(
            bloc.state.gridData[r][c] == NonogramCellState.filled,
            hinted.contains((row: r, col: c)),
          );
        }
      }
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
      // Chỉ còn đúng 5 ô gợi ý (đã khoá) sau khi chơi lại và mở lại app.
      expect(bloc.state.lockedCells.length, 5);
      expect(
        bloc.state.gridData
            .expand((row) => row)
            .where((cell) => cell == NonogramCellState.filled)
            .length,
        5,
      );
    });

    test('hints are not refilled on a new level', () async {
      bloc.add(const LevelLoadRequested());
      await bloc.stream.firstWhere((s) => s.puzzle != null && !s.isLoading);
      bloc.add(const HintRequested(offsetX: 0, offsetY: 0));
      await bloc.stream.firstWhere((s) => s.remainingHints == 2);
      await Future<void>.delayed(const Duration(milliseconds: 10));
      await bloc.close();

      // Màn khác, bloc mới: vẫn là kho đã dùng.
      bloc = NonogramPlayBloc(repository: repository, initialLevel: 2);
      bloc.add(const LevelLoadRequested());
      await bloc.stream.firstWhere((s) => s.puzzle != null && !s.isLoading);
      expect(bloc.state.level, 2);
      expect(bloc.state.remainingHints, 2);
    });

    test('a new player starts with the starter inventory', () async {
      expect(await repository.getPowerUps(), PowerUpInventory.starter);
      bloc.add(const LevelLoadRequested());
      await bloc.stream.firstWhere((s) => s.puzzle != null && !s.isLoading);
      expect(bloc.state.remainingHints, 3);
      expect(bloc.state.remainingWands, 1);
    });
  });

  group('NonogramPlayBloc Magic Wand Tests', () {
    late FakeNonogramRepository repository;
    late NonogramPlayBloc bloc;

    setUp(() {
      repository = FakeNonogramRepository();
      bloc = NonogramPlayBloc(repository: repository);
    });

    tearDown(() async {
      await bloc.close();
    });

    Future<void> start([NonogramBoardSnapshot? snapshot]) async {
      bloc.add(Started(puzzle: satisfactionPuzzle, snapshot: snapshot));
      await bloc.stream.firstWhere((s) => s.puzzle != null && !s.isLoading);
    }

    test('new level starts with one wand, not in selection mode', () async {
      await start();
      expect(bloc.state.remainingWands, 1);
      expect(bloc.state.isWandActive, isFalse);
    });

    test('toggling enters and leaves selection mode', () async {
      await start();
      bloc.add(const WandToggled());
      await bloc.stream.firstWhere((s) => s.isWandActive);
      bloc.add(const WandToggled());
      await bloc.stream.firstWhere((s) => !s.isWandActive);
      expect(bloc.state.remainingWands, 1);
    });

    test('selecting a column reveals exactly that column', () async {
      await start();
      bloc.add(const WandToggled());
      await bloc.stream.firstWhere((s) => s.isWandActive);

      bloc.add(
        const WandLineSelected(isRow: false, index: 1, offsetX: 0, offsetY: 0),
      );
      await bloc.stream.firstWhere((s) => s.remainingWands == 0);

      final grid = bloc.state.gridData;
      // Cột 1: [0, 1] -> X rồi tô.
      expect(grid[0][1], NonogramCellState.marked);
      expect(grid[1][1], NonogramCellState.filled);
      // Các cột khác không đổi.
      expect(grid[0][0], NonogramCellState.empty);
      expect(grid[1][0], NonogramCellState.empty);
      expect(bloc.state.isWandActive, isFalse);

      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect((await repository.getPowerUps()).wands, 0);
    });

    test('selecting a row reveals exactly that row', () async {
      await start();
      bloc.add(const WandToggled());
      bloc.add(
        const WandLineSelected(isRow: true, index: 0, offsetX: 0, offsetY: 0),
      );
      await bloc.stream.firstWhere((s) => s.remainingWands == 0);
      expect(bloc.state.gridData[0], const [
        NonogramCellState.filled,
        NonogramCellState.marked,
        NonogramCellState.filled,
        NonogramCellState.marked,
        NonogramCellState.filled,
      ]);
      expect(
        bloc.state.gridData[1].every((c) => c == NonogramCellState.empty),
        isTrue,
      );
    });

    test('selection without entering wand mode is ignored', () async {
      await start();
      bloc.add(
        const WandLineSelected(isRow: true, index: 0, offsetX: 0, offsetY: 0),
      );
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(bloc.state.remainingWands, 1);
      expect(
        bloc.state.gridData
            .expand((r) => r)
            .every((c) => c == NonogramCellState.empty),
        isTrue,
      );
    });

    test('cannot enter wand mode with no wands left', () async {
      await repository.savePowerUps(const PowerUpInventory(hints: 3, wands: 0));
      await start();
      expect(bloc.state.remainingWands, 0);
      bloc.add(const WandToggled());
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(bloc.state.isWandActive, isFalse);
    });

    test('old snapshots with per-level counts still load', () {
      final restored = NonogramBoardSnapshot.fromMap({
        'puzzleId': 'p',
        'level': 1,
        'gridData': [
          [0],
        ],
        'startTime': DateTime(2026).toIso8601String(),
        'interactionMode': null,
        'viewportOffsetX': 0,
        'viewportOffsetY': 0,
        'remainingHints': 1,
        'remainingWands': 0,
      });
      expect(restored.level, 1);
    });
  });

  group('NonogramPlayBloc Locked cells', () {
    late NonogramPlayBloc bloc;
    late FakeNonogramRepository repository;

    setUp(() {
      repository = FakeNonogramRepository();
      bloc = NonogramPlayBloc(repository: repository, random: Random(2));
    });

    tearDown(() async {
      await bloc.close();
    });

    // Hàng 0: 1 0 1 0 1, hàng 1: 1 1 1 1 1.
    Future<void> startAndWandRow0() async {
      bloc.add(Started(puzzle: satisfactionPuzzle));
      await bloc.stream.firstWhere((s) => s.puzzle != null && !s.isLoading);
      bloc.add(const WandToggled());
      bloc.add(
        const WandLineSelected(isRow: true, index: 0, offsetX: 0, offsetY: 0),
      );
      await bloc.stream.firstWhere((s) => s.remainingWands == 0);
    }

    test('wand locks the whole line, X cells included', () async {
      await startAndWandRow0();
      expect(bloc.state.lockedCells, {
        for (var c = 0; c < 5; c++) (row: 0, col: c),
      });
    });

    test('locked cells ignore tap, long press and mode', () async {
      await startAndWandRow0();
      final before = bloc.state.gridData;
      bloc.add(const CellTapped(0, 0, offsetX: 0, offsetY: 0)); // ô tô
      bloc.add(const CellTapped(0, 1, offsetX: 0, offsetY: 0)); // ô X
      bloc.add(const CellLongPressed(row: 0, col: 1));
      bloc.add(const InteractionModeChanged(offsetX: 0, offsetY: 0));
      await bloc.stream.firstWhere(
        (s) => s.interactionMode == NonogramInteractionMode.mark,
      );
      bloc.add(const CellTapped(0, 1, offsetX: 0, offsetY: 0));
      bloc.add(const CellTapped(0, 0, offsetX: 0, offsetY: 0));
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(bloc.state.gridData[0], before[0]);
    });

    test('dragging skips locked cells and keeps drawing others', () async {
      await startAndWandRow0();
      // Kéo dọc từ ô khoá (0,0, đang tô) xuống ô (1,0): vẫn là tô, không xoá.
      bloc.add(const DragStarted(0, 0));
      bloc.add(const DragUpdated(1, 0));
      bloc.add(const DragEnded(offsetX: 0, offsetY: 0));
      await bloc.stream.firstWhere(
        (s) => s.gridData[1][0] == NonogramCellState.filled,
      );
      expect(bloc.state.gridData[0][0], NonogramCellState.filled);

      // Kéo ngang hàng 1 rồi lên hàng 0 qua ô X khoá: ô X không bị tô.
      bloc.add(const DragStarted(1, 1));
      bloc.add(const DragUpdated(0, 1));
      bloc.add(const DragEnded(offsetX: 0, offsetY: 0));
      await bloc.stream.firstWhere(
        (s) => s.gridData[1][1] == NonogramCellState.filled,
      );
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(bloc.state.gridData[0][1], NonogramCellState.marked);
    });

    test('restart keeps locked cells, clears the rest', () async {
      await startAndWandRow0();
      bloc.add(const CellTapped(1, 2, offsetX: 0, offsetY: 0));
      await bloc.stream.firstWhere(
        (s) => s.gridData[1][2] == NonogramCellState.filled,
      );
      bloc.add(const BoardReset(offsetX: 0, offsetY: 0));
      await bloc.stream.firstWhere(
        (s) => s.gridData[1][2] == NonogramCellState.empty,
      );
      expect(bloc.state.gridData[0], const [
        NonogramCellState.filled,
        NonogramCellState.marked,
        NonogramCellState.filled,
        NonogramCellState.marked,
        NonogramCellState.filled,
      ]);
      expect(bloc.state.lockedCells.length, 5);
    });

    test('locked cells are saved and restored', () async {
      await startAndWandRow0();
      await Future<void>.delayed(const Duration(milliseconds: 20));
      final snapshot = await repository.getCurrentProgress();
      expect(snapshot!.lockedCells.length, 5);

      final map = snapshot.toMap();
      final restored = NonogramBoardSnapshot.fromMap(map);
      expect(restored.lockedCells, snapshot.lockedCells);

      final again = NonogramPlayBloc(repository: repository);
      addTearDown(again.close);
      again.add(Started(puzzle: satisfactionPuzzle, snapshot: restored));
      await again.stream.firstWhere((s) => s.puzzle != null && !s.isLoading);
      expect(again.state.lockedCells, snapshot.lockedCells);
    });

    test('old snapshots without locked cells lock nothing', () {
      final restored = NonogramBoardSnapshot.fromMap({
        'puzzleId': 'p',
        'level': 1,
        'gridData': [
          [1],
        ],
        'startTime': DateTime(2026).toIso8601String(),
        'interactionMode': null,
        'viewportOffsetX': 0,
        'viewportOffsetY': 0,
      });
      expect(restored.lockedCells, isEmpty);
    });
  });
}

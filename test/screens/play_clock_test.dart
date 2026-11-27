import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/data/nonogram_repository.dart';
import 'package:nonogram/engine/model/nonogram_cell_state.dart';
import 'package:nonogram/engine/model/nonogram_puzzle.dart';
import 'package:nonogram/models/nonogram_board_snapshot.dart';
import 'package:nonogram/models/nonogram_interaction_mode.dart';
import 'package:nonogram/screens/play/bloc/nonogram_play_bloc.dart';
import 'package:nonogram/screens/play/bloc/nonogram_play_event.dart';
import 'package:nonogram/screens/play/clock/nonogram_play_clock.dart';

import '../mocks/fake_nonogram_local_service.dart';
import '../mocks/fake_nonogram_puzzle_source.dart';

/// A clock whose time moves only when the test says so.
class _FakeTime {
  DateTime now = DateTime(2026, 11, 27, 9);
  void advance(Duration d) => now = now.add(d);
}

const _minute = Duration(minutes: 1);

final _puzzle = NonogramPuzzle(
  id: 'p-1',
  title: 'Test',
  author: '',
  difficulty: '',
  difficultyScore: 0,
  level: 1,
  solution: const [
    [1, 0],
    [0, 1],
  ],
);

Future<void> _settle() => Future<void>.delayed(Duration.zero);

void main() {
  group('NonogramPlayClock', () {
    late _FakeTime time;
    late NonogramPlayClock clock;

    setUp(() {
      time = _FakeTime();
      clock = NonogramPlayClock(now: () => time.now);
    });

    test('counts only between start and finish', () {
      time.advance(_minute);
      expect(clock.elapsed, Duration.zero, reason: 'not started');
      clock.start(0);
      time.advance(_minute * 2);
      expect(clock.elapsed, _minute * 2);
      clock.finish();
      time.advance(_minute * 5);
      expect(clock.elapsed, _minute * 2, reason: 'the total is kept');
      expect(clock.isRunning, isFalse);
    });

    test('any hold stops it; it runs again once every hold is released', () {
      clock.start(0);
      time.advance(_minute);
      clock
        ..hold(ClockHold.background)
        ..hold(ClockHold.covered);
      time.advance(const Duration(hours: 3));
      clock.release(ClockHold.background);
      time.advance(_minute);
      expect(clock.isRunning, isFalse, reason: 'still covered');
      clock.release(ClockHold.covered);
      time.advance(_minute);
      expect(clock.elapsed, _minute * 2);
    });

    test('the player pause is toggled, and a new level starts unpaused', () {
      clock.start(0);
      clock.toggleUserPause();
      expect(clock.isPausedByUser, isTrue);
      expect(clock.isRunning, isFalse);
      clock.toggleUserPause();
      expect(clock.isRunning, isTrue);

      clock.toggleUserPause();
      clock.start(90000);
      expect(clock.isPausedByUser, isFalse);
      expect(clock.elapsed, const Duration(seconds: 90));
      expect(clock.isRunning, isTrue);
    });

    test('onHeld fires when a hold stops it, not when the level ends', () {
      var held = 0;
      clock.onHeld = () => held++;
      clock.start(0);
      clock.hold(ClockHold.background);
      expect(held, 1);
      clock.hold(ClockHold.covered);
      expect(held, 1, reason: 'already stopped');
      clock.release(ClockHold.background);
      clock.release(ClockHold.covered);
      clock.finish();
      expect(held, 1);
    });

    test('formats as mm:ss, then h:mm:ss', () {
      expect(formatClock(const Duration(seconds: 7)), '00:07');
      expect(formatClock(const Duration(minutes: 12, seconds: 3)), '12:03');
      expect(
        formatClock(const Duration(hours: 1, minutes: 2, seconds: 3)),
        '1:02:03',
      );
    });
  });

  group('NonogramBoardSnapshot.elapsedMs', () {
    NonogramBoardSnapshot snapshot({int elapsedMs = 0}) =>
        NonogramBoardSnapshot(
          puzzleId: 'p-1',
          level: 1,
          gridData: const [
            [NonogramCellState.empty],
          ],
          startTime: DateTime(2026),
          interactionMode: NonogramInteractionMode.fill,
          elapsedMs: elapsedMs,
        );

    test('is saved and read back', () {
      final map = snapshot(elapsedMs: 123456).toMap();
      expect(NonogramBoardSnapshot.fromMap(map).elapsedMs, 123456);
    });

    test('a game saved before the clock existed restarts from 0', () {
      final map = snapshot().toMap()..remove('elapsedMs');
      expect(NonogramBoardSnapshot.fromMap(map).elapsedMs, 0);
    });
  });

  group('play bloc and clock', () {
    late _FakeTime time;
    late FakeNonogramLocalService local;
    late NonogramPlayBloc bloc;

    setUp(() {
      time = _FakeTime();
      local = FakeNonogramLocalService();
      bloc = NonogramPlayBloc(
        repository: NonogramRepository(FakeNonogramPuzzleSource(), local),
        clock: NonogramPlayClock(now: () => time.now),
      );
    });

    tearDown(() => bloc.close());

    test('the completion time leaves out the time the app was away', () async {
      bloc.add(Started(puzzle: _puzzle));
      await _settle();
      time.advance(_minute);
      bloc.clock.hold(ClockHold.background);
      time.advance(const Duration(days: 2));
      bloc.clock.release(ClockHold.background);
      time.advance(_minute);

      bloc
        ..add(const CellTapped(0, 0, offsetX: 0, offsetY: 0))
        ..add(const CellTapped(1, 1, offsetX: 0, offsetY: 0));
      await bloc.stream.firstWhere((s) => s.isSolved);
      await _settle();

      final record = (await local.getCompletedProgress()).single;
      expect(record.bestCompletionMs, (_minute * 2).inMilliseconds);
    });

    test('a pause saves the time played with the game in progress', () async {
      bloc.add(Started(puzzle: _puzzle));
      await _settle();
      time.advance(const Duration(seconds: 75));
      bloc.clock.hold(ClockHold.background);
      await _settle();
      expect((await local.getCurrentProgress())!.elapsedMs, 75000);
    });

    test('a saved game continues from its time played', () async {
      final saved = NonogramBoardSnapshot(
        puzzleId: _puzzle.id,
        level: 1,
        gridData: const [
          [NonogramCellState.empty, NonogramCellState.empty],
          [NonogramCellState.empty, NonogramCellState.empty],
        ],
        startTime: DateTime(2020),
        interactionMode: NonogramInteractionMode.fill,
        elapsedMs: 600000,
      );
      bloc.add(Started(puzzle: _puzzle, snapshot: saved));
      await _settle();
      time.advance(_minute);
      expect(bloc.clock.elapsed, const Duration(minutes: 11));
    });
  });
}

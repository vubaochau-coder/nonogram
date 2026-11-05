import 'package:nonogram/models/nonogram_board_snapshot.dart';
import 'package:nonogram/models/nonogram_completed_progress.dart';
import 'package:nonogram/models/nonogram_interaction_mode.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/screens/dashboard/bloc/nonogram_dashboard_bloc.dart';
import 'package:nonogram/screens/dashboard/bloc/nonogram_dashboard_event.dart';
import 'package:nonogram/screens/dashboard/bloc/nonogram_dashboard_state.dart';
import '../mocks/fake_nonogram_repository.dart';

void main() {
  group('NonogramDashboardBloc Tests', () {
    late FakeNonogramRepository repository;
    late NonogramDashboardBloc bloc;

    setUp(() {
      repository = FakeNonogramRepository();
      bloc = NonogramDashboardBloc(repository: repository);
    });

    tearDown(() {
      bloc.close();
    });

    test('Initial loading state is true', () {
      expect(bloc.state.isLoading, true);
    });

    test('Loads correct campaign overview on DashboardInitialized', () async {
      // Mock some data
      await repository.saveCurrentProgress(
        NonogramBoardSnapshot(
          puzzleId: 'p-5',
          level: 5,
          gridData: [],
          startTime: DateTime.now(),
          interactionMode: NonogramInteractionMode.draw,
        ),
      );

      bloc.add(const DashboardInitialized());

      await expectLater(
        bloc.stream,
        emitsThrough(
          predicate<NonogramDashboardState>(
            (s) =>
                s.isLoading == false &&
                s.currentLevel == 5 &&
                s.hasInProgressSession == true,
          ),
        ),
      );
    });

    test(
      'RefreshRequested should update state with latest repository data',
      () async {
        bloc.add(const DashboardInitialized());
        // Wait for first load
        await bloc.stream.firstWhere((s) => !s.isLoading);

        expect(bloc.state.completedCount, 0);

        // Simulate repository update (e.g. user completed a level)
        await repository.saveCompletedProgress(
          NonogramCompletedProgress(
            puzzleId: 'p-1',
            level: 1,
            bestCompletionMs: 500,
            completedAt: DateTime.now(),
            lastPlayedAt: DateTime.now(),
          ),
        );

        // Trigger refresh
        bloc.add(const RefreshRequested());

        await expectLater(
          bloc.stream,
          emitsThrough(
            predicate<NonogramDashboardState>(
              (s) => s.completedCount == 1 && s.isLoading == false,
            ),
          ),
        );
      },
    );

    test(
      'Completed-level snapshot should not be treated as in-progress session',
      () async {
        await repository.saveCurrentProgress(
          NonogramBoardSnapshot(
            puzzleId: 'p-1',
            level: 1,
            gridData: const [],
            startTime: DateTime.now(),
            interactionMode: NonogramInteractionMode.draw,
          ),
        );

        await repository.saveCompletedProgress(
          NonogramCompletedProgress(
            puzzleId: 'p-1',
            level: 1,
            bestCompletionMs: 500,
            completedAt: DateTime.now(),
            lastPlayedAt: DateTime.now(),
          ),
        );

        bloc.add(const DashboardInitialized());

        await expectLater(
          bloc.stream,
          emitsThrough(
            predicate<NonogramDashboardState>(
              (s) =>
                  s.isLoading == false &&
                  s.hasInProgressSession == false &&
                  s.currentLevel == 2,
            ),
          ),
        );
      },
    );
  });
}

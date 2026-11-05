import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:nonogram/core/app_bloc.dart';
import 'package:nonogram/data/nonogram_repository.dart';
import 'package:nonogram/core/toast_utils.dart';
import 'package:nonogram/core/wrapper.dart';
import 'nonogram_dashboard_event.dart';
import 'nonogram_dashboard_state.dart';

class NonogramDashboardBloc
    extends AppBloc<NonogramDashboardEvent, NonogramDashboardState> {
  final NonogramRepository _repository;

  NonogramDashboardBloc({required NonogramRepository repository})
    : _repository = repository,
      super(NonogramDashboardState.initial()) {
    on<DashboardInitialized>(
      _onDashboardInitialized,
      transformer: sequential(),
    );
    on<RefreshRequested>(_onRefreshRequested, transformer: droppable());
  }

  _onDashboardInitialized(DashboardInitialized event, Emitter emit) async {
    if (event.showLoading) {
      emit(state.copyWith(isLoading: true));
    }

    try {
      final overview = await _repository.getCampaignOverview();
      emit(
        state.copyWith(
          isLoading: false,
          currentProgress: Wrapper(overview.currentProgress),
          currentLevel: overview.currentLevel,
          nextPlayableLevel: Wrapper(overview.nextPlayableLevel),
          completedCount: overview.completedCount,
          hasInProgressSession: overview.currentProgress != null,
          totalLevels: overview.totalLevels,
        ),
      );
    } catch (e) {
      ToastUtils.error(title: e.toString());
    } finally {
      if (event.showLoading) {
        emit(state.copyWith(isLoading: false));
      }
    }
  }

  _onRefreshRequested(RefreshRequested event, Emitter emit) async {
    add(const DashboardInitialized());
  }
}

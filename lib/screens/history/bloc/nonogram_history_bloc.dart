import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nonogram/data/nonogram_repository.dart';
import 'nonogram_history_event.dart';
import 'nonogram_history_state.dart';

class NonogramHistoryBloc
    extends Bloc<NonogramHistoryEvent, NonogramHistoryState> {
  final NonogramRepository _repository;

  NonogramHistoryBloc({required NonogramRepository repository})
    : _repository = repository,
      super(const NonogramHistoryState()) {
    on<HistoryInitialized>(_onInitialized);
    on<LoadMoreRequested>(_onLoadMore);
  }

  Future<void> _onInitialized(
    HistoryInitialized event,
    Emitter<NonogramHistoryState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _repository.getCompletedResultsPage(loadedCount: 0);
      emit(
        state.copyWith(
          isLoading: false,
          items: result.items,
          hasMore: result.hasMore,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e));
    }
  }

  Future<void> _onLoadMore(
    LoadMoreRequested event,
    Emitter<NonogramHistoryState> emit,
  ) async {
    if (state.isLoadingMore || !state.hasMore || state.items.isEmpty) return;

    emit(state.copyWith(isLoadingMore: true));
    try {
      // loadedCount là số lượng item hiện có trong list UI
      final result = await _repository.getCompletedResultsPage(
        loadedCount: state.items.length,
      );

      emit(
        state.copyWith(
          isLoadingMore: false,
          items: [...state.items, ...result.items],
          hasMore: result.hasMore,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false, error: e));
    }
  }
}

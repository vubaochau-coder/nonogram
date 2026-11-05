import 'package:nonogram/models/nonogram_completed_progress.dart';
import 'package:equatable/equatable.dart';

class NonogramHistoryState extends Equatable {
  final bool isLoading;
  final bool isLoadingMore;
  final List<NonogramCompletedProgress> items;
  final bool hasMore;
  final Object? error;

  const NonogramHistoryState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.items = const [],
    this.hasMore = true,
    this.error,
  });

  NonogramHistoryState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    List<NonogramCompletedProgress>? items,
    bool? hasMore,
    Object? error,
  }) {
    return NonogramHistoryState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, isLoadingMore, items, hasMore, error];
}

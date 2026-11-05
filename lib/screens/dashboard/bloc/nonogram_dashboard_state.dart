import 'package:equatable/equatable.dart';
import 'package:nonogram/models/nonogram_board_snapshot.dart';
import 'package:nonogram/core/wrapper.dart';

class NonogramDashboardState extends Equatable {
  final bool isLoading;
  final NonogramBoardSnapshot? currentProgress;

  /// Level đang được chơi dở (từ snapshot). Dùng cho CTA "Continue".
  final int currentLevel;

  /// Level kế tiếp chưa được hoàn thành. Dùng cho card "Next Target".
  /// null nếu đã hoàn thành toàn bộ campaign hiện có.
  final int? nextPlayableLevel;
  final int completedCount;
  final bool hasInProgressSession;

  /// Tổng số màn có trong game.
  final int totalLevels;

  const NonogramDashboardState({
    required this.isLoading,
    this.currentProgress,
    this.currentLevel = 1,
    this.nextPlayableLevel,
    this.completedCount = 0,
    this.hasInProgressSession = false,
    this.totalLevels = 0,
  });

  factory NonogramDashboardState.initial() {
    return const NonogramDashboardState(isLoading: true);
  }

  NonogramDashboardState copyWith({
    bool? isLoading,
    Wrapper<NonogramBoardSnapshot?>? currentProgress,
    int? currentLevel,
    Wrapper<int?>? nextPlayableLevel,
    int? completedCount,
    bool? hasInProgressSession,
    int? totalLevels,
  }) {
    return NonogramDashboardState(
      isLoading: isLoading ?? this.isLoading,
      currentProgress: currentProgress.unWrapOr(this.currentProgress),
      currentLevel: currentLevel ?? this.currentLevel,
      nextPlayableLevel: nextPlayableLevel.unWrapOr(this.nextPlayableLevel),
      completedCount: completedCount ?? this.completedCount,
      hasInProgressSession: hasInProgressSession ?? this.hasInProgressSession,
      totalLevels: totalLevels ?? this.totalLevels,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    currentProgress,
    currentLevel,
    nextPlayableLevel,
    completedCount,
    hasInProgressSession,
    totalLevels,
  ];
}

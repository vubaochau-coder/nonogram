import 'package:equatable/equatable.dart';
import 'package:nonogram/core/wrapper.dart';
import 'package:nonogram/data/nonogram_repository.dart';
import 'package:nonogram/models/nonogram_board_snapshot.dart';
import 'package:nonogram/models/nonogram_puzzle.dart';

class NonogramDashboardState extends Equatable {
  final bool isLoading;
  final NonogramBoardSnapshot? currentProgress;

  /// Màn hiển thị trên thẻ chính: màn đang chơi dở, hoặc màn kế tiếp.
  final int currentLevel;

  /// Puzzle của [currentLevel] (để hiện kích thước, độ khó).
  final NonogramPuzzle? currentPuzzle;

  /// Level kế tiếp chưa được hoàn thành.
  /// null nếu đã hoàn thành toàn bộ campaign hiện có.
  final int? nextPlayableLevel;
  final int completedCount;
  final bool hasInProgressSession;

  /// Tổng số màn có trong game.
  final int totalLevels;

  final NonogramCompletionSummary summary;

  const NonogramDashboardState({
    required this.isLoading,
    this.currentProgress,
    this.currentLevel = 1,
    this.currentPuzzle,
    this.nextPlayableLevel,
    this.completedCount = 0,
    this.hasInProgressSession = false,
    this.totalLevels = 0,
    this.summary = NonogramCompletionSummary.empty,
  });

  factory NonogramDashboardState.initial() {
    return const NonogramDashboardState(isLoading: true);
  }

  /// Đã giải hết mọi màn và không còn ván dở.
  bool get isCampaignComplete =>
      !isLoading && nextPlayableLevel == null && !hasInProgressSession;

  double get progress =>
      totalLevels == 0 ? 0 : (completedCount / totalLevels).clamp(0, 1);

  NonogramDashboardState copyWith({
    bool? isLoading,
    Wrapper<NonogramBoardSnapshot?>? currentProgress,
    int? currentLevel,
    Wrapper<NonogramPuzzle?>? currentPuzzle,
    Wrapper<int?>? nextPlayableLevel,
    int? completedCount,
    bool? hasInProgressSession,
    int? totalLevels,
    NonogramCompletionSummary? summary,
  }) {
    return NonogramDashboardState(
      isLoading: isLoading ?? this.isLoading,
      currentProgress: currentProgress.unWrapOr(this.currentProgress),
      currentLevel: currentLevel ?? this.currentLevel,
      currentPuzzle: currentPuzzle.unWrapOr(this.currentPuzzle),
      nextPlayableLevel: nextPlayableLevel.unWrapOr(this.nextPlayableLevel),
      completedCount: completedCount ?? this.completedCount,
      hasInProgressSession: hasInProgressSession ?? this.hasInProgressSession,
      totalLevels: totalLevels ?? this.totalLevels,
      summary: summary ?? this.summary,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    currentProgress,
    currentLevel,
    currentPuzzle,
    nextPlayableLevel,
    completedCount,
    hasInProgressSession,
    totalLevels,
    summary,
  ];
}

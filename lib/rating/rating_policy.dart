/// Khi nào hỏi người chơi đánh giá app:
///
/// - lần đầu sau khi đã giải [firstAfter] màn;
/// - bấm "Để sau" thì hỏi lại sau [repeatEvery] màn nữa, tối đa [maxPrompts]
///   lần;
/// - đã chọn số sao (bao nhiêu cũng vậy) thì không hỏi nữa.
class RatingPolicy {
  const RatingPolicy({
    this.firstAfter = 5,
    this.repeatEvery = 15,
    this.maxPrompts = 3,
  });

  final int firstAfter;
  final int repeatEvery;
  final int maxPrompts;

  bool shouldPrompt({required int solvedLevels, required RatingState state}) {
    if (state.answered || state.prompts >= maxPrompts) return false;
    if (solvedLevels < firstAfter) return false;
    final last = state.lastPromptSolved;
    return last == null || solvedLevels - last >= repeatEvery;
  }
}

/// Trạng thái đã lưu của lời mời đánh giá.
class RatingState {
  const RatingState({
    this.answered = false,
    this.prompts = 0,
    this.lastPromptSolved,
  });

  /// Người chơi đã chọn số sao.
  final bool answered;

  /// Số lần đã hiện lời mời.
  final int prompts;

  /// Số màn đã giải ở lần hiện gần nhất.
  final int? lastPromptSolved;
}

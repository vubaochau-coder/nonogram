import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/app_sounds.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/core/onboarding_preferences.dart';
import 'package:nonogram/engine/model/nonogram_cell_state.dart';

import '../play/nonogram_play_sounds.dart';
import 'nonogram_tutorial_controller.dart';
import 'widgets/tutorial_board.dart';
import 'widgets/tutorial_message_card.dart';
import 'widgets/tutorial_mode_toggle.dart';
import 'widgets/tutorial_overlays.dart';
import 'widgets/tutorial_tool_button.dart';

/// Luồng "Cách chơi": một câu đố 5×5 hiện dần từng hàng, mỗi bước có lời dẫn,
/// viền sáng chỗ cần làm và bàn tay chỉ vào chỗ cần chạm.
///
/// Phần 2 (sau luật chơi) thực hành thao tác trên một câu đố khác: kéo để tô
/// liền, nhấn giữ để đánh X, nút gợi ý, gậy phép. Làm xong phần này thì
/// không tự hiện hướng dẫn thao tác trong màn chơi nữa.
///
/// Phần 3 dạy các kỹ thuật giải trên câu đố 8×8: chồng lấp (một số, nhiều
/// số), hàng số 0, ô ngoài tầm với, khoảng trống vừa khít, rồi để người chơi
/// tự giải nốt.
///
/// Đóng trang trả về `true` nếu người chơi bấm "Xem các kỹ thuật giải".
class NonogramTutorialScreen extends StatefulWidget {
  const NonogramTutorialScreen({super.key});

  @override
  State<NonogramTutorialScreen> createState() => _NonogramTutorialScreenState();
}

class _NonogramTutorialScreenState extends State<NonogramTutorialScreen> {
  final _controller = NonogramTutorialController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onProgress);
    _lastTally = _tally();
  }

  @override
  void dispose() {
    _controller.removeListener(_onProgress);
    _controller.dispose();
    super.dispose();
  }

  /// Bàn hướng dẫn lần trước, để biết vừa tô / đánh X / khớp hàng nào.
  PlayTally? _lastTally;
  bool _wasFinished = false;

  PlayTally _tally() {
    final c = _controller;
    var filled = 0;
    var marked = 0;
    for (final row in c.grid) {
      for (final cell in row) {
        if (cell == NonogramCellState.filled) filled++;
        if (cell == NonogramCellState.marked) marked++;
      }
    }
    var lines = 0;
    for (var r = 0; r < c.rows; r++) {
      if (c.isRowComplete(r)) lines++;
    }
    for (var col = 0; col < c.cols; col++) {
      if (c.isColComplete(col)) lines++;
    }
    return (
      // Mỗi lần nạp bài mới là một danh sách solution mới.
      game: identityHashCode(c.solution),
      filled: filled,
      marked: marked,
      lines: lines,
      totalLines: c.rows + c.cols,
    );
  }

  /// Tiếng giống màn chơi: tô ô, đánh X, khớp xong hàng / cột; giải xong bài
  /// thì hợp âm mừng.
  void _playSounds() {
    final tally = _tally();
    final prev = _lastTally;
    _lastTally = tally;
    final sounds = AppSoundController.maybeOf(context);
    if (sounds == null) return;
    final finished = _controller.isFinished;
    if (finished && !_wasFinished) {
      _wasFinished = true;
      sounds.play(GameSound.fanfare);
      return;
    }
    if (prev == null || prev.game != tally.game) return;
    final sound = soundFor(prev, tally);
    if (sound != null) sounds.play(sound);
  }

  void _onProgress() {
    _playSounds();
    if (_controller.step.task != TutorialTask.toolsDone &&
        !_controller.isFinished) {
      return;
    }
    try {
      final prefs = context.read<OnboardingPreferences>();
      prefs.markPlayCoachSeen();
      // Phần thao tác đã dạy kéo để tô nhiều ô.
      prefs.markDragTipSeen();
    } on ProviderNotFoundException {
      // Không có tuỳ chọn (test): bỏ qua.
    }
  }

  void _close({bool showTechniques = false}) {
    Navigator.of(context).pop(showTechniques);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final step = _controller.step;
        final task = step.task;

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.nonogramTutorialTitle),
            actions: [
              if (task != TutorialTask.done)
                TextButton(
                  key: const ValueKey('nonogram-tutorial-skip'),
                  onPressed: _close,
                  child: Text(l10n.nonogramTutorialSkip),
                ),
              const SizedBox(width: 8),
            ],
          ),
          body: SafeArea(
            top: false,
            child: Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: TutorialMessageCard(
                        text:
                            task == TutorialTask.intro ||
                                task == TutorialTask.rulesDone ||
                                task == TutorialTask.toolsDone
                            ? ''
                            : tutorialMessageText(l10n, step.message),
                        note: step.dragNote
                            ? l10n.nonogramTutorialDragNote
                            : null,
                        mistakes: _controller.mistakes,
                      ),
                    ),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return TutorialBoardArea(
                            controller: _controller,
                            constraints: constraints,
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (step.showTools) ...[
                            TutorialToolButton(
                              key: const ValueKey('nonogram-tutorial-hint'),
                              icon: LucideIcons.lightbulb,
                              label: l10n.nonogramCoachHintTitle,
                              count: _controller.remainingHints,
                              active: false,
                              pointed: task == TutorialTask.useHint,
                              onPressed: _controller.useHint,
                            ),
                            const SizedBox(width: 12),
                            TutorialToolButton(
                              key: const ValueKey('nonogram-tutorial-wand'),
                              icon: LucideIcons.wand2,
                              label: l10n.nonogramPlayWandLabel,
                              count: _controller.remainingWands,
                              active: _controller.isWandActive,
                              pointed: task == TutorialTask.activateWand,
                              onPressed: _controller.activateWand,
                            ),
                            const SizedBox(width: 20),
                          ],
                          TutorialModeToggle(controller: _controller),
                        ],
                      ),
                    ),
                  ],
                ),
                if (TutorialStepOverlay.showsFor(task))
                  TutorialStepOverlay(
                    task: task,
                    controller: _controller,
                    onClose: _close,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/l10n/app_localizations.dart';

import '../nonogram_tutorial_controller.dart';

String tutorialMessageText(AppLocalizations l10n, TutorialMessage message) {
  return switch (message) {
    TutorialMessage.welcome => l10n.nonogramTutorialWelcome,
    TutorialMessage.switchToFill => l10n.nonogramTutorialSwitchToFill,
    TutorialMessage.clueIsCount => l10n.nonogramTutorialClueIsCount,
    TutorialMessage.edgeCell => l10n.nonogramTutorialEdgeCell,
    TutorialMessage.multipleClues => l10n.nonogramTutorialMultipleClues,
    TutorialMessage.clueOrder => l10n.nonogramTutorialClueOrder,
    TutorialMessage.columns => l10n.nonogramTutorialColumns,
    TutorialMessage.markEmpty => l10n.nonogramTutorialMarkEmpty,
    TutorialMessage.oneCellLeft => l10n.nonogramTutorialOneCellLeft,
    TutorialMessage.finish => l10n.nonogramTutorialFinish,
    TutorialMessage.rulesDone => l10n.nonogramTutorialRulesDone,
    TutorialMessage.dragRow => l10n.nonogramTutorialDragRow,
    TutorialMessage.longPressMark => l10n.nonogramTutorialLongPressMark,
    TutorialMessage.useHint => l10n.nonogramTutorialUseHint,
    TutorialMessage.activateWand => l10n.nonogramTutorialActivateWand,
    TutorialMessage.pickWandLine => l10n.nonogramTutorialPickWandLine,
    TutorialMessage.finishTools => l10n.nonogramTutorialFinishTools,
    TutorialMessage.toolsDone => l10n.nonogramTutorialToolsDone,
    TutorialMessage.overlapSingle => l10n.nonogramTutorialOverlapSingle,
    TutorialMessage.overlapMulti => l10n.nonogramTutorialOverlapMulti,
    TutorialMessage.fullRow => l10n.nonogramTutorialFullRow,
    TutorialMessage.zeroRow => l10n.nonogramTutorialZeroRow,
    TutorialMessage.markZeroRow => l10n.nonogramTutorialMarkZeroRow,
    TutorialMessage.outOfReach => l10n.nonogramTutorialOutOfReach,
    TutorialMessage.backToFill => l10n.nonogramTutorialBackToFill,
    TutorialMessage.exactSpace => l10n.nonogramTutorialExactSpace,
    TutorialMessage.finishTechniques => l10n.nonogramTutorialFinishTechniques,
    TutorialMessage.done => l10n.nonogramTutorialDone,
  };
}

/// Lời dẫn của bước hiện tại. Rung nhẹ mỗi khi người chơi làm sai.
class TutorialMessageCard extends StatelessWidget {
  const TutorialMessageCard({
    super.key,
    required this.text,
    this.note,
    required this.mistakes,
  });

  final String text;

  /// Dòng mẹo nhỏ dưới lời dẫn (null: không có).
  final String? note;
  final int mistakes;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;

    return TweenAnimationBuilder<double>(
      key: ValueKey(mistakes),
      tween: Tween(begin: mistakes == 0 ? 0.0 : 1.0, end: 0.0),
      duration: const Duration(milliseconds: 420),
      builder: (context, t, child) {
        final dx = math.sin(t * math.pi * 6) * 10 * t;
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: Container(
        width: double.infinity,
        // Đủ cho 4 dòng, để lời dẫn dài / ngắn không làm bàn nhảy lên xuống.
        constraints: const BoxConstraints(minHeight: 128),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: context.gameColors.cardBorder),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: Column(
            key: ValueKey(text),
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                textAlign: TextAlign.center,
                style: context.bodyLarge.copyWith(height: 1.4),
              ),
              if (note case final note?) ...[
                const SizedBox(height: 8),
                Row(
                  key: const ValueKey('nonogram-tutorial-drag-note'),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.swipe_right_alt_rounded,
                      size: 18,
                      color: colors.primary,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        note,
                        textAlign: TextAlign.center,
                        style: context.bodySmall.copyWith(
                          color: colors.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

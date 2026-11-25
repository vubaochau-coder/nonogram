import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/models/nonogram_interaction_mode.dart';

import '../nonogram_tutorial_controller.dart';
import 'tutorial_hand_hints.dart';

/// Nút gạt Tô / X giống trong màn chơi, kèm bàn tay chỉ vào lựa chọn cần bấm.
class TutorialModeToggle extends StatelessWidget {
  const TutorialModeToggle({super.key, required this.controller});

  final NonogramTutorialController controller;

  static const double _segment = 56;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.color;
    final step = controller.step;
    final pointAt = step.task == TutorialTask.switchMode ? step.mode : null;

    void toggle() {
      controller.selectMode(
        controller.mode == NonogramInteractionMode.fill
            ? NonogramInteractionMode.mark
            : NonogramInteractionMode.fill,
      );
    }

    Widget segment(
      NonogramInteractionMode mode,
      String label,
      Widget Function(Color color) icon,
    ) {
      final selected = controller.mode == mode;
      final foreground = selected ? colors.onPrimary : colors.onSurface;
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Semantics(
            button: true,
            selected: selected,
            label: label,
            child: InkWell(
              key: ValueKey('nonogram-tutorial-mode-${mode.name}'),
              onTap: toggle,
              borderRadius: BorderRadius.circular(15),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: _segment,
                height: _segment,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? colors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: icon(foreground),
              ),
            ),
          ),
          if (pointAt == mode)
            tutorialHandAt(
              center: const Offset(_segment / 2, _segment / 2),
              size: 48,
              child: const TutorialTapHint(size: 48),
            ),
        ],
      );
    }

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: context.gameColors.cardBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            segment(
              NonogramInteractionMode.fill,
              l10n.nonogramPlayModeFill,
              (color) => Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            segment(
              NonogramInteractionMode.mark,
              l10n.nonogramPlayModeMark,
              (color) => Icon(LucideIcons.x, size: 26, color: color),
            ),
          ],
        ),
      ),
    );
  }
}

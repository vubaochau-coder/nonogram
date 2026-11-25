import 'package:flutter/material.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/context_ext.dart';

import 'tutorial_hand_hints.dart';

/// Nút gợi ý / gậy phép trong bài hướng dẫn, kèm số lượt và bàn tay chỉ.
class TutorialToolButton extends StatelessWidget {
  const TutorialToolButton({
    super.key,
    required this.icon,
    required this.label,
    required this.count,
    required this.active,
    required this.pointed,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final int count;
  final bool active;
  final bool pointed;
  final VoidCallback onPressed;

  static const double _size = 60;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final game = context.gameColors;
    final foreground = active ? colors.primary : colors.onSurface;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Semantics(
          button: true,
          label: label,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(17),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: _size,
                height: _size,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: active
                      ? colors.primary.withValues(alpha: 0.12)
                      : colors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(
                    color: pointed
                        ? game.reward
                        : (active
                              ? colors.primary.withValues(alpha: 0.4)
                              : game.cardBorder),
                    width: pointed ? 2 : 1,
                  ),
                ),
                child: Icon(icon, size: 26, color: foreground),
              ),
            ),
          ),
        ),
        Positioned(
          right: -5,
          top: -5,
          child: IgnorePointer(
            child: Container(
              constraints: const BoxConstraints(minWidth: 20),
              height: 20,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: count > 0 ? colors.primary : colors.outline,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: context.labelSmall.copyWith(
                  fontSize: 11,
                  height: 1,
                  fontWeight: FontWeight.w800,
                  color: colors.onPrimary,
                ),
              ),
            ),
          ),
        ),
        if (pointed)
          tutorialHandAt(
            center: const Offset(_size / 2, _size / 2),
            size: 48,
            child: const TutorialTapHint(size: 48),
          ),
      ],
    );
  }
}

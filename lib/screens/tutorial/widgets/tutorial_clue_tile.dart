import 'package:flutter/material.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/context_ext.dart';

import 'tutorial_hand_hints.dart';

/// Ô số gợi ý của một hàng / cột. Đủ ô thì mờ đi và hiện dấu ✓.
class TutorialClueTile extends StatelessWidget {
  const TutorialClueTile({
    super.key,
    required this.width,
    required this.height,
    required this.clues,
    required this.vertical,
    required this.complete,
    required this.active,
    this.pointed = false,
    this.onTap,
  });

  final double width;
  final double height;
  final List<int> clues;
  final bool vertical;
  final bool complete;
  final bool active;

  /// Bàn tay chỉ vào ô số này (chọn hàng / cột cho gậy phép).
  final bool pointed;

  /// Chạm vào dãy số (khi đang chọn hàng / cột cho gậy phép).
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final game = context.gameColors;
    final shortSide = vertical ? width : height;
    final style = context.titleMedium.copyWith(
      fontSize: shortSide * 0.36,
      height: 1.15,
      fontWeight: active ? FontWeight.w800 : FontWeight.w600,
      color: complete ? colors.onSurfaceVariant : colors.onSurface,
    );
    final numbers = [for (final clue in clues) Text('$clue', style: style)];
    final handSize = shortSide * 0.9;

    final tile = SizedBox(
      width: width,
      height: height,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: complete ? colors.surface : game.clueBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: active ? game.reward : game.cardBorder,
              width: active ? 2 : 1,
            ),
          ),
          // Dấu ✓ và các số chia chỗ với nhau (không đè lên nhau khi có
          // nhiều số); 3 số trở lên ("1 1 1") thì thu nhỏ cho vừa ô.
          child: Flex(
            direction: vertical ? Axis.vertical : Axis.horizontal,
            children: [
              if (complete)
                Icon(
                  Icons.check_rounded,
                  size: shortSide * 0.3,
                  color: game.success,
                ),
              Expanded(
                child: Align(
                  alignment: vertical
                      ? Alignment.bottomCenter
                      : Alignment.centerRight,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: vertical
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: numbers,
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for (var i = 0; i < numbers.length; i++) ...[
                                if (i > 0) SizedBox(width: shortSide * 0.12),
                                numbers[i],
                              ],
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (onTap == null && !pointed) return tile;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          tile,
          if (pointed)
            tutorialHandAt(
              center: Offset(width / 2, height / 2),
              size: handSize,
              child: TutorialTapHint(size: handSize),
            ),
        ],
      ),
    );
  }
}

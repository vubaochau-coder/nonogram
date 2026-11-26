import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/context_ext.dart';

/// Nút "Điểm danh hôm nay": viên gradient, dòng dưới báo còn mấy ngày tới
/// quà chuỗi (hay hôm nay có quà). Đã điểm danh: viên xám, không bấm được.
class CheckInButton extends StatefulWidget {
  const CheckInButton({
    super.key,
    required this.done,
    required this.daysLeft,
    this.onPressed,
  });

  final bool done;

  /// Còn mấy ngày tới mốc kế tiếp (null: đã nhận hết quà tháng này).
  final int? daysLeft;
  final VoidCallback? onPressed;

  @override
  State<CheckInButton> createState() => _CheckInButtonState();
}

class _CheckInButtonState extends State<CheckInButton> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final game = context.gameColors;
    final colors = context.color;
    final done = widget.done;
    final daysLeft = widget.daysLeft;
    final giftToday = daysLeft != null && daysLeft <= 1;
    final subtitle = daysLeft == null
        ? l10n.checkInStreakAllDone
        : giftToday
        ? l10n.checkInGiftToday
        : l10n.checkInStreakDaysLeft(daysLeft);
    final ink = done ? colors.onSurfaceVariant : Colors.white;
    final pill = Container(
      height: 62,
      padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(31),
        color: done ? colors.surfaceContainerHigh : null,
        gradient: done
            ? null
            : LinearGradient(colors: [game.heroStart, game.heroEnd]),
        boxShadow: done
            ? null
            : [
                BoxShadow(
                  color: game.heroStart.withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: done ? colors.surface : Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              done
                  ? LucideIcons.check
                  : giftToday
                  ? LucideIcons.gift
                  : LucideIcons.calendarCheck,
              color: done ? colors.onSurfaceVariant : game.heroStart,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  done ? l10n.checkInDoneToday : l10n.checkInTodayButton,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.titleMedium.copyWith(
                    color: ink,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.labelMedium.copyWith(
                    color: ink.withValues(alpha: 0.85),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    if (widget.onPressed == null) return pill;
    return Semantics(
      button: true,
      enabled: !done,
      label: done ? l10n.checkInDoneToday : l10n.checkInTodayButton,
      child: GestureDetector(
        key: const ValueKey('check-in-button'),
        onTapDown: done ? null : (_) => setState(() => _down = true),
        onTapCancel: () => setState(() => _down = false),
        onTapUp: (_) => setState(() => _down = false),
        onTap: done ? null : widget.onPressed,
        child: AnimatedScale(
          scale: _down ? 0.94 : 1,
          duration: const Duration(milliseconds: 90),
          child: pill,
        ),
      ),
    );
  }
}

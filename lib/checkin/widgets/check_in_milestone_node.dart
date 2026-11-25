import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/context_ext.dart';

import 'check_in_colors.dart';

enum CheckInNodeState { claimed, ready, next, later }

/// Mốc trên thanh chuỗi: hộp quà (đã nhận: dấu tích). Nảy lên mỗi khi đổi
/// trạng thái (thanh vừa chạm tới, vừa nhận quà).
class CheckInMilestoneNode extends StatefulWidget {
  const CheckInMilestoneNode({
    super.key,
    required this.milestone,
    required this.state,
  });

  /// Diameter of the node, also its slot on the streak bar.
  static const size = 34.0;

  final int milestone;
  final CheckInNodeState state;

  @override
  State<CheckInMilestoneNode> createState() => _MilestoneNodeState();
}

class _MilestoneNodeState extends State<CheckInMilestoneNode>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bump = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );

  @override
  void didUpdateWidget(CheckInMilestoneNode old) {
    super.didUpdateWidget(old);
    if (old.state != widget.state &&
        (widget.state == CheckInNodeState.ready ||
            widget.state == CheckInNodeState.claimed)) {
      _bump.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _bump.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final fire = checkInFireColor(context);
    final state = widget.state;
    final filled =
        state == CheckInNodeState.claimed || state == CheckInNodeState.ready;
    final border = switch (state) {
      CheckInNodeState.claimed ||
      CheckInNodeState.ready ||
      CheckInNodeState.next => fire,
      CheckInNodeState.later => colors.outlineVariant,
    };
    final ink = switch (state) {
      CheckInNodeState.claimed || CheckInNodeState.ready => Colors.white,
      CheckInNodeState.next => fire,
      CheckInNodeState.later => colors.onSurfaceVariant,
    };
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _bump,
          builder: (context, child) {
            final t = _bump.value;
            final scale = _bump.isAnimating
                ? 1 + 0.45 * math.sin(math.pi * t)
                : 1.0;
            return Transform.scale(scale: scale, child: child);
          },
          child: Container(
            key: ValueKey(
              'check-in-milestone-${widget.milestone}-${state.name}',
            ),
            width: CheckInMilestoneNode.size,
            height: CheckInMilestoneNode.size,
            decoration: BoxDecoration(
              color: filled ? fire : colors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: border, width: 2),
            ),
            child: Icon(
              state == CheckInNodeState.claimed
                  ? LucideIcons.check
                  : LucideIcons.gift,
              size: 17,
              color: ink,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          context.l10n.checkInStreakDays(widget.milestone),
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.visible,
          style: context.labelSmall.copyWith(
            fontWeight: FontWeight.w700,
            color: colors.onSurface,
          ),
        ),
      ],
    );
  }
}

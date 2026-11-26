import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:nonogram/core/context_ext.dart';

import '../check_in_policy.dart';
import 'check_in_colors.dart';
import 'check_in_milestone_node.dart';

/// Thẻ chuỗi của tháng: ngọn lửa và chuỗi hiện tại, dòng nhắc bù ngày, và
/// thanh tiến trình đứng ở chuỗi dài nhất trong tháng với các mốc quà. Phần
/// sọc cam là chỗ chuỗi dài thêm được nếu bù hết ngày bỏ lỡ.
class CheckInStreakCard extends StatelessWidget {
  const CheckInStreakCard({
    super.key,
    required this.stats,
    required this.isThisMonth,
    required this.longest,
    required this.claimed,
    required this.pending,
    required this.nodeKeys,
  });

  final StreakStats stats;
  final bool isThisMonth;

  /// Vị trí thanh (chuỗi dài nhất, có thể đang chạy).
  final double longest;
  final Set<int> claimed;

  /// Mốc vừa đạt, quà chưa mở.
  final Set<int> pending;
  final Map<int, GlobalKey> nodeKeys;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.color;
    final fire = checkInFireColor(context);
    final missed = checkInMissedColor(context);
    final allClaimed = CheckInPolicy.nextMilestone(claimed) == null;
    final canGrow = stats.missed.isNotEmpty && stats.potential > longest;

    final Widget sub;
    if (canGrow) {
      // Ký tự riêng (vùng Private Use) đánh dấu chỗ số ngày được tô màu.
      const mark = '';
      final text = l10n.checkInStreakMakeUp(stats.missed.length, mark);
      final parts = text.split(mark);
      sub = Text.rich(
        TextSpan(
          children: [
            TextSpan(text: parts.first),
            TextSpan(
              text: l10n.checkInStreakDays(stats.potential),
              style: TextStyle(color: missed, fontWeight: FontWeight.w800),
            ),
            if (parts.length > 1) TextSpan(text: parts.sublist(1).join(mark)),
          ],
        ),
        key: const ValueKey('check-in-streak-make-up'),
      );
    } else {
      sub = Text(
        allClaimed ? l10n.checkInStreakAllDone : l10n.checkInStreakKeepGoing,
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_fire_department_rounded, color: fire),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    l10n.checkInStreakTitle(
                      isThisMonth ? stats.current : stats.longest,
                    ),
                    key: const ValueKey('check-in-streak-title'),
                    style: context.titleMedium.copyWith(
                      color: fire,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            DefaultTextStyle.merge(
              style: context.bodySmall.copyWith(
                color: colors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
              child: sub,
            ),
            const SizedBox(height: 22),
            _StreakBar(
              longest: longest,
              potential: canGrow ? stats.potential.toDouble() : null,
              claimed: claimed,
              pending: pending,
              nodeKeys: nodeKeys,
            ),
          ],
        ),
      ),
    );
  }
}

class _StreakBar extends StatelessWidget {
  const _StreakBar({
    required this.longest,
    required this.potential,
    required this.claimed,
    required this.pending,
    required this.nodeKeys,
  });

  final double longest;
  final double? potential;
  final Set<int> claimed;
  final Set<int> pending;
  final Map<int, GlobalKey> nodeKeys;

  static const _max = 28.0;
  static const _node = CheckInMilestoneNode.size;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final fire = checkInFireColor(context);
    final missed = checkInMissedColor(context);
    final next = CheckInPolicy.nextMilestone({...claimed, ...pending});
    return LayoutBuilder(
      builder: (context, constraints) {
        // Chừa nửa mốc ở hai đầu cho mốc 28 và nhãn không bị cắt.
        const inset = _node / 2 + 6;
        final width = constraints.maxWidth - inset * 2;
        double x(double v) => inset + width * (v.clamp(0, _max) / _max);
        final fillEnd = x(longest);
        final potentialEnd = potential == null ? null : x(potential!);
        return SizedBox(
          height: _node + 22,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: inset,
                right: inset,
                top: _node / 2 - 5,
                height: 10,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              if (potentialEnd != null && potentialEnd > fillEnd)
                Positioned(
                  left: fillEnd - 5,
                  width: potentialEnd - fillEnd + 5,
                  top: _node / 2 - 5,
                  height: 10,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CustomPaint(
                      key: const ValueKey('check-in-streak-potential'),
                      painter: _StripesPainter(
                        color: missed.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ),
              if (longest > 0)
                Positioned(
                  left: inset,
                  width: math.max(10, fillEnd - inset),
                  top: _node / 2 - 5,
                  height: 10,
                  child: DecoratedBox(
                    key: const ValueKey('check-in-streak-fill'),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: LinearGradient(
                        colors: [const Color(0xFFFAB005), fire],
                      ),
                    ),
                  ),
                ),
              for (final m in CheckInPolicy.streakMilestones)
                Positioned(
                  left: x(m.toDouble()) - _node / 2,
                  top: 0,
                  width: _node,
                  child: CheckInMilestoneNode(
                    key: nodeKeys[m],
                    milestone: m,
                    state: claimed.contains(m)
                        ? CheckInNodeState.claimed
                        : pending.contains(m) && longest >= m
                        ? CheckInNodeState.ready
                        : m == next
                        ? CheckInNodeState.next
                        : CheckInNodeState.later,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Sọc chéo của phần chuỗi có thể nối thêm nếu bù ngày.
class _StripesPainter extends CustomPainter {
  _StripesPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3;
    for (var x = -size.height; x < size.width + size.height; x += 7) {
      canvas.drawLine(
        Offset(x, size.height),
        Offset(x + size.height, 0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_StripesPainter old) => old.color != color;
}

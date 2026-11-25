import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/context_ext.dart';

import '../check_in_policy.dart';
import 'check_in_colors.dart';

class CheckInCalendarGrid extends StatelessWidget {
  const CheckInCalendarGrid({
    super.key,
    required this.month,
    required this.stampDay,
    required this.stampKey,
    required this.holdDay,
    required this.onMakeUp,
  });

  final CheckInMonth month;

  /// Ô nhận [stampKey]: ô hiệu ứng đóng dấu bay tới.
  final int stampDay;
  final GlobalKey stampKey;

  /// Ô vẽ như chưa điểm danh (hiệu ứng chưa tới).
  final int? holdDay;

  /// Chạm ngày bỏ lỡ (null: đang bận).
  final ValueChanged<int>? onMakeUp;

  @override
  Widget build(BuildContext context) {
    final material = MaterialLocalizations.of(context);
    final firstWeekday = material.firstDayOfWeekIndex; // 0 = Chủ nhật
    // DateTime.weekday: 1 = thứ Hai ... 7 = Chủ nhật.
    final weekdayOfFirst =
        DateTime(month.year, month.month).weekday % 7; // 0 = Chủ nhật
    final leading = (weekdayOfFirst - firstWeekday + 7) % 7;
    final cells = <CheckInDay?>[
      for (var i = 0; i < leading; i++) null,
      ...month.days,
    ];
    while (cells.length % 7 != 0) {
      cells.add(null);
    }

    return Column(
      children: [
        Row(
          children: [
            for (var i = 0; i < 7; i++)
              Expanded(
                child: Center(
                  child: Text(
                    material.narrowWeekdays[(firstWeekday + i) % 7],
                    style: context.labelSmall.copyWith(
                      color: context.color.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        for (var row = 0; row < cells.length ~/ 7; row++)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                for (var col = 0; col < 7; col++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: SizedBox(
                        height: 50,
                        child: switch (cells[row * 7 + col]) {
                          null => null,
                          final day => _DayCell(
                            key: day.day == stampDay ? stampKey : null,
                            day: day,
                            status: day.day == holdDay
                                ? (day.isToday
                                      ? CheckInDayStatus.today
                                      : CheckInDayStatus.missed)
                                : day.status,
                            onMakeUp: onMakeUp == null
                                ? null
                                : () => onMakeUp!(day.day),
                          ),
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Một ngày trên lịch (icon trơn, không chữ):
/// - Đã điểm danh: nền xanh nhạt, dấu tích.
/// - Bỏ lỡ: nền cam nhạt, viền cam nét đứt, nút ▶ (chạm để bù).
/// - Hôm nay chưa điểm danh: viền xanh đậm, chấm xanh.
/// - Chưa tới: nền xám nhạt, ổ khoá.
/// - Trước ngày bắt đầu dùng app: chỉ có số, mờ.
class _DayCell extends StatelessWidget {
  const _DayCell({
    super.key,
    required this.day,
    required this.status,
    this.onMakeUp,
  });

  final CheckInDay day;
  final CheckInDayStatus status;
  final VoidCallback? onMakeUp;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final missed = checkInMissedColor(context);
    final soft = Color.alphaBlend(
      colors.primary.withValues(alpha: dark ? 0.22 : 0.14),
      colors.surfaceContainerLow,
    );

    final (Color? background, Color ink, Widget? icon) = switch (status) {
      CheckInDayStatus.checked => (
        soft,
        colors.primary,
        Icon(LucideIcons.check, size: 16, color: colors.primary),
      ),
      CheckInDayStatus.missed => (
        Color.alphaBlend(
          missed.withValues(alpha: dark ? 0.18 : 0.14),
          colors.surfaceContainerLow,
        ),
        missed,
        Icon(Icons.play_arrow_rounded, size: 18, color: missed),
      ),
      CheckInDayStatus.today => (
        colors.surface,
        colors.primary,
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: colors.primary,
            shape: BoxShape.circle,
          ),
        ),
      ),
      CheckInDayStatus.future => (
        colors.surfaceContainerHigh.withValues(alpha: 0.6),
        colors.onSurfaceVariant.withValues(alpha: 0.6),
        Icon(
          LucideIcons.lock,
          size: 13,
          color: colors.onSurfaceVariant.withValues(alpha: 0.5),
        ),
      ),
      CheckInDayStatus.beforeStart => (
        null,
        colors.onSurfaceVariant.withValues(alpha: 0.4),
        null,
      ),
    };

    Widget cell = Container(
      key: ValueKey('check-in-day-${day.dayOfMonth}-${status.name}'),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
        border: status == CheckInDayStatus.today
            ? Border.all(color: colors.primary, width: 2.5)
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${day.dayOfMonth}',
            style: context.labelLarge.copyWith(
              color: ink,
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),
          if (icon != null) ...[const SizedBox(height: 3), icon],
        ],
      ),
    );
    if (status == CheckInDayStatus.missed) {
      cell = CustomPaint(
        foregroundPainter: CheckInDashedBorderPainter(color: missed),
        child: cell,
      );
      cell = Semantics(
        button: true,
        label: context.l10n.checkInLegendMissed,
        child: GestureDetector(
          key: ValueKey('check-in-make-up-${day.dayOfMonth}'),
          behavior: HitTestBehavior.opaque,
          onTap: onMakeUp,
          child: cell,
        ),
      );
    }
    return cell;
  }
}

/// Viền nét đứt bo góc của ngày bỏ lỡ.
class CheckInDashedBorderPainter extends CustomPainter {
  CheckInDashedBorderPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          (Offset.zero & size).deflate(0.75),
          const Radius.circular(12),
        ),
      );
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    for (final metric in path.computeMetrics()) {
      for (var d = 0.0; d < metric.length; d += 7) {
        canvas.drawPath(metric.extractPath(d, d + 4), paint);
      }
    }
  }

  @override
  bool shouldRepaint(CheckInDashedBorderPainter old) => old.color != color;
}

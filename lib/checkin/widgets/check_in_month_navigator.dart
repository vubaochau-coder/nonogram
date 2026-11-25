import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/context_ext.dart';

import 'check_in_calendar_grid.dart';
import 'check_in_colors.dart';

class CheckInMonthNavigator extends StatelessWidget {
  const CheckInMonthNavigator({
    super.key,
    required this.month,
    required this.canGoBack,
    required this.canGoForward,
    required this.onChanged,
  });

  final DateTime month;
  final bool canGoBack;
  final bool canGoForward;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final material = MaterialLocalizations.of(context);
    return Row(
      children: [
        IconButton(
          key: const ValueKey('check-in-prev-month'),
          onPressed: canGoBack
              ? () => onChanged(DateTime(month.year, month.month - 1))
              : null,
          icon: const Icon(LucideIcons.chevronLeft),
          tooltip: material.previousMonthTooltip,
        ),
        Expanded(
          child: Text(
            material.formatMonthYear(month),
            textAlign: TextAlign.center,
            style: context.titleMedium,
          ),
        ),
        IconButton(
          key: const ValueKey('check-in-next-month'),
          onPressed: canGoForward
              ? () => onChanged(DateTime(month.year, month.month + 1))
              : null,
          icon: const Icon(LucideIcons.chevronRight),
          tooltip: material.nextMonthTooltip,
        ),
      ],
    );
  }
}

/// Chú thích dưới lịch: đã điểm danh, bỏ lỡ, chưa tới.
class CheckInCalendarLegend extends StatelessWidget {
  const CheckInCalendarLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.color;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final missed = checkInMissedColor(context);
    final style = context.bodySmall.copyWith(color: colors.onSurfaceVariant);

    Widget item(Widget swatch, String label) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        swatch,
        const SizedBox(width: 6),
        Text(label, style: style),
      ],
    );
    Widget swatch(Color color, {Color? dashed}) => SizedBox.square(
      dimension: 12,
      child: CustomPaint(
        foregroundPainter: dashed == null
            ? null
            : CheckInDashedBorderPainter(color: dashed),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 6, 6, 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Wrap(
          spacing: 16,
          runSpacing: 6,
          children: [
            item(
              swatch(colors.primary.withValues(alpha: dark ? 0.3 : 0.18)),
              l10n.checkInLegendChecked,
            ),
            item(
              swatch(
                missed.withValues(alpha: dark ? 0.2 : 0.16),
                dashed: missed,
              ),
              l10n.checkInLegendMissed,
            ),
            item(swatch(colors.surfaceContainerHigh), l10n.checkInLegendFuture),
          ],
        ),
      ),
    );
  }
}

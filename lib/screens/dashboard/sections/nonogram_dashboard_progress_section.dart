import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/app_route_intent.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/core/duration_format.dart';

import '../bloc/nonogram_dashboard_bloc.dart';
import '../bloc/nonogram_dashboard_state.dart';
import '../dashboard_navigation.dart';

/// Thanh tiến trình campaign và ba ô thống kê.
class NonogramDashboardProgressSection extends StatelessWidget {
  const NonogramDashboardProgressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NonogramDashboardBloc, NonogramDashboardState>(
      buildWhen:
          (p, c) =>
              p.isLoading != c.isLoading ||
              p.completedCount != c.completedCount ||
              p.totalLevels != c.totalLevels ||
              p.summary != c.summary,
      builder: (context, state) {
        final l10n = context.l10n;
        final game = context.gameColors;
        final pct = state.progress * 100;
        // Dưới 10% hiện một chữ số thập phân để 1/574 không hiện thành "0%".
        final percent =
            pct > 0 && pct < 10
                ? pct.toStringAsFixed(1)
                : pct.floor().toString();
        final summary = state.summary;

        return Card(
          child: InkWell(
            onTap:
                state.completedCount == 0
                    ? null
                    : () => openFromDashboard(
                      context,
                      const NonogramCompletedResultsIntent(),
                    ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.nonogramDashboardProgressSectionTitle,
                          style: context.titleMedium,
                        ),
                      ),
                      Text(
                        state.isLoading ? '' : '$percent%',
                        style: context.titleMedium.copyWith(
                          color: context.color.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TweenAnimationBuilder<double>(
                    tween: Tween(end: state.isLoading ? 0 : state.progress),
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.easeOutCubic,
                    builder:
                        (context, value, _) => LinearProgressIndicator(
                          value: value == 0 ? 0 : value.clamp(0.015, 1.0),
                          minHeight: 10,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.isLoading
                        ? ''
                        : l10n.nonogramDashboardSolvedOfTotal(
                          state.completedCount,
                          state.totalLevels,
                        ),
                    style: context.bodySmall.copyWith(
                      color: context.color.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _Stat(
                        icon: LucideIcons.trophy,
                        color: game.reward,
                        value: '${state.completedCount}',
                        label: l10n.nonogramDashboardStatCompleted,
                      ),
                      _Stat(
                        icon: LucideIcons.zap,
                        color: context.color.primary,
                        value:
                            summary.bestMs == null
                                ? '–'
                                : context.formatPlayTime(summary.bestMs!),
                        label: l10n.nonogramDashboardStatFastest,
                      ),
                      _Stat(
                        icon: LucideIcons.clock,
                        color: game.success,
                        value:
                            summary.totalPlayMs == 0
                                ? '–'
                                : context.formatPlayTime(summary.totalPlayMs),
                        label: l10n.nonogramDashboardStatTotalTime,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(value, style: context.titleMedium),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.labelSmall.copyWith(
              color: context.color.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:nonogram/core/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/core/app_route_intent.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nonogram/widgets/app_skeleton_box.dart';
import '../bloc/nonogram_dashboard_bloc.dart';
import '../bloc/nonogram_dashboard_state.dart';

class NonogramDashboardSummarySection extends StatelessWidget {
  const NonogramDashboardSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.scrollViewHorizontalPadding,
      ),
      child: BlocBuilder<NonogramDashboardBloc, NonogramDashboardState>(
        buildWhen:
            (p, c) =>
                p.completedCount != c.completedCount ||
                p.currentLevel != c.currentLevel ||
                p.nextPlayableLevel != c.nextPlayableLevel ||
                p.hasInProgressSession != c.hasInProgressSession ||
                p.isLoading != c.isLoading,
        builder: (context, state) {
          final isLoading = state.isLoading;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.nonogramDashboardProgressSectionTitle,
                style: context.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _StatCard(
                    icon: LucideIcons.trophy,
                    label: context.l10n.nonogramDashboardStatCompleted,
                    value: '${state.completedCount}',
                    color: Colors.amber,
                    isLoading: isLoading,
                    onTap: () {
                      context.navigate(const NonogramCompletedResultsIntent());
                    },
                  ),
                  const SizedBox(width: 16),
                  _StatCard(
                    icon: LucideIcons.star,
                    label: context.l10n.nonogramDashboardStatNextTarget,
                    value: state.nextPlayableLevel?.toString() ?? 'Done',
                    color: context.color.primary,
                    isLoading: isLoading,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _ProgressPanel(
                isInProgress: state.hasInProgressSession,
                level: state.currentLevel,
                nextLevel: state.nextPlayableLevel,
                isLoading: isLoading,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ProgressPanel extends StatelessWidget {
  final bool isInProgress;
  final int level;
  final int? nextLevel;
  final bool isLoading;

  const _ProgressPanel({
    required this.isInProgress,
    required this.level,
    this.nextLevel,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.color.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.color.surfaceContainerHigh.withValues(alpha: 0.72),
        ),
      ),
      child:
          isLoading
              ? Shimmer.fromColors(
                baseColor: context.color.surfaceContainerHigh,
                highlightColor: context.color.surfaceContainerHighest,
                child: const Row(
                  children: [
                    AppSkeletonBox(width: 36, height: 36, borderRadius: 100),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppSkeletonBox(width: 100, height: 16),
                          SizedBox(height: 4),
                          AppSkeletonBox(width: 160, height: 12),
                        ],
                      ),
                    ),
                  ],
                ),
              )
              : Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (isInProgress
                              ? context.color.primary
                              : context.color.secondary)
                          .withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isInProgress
                          ? LucideIcons.hourglass
                          : LucideIcons.checkCircle2,
                      size: 20,
                      color:
                          isInProgress
                              ? context.color.primary
                              : context.color.secondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isInProgress
                              ? context.l10n.nonogramDashboardInSessionTitle
                              : context.l10n.nonogramDashboardReadyTitle,
                          style: context.titleSmall.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          isInProgress
                              ? context.l10n.nonogramDashboardInSessionDesc(
                                level,
                              )
                              : (nextLevel != null
                                  ? context.l10n.nonogramDashboardReadyDesc(
                                    nextLevel!,
                                  )
                                  : "You've completed all levels! Stay tuned for more."),
                          style: context.bodySmall.copyWith(
                            color: context.color.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isLoading;
  final VoidCallback? onTap;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.isLoading,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: context.color.surfaceContainerHigh.withValues(
                  alpha: 0.72,
                ),
              ),
            ),
            child:
                isLoading
                    ? Shimmer.fromColors(
                      baseColor: context.color.surfaceContainerHigh,
                      highlightColor: context.color.surfaceContainerHighest,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppSkeletonBox(width: 24, height: 24),
                          SizedBox(height: 16),
                          AppSkeletonBox(width: 40, height: 28),
                          SizedBox(height: 6),
                          AppSkeletonBox(width: 60, height: 12),
                        ],
                      ),
                    )
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(icon, color: color, size: 24),
                        const SizedBox(height: 16),
                        Text(
                          value,
                          style: context.headlineMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          label,
                          style: context.labelMedium.copyWith(
                            color: context.color.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
          ),
        ),
      ),
    );
  }
}

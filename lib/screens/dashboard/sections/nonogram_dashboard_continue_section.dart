import 'package:nonogram/core/app_spacing.dart';
import 'package:nonogram/core/app_route_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nonogram/widgets/app_skeleton_box.dart';
import '../bloc/nonogram_dashboard_bloc.dart';
import '../bloc/nonogram_dashboard_event.dart';
import '../bloc/nonogram_dashboard_state.dart';

class NonogramDashboardContinueSection extends StatelessWidget {
  const NonogramDashboardContinueSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NonogramDashboardBloc, NonogramDashboardState>(
      buildWhen: (p, c) {
        return p.currentLevel != c.currentLevel ||
            p.hasInProgressSession != c.hasInProgressSession ||
            p.isLoading != c.isLoading;
      },
      builder: (context, state) {
        final level = state.currentLevel;
        final isContinue = state.hasInProgressSession;
        final isLoading = state.isLoading;

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.scrollViewHorizontalPadding,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: context.color.surfaceContainerHigh,
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
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AppSkeletonBox(width: 80, height: 14),
                                const SizedBox(height: 8),
                                const AppSkeletonBox(width: 120, height: 24),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          const AppSkeletonBox(
                            width: 48,
                            height: 48,
                            borderRadius: 100,
                          ),
                        ],
                      ),
                    )
                    : Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (isContinue
                                        ? context
                                            .l10n
                                            .nonogramDashboardContinueResume
                                        : context
                                            .l10n
                                            .nonogramDashboardContinueNext)
                                    .toUpperCase(),
                                style: context.labelLarge.copyWith(
                                  color: context.color.primary,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                context.l10n.nonogramDashboardContinueLevel(
                                  level,
                                ),
                                style: context.titleLarge.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        InkWell(
                          onTap: () async {
                            // Navigate to play screen
                            await context.navigate(
                              NonogramPlayIntent(initialLevel: level),
                            );

                            // Refresh dashboard data when returning
                            if (context.mounted) {
                              context.read<NonogramDashboardBloc>().add(
                                const RefreshRequested(),
                              );
                            }
                          },
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: context.color.primary.withValues(
                                alpha: 0.1,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              LucideIcons.playCircle,
                              color: context.color.primary,
                              size: 28,
                            ),
                          ),
                        ),
                      ],
                    ),
          ),
        );
      },
    );
  }
}

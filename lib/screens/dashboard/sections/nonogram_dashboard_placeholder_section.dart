import 'package:nonogram/core/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:lucide_icons/lucide_icons.dart';

class NonogramDashboardPlaceholderSection extends StatelessWidget {
  const NonogramDashboardPlaceholderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.scrollViewHorizontalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Campaign Progress',
            style: context.titleMedium.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
            decoration: BoxDecoration(
              color: context.color.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: context.color.surfaceContainerHigh.withValues(
                  alpha: 0.72,
                ),
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  LucideIcons.lock,
                  size: 40,
                  color: context.color.onSurfaceVariant.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'Your campaign progress will appear here',
                  textAlign: TextAlign.center,
                  style: context.bodyMedium.copyWith(
                    color: context.color.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Coming soon in Phase 4',
                  style: context.labelSmall.copyWith(
                    color: context.color.primary.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

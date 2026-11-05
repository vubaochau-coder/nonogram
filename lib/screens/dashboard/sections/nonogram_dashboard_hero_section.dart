import 'package:nonogram/core/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:nonogram/core/context_ext.dart';

class NonogramDashboardHeroSection extends StatelessWidget {
  const NonogramDashboardHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.scrollViewHorizontalPadding,
        vertical: 24,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [context.color.primaryContainer, context.color.surface],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.nonogramDashboardTitle,
            style: context.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: context.color.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.nonogramDashboardHeroSubtitle,
            style: context.bodyMedium.copyWith(
              color: context.color.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:nonogram/core/context_ext.dart';
import 'package:flutter/material.dart';

class NonogramCompletionHeader extends StatelessWidget {
  final int level;
  final String difficulty;
  final String timeStr;
  final bool isCompact;

  const NonogramCompletionHeader({
    super.key,
    required this.level,
    required this.difficulty,
    required this.timeStr,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 16 : 24,
        vertical: isCompact ? 16 : 32,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            context.color.primaryContainer.withValues(alpha: 0.2),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        children: [
          Text(
            context.l10n.nonogramPlayCompletionTitle,
            style: (isCompact ? context.titleLarge : context.headlineMedium)
                .copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.color.primary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.nonogramPlayCompletionMessage(level),
            textAlign: TextAlign.center,
            style: isCompact ? context.bodyMedium : context.bodyLarge,
          ),
          SizedBox(height: isCompact ? 12 : 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _StatItem(
                icon: Icons.speed_rounded,
                label: context.l10n.nonogramPlayStatDifficulty,
                value: difficulty,
                isCompact: isCompact,
              ),
              SizedBox(width: isCompact ? 24 : 48),
              _StatItem(
                icon: Icons.timer_outlined,
                label: context.l10n.nonogramPlayStatTime,
                value: timeStr,
                isCompact: isCompact,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isCompact;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: isCompact ? 16 : 20, color: context.color.primary),
        const SizedBox(height: 4),
        if (!isCompact)
          Text(
            label,
            style: context.bodySmall.copyWith(
              color: context.color.onSurfaceVariant,
            ),
          ),
        Text(
          value,
          style: (isCompact ? context.bodySmall : context.bodyMedium).copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/context_ext.dart';

import '../bloc/nonogram_play_bloc.dart';
import '../clock/nonogram_play_clock.dart';

/// Covers the board while the player has paused the clock, so the puzzle
/// cannot be studied with the clock stopped. Lets touches through otherwise.
class NonogramPauseOverlay extends StatelessWidget {
  const NonogramPauseOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final clock = context.read<NonogramPlayBloc>().clock;
    return ListenableBuilder(
      listenable: clock,
      builder: (context, _) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        child: clock.isPausedByUser
            ? _PausedCard(clock: clock)
            : const SizedBox.shrink(),
      ),
    );
  }
}

class _PausedCard extends StatelessWidget {
  const _PausedCard({required this.clock});

  final NonogramPlayClock clock;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.color;
    return ColoredBox(
      key: const ValueKey('nonogram-pause-overlay'),
      color: colors.surface,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 320),
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
            decoration: BoxDecoration(
              color: colors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: context.gameColors.cardBorder),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.pause, size: 32, color: colors.primary),
                const SizedBox(height: 12),
                Text(l10n.playClockPausedTitle, style: context.titleLarge),
                const SizedBox(height: 4),
                Text(
                  formatClock(clock.elapsed),
                  style: context.headlineMedium.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w800,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.playClockPausedBody,
                  textAlign: TextAlign.center,
                  style: context.bodyMedium.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  key: const ValueKey('nonogram-clock-resume'),
                  onPressed: clock.toggleUserPause,
                  icon: const Icon(LucideIcons.play, size: 18),
                  label: Text(l10n.playClockResume),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

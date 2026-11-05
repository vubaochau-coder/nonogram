import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/core/duration_format.dart';
import 'package:nonogram/models/nonogram_puzzle.dart';
import 'package:nonogram/widgets/nonogram_pixel_art.dart';

/// Màn hình khi giải xong: hình hoàn chỉnh, thời gian, nút chơi tiếp.
class NonogramCompletionResultSection extends StatelessWidget {
  final NonogramPuzzle puzzle;
  final Duration completionDuration;
  final VoidCallback onNextLevel;

  const NonogramCompletionResultSection({
    super.key,
    required this.puzzle,
    required this.completionDuration,
    required this.onNextLevel,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLandscape =
            constraints.maxWidth > constraints.maxHeight &&
            constraints.maxWidth > 560;
        final picture = _Picture(puzzle: puzzle);
        final info = _Info(
          puzzle: puzzle,
          completionDuration: completionDuration,
        );
        final actions = _Actions(onNextLevel: onNextLevel);

        if (isLandscape) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(child: Center(child: picture)),
                const SizedBox(width: 32),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [info, const SizedBox(height: 24), actions],
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Column(
                  children: [
                    const _SolvedBadge(),
                    const SizedBox(height: 20),
                    picture,
                    const SizedBox(height: 20),
                    info,
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: actions,
            ),
          ],
        );
      },
    );
  }
}

class _SolvedBadge extends StatelessWidget {
  const _SolvedBadge();

  @override
  Widget build(BuildContext context) {
    final success = context.gameColors.success;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutBack,
      builder:
          (context, t, child) => Transform.scale(
            scale: t,
            child: Opacity(opacity: t.clamp(0, 1), child: child),
          ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: success.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(LucideIcons.checkCircle2, color: success, size: 30),
          ),
          const SizedBox(height: 12),
          Text(
            context.l10n.nonogramPlayCompletionTitle,
            style: context.headlineSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _Picture extends StatelessWidget {
  const _Picture({required this.puzzle});

  final NonogramPuzzle puzzle;

  @override
  Widget build(BuildContext context) {
    final aspect = puzzle.cols / puzzle.rows;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.9, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder:
          (context, scale, child) =>
              Transform.scale(scale: scale, child: child),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: context.color.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(14),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320, maxHeight: 320),
              child: AspectRatio(
                aspectRatio: aspect,
                child: NonogramPixelArt.picture(context, puzzle.solution),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({required this.puzzle, required this.completionDuration});

  final NonogramPuzzle puzzle;
  final Duration completionDuration;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        Text(
          puzzle.title,
          style: context.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          l10n.nonogramPlayCompletionMessage(puzzle.level),
          style: context.bodyMedium.copyWith(
            color: context.color.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            _StatChip(
              icon: LucideIcons.timer,
              color: context.color.primary,
              label: context.formatPlayTime(completionDuration.inMilliseconds),
            ),
            if (puzzle.difficulty.isNotEmpty)
              _StatChip(
                icon: LucideIcons.gauge,
                color: context.gameColors.reward,
                label: puzzle.difficulty,
              ),
            _StatChip(
              icon: LucideIcons.grid,
              color: context.gameColors.success,
              label: '${puzzle.cols} × ${puzzle.rows}',
            ),
          ],
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.color,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: context.color.surfaceContainerLow,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: context.gameColors.cardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(label, style: context.labelLarge),
        ],
      ),
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({required this.onNextLevel});

  final VoidCallback onNextLevel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).maybePop(),
            style: OutlinedButton.styleFrom(minimumSize: const Size(0, 52)),
            child: Text(l10n.nonogramPlayActionDashboard),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: FilledButton.icon(
            onPressed: onNextLevel,
            icon: const Icon(LucideIcons.arrowRight),
            iconAlignment: IconAlignment.end,
            label: Text(l10n.nonogramPlayActionNextLevelFixed),
          ),
        ),
      ],
    );
  }
}

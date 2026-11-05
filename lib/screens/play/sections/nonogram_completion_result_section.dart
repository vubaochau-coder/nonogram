import 'dart:math';
import 'package:nonogram/core/app_spacing.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/models/nonogram_puzzle.dart';
import 'package:flutter/material.dart';
import '../widgets/nonogram_completion_header.dart';
import '../widgets/nonogram_completion_board.dart';

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

  int _getMaxClueCount(List<List<int>> clues) {
    if (clues.isEmpty) return 0;
    return clues.map((c) => c.length).reduce(max);
  }

  @override
  Widget build(BuildContext context) {
    final minutes = completionDuration.inMinutes;
    final seconds = completionDuration.inSeconds % 60;
    final timeStr = context.l10n.nonogramPlayDurationFormat(minutes, seconds);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isLandscape = constraints.maxWidth > constraints.maxHeight;

        if (isLandscape) {
          return _buildLandscapeLayout(context, timeStr);
        }
        return _buildPortraitLayout(context, timeStr);
      },
    );
  }

  Widget _buildPortraitLayout(BuildContext context, String timeStr) {
    return Column(
      children: [
        NonogramCompletionHeader(
          level: puzzle.level,
          difficulty: puzzle.difficulty,
          timeStr: timeStr,
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pageHorizontalPadding,
          ),
          child: Text(
            puzzle.title,
            style: context.titleMedium.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: NonogramCompletionBoard(
            puzzle: puzzle,
            cellSize: 24.0,
            getMaxClueCount: _getMaxClueCount,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.pageHorizontalPadding),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onNextLevel,
              child: Text(context.l10n.nonogramPlayActionNextLevelFixed),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout(BuildContext context, String timeStr) {
    return Row(
      children: [
        // Left Column: Board
        Expanded(
          flex: 3, // Board takes more space
          child: Container(
            color: context.color.surfaceContainerLow.withValues(alpha: 0.5),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 500,
                    maxHeight: 500,
                  ),
                  child: NonogramCompletionBoard(
                    puzzle: puzzle,
                    cellSize: 24.0,
                    getMaxClueCount: _getMaxClueCount,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Right Column: Info & Action
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      NonogramCompletionHeader(
                        level: puzzle.level,
                        difficulty: puzzle.difficulty,
                        timeStr: timeStr,
                        isCompact: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.cardPadding,
                          0,
                          AppSpacing.cardPadding,
                          AppSpacing.sectionVerticalSpacing,
                        ),
                        child: Text(
                          puzzle.title,
                          style: context.titleMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.pageHorizontalPadding),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: onNextLevel,
                    child: Text(context.l10n.nonogramPlayActionNextLevelFixed),
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

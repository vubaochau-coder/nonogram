import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/context_ext.dart';
import '../bloc/nonogram_play_bloc.dart';
import '../bloc/nonogram_play_state.dart';
import '../../painters/nonogram_top_clues_painter.dart';

class NonogramTopCluesSection extends StatelessWidget {
  const NonogramTopCluesSection({super.key});

  int _getMaxClueCount(List<List<int>> clues) {
    if (clues.isEmpty) return 0;
    return clues.map((c) => c.length).reduce(max);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NonogramPlayBloc, NonogramPlayState>(
      buildWhen: (p, c) {
        return p.puzzle != c.puzzle ||
            p.cellSize != c.cellSize ||
            p.satisfiedCols != c.satisfiedCols;
      },
      builder: (context, state) {
        final puzzle = state.puzzle;
        if (puzzle == null) return const SizedBox.shrink();
        final cellSize = state.cellSize;

        final topClues = puzzle.topClues;
        final leftClues = puzzle.leftClues;

        if (topClues.isEmpty) return const SizedBox.shrink();

        final maxTopClues = _getMaxClueCount(topClues);
        final topClueHeight = maxTopClues * cellSize;
        final leftClueWidth = _getMaxClueCount(leftClues) * cellSize;

        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Corner Spacer
            SizedBox(width: leftClueWidth, height: topClueHeight),
            CustomPaint(
              size: Size(puzzle.cols * cellSize, topClueHeight),
              painter: NonogramTopCluesPainter(
                clues: topClues,
                satisfiedColumns: state.satisfiedCols,
                cellSize: cellSize,
                lineColor: context.color.outlineVariant,
                majorLineColor: context.color.outline,
                backgroundColor: context.color.surfaceContainer,
                textStyle: _clueStyle(context, cellSize),
                satisfiedTextStyle: _clueStyle(context, cellSize).copyWith(
                  color: context.gameColors.success.withValues(alpha: 0.75),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

TextStyle _clueStyle(BuildContext context, double cellSize) {
  return context.labelSmall.copyWith(
    fontSize: (cellSize * 0.4).clamp(9.0, 16.0),
    fontWeight: FontWeight.w800,
    color: context.color.onSurface,
    height: 1,
  );
}

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                backgroundColor: context.color.onSurface.withValues(
                  alpha: 0.05,
                ),
                textStyle: context.labelSmall.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.normal,
                ),
                satisfiedTextStyle: context.labelSmall.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

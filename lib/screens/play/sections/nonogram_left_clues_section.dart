import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/context_ext.dart';
import '../bloc/nonogram_play_bloc.dart';
import '../bloc/nonogram_play_state.dart';
import '../../painters/nonogram_left_clues_painter.dart';

class NonogramLeftCluesSection extends StatelessWidget {
  const NonogramLeftCluesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NonogramPlayBloc, NonogramPlayState>(
      buildWhen: (p, c) {
        return p.puzzle != c.puzzle ||
            p.cellSize != c.cellSize ||
            p.satisfiedRows != c.satisfiedRows;
      },
      builder: (context, state) {
        final puzzle = state.puzzle;
        if (puzzle == null) return const SizedBox.shrink();
        final cellSize = state.cellSize;

        final clues = puzzle.leftClues;
        if (clues.isEmpty) return const SizedBox.shrink();

        final maxClues = clues.map((r) => r.length).reduce(max);
        final width = maxClues * cellSize;

        return CustomPaint(
          size: Size(width, puzzle.rows * cellSize),
          painter: NonogramLeftCluesPainter(
            clues: clues,
            satisfiedRows: state.satisfiedRows,
            cellSize: cellSize,
            lineColor: context.color.surface,
            majorLineColor: context.color.outline,
            backgroundColor: context.gameColors.clueBackground,
            bandColor: context.gameColors.clueBand,
            textStyle: _clueStyle(context, cellSize),
            satisfiedTextStyle: _clueStyle(context, cellSize).copyWith(
              color: context.gameColors.success.withValues(alpha: 0.75),
            ),
          ),
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

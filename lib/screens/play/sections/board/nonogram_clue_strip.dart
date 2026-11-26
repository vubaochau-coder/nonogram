import 'package:flutter/material.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/context_ext.dart';

import '../../../painters/nonogram_clue_overflow_painter.dart';
import '../../../painters/nonogram_left_clues_painter.dart';
import '../../../painters/nonogram_top_clues_painter.dart';
import '../../bloc/nonogram_play_state.dart';
import '../../layout/clue_overflow.dart';
import '../../layout/nonogram_board_layout.dart';

/// Content of one clue strip: the row clues ([isLeft]) or the column clues,
/// scrolled by [scroll] to show clues cut off by the strip, with "+n" chips
/// on the lines that still have hidden clues.
class NonogramClueStrip extends StatelessWidget {
  const NonogramClueStrip({
    super.key,
    required this.isLeft,
    required this.state,
    required this.layout,
    required this.scroll,
    required this.textStyle,
    required this.satisfiedTextStyle,
    required this.chipTextStyle,
  });

  final bool isLeft;
  final NonogramPlayState state;
  final NonogramBoardLayout layout;
  final double scroll;
  final TextStyle textStyle;
  final TextStyle satisfiedTextStyle;
  final TextStyle chipTextStyle;

  @override
  Widget build(BuildContext context) {
    final puzzle = state.puzzle!;
    final game = context.gameColors;
    final colors = context.color;
    final cell = layout.cellSize;
    final clues = isLeft ? puzzle.leftClues : puzzle.topClues;
    final depth = isLeft ? layout.leftClueDepth : layout.topClueDepth;
    // Strip thickness, and the full thickness of its clues.
    final extent = isLeft ? layout.leftStripWidth : layout.topStripHeight;
    final content = isLeft ? layout.leftStripContent : layout.topStripContent;
    final shift = extent - content + scroll;

    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        Positioned(
          left: isLeft ? shift : 0,
          top: isLeft ? 0 : shift,
          width: isLeft ? content : layout.gridWidth,
          height: isLeft ? layout.gridHeight : content,
          child: CustomPaint(
            painter: isLeft
                ? NonogramLeftCluesPainter(
                    clues: clues,
                    satisfiedRows: state.satisfiedRows,
                    cellSize: cell,
                    clueDepth: depth,
                    lineColor: colors.surface,
                    majorLineColor: colors.outline,
                    backgroundColor: game.clueBackground,
                    bandColor: game.clueBand,
                    textStyle: textStyle,
                    satisfiedTextStyle: satisfiedTextStyle,
                  )
                : NonogramTopCluesPainter(
                    clues: clues,
                    satisfiedColumns: state.satisfiedCols,
                    cellSize: cell,
                    clueDepth: depth,
                    lineColor: colors.surface,
                    majorLineColor: colors.outline,
                    backgroundColor: game.clueBackground,
                    bandColor: game.clueBand,
                    textStyle: textStyle,
                    satisfiedTextStyle: satisfiedTextStyle,
                  ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              key: ValueKey(
                isLeft ? 'left-clue-overflow' : 'top-clue-overflow',
              ),
              painter: NonogramClueOverflowPainter(
                // Lines with hidden clues (far or near side): "+n" chip.
                overflows: [
                  for (final line in clues)
                    ClueOverflow.of(
                      count: line.length,
                      depth: depth,
                      visibleExtent: extent,
                      scroll: scroll,
                    ),
                ],
                axis: isLeft ? Axis.horizontal : Axis.vertical,
                cellSize: cell,
                clueDepth: depth,
                chipColor: game.reward,
                textStyle: chipTextStyle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

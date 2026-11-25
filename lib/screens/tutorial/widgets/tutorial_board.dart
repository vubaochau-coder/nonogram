import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../nonogram_tutorial_controller.dart';
import 'tutorial_clue_tile.dart';
import 'tutorial_grid.dart';

/// Tính cỡ ô theo chỗ trống và giữ bàn đứng yên khi các hàng hiện dần.
class TutorialBoardArea extends StatelessWidget {
  const TutorialBoardArea({
    super.key,
    required this.controller,
    required this.constraints,
  });

  final NonogramTutorialController controller;
  final BoxConstraints constraints;

  /// Bề rộng / cao vùng số gợi ý, tính theo số ô.
  static const double clueExtent = 1.4;
  static const double clueGap = 4;

  @override
  Widget build(BuildContext context) {
    final rows = controller.rows;
    final cols = controller.cols;
    final byWidth = (constraints.maxWidth - 32 - clueGap) / (cols + clueExtent);
    final byHeight = (constraints.maxHeight - clueGap) / (rows + clueExtent);
    final cellSize = math.min(64.0, math.min(byWidth, byHeight));
    if (cellSize <= 8) return const SizedBox.shrink();

    final clueSize = cellSize * clueExtent;
    final width = clueSize + clueGap + cellSize * cols;
    final height = clueSize + clueGap + cellSize * rows;

    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: width,
        height: height,
        child: Align(
          alignment: Alignment.topLeft,
          child: _TutorialBoard(
            controller: controller,
            cellSize: cellSize,
            clueSize: clueSize,
            clueGap: clueGap,
          ),
        ),
      ),
    );
  }
}

class _TutorialBoard extends StatelessWidget {
  const _TutorialBoard({
    required this.controller,
    required this.cellSize,
    required this.clueSize,
    required this.clueGap,
  });

  final NonogramTutorialController controller;
  final double cellSize;
  final double clueSize;
  final double clueGap;

  @override
  Widget build(BuildContext context) {
    final step = controller.step;
    // Bước theo cột (các ô cần làm trải trên nhiều hàng hơn số cột): sáng
    // dãy số của cột; còn lại sáng dãy số của hàng.
    final highlighted = controller.highlightedCells;
    final highlightRows = {for (final cell in highlighted) cell.row};
    final highlightCols = {for (final cell in highlighted) cell.col};
    final byColumn = highlightRows.length > highlightCols.length;
    final activeRows = byColumn ? const <int>{} : highlightRows;
    final activeCols = byColumn ? highlightCols : const <int>{};
    final wandLine = step.wandLine;
    final picking = step.task == TutorialTask.pickWandLine;
    bool isWandTarget(bool isRow, int index) =>
        picking && wandLine == (isRow: isRow, index: index);
    VoidCallback? pick(bool isRow, int index) => picking
        ? () => controller.pickClueLine((isRow: isRow, index: index))
        : null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedOpacity(
          opacity: step.showColumnClues ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Padding(
            padding: EdgeInsets.only(left: clueSize + clueGap, bottom: clueGap),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var c = 0; c < controller.cols; c++)
                  TutorialClueTile(
                    width: cellSize,
                    height: clueSize,
                    clues: controller.colClues[c],
                    vertical: true,
                    complete: controller.isColComplete(c),
                    active: activeCols.contains(c) || isWandTarget(false, c),
                    pointed: isWandTarget(false, c),
                    onTap: pick(false, c),
                  ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var r = 0; r < step.visibleRows; r++)
                  TutorialClueTile(
                    width: clueSize,
                    height: cellSize,
                    clues: controller.rowClues[r],
                    vertical: false,
                    complete: controller.isRowComplete(r),
                    active: activeRows.contains(r) || isWandTarget(true, r),
                    pointed: isWandTarget(true, r),
                    onTap: pick(true, r),
                  ),
              ],
            ),
            SizedBox(width: clueGap),
            TutorialGrid(controller: controller, cellSize: cellSize),
          ],
        ),
      ],
    );
  }
}

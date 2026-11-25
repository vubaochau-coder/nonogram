import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nonogram/core/app_haptics.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/screens/painters/nonogram_cells_painter.dart';
import 'package:nonogram/screens/painters/nonogram_grid_painter.dart';

import '../nonogram_tutorial_controller.dart';
import 'tutorial_grid_painters.dart';
import 'tutorial_hand_hints.dart';
import 'tutorial_motion_hints.dart';

/// Lưới ô: chạm hoặc kéo qua các ô để tô / đánh X.
class TutorialGrid extends StatefulWidget {
  const TutorialGrid({
    super.key,
    required this.controller,
    required this.cellSize,
  });

  final NonogramTutorialController controller;
  final double cellSize;

  @override
  State<TutorialGrid> createState() => _TutorialGridState();
}

class _TutorialGridState extends State<TutorialGrid> {
  TutorialCell? _lastDragCell;

  TutorialCell? _cellAt(Offset position) {
    final controller = widget.controller;
    final row = (position.dy / widget.cellSize).floor();
    final col = (position.dx / widget.cellSize).floor();
    if (row < 0 || row >= controller.step.visibleRows) return null;
    if (col < 0 || col >= controller.cols) return null;
    return (row: row, col: col);
  }

  void _apply(TutorialCell? cell, {required bool countMiss}) {
    if (cell == null) return;
    final changed = widget.controller.tapCell(
      cell.row,
      cell.col,
      countMiss: countMiss,
    );
    if (changed) HapticFeedback.selectionClick();
  }

  void _onLongPress(Offset position) {
    final cell = _cellAt(position);
    if (cell == null) return;
    // Như màn chơi: rung ngay lúc nhấn giữ được nhận (kể cả khi bước này
    // không nhận nhấn giữ), để người chơi biết đã có thể nhấc tay.
    AppHaptics.longPress();
    widget.controller.longPressCell(cell.row, cell.col);
  }

  void _onDrag(Offset position) {
    final cell = _cellAt(position);
    if (cell == null || cell == _lastDragCell) return;
    final last = _lastDragCell;
    _lastDragCell = cell;
    if (last == null) {
      _apply(cell, countMiss: false);
      return;
    }
    // Lướt nhanh có thể nhảy qua vài ô giữa hai sự kiện: tô cả các ô đó.
    final dr = cell.row - last.row;
    final dc = cell.col - last.col;
    final steps = math.max(dr.abs(), dc.abs());
    for (var i = 1; i <= steps; i++) {
      _apply((
        row: last.row + (dr * i / steps).round(),
        col: last.col + (dc * i / steps).round(),
      ), countMiss: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final step = controller.step;
    final cellSize = widget.cellSize;
    final rows = step.visibleRows;
    final cols = controller.cols;
    final colors = context.color;
    final game = context.gameColors;

    final pending = controller.pendingTargets;
    // Bàn tay chỉ hiện khi bước vừa bắt đầu, để không che bàn khi đang tô.
    final pointAt =
        !step.freePlay &&
            step.ghostLine == null &&
            pending.isNotEmpty &&
            pending.length == step.targets.length
        ? pending.first
        : null;
    final handSize = cellSize * 0.9;
    // Bước tập kéo: bàn tay lướt dọc theo các ô cần tô.
    final swipe = step.message == TutorialMessage.dragRow && pointAt != null;

    return GestureDetector(
      key: const ValueKey('nonogram-tutorial-grid'),
      behavior: HitTestBehavior.opaque,
      onTapUp: (details) {
        _apply(_cellAt(details.localPosition), countMiss: true);
      },
      // Bắt đầu tính từ chỗ ngón tay chạm xuống, không phải chỗ đã trượt
      // qua ngưỡng nhận kéo (không bỏ sót ô đầu tiên).
      dragStartBehavior: DragStartBehavior.down,
      onPanStart: (details) {
        _lastDragCell = null;
        _onDrag(details.localPosition);
      },
      onPanUpdate: (details) => _onDrag(details.localPosition),
      onPanEnd: (_) => _lastDragCell = null,
      onLongPressStart: (details) => _onLongPress(details.localPosition),
      child: SizedBox(
        width: cellSize * cols,
        height: cellSize * rows,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: NonogramCellsPainter(
                  rows: rows,
                  cols: cols,
                  gridData: controller.grid.sublist(0, rows),
                  satisfiedRows: [
                    for (var r = 0; r < rows; r++) controller.isRowComplete(r),
                  ],
                  satisfiedCols: [
                    for (var c = 0; c < cols; c++)
                      step.showColumnClues && controller.isColComplete(c),
                  ],
                  cellSize: cellSize,
                  backgroundColor: colors.surfaceContainerLow,
                  filledColor: colors.onSurface,
                  markedMarkerColor: colors.primary,
                  markerColor: colors.onSurfaceVariant.withValues(alpha: 0.7),
                  lockedCells: controller.lockedCells,
                  lockedStarColor: game.lockedStar,
                  lockedMarkStarColor: game.lockedMarkStar,
                ),
                foregroundPainter: NonogramGridPainter(
                  rows: rows,
                  cols: cols,
                  cellSize: cellSize,
                  themeColor: colors.primary,
                  lineColor: colors.outlineVariant,
                  majorLineColor: colors.outline,
                ),
              ),
            ),
            if (step.ghostLine case final line? when controller.showGhost)
              Positioned.fill(
                child: IgnorePointer(
                  child: TutorialGhostBlink(
                    key: ValueKey(controller.stepIndex),
                    line: line,
                    placements: controller.ghostPlacements,
                    cellSize: cellSize,
                    color: colors.primary,
                  ),
                ),
              ),
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: TutorialHighlightPainter(
                    cells: {
                      for (final cell in controller.highlightedCells)
                        if (cell.row < rows) cell,
                    },
                    cellSize: cellSize,
                    color: game.reward,
                  ),
                ),
              ),
            ),
            if (controller.revealedCells.isNotEmpty)
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: TutorialHighlightPainter(
                      cells: controller.revealedCells,
                      cellSize: cellSize,
                      color: colors.primary,
                    ),
                  ),
                ),
              ),
            if (pointAt != null && swipe)
              Positioned.fill(
                child: IgnorePointer(
                  child: TutorialSwipeHint(
                    from: Offset(
                      (pending.first.col + 0.5) * cellSize -
                          handSize * tutorialFingertip.dx,
                      (pending.first.row + 0.5) * cellSize -
                          handSize * tutorialFingertip.dy,
                    ),
                    to: Offset(
                      (pending.last.col + 0.5) * cellSize -
                          handSize * tutorialFingertip.dx,
                      (pending.last.row + 0.5) * cellSize -
                          handSize * tutorialFingertip.dy,
                    ),
                    size: handSize,
                  ),
                ),
              )
            else if (pointAt != null)
              tutorialHandAt(
                center: Offset(
                  (pointAt.col + 0.5) * cellSize,
                  (pointAt.row + 0.5) * cellSize,
                ),
                size: handSize,
                child: step.task == TutorialTask.longPressMark
                    ? TutorialHoldHint(size: handSize)
                    : TutorialTapHint(size: handSize),
              ),
          ],
        ),
      ),
    );
  }
}

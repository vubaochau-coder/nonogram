import 'package:flutter/material.dart';
import 'package:nonogram/models/nonogram_cell_state.dart';

class NonogramCellsPainter extends CustomPainter {
  final int rows;
  final int cols;
  final List<List<NonogramCellState>> gridData;
  final List<bool> satisfiedRows;
  final List<bool> satisfiedCols;
  final double cellSize;
  final Color filledColor;
  final Color markedMarkerColor;
  final Color markerColor;

  NonogramCellsPainter({
    required this.rows,
    required this.cols,
    required this.gridData,
    required this.satisfiedRows,
    required this.satisfiedCols,
    required this.cellSize,
    required this.filledColor,
    required this.markedMarkerColor,
    required this.markerColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint =
        Paint()
          ..color = filledColor
          ..style = PaintingStyle.fill;
    final markerPaint =
        Paint()
          ..color = markerColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..strokeCap = StrokeCap.round;
    final markedMarkerPaint =
        Paint()
          ..color = markedMarkerColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..strokeCap = StrokeCap.round;
    final markedBackgroundPaint =
        Paint()
          ..color = markedMarkerColor.withValues(alpha: 0.14)
          ..style = PaintingStyle.fill;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final cellState = gridData[r][c];
        final rect = Rect.fromLTWH(
          c * cellSize,
          r * cellSize,
          cellSize,
          cellSize,
        );

        if (cellState == NonogramCellState.filled) {
          // Slightly deflate to avoid overlapping with grid lines
          canvas.drawRect(rect.deflate(0.5), fillPaint);
        } else if (cellState == NonogramCellState.marked) {
          canvas.drawRect(rect.deflate(0.5), markedBackgroundPaint);

          final inset = cellSize * 0.4;
          final left = c * cellSize + inset;
          final top = r * cellSize + inset;
          final right = (c + 1) * cellSize - inset;
          final bottom = (r + 1) * cellSize - inset;

          canvas.drawLine(
            Offset(left, top),
            Offset(right, bottom),
            markedMarkerPaint,
          );
          canvas.drawLine(
            Offset(right, top),
            Offset(left, bottom),
            markedMarkerPaint,
          );
        } else if (cellState == NonogramCellState.empty) {
          // Auto-marker (X) for satisfied lines, only on empty cells
          final isSatisfiedRow = r < satisfiedRows.length && satisfiedRows[r];
          final isSatisfiedCol = c < satisfiedCols.length && satisfiedCols[c];

          if (isSatisfiedRow || isSatisfiedCol) {
            final inset = cellSize * 0.4;
            final left = c * cellSize + inset;
            final top = r * cellSize + inset;
            final right = (c + 1) * cellSize - inset;
            final bottom = (r + 1) * cellSize - inset;

            canvas.drawLine(
              Offset(left, top),
              Offset(right, bottom),
              markerPaint,
            );
            canvas.drawLine(
              Offset(right, top),
              Offset(left, bottom),
              markerPaint,
            );
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant NonogramCellsPainter oldDelegate) {
    return oldDelegate.rows != rows ||
        oldDelegate.cols != cols ||
        oldDelegate.cellSize != cellSize ||
        oldDelegate.filledColor != filledColor ||
        oldDelegate.markedMarkerColor != markedMarkerColor ||
        oldDelegate.markerColor != markerColor ||
        oldDelegate.gridData != gridData ||
        oldDelegate.satisfiedRows != satisfiedRows ||
        oldDelegate.satisfiedCols != satisfiedCols;
  }
}

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
  final Color? backgroundColor;

  NonogramCellsPainter({
    this.backgroundColor,
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
    if (backgroundColor != null) {
      canvas.drawRect(Offset.zero & size, Paint()..color = backgroundColor!);
    }
    final fillPaint =
        Paint()
          ..color = filledColor
          ..style = PaintingStyle.fill;
    // Ô trống trên hàng/cột đã khớp: chấm tròn nhỏ (gọn hơn dấu X, và phân
    // biệt được với dấu X người chơi tự đánh).
    final markerPaint =
        Paint()
          ..color = markerColor
          ..style = PaintingStyle.fill;
    final dotRadius = (cellSize * 0.075).clamp(1.2, 3.2);
    final markedMarkerPaint =
        Paint()
          ..color = markedMarkerColor
          ..style = PaintingStyle.stroke
          // Dấu X người chơi tự đánh: nhỏ, nét mảnh vừa phải.
          ..strokeWidth = (cellSize * 0.06).clamp(1.2, 2.2)
          ..strokeCap = StrokeCap.round;
    final markedBackgroundPaint =
        Paint()
          ..color = markedMarkerColor.withValues(alpha: 0.07)
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
          // Thu nhỏ một chút và bo góc để ô tô tách khỏi đường lưới.
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              rect.deflate(cellSize >= 16 ? 1.5 : 0.5),
              Radius.circular(cellSize * 0.12),
            ),
            fillPaint,
          );
        } else if (cellState == NonogramCellState.marked) {
          canvas.drawRect(rect.deflate(0.5), markedBackgroundPaint);

          final inset = cellSize * 0.34;
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
          // Ô trống trên hàng/cột đã khớp gợi ý: vẽ chấm.
          final isSatisfiedRow = r < satisfiedRows.length && satisfiedRows[r];
          final isSatisfiedCol = c < satisfiedCols.length && satisfiedCols[c];

          if (isSatisfiedRow || isSatisfiedCol) {
            canvas.drawCircle(rect.center, dotRadius, markerPaint);
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
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.gridData != gridData ||
        oldDelegate.satisfiedRows != satisfiedRows ||
        oldDelegate.satisfiedCols != satisfiedCols;
  }
}

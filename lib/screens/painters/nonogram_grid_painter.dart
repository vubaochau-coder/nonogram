import 'package:flutter/material.dart';

class NonogramGridPainter extends CustomPainter {
  final int rows;
  final int cols;
  final double cellSize;
  final Color themeColor;
  final Color lineColor;

  NonogramGridPainter({
    required this.rows,
    required this.cols,
    required this.cellSize,
    required this.themeColor,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final standardGridPaint =
        Paint()
          ..color = lineColor.withValues(alpha: 0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5;
    final outerGridPaint =
        Paint()
          ..color = themeColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

    // Draw Grid Lines with hierarchy
    // Vertical lines
    for (int i = 0; i <= cols; i++) {
      final x = i * cellSize;
      Paint currentPaint;
      if (i == 0 || i == cols) {
        currentPaint = outerGridPaint;
      } else {
        currentPaint = standardGridPaint;
      }
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), currentPaint);
    }

    // Horizontal lines
    for (int i = 0; i <= rows; i++) {
      final y = i * cellSize;
      Paint currentPaint;
      if (i == 0 || i == rows) {
        currentPaint = outerGridPaint;
      } else {
        currentPaint = standardGridPaint;
      }
      canvas.drawLine(Offset(0, y), Offset(size.width, y), currentPaint);
    }
  }

  @override
  bool shouldRepaint(covariant NonogramGridPainter oldDelegate) {
    return oldDelegate.rows != rows ||
        oldDelegate.cols != cols ||
        oldDelegate.cellSize != cellSize ||
        oldDelegate.themeColor != themeColor ||
        oldDelegate.lineColor != lineColor;
  }
}

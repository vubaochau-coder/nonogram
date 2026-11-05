import 'package:flutter/material.dart';

class NonogramSolutionPainter extends CustomPainter {
  final List<List<int>> solution;
  final double cellSize;
  final Color filledColor;
  final Color gridLineColor;

  NonogramSolutionPainter({
    required this.solution,
    required this.cellSize,
    required this.filledColor,
    required this.gridLineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (solution.isEmpty) return;

    final rows = solution.length;
    final cols = solution[0].length;

    final cellPaint = Paint()..color = filledColor;
    final linePaint =
        Paint()
          ..color = gridLineColor
          ..strokeWidth = 1.0;

    // Draw filled cells (1 = filled)
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (solution[r][c] == 1) {
          canvas.drawRect(
            Rect.fromLTWH(c * cellSize, r * cellSize, cellSize, cellSize),
            cellPaint,
          );
        }
      }
    }

    // Draw grid lines
    for (int i = 0; i <= rows; i++) {
      canvas.drawLine(
        Offset(0, i * cellSize),
        Offset(size.width, i * cellSize),
        linePaint,
      );
    }
    for (int i = 0; i <= cols; i++) {
      canvas.drawLine(
        Offset(i * cellSize, 0),
        Offset(i * cellSize, size.height),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant NonogramSolutionPainter oldDelegate) {
    return oldDelegate.solution != solution || oldDelegate.cellSize != cellSize;
  }
}

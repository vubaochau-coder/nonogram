import 'package:flutter/material.dart';

class NonogramTopCluesPainter extends CustomPainter {
  final List<List<int>> clues;
  final List<bool> satisfiedColumns;
  final double cellSize;
  final Color lineColor;
  final Color backgroundColor;
  final TextStyle textStyle;
  final TextStyle satisfiedTextStyle;

  NonogramTopCluesPainter({
    required this.clues,
    required this.satisfiedColumns,
    required this.cellSize,
    required this.lineColor,
    required this.backgroundColor,
    required this.textStyle,
    required this.satisfiedTextStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final borderPaint =
        Paint()
          ..color = lineColor.withValues(alpha: 0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5;

    final bgPaint =
        Paint()
          ..color = backgroundColor
          ..style = PaintingStyle.fill;

    final cols = clues.length;
    final maxClues = (size.height / cellSize).round();

    // Fill background
    canvas.drawRect(Offset.zero & size, bgPaint);

    for (int c = 0; c < cols; c++) {
      final columnClues = clues[c];
      final x = c * cellSize;

      // Draw vertical lines
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), borderPaint);
      if (c == cols - 1) {
        canvas.drawLine(
          Offset(x + cellSize, 0),
          Offset(x + cellSize, size.height),
          borderPaint,
        );
      }

      // Draw horizontal lines for cells
      for (int r = 0; r <= maxClues; r++) {
        final y = r * cellSize;
        canvas.drawLine(Offset(x, y), Offset(x + cellSize, y), borderPaint);
      }

      // Draw numbers (pinned to bottom)
      for (int i = 0; i < columnClues.length; i++) {
        final clueValue = columnClues[columnClues.length - 1 - i];
        final clueStyle =
            c < satisfiedColumns.length && satisfiedColumns[c]
                ? satisfiedTextStyle
                : textStyle;
        final textPainter = TextPainter(
          text: TextSpan(text: '$clueValue', style: clueStyle),
          textDirection: TextDirection.ltr,
        )..layout();

        final targetY = size.height - (i + 1) * cellSize;
        final offset = Offset(
          x + (cellSize - textPainter.width) / 2,
          targetY + (cellSize - textPainter.height) / 2,
        );
        textPainter.paint(canvas, offset);
      }
    }
  }

  @override
  bool shouldRepaint(covariant NonogramTopCluesPainter oldDelegate) {
    return oldDelegate.clues != clues ||
        oldDelegate.satisfiedColumns != satisfiedColumns ||
        oldDelegate.cellSize != cellSize ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.textStyle != textStyle ||
        oldDelegate.satisfiedTextStyle != satisfiedTextStyle;
  }
}

import 'package:flutter/material.dart';

class NonogramLeftCluesPainter extends CustomPainter {
  final List<List<int>> clues;
  final List<bool> satisfiedRows;
  final double cellSize;
  final Color lineColor;
  final Color backgroundColor;
  final TextStyle textStyle;
  final TextStyle satisfiedTextStyle;

  NonogramLeftCluesPainter({
    required this.clues,
    required this.satisfiedRows,
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

    final rows = clues.length;
    final maxClues = (size.width / cellSize).round();

    // Fill background
    canvas.drawRect(Offset.zero & size, bgPaint);

    for (int r = 0; r < rows; r++) {
      final rowClues = clues[r];
      final y = r * cellSize;

      // Draw horizontal lines
      canvas.drawLine(Offset(0, y), Offset(size.width, y), borderPaint);
      if (r == rows - 1) {
        canvas.drawLine(
          Offset(0, y + cellSize),
          Offset(size.width, y + cellSize),
          borderPaint,
        );
      }

      // Draw vertical lines for cells
      for (int c = 0; c <= maxClues; c++) {
        final x = c * cellSize;
        canvas.drawLine(Offset(x, y), Offset(x, y + cellSize), borderPaint);
      }

      // Draw numbers (pinned to right)
      for (int i = 0; i < rowClues.length; i++) {
        final clueValue = rowClues[rowClues.length - 1 - i];
        final clueStyle =
            r < satisfiedRows.length && satisfiedRows[r]
                ? satisfiedTextStyle
                : textStyle;
        final textPainter = TextPainter(
          text: TextSpan(text: '$clueValue', style: clueStyle),
          textDirection: TextDirection.ltr,
        )..layout();

        final targetX = size.width - (i + 1) * cellSize;
        final offset = Offset(
          targetX + (cellSize - textPainter.width) / 2,
          y + (cellSize - textPainter.height) / 2,
        );
        textPainter.paint(canvas, offset);
      }
    }
  }

  @override
  bool shouldRepaint(covariant NonogramLeftCluesPainter oldDelegate) {
    return oldDelegate.clues != clues ||
        oldDelegate.satisfiedRows != satisfiedRows ||
        oldDelegate.cellSize != cellSize ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.textStyle != textStyle ||
        oldDelegate.satisfiedTextStyle != satisfiedTextStyle;
  }
}

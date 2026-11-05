import 'package:flutter/material.dart';

/// Gợi ý của các hàng, xếp sát phải. Hàng đã khớp gợi ý đổi sang
/// [satisfiedTextStyle]. Vạch ngăn hàng đậm mỗi 5 hàng, khớp với lưới.
class NonogramLeftCluesPainter extends CustomPainter {
  final List<List<int>> clues;
  final List<bool> satisfiedRows;
  final double cellSize;
  final Color lineColor;
  final Color backgroundColor;
  final TextStyle textStyle;
  final TextStyle satisfiedTextStyle;
  final Color? majorLineColor;

  /// Màu tô nhóm 5 cột/hàng thứ 2, 4, 6...; null thì không tô dải.
  final Color? bandColor;

  NonogramLeftCluesPainter({
    required this.clues,
    required this.satisfiedRows,
    required this.cellSize,
    required this.lineColor,
    required this.backgroundColor,
    required this.textStyle,
    required this.satisfiedTextStyle,
    this.majorLineColor,
    this.bandColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rows = clues.length;
    final minor =
        Paint()
          ..color = lineColor
          ..strokeWidth = 1;
    final major =
        Paint()
          ..color = majorLineColor ?? lineColor
          ..strokeWidth = 1.6;

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Offset.zero & size,
        topLeft: const Radius.circular(10),
        bottomLeft: const Radius.circular(10),
      ),
      Paint()..color = backgroundColor,
    );

    if (bandColor != null) {
      final band = Paint()..color = bandColor!;
      for (var start = 5; start < rows; start += 10) {
        final end = (start + 5).clamp(0, rows);
        canvas.drawRect(
          Rect.fromLTRB(0, start * cellSize, size.width, end * cellSize),
          band,
        );
      }
    }

    for (var r = 1; r < rows; r++) {
      final y = r * cellSize;
      canvas.drawLine(
        Offset(4, y),
        Offset(size.width, y),
        r % 5 == 0 ? major : minor,
      );
    }

    for (var r = 0; r < rows; r++) {
      final rowClues = clues[r];
      final satisfied = r < satisfiedRows.length && satisfiedRows[r];
      final style = satisfied ? satisfiedTextStyle : textStyle;
      final y = r * cellSize;

      for (var i = 0; i < rowClues.length; i++) {
        final value = rowClues[rowClues.length - 1 - i];
        final tp = TextPainter(
          text: TextSpan(text: '$value', style: style),
          textDirection: TextDirection.ltr,
        )..layout();
        final x = size.width - (i + 1) * cellSize;
        tp.paint(
          canvas,
          Offset(x + (cellSize - tp.width) / 2, y + (cellSize - tp.height) / 2),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant NonogramLeftCluesPainter oldDelegate) {
    return oldDelegate.clues != clues ||
        oldDelegate.satisfiedRows != satisfiedRows ||
        oldDelegate.cellSize != cellSize ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.majorLineColor != majorLineColor ||
        oldDelegate.bandColor != bandColor ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.textStyle != textStyle ||
        oldDelegate.satisfiedTextStyle != satisfiedTextStyle;
  }
}

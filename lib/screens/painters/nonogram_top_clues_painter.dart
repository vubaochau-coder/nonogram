import 'package:flutter/material.dart';

/// Gợi ý của các cột, xếp sát đáy. Cột đã khớp gợi ý đổi sang
/// [satisfiedTextStyle]. Vạch ngăn cột đậm mỗi 5 cột, khớp với lưới.
class NonogramTopCluesPainter extends CustomPainter {
  final List<List<int>> clues;
  final List<bool> satisfiedColumns;
  final double cellSize;
  final Color lineColor;
  final Color backgroundColor;
  final TextStyle textStyle;
  final TextStyle satisfiedTextStyle;
  final Color? majorLineColor;

  /// Màu tô nhóm 5 cột/hàng thứ 2, 4, 6...; null thì không tô dải.
  final Color? bandColor;

  /// Độ dày mỗi ô số theo chiều vuông góc với lưới; mặc định bằng
  /// [cellSize] (ô số vuông).
  final double? clueDepth;

  NonogramTopCluesPainter({
    required this.clues,
    required this.satisfiedColumns,
    required this.cellSize,
    required this.lineColor,
    required this.backgroundColor,
    required this.textStyle,
    required this.satisfiedTextStyle,
    this.majorLineColor,
    this.bandColor,
    this.clueDepth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cols = clues.length;
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
        topRight: const Radius.circular(10),
      ),
      Paint()..color = backgroundColor,
    );

    if (bandColor != null) {
      final band = Paint()..color = bandColor!;
      for (var start = 5; start < cols; start += 10) {
        final end = (start + 5).clamp(0, cols);
        canvas.drawRect(
          Rect.fromLTRB(start * cellSize, 0, end * cellSize, size.height),
          band,
        );
      }
    }

    for (var c = 1; c < cols; c++) {
      final x = c * cellSize;
      canvas.drawLine(
        Offset(x, 4),
        Offset(x, size.height),
        c % 5 == 0 ? major : minor,
      );
    }

    for (var c = 0; c < cols; c++) {
      final columnClues = clues[c];
      final satisfied = c < satisfiedColumns.length && satisfiedColumns[c];
      final style = satisfied ? satisfiedTextStyle : textStyle;
      final x = c * cellSize;

      for (var i = 0; i < columnClues.length; i++) {
        final value = columnClues[columnClues.length - 1 - i];
        final tp = TextPainter(
          text: TextSpan(text: '$value', style: style),
          textDirection: TextDirection.ltr,
        )..layout();
        final depth = clueDepth ?? cellSize;
        final y = size.height - (i + 1) * depth;
        tp.paint(
          canvas,
          Offset(x + (cellSize - tp.width) / 2, y + (depth - tp.height) / 2),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant NonogramTopCluesPainter oldDelegate) {
    return oldDelegate.clues != clues ||
        oldDelegate.satisfiedColumns != satisfiedColumns ||
        oldDelegate.cellSize != cellSize ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.majorLineColor != majorLineColor ||
        oldDelegate.bandColor != bandColor ||
        oldDelegate.clueDepth != clueDepth ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.textStyle != textStyle ||
        oldDelegate.satisfiedTextStyle != satisfiedTextStyle;
  }
}

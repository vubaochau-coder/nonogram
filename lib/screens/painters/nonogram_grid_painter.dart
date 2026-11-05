import 'package:flutter/material.dart';

/// Đường lưới của bàn chơi: đường mảnh giữa các ô, đường đậm mỗi 5 ô (giúp
/// đếm trên màn lớn) và viền ngoài màu chủ đạo.
class NonogramGridPainter extends CustomPainter {
  final int rows;
  final int cols;
  final double cellSize;
  final Color themeColor;
  final Color lineColor;
  final Color majorLineColor;

  NonogramGridPainter({
    required this.rows,
    required this.cols,
    required this.cellSize,
    required this.themeColor,
    required this.lineColor,
    Color? majorLineColor,
  }) : majorLineColor = majorLineColor ?? lineColor;

  static const int majorEvery = 5;

  @override
  void paint(Canvas canvas, Size size) {
    final minor =
        Paint()
          ..color = lineColor
          ..strokeWidth = 1;
    final major =
        Paint()
          ..color = majorLineColor
          ..strokeWidth = 1.6;

    for (var i = 1; i < cols; i++) {
      final x = i * cellSize;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        i % majorEvery == 0 ? major : minor,
      );
    }
    for (var i = 1; i < rows; i++) {
      final y = i * cellSize;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        i % majorEvery == 0 ? major : minor,
      );
    }

    final outer =
        Paint()
          ..color = themeColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
    canvas.drawRect(Offset.zero & size, outer);
  }

  @override
  bool shouldRepaint(covariant NonogramGridPainter oldDelegate) {
    return oldDelegate.rows != rows ||
        oldDelegate.cols != cols ||
        oldDelegate.cellSize != cellSize ||
        oldDelegate.themeColor != themeColor ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.majorLineColor != majorLineColor;
  }
}

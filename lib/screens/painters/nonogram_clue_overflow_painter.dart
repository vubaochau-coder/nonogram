import 'package:flutter/material.dart';

import '../play/engine/clue_overflow.dart';

/// Vẽ chip "+n" ở mép dải gợi ý cho các hàng / cột còn số bị khuất (xem
/// [ClueOverflow]). Dải trái: hàng xếp theo chiều dọc, phía xa ở bên trái.
/// Dải trên: cột xếp theo chiều ngang, phía xa ở bên trên.
class NonogramClueOverflowPainter extends CustomPainter {
  NonogramClueOverflowPainter({
    required this.overflows,
    required this.axis,
    required this.cellSize,
    required this.clueDepth,
    required this.chipColor,
    required this.textStyle,
  });

  final List<ClueOverflow> overflows;

  /// [Axis.horizontal]: dải trái (số chạy ngang). [Axis.vertical]: dải trên.
  final Axis axis;
  final double cellSize;
  final double clueDepth;
  final Color chipColor;
  final TextStyle textStyle;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = chipColor;
    final horizontal = axis == Axis.horizontal;
    final extent = horizontal ? size.width : size.height;

    void chip(int line, bool far, int count) {
      final along = far ? 0.0 : extent - clueDepth;
      final across = line * cellSize;
      final rect =
          horizontal
              ? Rect.fromLTWH(along, across, clueDepth, cellSize)
              : Rect.fromLTWH(across, along, cellSize, clueDepth);
      final box = rect.deflate(1.5);
      canvas.drawRRect(
        RRect.fromRectAndRadius(box, const Radius.circular(4)),
        paint,
      );

      final tp = TextPainter(
        text: TextSpan(text: '+$count', style: textStyle),
        textDirection: TextDirection.ltr,
        maxLines: 1,
      )..layout();
      // Thu nhỏ chữ nếu không vừa chip (vd. "+12" trong ô số hẹp).
      final scale = [
        1.0,
        (box.width - 2) / tp.width,
        (box.height - 2) / tp.height,
      ].reduce((a, b) => a < b ? a : b);
      canvas.save();
      canvas.translate(box.center.dx, box.center.dy);
      canvas.scale(scale);
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
      canvas.restore();
    }

    for (var i = 0; i < overflows.length; i++) {
      final o = overflows[i];
      if (o.far > 0) chip(i, true, o.far);
      if (o.near > 0) chip(i, false, o.near);
    }
  }

  @override
  bool shouldRepaint(covariant NonogramClueOverflowPainter old) =>
      old.overflows != overflows ||
      old.axis != axis ||
      old.cellSize != cellSize ||
      old.clueDepth != clueDepth ||
      old.chipColor != chipColor ||
      old.textStyle != textStyle;
}

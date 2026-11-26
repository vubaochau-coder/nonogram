import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Icon of the rotate button: a portrait phone (top left) and a landscape
/// phone (bottom right) always in the same place, with two concentric
/// motion arcs in the top right corner. The orientation in use is drawn
/// faint, the one the button switches to is drawn bold, so the icon keeps
/// its shape and only swaps emphasis when the screen turns.
class RotateScreenIcon extends StatelessWidget {
  const RotateScreenIcon({
    super.key,
    required this.landscape,
    required this.color,
    this.size = 20,
  });

  /// The screen is in landscape now (the button switches to portrait).
  final bool landscape;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: RotateScreenIconPainter(landscape: landscape, color: color),
    );
  }
}

/// Paints [RotateScreenIcon] on a 24-unit grid scaled to the canvas.
class RotateScreenIconPainter extends CustomPainter {
  RotateScreenIconPainter({required this.landscape, required this.color});

  final bool landscape;
  final Color color;

  /// The orientation in use.
  static const fadedAlpha = 0.32;

  /// The outer motion arc.
  static const trailAlpha = 0.45;

  static final _portrait = RRect.fromRectAndRadius(
    const Rect.fromLTWH(2.5, 2, 8, 13),
    const Radius.circular(1.6),
  );
  static final _landscape = RRect.fromRectAndRadius(
    const Rect.fromLTWH(8, 12, 13.5, 8.5),
    const Radius.circular(1.6),
  );
  static const _arcCenter = Offset(12.5, 10.5);
  static const _arcStart = -80 * math.pi / 180;
  static const _arcSweep = 70 * math.pi / 180;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 24, size.height / 24);
    Paint stroke(double width, double alpha) => Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = color.withValues(alpha: color.a * alpha);

    final faded = landscape ? _landscape : _portrait;
    final bold = landscape ? _portrait : _landscape;
    canvas.drawRRect(faded, stroke(1.6, fadedAlpha));
    for (final (radius, width, alpha) in [
      (5.5, 2.0, 1.0),
      (8.5, 1.6, trailAlpha),
    ]) {
      canvas.drawArc(
        Rect.fromCircle(center: _arcCenter, radius: radius),
        _arcStart,
        _arcSweep,
        false,
        stroke(width, alpha),
      );
    }
    canvas.drawRRect(bold, stroke(2, 1));
    canvas.restore();
  }

  @override
  bool shouldRepaint(RotateScreenIconPainter old) =>
      old.landscape != landscape || old.color != color;
}

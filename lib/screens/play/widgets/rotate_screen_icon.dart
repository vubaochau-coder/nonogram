import 'package:flutter/material.dart';

/// Icon of the rotate button: a portrait and a landscape phone sharing their
/// bottom left corner, and one curved arrow in the free top right corner.
/// The orientation in use is drawn faint (cut away around the other phone so
/// the outlines never cross), the one the button switches to is drawn bold,
/// and the arrow turns from the faint phone towards the bold one.
///
/// Kept to two ideas in 24 units so the arrow stays long enough to read
/// (about 5 stroke widths) at button size.
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

  static const _frameStroke = 1.8;
  static const _arrowStroke = 1.45;

  /// Gap cut around the bold phone in the faint one.
  static const _cutout = 1.8;

  static final _portrait = RRect.fromRectAndRadius(
    const Rect.fromLTWH(3.25, 5.75, 8.5, 15),
    const Radius.circular(2),
  );
  static final _landscape = RRect.fromRectAndRadius(
    const Rect.fromLTWH(3.25, 12.25, 15, 8.5),
    const Radius.circular(2),
  );

  /// Arrow body (from, to; clockwise) and head for portrait now (turning
  /// right, to landscape) and landscape now (turning back, to portrait).
  static const _toLandscape = (
    from: Offset(14.27, 5.19),
    to: Offset(18.24, 8.07),
    clockwise: true,
    head: [Offset(19.19, 9.94), Offset(16.63, 8.55), Offset(19.57, 7.05)],
  );
  static const _toPortrait = (
    from: Offset(18.81, 9.73),
    to: Offset(15.93, 5.76),
    clockwise: false,
    head: [Offset(14.06, 4.81), Offset(15.45, 7.37), Offset(16.95, 4.43)],
  );

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 24, size.height / 24);
    final faded = landscape ? _landscape : _portrait;
    final bold = landscape ? _portrait : _landscape;
    final ink = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Faint phone, with the bold phone and a gap around it cut away.
    canvas.saveLayer(const Rect.fromLTWH(0, 0, 24, 24), Paint());
    canvas.drawRRect(
      faded,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = _frameStroke
        ..color = color.withValues(alpha: color.a * fadedAlpha),
    );
    canvas.drawRRect(
      bold.inflate(_cutout),
      Paint()..blendMode = BlendMode.clear,
    );
    canvas.restore();

    canvas.drawRRect(
      bold,
      Paint.from(ink)
        ..style = PaintingStyle.stroke
        ..strokeWidth = _frameStroke,
    );

    final arrow = landscape ? _toPortrait : _toLandscape;
    canvas.drawPath(
      Path()
        ..moveTo(arrow.from.dx, arrow.from.dy)
        ..arcToPoint(
          arrow.to,
          radius: const Radius.circular(5.6),
          clockwise: arrow.clockwise,
        ),
      Paint.from(ink)
        ..style = PaintingStyle.stroke
        ..strokeWidth = _arrowStroke,
    );
    final head = Path()..addPolygon(arrow.head, true);
    canvas
      ..drawPath(head, Paint.from(ink)..style = PaintingStyle.fill)
      ..drawPath(
        head,
        Paint.from(ink)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.4,
      );
    canvas.restore();
  }

  @override
  bool shouldRepaint(RotateScreenIconPainter old) =>
      old.landscape != landscape || old.color != color;
}

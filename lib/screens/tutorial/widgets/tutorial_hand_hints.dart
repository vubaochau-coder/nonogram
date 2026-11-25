import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:nonogram/core/context_ext.dart';

/// Tâm đầu ngón tay trong icon [Icons.touch_app] (lưới 24), theo tỉ lệ cạnh
/// icon. Cũng là tâm các cung tròn vẽ sẵn quanh ngón tay của icon.
const tutorialFingertip = Offset(11.5 / 24, 7.5 / 24);

/// Đặt bàn tay cỡ [size] sao cho đầu ngón tay (lúc nhấn xuống) nằm đúng
/// [center].
Positioned tutorialHandAt({
  required Offset center,
  required double size,
  required Widget child,
}) => Positioned(
  left: center.dx - tutorialFingertip.dx * size,
  top: center.dy - tutorialFingertip.dy * size,
  width: size,
  height: size,
  child: IgnorePointer(child: child),
);

/// Bàn tay nhấp nhô: nhấc lên rồi nhấn xuống đúng đầu ngón tay; mỗi lần
/// nhấn, hai vòng sóng lan ra từ đầu ngón tay rồi mờ dần.
class TutorialTapHint extends StatefulWidget {
  const TutorialTapHint({super.key, required this.size});

  final double size;

  @override
  State<TutorialTapHint> createState() => _TapHintState();
}

class _TapHintState extends State<TutorialTapHint>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animation = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      // Giảm chuyển động: bàn tay đứng yên ở tư thế nhấn, không có sóng.
      _animation
        ..stop()
        ..value = 0.5;
    } else if (!_animation.isAnimating) {
      _animation.repeat();
    }
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final size = widget.size;
    final still = MediaQuery.disableAnimationsOf(context);
    return SizedBox.square(
      dimension: size,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final v = _animation.value;
          // 0–30%: nhấn xuống; 30–80%: giữ nguyên (sóng lan từ đầu ngón tay
          // đứng yên, nên tâm sóng luôn trùng đầu ngón tay); 80–100%: nhấc.
          final double press;
          if (v < _TapRipplePainter.pressAt) {
            press = Curves.easeInOut.transform(v / _TapRipplePainter.pressAt);
          } else if (v < 0.8) {
            press = 1;
          } else {
            press = Curves.easeInOut.transform((1 - v) / 0.2);
          }
          return Stack(
            clipBehavior: Clip.none,
            children: [
              if (!still)
                Positioned.fill(
                  child: CustomPaint(
                    painter: _TapRipplePainter(
                      progress: v,
                      center: Offset(
                        tutorialFingertip.dx * size,
                        tutorialFingertip.dy * size,
                      ),
                      maxRadius: size * 0.6,
                      strokeWidth: math.max(2, size * 0.045),
                      color: colors.primary,
                    ),
                  ),
                ),
              Transform.translate(
                offset: Offset(0, -size * 0.14 * (1 - press)),
                child: child,
              ),
            ],
          );
        },
        child: Icon(
          Icons.touch_app,
          size: size,
          color: colors.onSurface,
          shadows: [
            Shadow(color: colors.surface, blurRadius: 6),
            Shadow(color: colors.surface, blurRadius: 2),
          ],
        ),
      ),
    );
  }
}

/// Hai vòng sóng (chỉ viền) lan ra từ [center] ngay lúc ngón tay nhấn xuống
/// ([pressAt]), vòng thứ hai trễ hơn một chút; cả hai tắt trước khi bàn tay
/// nhấc lên.
class _TapRipplePainter extends CustomPainter {
  _TapRipplePainter({
    required this.progress,
    required this.center,
    required this.maxRadius,
    required this.strokeWidth,
    required this.color,
  });

  final double progress;
  final Offset center;
  final double maxRadius;
  final double strokeWidth;
  final Color color;

  /// Lúc đầu ngón tay chạm (tỉ lệ chu kỳ).
  static const pressAt = 0.3;

  /// Độ trễ của từng vòng và thời gian sống của mỗi vòng (tỉ lệ chu kỳ).
  static const _delays = [0.0, 0.12];
  static const _life = 0.38;

  @override
  void paint(Canvas canvas, Size size) {
    for (final delay in _delays) {
      final local = progress - pressAt - delay;
      if (local < 0 || local >= _life) continue;
      final t = local / _life;
      final radius = maxRadius * (0.15 + 0.85 * Curves.easeOut.transform(t));
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..color = color.withValues(alpha: 0.85 * (1 - t)),
      );
    }
  }

  @override
  bool shouldRepaint(_TapRipplePainter old) =>
      old.progress != progress ||
      old.center != center ||
      old.maxRadius != maxRadius ||
      old.strokeWidth != strokeWidth ||
      old.color != color;
}

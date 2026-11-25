import 'package:flutter/material.dart';
import 'package:nonogram/core/context_ext.dart';

import 'tutorial_hand_hints.dart';

/// Bàn tay lướt từ [from] tới [to] (vị trí góc trên-trái của icon), lặp lại.
class TutorialSwipeHint extends StatefulWidget {
  const TutorialSwipeHint({
    super.key,
    required this.from,
    required this.to,
    required this.size,
  });

  final Offset from;
  final Offset to;
  final double size;

  @override
  State<TutorialSwipeHint> createState() => _SwipeHintState();
}

class _SwipeHintState extends State<TutorialSwipeHint>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animation = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat();

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        // 0–15%: hiện ra, 15–80%: lướt, 80–100%: mờ đi.
        final v = _animation.value;
        final move = Curves.easeInOut.transform(
          ((v - 0.15) / 0.65).clamp(0.0, 1.0),
        );
        final opacity = v < 0.15 ? v / 0.15 : (v > 0.8 ? (1 - v) / 0.2 : 1.0);
        final p = Offset.lerp(widget.from, widget.to, move)!;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: p.dx,
              top: p.dy,
              child: Opacity(
                opacity: opacity.clamp(0.0, 1.0),
                child: Icon(
                  Icons.touch_app,
                  size: widget.size,
                  color: colors.onSurface,
                  shadows: [
                    Shadow(color: colors.surface, blurRadius: 6),
                    Shadow(color: colors.surface, blurRadius: 2),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Bàn tay nhấn xuống và giữ, kèm vòng tròn chạy quanh đầu ngón tay cho tới
/// lúc "rung".
class TutorialHoldHint extends StatefulWidget {
  const TutorialHoldHint({super.key, required this.size});

  final double size;

  @override
  State<TutorialHoldHint> createState() => _HoldHintState();
}

class _HoldHintState extends State<TutorialHoldHint>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animation = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..repeat();

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final size = widget.size;
    final ring = size * 0.62;
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final v = _animation.value;
        // 0–20%: ấn xuống, 20–70%: giữ (vòng chạy), 70–100%: nhả.
        final press = v < 0.2 ? v / 0.2 : (v > 0.7 ? (1 - v) / 0.3 : 1.0);
        final progress = ((v - 0.2) / 0.5).clamp(0.0, 1.0);
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              if (v >= 0.2 && v <= 0.85)
                Positioned(
                  left: size * tutorialFingertip.dx - ring / 2,
                  top: size * tutorialFingertip.dy - ring / 2,
                  width: ring,
                  height: ring,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 3,
                    color: colors.primary,
                    backgroundColor: colors.primary.withValues(alpha: 0.2),
                  ),
                ),
              Transform.translate(
                offset: Offset(0, -size * 0.12 * (1 - press)),
                child: child,
              ),
            ],
          ),
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
    );
  }
}

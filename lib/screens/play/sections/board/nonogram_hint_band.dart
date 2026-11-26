import 'package:flutter/material.dart';
import 'package:nonogram/core/context_ext.dart';

/// Pulsing highlight of a hinted line or cell; fades out with [pulse].
class NonogramHintBand extends StatelessWidget {
  const NonogramHintBand({
    super.key,
    required this.rect,
    required this.pulse,
    this.strong = false,
  });

  final Rect rect;
  final Animation<double> pulse;

  /// Ô đơn lẻ: thêm viền để dễ thấy trên ô đã tô màu đậm.
  final bool strong;

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: rect,
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: pulse,
          builder: (context, _) {
            final opacity = (1 - pulse.value).clamp(0.0, 1.0);
            final primary = context.color.primary;
            return DecoratedBox(
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.28 * opacity),
                borderRadius: BorderRadius.circular(4),
                border: strong
                    ? Border.all(
                        color: primary.withValues(alpha: opacity),
                        width: 2.5,
                      )
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }
}

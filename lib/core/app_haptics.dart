import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

abstract final class AppHaptics {
  /// Rung lúc nhấn giữ được nhận, để người chơi biết đã có thể nhấc tay.
  ///
  /// `selectionClick` (CLOCK_TICK trên Android) không rung trên nhiều máy,
  /// nên Android dùng hiệu ứng nhấn giữ chuẩn của hệ thống, iOS dùng một
  /// nhịp va chạm vừa.
  static void longPress() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      HapticFeedback.vibrate();
    } else {
      HapticFeedback.mediumImpact();
    }
  }
}

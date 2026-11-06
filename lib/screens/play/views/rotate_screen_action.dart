import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../engine/nonogram_board_layout.dart';
import '../widgets/overlay_button.dart';

/// Xoay màn hình sang hướng còn lại (dọc ⇄ ngang) và khoá ở hướng đó, không
/// phụ thuộc cảm biến xoay của máy. Rời trang chơi thì trả lại như cũ.
///
/// Icon là chiếc điện thoại vẽ theo hướng sẽ xoay tới.
class RotateScreenAction extends StatelessWidget {
  const RotateScreenAction({super.key});

  /// Chỉ có ý nghĩa trên điện thoại / máy tính bảng.
  static bool get isSupported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  @override
  Widget build(BuildContext context) {
    final landscape = NonogramBoardLayout.isLandscapeViewport(
      MediaQuery.sizeOf(context),
    );
    return OverlayButton(
      key: const ValueKey('nonogram-rotate-screen'),
      icon: LucideIcons.smartphone,
      iconQuarterTurns: landscape ? 0 : 1,
      onPressed: () {
        SystemChrome.setPreferredOrientations(
          landscape
              ? const [DeviceOrientation.portraitUp]
              : const [
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight,
              ],
        );
      },
    );
  }
}

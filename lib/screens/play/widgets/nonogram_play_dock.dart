import 'package:flutter/material.dart';

import '../clock/clock_paused_lock.dart';
import '../views/mode_toggle_action.dart';
import '../views/undo_action.dart';

/// Portrait play screen: undo and the Fill / X toggle side by side, centred
/// at the bottom within reach of either thumb. The board keeps
/// `NonogramBoardLayout.dockReserve` free above the bottom edge for it.
class NonogramPlayDock extends StatelessWidget {
  const NonogramPlayDock({
    super.key,
    required this.undoKey,
    required this.modeKey,
  });

  /// Keys the play coach uses to point at the buttons.
  final GlobalKey undoKey;
  final GlobalKey modeKey;

  /// Height of the dock (the horizontal toggle), for insets above it.
  static const double height = 42;

  /// Gap between the dock and the bottom edge.
  static const double margin = 16;

  /// Bottom inset of the banner shown just above the dock (wand, drag tip).
  static const double bannerInset = margin + height + 10;

  @override
  Widget build(BuildContext context) {
    return ClockPausedLock(child: _row());
  }

  Widget _row() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        KeyedSubtree(key: undoKey, child: const UndoAction()),
        const SizedBox(width: 12),
        KeyedSubtree(key: modeKey, child: const ModeToggleAction()),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../views/mode_toggle_action.dart';
import '../views/undo_action.dart';

/// Portrait play screen: undo and the Fill / X toggle stacked in the bottom
/// right corner, within reach of the thumb. The board keeps
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

  /// Width of the dock (the vertical toggle), for insets beside it.
  static const double width = 42;

  /// Gap between the dock and the screen edges.
  static const double margin = 16;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        KeyedSubtree(key: undoKey, child: const UndoAction()),
        const SizedBox(height: 12),
        KeyedSubtree(
          key: modeKey,
          child: const ModeToggleAction(vertical: true),
        ),
      ],
    );
  }
}

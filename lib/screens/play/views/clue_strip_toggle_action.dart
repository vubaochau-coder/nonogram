import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/context_ext.dart';

import '../nonogram_board_ui_controller.dart';
import '../widgets/overlay_button.dart';

/// Thu gọn / mở rộng hai dải gợi ý.
class ClueStripToggleAction extends StatelessWidget {
  const ClueStripToggleAction({super.key});

  @override
  Widget build(BuildContext context) {
    final ui = NonogramBoardUiScope.of(context);
    return OverlayButton(
      icon:
          ui.compactClues
              ? LucideIcons.panelLeftOpen
              : LucideIcons.panelLeftClose,
      color: ui.compactClues ? context.color.primary : null,
      onPressed: ui.toggleCompactClues,
    );
  }
}

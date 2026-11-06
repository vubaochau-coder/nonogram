import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/context_ext.dart';

import '../nonogram_board_ui_controller.dart';

/// Nút tròn ở góc dưới, trong tầm ngón cái: giữ nút thì một ngón khác trên
/// bàn sẽ kéo bàn thay vì tô; thả ra là quay lại tô.
class HoldToPanButton extends StatefulWidget {
  const HoldToPanButton({super.key});

  static const double size = 52;

  @override
  State<HoldToPanButton> createState() => _HoldToPanButtonState();
}

class _HoldToPanButtonState extends State<HoldToPanButton> {
  NonogramBoardUiController? _ui;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ui = NonogramBoardUiScope.read(context);
  }

  @override
  void dispose() {
    // Nút bị gỡ khi đang giữ (vd. đổi sang chế độ bàn tay): sẽ không nhận
    // được sự kiện nhấc ngón, nên tự nhả ở khung hình sau.
    final ui = _ui;
    if (ui != null && ui.panHeld) {
      WidgetsBinding.instance.addPostFrameCallback((_) => ui.panHeld = false);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const size = HoldToPanButton.size;
    final ui = NonogramBoardUiScope.of(context);
    final held = ui.panHeld;
    final colors = context.color;

    void release() => ui.panHeld = false;

    return Listener(
      key: const ValueKey('nonogram-hold-to-pan'),
      behavior: HitTestBehavior.opaque,
      onPointerDown: (_) {
        ui.panHeld = true;
        HapticFeedback.selectionClick();
      },
      onPointerUp: (_) => release(),
      onPointerCancel: (_) => release(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              held
                  ? colors.primary
                  : colors.surfaceContainerHighest.withValues(alpha: 0.88),
          border: Border.all(
            color:
                held
                    ? colors.primary
                    : context.gameColors.cardBorder.withValues(alpha: 0.9),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          held ? LucideIcons.grab : LucideIcons.hand,
          size: 22,
          color: held ? colors.onPrimary : colors.onSurfaceVariant,
        ),
      ),
    );
  }
}

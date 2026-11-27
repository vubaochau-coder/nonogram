import 'package:flutter/material.dart';

import '../clock/clock_paused_lock.dart';
import '../views/clock_action.dart';
import '../views/fullscreen_toggle_action.dart';
import '../views/hint_action.dart';
import '../views/rotate_screen_action.dart';
import '../views/wand_action.dart';

/// Portrait top row: the clock on the left; hint, wand, rotate and
/// fullscreen on the right.
///
/// Never overflows, however narrow the phone or large the system font: the
/// clock takes at most [clockMaxWidth] (its text shrinks inside, e.g. past
/// one hour), and the button group takes the rest, shrinking as a whole only
/// when it does not fit (at 320 dp both fit at full size).
class NonogramPortraitToolbar extends StatelessWidget {
  const NonogramPortraitToolbar({
    super.key,
    required this.hintKey,
    required this.wandKey,
    required this.rotateKey,
    required this.compactHint,
  });

  /// Keys the play coach uses to point at the buttons.
  final GlobalKey hintKey;
  final GlobalKey wandKey;
  final GlobalKey rotateKey;

  /// Hint as icon + badge only (narrow screens).
  final bool compactHint;

  static const double clockMaxWidth = 120;

  @override
  Widget build(BuildContext context) {
    // Room above the row for the count badges that stick out of the buttons.
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: clockMaxWidth),
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: ClockAction(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: ClockPausedLock(child: _actions()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        KeyedSubtree(
          key: hintKey,
          child: HintAction(compact: compactHint),
        ),
        const SizedBox(width: 8),
        KeyedSubtree(key: wandKey, child: const WandAction()),
        if (RotateScreenAction.isSupported) ...[
          const SizedBox(width: 8),
          KeyedSubtree(key: rotateKey, child: const RotateScreenAction()),
        ],
        const SizedBox(width: 8),
        const FullscreenToggleAction(),
      ],
    );
  }
}

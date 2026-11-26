import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart' show Consumer;

import '../bloc/nonogram_play_bloc.dart';
import '../bloc/nonogram_play_state.dart';
import '../views/drag_tip.dart';
import '../views/wand_action.dart';

/// Banner along the bottom of the board: how to pick a line while the wand
/// is waiting for one, otherwise the drag-to-fill tip when it is due.
class NonogramBottomBanner extends StatelessWidget {
  const NonogramBottomBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<NonogramPlayBloc, NonogramPlayState, bool>(
      selector: (state) => state.isWandActive,
      builder: (context, active) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        child: active
            ? const Center(child: WandSelectBanner())
            : Consumer<DragTip>(
                builder: (context, tip, _) => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: tip.visible
                      ? const Center(child: DragTipBanner())
                      : const SizedBox.shrink(),
                ),
              ),
      ),
    );
  }
}

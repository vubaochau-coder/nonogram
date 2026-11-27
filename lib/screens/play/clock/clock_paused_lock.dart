import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/nonogram_play_bloc.dart';

/// Dims and disables [child] (hint, wand, undo, Fill / X...) while the
/// player has paused the clock, so nothing changes on the hidden board.
class ClockPausedLock extends StatelessWidget {
  const ClockPausedLock({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final clock = context.read<NonogramPlayBloc>().clock;
    return ListenableBuilder(
      listenable: clock,
      child: child,
      builder: (context, child) {
        final paused = clock.isPausedByUser;
        return IgnorePointer(
          ignoring: paused,
          child: AnimatedOpacity(
            opacity: paused ? 0.4 : 1,
            duration: const Duration(milliseconds: 160),
            child: child,
          ),
        );
      },
    );
  }
}

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/nonogram_play_bloc.dart';
import 'nonogram_play_clock.dart';

/// Pauses the play clock on its own: while the app is in the background (or
/// the screen is off, or the app is closing) and while another screen,
/// dialog or sheet covers the play screen. Renders nothing.
class PlayClockDriver extends StatefulWidget {
  const PlayClockDriver({super.key});

  @override
  State<PlayClockDriver> createState() => _PlayClockDriverState();
}

class _PlayClockDriverState extends State<PlayClockDriver> {
  late final NonogramPlayClock _clock;
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _clock = context.read<NonogramPlayBloc>().clock;
    _lifecycle = AppLifecycleListener(
      onStateChange: (state) => state == AppLifecycleState.resumed
          ? _clock.release(ClockHold.background)
          : _clock.hold(ClockHold.background),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Called again whenever the route becomes or stops being the top one.
    // Applied after the frame: the clock notifies widgets that may be
    // building right now.
    final current = ModalRoute.isCurrentOf(context) ?? true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      current
          ? _clock.release(ClockHold.covered)
          : _clock.hold(ClockHold.covered);
    });
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    final clock = _clock;
    // Not while the tree is being torn down: the clock notifies its widgets.
    Future.microtask(() {
      clock
        ..release(ClockHold.background)
        ..release(ClockHold.covered);
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

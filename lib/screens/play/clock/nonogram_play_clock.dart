import 'package:flutter/foundation.dart';

/// Why the clock is not counting. The clock runs only while a level is in
/// play and nothing holds it.
enum ClockHold {
  /// The player paused it (the board is hidden until they resume).
  user,

  /// The app is in the background, the screen is off or the app is closing.
  background,

  /// Another screen, dialog or sheet covers the play screen.
  covered,

  /// The controls guide is showing.
  coach,
}

/// Time spent actually playing the current level.
///
/// Counts only while the level is active (loaded, not solved) and no
/// [ClockHold] is set, so leaving the level, closing the app or pausing does
/// not add time. The total is saved with the game in progress
/// (`NonogramBoardSnapshot.elapsedMs`) and becomes the completion time.
class NonogramPlayClock extends ChangeNotifier {
  NonogramPlayClock({DateTime Function()? now}) : _now = now ?? DateTime.now;

  final DateTime Function() _now;
  final Set<ClockHold> _holds = {};
  int _committedMs = 0;
  DateTime? _runningSince;
  bool _active = false;

  /// Called when the clock stops because of a hold (not when the level ends),
  /// so the game can save the time played so far.
  VoidCallback? onHeld;

  /// Time played on the current level so far.
  Duration get elapsed {
    final since = _runningSince;
    final running = since == null ? 0 : _now().difference(since).inMilliseconds;
    return Duration(milliseconds: _committedMs + running);
  }

  bool get isRunning => _runningSince != null;

  /// The player paused the clock (as opposed to an automatic pause).
  bool get isPausedByUser => _holds.contains(ClockHold.user);

  /// A level starts or resumes with [elapsedMs] already played. A pause the
  /// player set on the previous level does not carry over.
  void start(int elapsedMs) {
    _commit();
    _committedMs = elapsedMs < 0 ? 0 : elapsedMs;
    _holds.remove(ClockHold.user);
    _active = true;
    _update(notifyHeld: false);
  }

  /// The level is solved (or gone): stop counting and keep the total.
  void finish() {
    _active = false;
    _update(notifyHeld: false);
  }

  void hold(ClockHold reason) {
    if (_holds.add(reason)) _update();
  }

  void release(ClockHold reason) {
    if (_holds.remove(reason)) _update();
  }

  void toggleUserPause() =>
      isPausedByUser ? release(ClockHold.user) : hold(ClockHold.user);

  void _commit() {
    final since = _runningSince;
    if (since == null) return;
    _committedMs += _now().difference(since).inMilliseconds;
    _runningSince = null;
  }

  void _update({bool notifyHeld = true}) {
    final shouldRun = _active && _holds.isEmpty;
    if (shouldRun && _runningSince == null) {
      _runningSince = _now();
    } else if (!shouldRun && _runningSince != null) {
      _commit();
      if (notifyHeld && _active) onHeld?.call();
    }
    notifyListeners();
  }
}

/// `mm:ss`, or `h:mm:ss` from one hour on.
String formatClock(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return h > 0 ? '$h:$m:$s' : '$m:$s';
}

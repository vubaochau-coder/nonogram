import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/context_ext.dart';

import '../bloc/nonogram_play_bloc.dart';
import '../clock/nonogram_play_clock.dart';
import '../clock/play_clock_visibility.dart';

/// The play clock: time played on the level, tap to pause or resume. A pill
/// in the portrait top row, or a compact tile ([vertical]) in the landscape
/// side rail. Shows nothing when the player hid the clock in Settings.
class ClockAction extends StatefulWidget {
  const ClockAction({super.key, this.vertical = false});

  /// Icon above the time, for the narrow landscape rail.
  final bool vertical;

  @override
  State<ClockAction> createState() => _ClockActionState();
}

class _ClockActionState extends State<ClockAction> {
  late final NonogramPlayClock _clock;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _clock = context.read<NonogramPlayBloc>().clock..addListener(_sync);
    _sync();
  }

  @override
  void dispose() {
    _clock.removeListener(_sync);
    _ticker?.cancel();
    super.dispose();
  }

  /// Ticks once a second only while the clock runs.
  void _sync() {
    if (_clock.isRunning) {
      _ticker ??= Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() {});
      });
    } else {
      _ticker?.cancel();
      _ticker = null;
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: PlayClockVisibility.notifier,
      builder: (context, visible, _) =>
          visible ? _button(context) : const SizedBox.shrink(),
    );
  }

  Widget _button(BuildContext context) {
    final colors = context.color;
    final paused = _clock.isPausedByUser;
    final foreground = paused ? colors.primary : colors.onSurface;
    final icon = Icon(
      paused ? LucideIcons.play : LucideIcons.pause,
      size: widget.vertical ? 14 : 16,
      color: foreground,
    );
    final time = Text(
      formatClock(_clock.elapsed),
      maxLines: 1,
      style: context.labelLarge.copyWith(
        color: foreground,
        fontWeight: FontWeight.w800,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
    final l10n = context.l10n;
    return Semantics(
      button: true,
      label: paused ? l10n.playClockResume : l10n.playClockPause,
      value: formatClock(_clock.elapsed),
      excludeSemantics: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: const ValueKey('nonogram-clock'),
          onTap: _clock.toggleUserPause,
          borderRadius: BorderRadius.circular(14),
          child: Ink(
            height: widget.vertical ? 52 : 40,
            width: widget.vertical ? 52 : null,
            padding: EdgeInsets.symmetric(horizontal: widget.vertical ? 4 : 12),
            decoration: BoxDecoration(
              color: paused
                  ? colors.primary.withValues(alpha: 0.12)
                  : colors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: paused
                    ? colors.primary.withValues(alpha: 0.4)
                    : context.gameColors.cardBorder,
              ),
            ),
            child: widget.vertical
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      icon,
                      const SizedBox(height: 4),
                      FittedBox(fit: BoxFit.scaleDown, child: time),
                    ],
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [icon, const SizedBox(width: 8), time],
                  ),
          ),
        ),
      ),
    );
  }
}

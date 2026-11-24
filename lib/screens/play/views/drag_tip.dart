import 'package:flutter/material.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/core/onboarding_preferences.dart';
import 'package:provider/provider.dart';

/// Mẹo "kéo để tô nhiều ô": hiện một lần, đúng lúc người chơi đang chạm từng
/// ô một ([tapsBeforeTip] lần liền, chưa kéo lần nào). Tắt hẳn khi người chơi
/// kéo qua nhiều ô hoặc bấm "Đã hiểu".
class DragTip extends ChangeNotifier {
  DragTip(this._prefs);

  final OnboardingPreferences? _prefs;
  static const tapsBeforeTip = 3;

  int _taps = 0;
  bool _visible = false;

  bool get visible => _visible;

  static DragTip? maybeOf(BuildContext context) {
    try {
      return context.read<DragTip>();
    } on ProviderNotFoundException {
      return null;
    }
  }

  /// Vừa chạm một ô.
  void cellTapped() {
    final prefs = _prefs;
    if (prefs == null || prefs.dragTipSeen || _visible) return;
    if (++_taps < tapsBeforeTip) return;
    _visible = true;
    notifyListeners();
  }

  /// Vừa kéo qua nhiều ô: đã biết kéo, không cần mẹo nữa.
  void dragged() => dismiss();

  void dismiss() {
    _prefs?.markDragTipSeen();
    _taps = 0;
    if (!_visible) return;
    _visible = false;
    notifyListeners();
  }
}

/// Dải mẹo ở mép dưới bàn chơi: bàn tay lướt qua, lời nhắc và nút "Đã hiểu".
class DragTipBanner extends StatefulWidget {
  const DragTipBanner({super.key});

  @override
  State<DragTipBanner> createState() => _DragTipBannerState();
}

class _DragTipBannerState extends State<DragTipBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _swipe = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _swipe
        ..stop()
        ..value = 0.5;
    } else if (!_swipe.isAnimating) {
      _swipe.repeat();
    }
  }

  @override
  void dispose() {
    _swipe.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.color;
    return Material(
      key: const ValueKey('nonogram-drag-tip'),
      color: colors.inverseSurface,
      borderRadius: BorderRadius.circular(16),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Bàn tay lướt sang phải rồi quay lại.
            SizedBox(
              width: 44,
              height: 28,
              child: AnimatedBuilder(
                animation: _swipe,
                builder: (context, child) {
                  final t = Curves.easeInOut.transform(
                    (_swipe.value * 1.25).clamp(0.0, 1.0),
                  );
                  return Align(
                    alignment: Alignment(-1 + 2 * t, 0),
                    child: child,
                  );
                },
                child: Icon(
                  Icons.touch_app_rounded,
                  size: 24,
                  color: colors.onInverseSurface,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                l10n.nonogramPlayDragTip,
                style: context.bodyMedium.copyWith(
                  color: colors.onInverseSurface,
                ),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(
              key: const ValueKey('nonogram-drag-tip-ok'),
              onPressed: () => DragTip.maybeOf(context)?.dismiss(),
              style: FilledButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 14),
              ),
              child: Text(l10n.nonogramCoachDone),
            ),
          ],
        ),
      ),
    );
  }
}

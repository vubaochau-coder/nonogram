import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/models/power_up_inventory.dart';
import 'package:nonogram/checkin/reward_view.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/context_ext.dart';

import '../bloc/nonogram_play_bloc.dart';
import '../bloc/nonogram_play_event.dart';
import '../bloc/nonogram_play_state.dart';
import '../widgets/overlay_button.dart';
import 'rewarded_offer.dart';

/// Gậy phép: bật chế độ chọn, rồi chạm vào dãy số của một hàng / cột để
/// hiện đáp án của đúng hàng / cột đó (khác nút gợi ý tự chọn hàng).
/// Số lượt còn lại hiện thành huy hiệu nhỏ.
class WandAction extends StatelessWidget {
  const WandAction({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NonogramPlayBloc, NonogramPlayState>(
      buildWhen: (p, c) =>
          p.remainingWands != c.remainingWands ||
          p.dailyWands != c.dailyWands ||
          p.isWandActive != c.isWandActive ||
          p.isSolved != c.isSolved,
      builder: (context, state) {
        // Hết lượt: nút vẫn bấm được, bấm là xem quảng cáo để dùng một lượt.
        final adOffer = !state.isWandActive && state.remainingWands <= 0;
        final enabled = !state.isSolved;
        // Còn lượt trong ngày (và không đang bật chế độ chọn): icon vàng kèm
        // đồng hồ cho lượt có hạn.
        final timeLimited =
            enabled && !state.isWandActive && state.dailyWands > 0;
        return Tooltip(
          message: context.l10n.nonogramPlayWandLabel,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              _PulseRing(
                active: state.isWandActive,
                child: OverlayButton(
                  key: const ValueKey('nonogram-wand'),
                  icon: LucideIcons.wand2,
                  iconWidget: timeLimited
                      ? const PowerUpGlyph(
                          powerUp: PowerUp.wand,
                          timeLimited: true,
                        )
                      : null,
                  color: state.isWandActive ? context.gameColors.reward : null,
                  enabled: enabled,
                  onPressed: () {
                    if (adOffer) {
                      usePowerUpWithAd(context, PowerUp.wand);
                      return;
                    }
                    context.read<NonogramPlayBloc>().add(const WandToggled());
                  },
                ),
              ),
              Positioned(
                right: -4,
                top: -4,
                child: IgnorePointer(
                  child: CountBadge(
                    count: state.remainingWands,
                    active: state.remainingWands > 0,
                    adOffer: adOffer,
                    daily: state.dailyWands > 0,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Chu kỳ nhấp nháy chung của nút gậy phép và dãy số khi đang chọn hàng /
/// cột.
const wandPulsePeriod = Duration(milliseconds: 1600);

/// Tín hiệu "nhắc" khi người chơi bấm một thao tác bị chặn trong lúc gậy
/// phép đang chờ chọn hàng / cột: dải hướng dẫn nảy lên để kéo sự chú ý.
class WandNudge extends ChangeNotifier {
  void nudge() {
    HapticFeedback.lightImpact();
    notifyListeners();
  }

  /// Gửi nhắc nếu màn chơi có cung cấp [WandNudge] (test lẻ thì không).
  static void of(BuildContext context) {
    try {
      context.read<WandNudge>().nudge();
    } on ProviderNotFoundException {
      HapticFeedback.lightImpact();
    }
  }
}

/// Vòng sáng lan ra định kỳ quanh nút gậy phép khi đang chọn hàng / cột.
class _PulseRing extends StatefulWidget {
  const _PulseRing({required this.active, required this.child});

  final bool active;
  final Widget child;

  @override
  State<_PulseRing> createState() => _PulseRingState();
}

class _PulseRingState extends State<_PulseRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: wandPulsePeriod,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(_PulseRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  void _sync() {
    final animate = widget.active && !MediaQuery.disableAnimationsOf(context);
    if (animate && !_pulse.isAnimating) {
      _pulse.repeat();
    } else if (!animate && _pulse.isAnimating) {
      _pulse
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.active) return widget.child;
    final gold = context.gameColors.reward;
    return AnimatedBuilder(
      animation: _pulse,
      child: widget.child,
      builder: (context, child) {
        // Lan ra rồi tắt dần trong nửa đầu chu kỳ, nghỉ ở nửa sau.
        final t = (_pulse.value * 2).clamp(0.0, 1.0);
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: gold.withValues(alpha: 0.5 * (1 - t)),
                spreadRadius: 7 * t,
              ),
            ],
          ),
          child: child,
        );
      },
    );
  }
}

/// Huy hiệu số lượt còn lại ở góc nút.
class CountBadge extends StatelessWidget {
  const CountBadge({
    super.key,
    required this.count,
    required this.active,
    this.adOffer = false,
    this.daily = false,
  });

  final int count;
  final bool active;

  /// Hết lượt: hiện biểu tượng quảng cáo thay cho số 0.
  final bool adOffer;

  /// Còn lượt chỉ dùng được hôm nay (quà điểm danh của gói không quảng
  /// cáo): badge màu vàng, cùng màu với lượt có hạn ở màn điểm danh.
  final bool daily;

  /// Chữ tối trên nền vàng cho dễ đọc.
  static const dailyForeground = Color(0xFF2B1A00);

  @override
  Widget build(BuildContext context) {
    final yellow = daily && active && !adOffer;
    final foreground = yellow ? dailyForeground : context.color.onPrimary;
    return Container(
      constraints: const BoxConstraints(minWidth: 16),
      height: 16,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: yellow
            ? context.gameColors.reward
            : active || adOffer
            ? context.color.primary
            : context.color.outline,
        borderRadius: BorderRadius.circular(8),
      ),
      child: adOffer
          ? Icon(LucideIcons.video, size: 10, color: foreground)
          : Text(
              '$count',
              style: context.labelSmall.copyWith(
                fontSize: 10,
                height: 1,
                fontWeight: FontWeight.w800,
                color: foreground,
              ),
            ),
    );
  }
}

/// Dải hướng dẫn khi đang chọn hàng / cột cho gậy phép, kèm nút huỷ.
class WandSelectBanner extends StatefulWidget {
  const WandSelectBanner({super.key});

  @override
  State<WandSelectBanner> createState() => _WandSelectBannerState();
}

class _WandSelectBannerState extends State<WandSelectBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bounce = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 360),
  );
  WandNudge? _nudge;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WandNudge? nudge;
    try {
      nudge = context.read<WandNudge>();
    } on ProviderNotFoundException {
      nudge = null;
    }
    if (nudge != _nudge) {
      _nudge?.removeListener(_onNudge);
      _nudge = nudge?..addListener(_onNudge);
    }
  }

  void _onNudge() {
    if (MediaQuery.disableAnimationsOf(context)) return;
    _bounce.forward(from: 0);
  }

  @override
  void dispose() {
    _nudge?.removeListener(_onNudge);
    _bounce.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bounce,
      builder: (context, child) => Transform.scale(
        scale: 1 + 0.07 * sin(pi * _bounce.value),
        child: child,
      ),
      child: _banner(context),
    );
  }

  Widget _banner(BuildContext context) {
    final colors = context.color;
    final gold = context.gameColors.reward;
    return Material(
      color: Color.alphaBlend(
        gold.withValues(alpha: 0.18),
        colors.surfaceContainerLow,
      ),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: gold.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 6, 6, 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.wand2, size: 18, color: gold),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                context.l10n.nonogramPlayWandSelectPrompt,
                style: context.labelLarge.copyWith(color: colors.onSurface),
              ),
            ),
            const SizedBox(width: 4),
            TextButton(
              key: const ValueKey('nonogram-wand-cancel'),
              style: TextButton.styleFrom(
                foregroundColor: colors.onSurface,
                // Giữ font của theme, chỉ đậm hơn.
                textStyle: context.labelLarge.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              onPressed: () =>
                  context.read<NonogramPlayBloc>().add(const WandToggled()),
              child: Text(context.l10n.commonCancel),
            ),
          ],
        ),
      ),
    );
  }
}

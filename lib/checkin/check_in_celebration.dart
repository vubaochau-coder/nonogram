import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:nonogram/core/app_sounds.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/context_ext.dart';

import 'check_in_policy.dart';
import 'reward_view.dart';

/// Mốc thời gian (giây, tính từ lúc bấm nút điểm danh).
abstract final class CheckInTimeline {
  /// Nút phồng lên rồi vỡ.
  static const pop = 0.13;

  /// Quả cầu sáng bay từ nút lên ô hôm nay.
  static const flyStart = 0.23;
  static const land = 0.78;

  /// Hết hiệu ứng đóng dấu (ngày không có quà).
  static const stampDone = 1.7;

  // Ngày có quà.
  static const badgeShake = 1.08;
  static const boxOut = 1.48;
  static const boxCentered = 1.93;
  static const rattleStart = 2.08;
  static const open = 2.58;

  /// Từ lúc này mới bấm "Nhận" được.
  static const collectReady = 3.2;

  /// Thời gian phần quà bay về thẻ "Quà trong tháng" sau khi bấm "Nhận".
  static const collectDuration = 0.6;
}

/// Hiệu ứng điểm danh, vẽ trên lớp phủ trên cùng của app:
///
/// 1. Nút điểm danh phồng lên rồi vỡ như bong bóng, quả cầu sáng bay lên ô
///    hôm nay; ô được đóng dấu tích kèm gợn sóng và tia lấp lánh.
/// 2. Ngày có quà: huy hiệu quà trên ô lắc, nền tối lại, hộp quà bay ra giữa
///    màn hình, rung, bật nắp (tia sáng, pháo giấy), phần quà hiện ra cùng
///    nút "Nhận". Bấm "Nhận" (hoặc nút quay lại): phần quà bay về thẻ "Quà
///    trong tháng".
///
/// Lớp phủ chặn chạm suốt hiệu ứng (trừ nút "Nhận").
class CheckInCelebration {
  CheckInCelebration({
    required TickerProvider vsync,
    required OverlayState overlay,
    required this.button,
    required this.buttonChild,
    required this.today,
    this.gift,
    this.giftCheckIns = 0,
    this.giftTarget,
    this.onLand,
    this.onCollected,
    this.sounds,
  }) : _overlay = overlay {
    _ticker = vsync.createTicker(_onTick);
  }

  /// Vị trí (toàn màn hình) nút điểm danh, ô hôm nay, và chỗ phần quà bay về.
  final Rect button;
  final Rect today;
  final Offset? giftTarget;

  /// Bản sao nút điểm danh để vẽ lúc nút phồng lên và vỡ.
  final Widget buttonChild;

  /// Quà mốc nhận hôm nay (null: ngày thường) và số lần điểm danh của mốc.
  final CheckInReward? gift;
  final int giftCheckIns;

  final VoidCallback? onLand;
  final VoidCallback? onCollected;
  final AppSoundController? sounds;

  final OverlayState _overlay;
  late final Ticker _ticker;
  OverlayEntry? _entry;
  final _time = ValueNotifier<double>(0);
  final _done = Completer<void>();

  /// Lúc bấm "Nhận" (null: chưa bấm).
  double? _collectAt;
  final _fired = <String>{};

  double get time => _time.value;

  /// Đang chờ người chơi bấm "Nhận".
  bool get awaitingCollect =>
      gift != null && _collectAt == null && time >= CheckInTimeline.open;

  /// Chạy hiệu ứng; xong khi phần quà đã về (hoặc hết đóng dấu).
  Future<void> run() {
    _entry = OverlayEntry(builder: (_) => _CelebrationLayer(this));
    _overlay.insert(_entry!);
    _ticker.start();
    return _done.future;
  }

  /// Nhận quà (nút "Nhận" hoặc nút quay lại).
  void collect() {
    if (gift == null || _collectAt != null) return;
    if (time < CheckInTimeline.collectReady) return;
    _collectAt = time;
    HapticFeedback.selectionClick();
    sounds?.play(GameSound.whoosh);
  }

  void _once(String id, double at, VoidCallback action) {
    if (time >= at && _fired.add(id)) action();
  }

  void _onTick(Duration elapsed) {
    _time.value = elapsed.inMicroseconds / 1e6;
    _once('pop', CheckInTimeline.pop, () {
      HapticFeedback.lightImpact();
      sounds?.play(GameSound.pop);
    });
    _once('fly', CheckInTimeline.flyStart, () {
      sounds?.play(GameSound.whoosh);
    });
    _once('land', CheckInTimeline.land, () {
      HapticFeedback.mediumImpact();
      sounds?.play(GameSound.stamp);
      onLand?.call();
    });
    if (gift == null) {
      if (time >= CheckInTimeline.stampDone) _finish();
      return;
    }
    _once('box', CheckInTimeline.boxOut, () => sounds?.play(GameSound.whoosh));
    for (var k = 0; k < 9; k++) {
      final at =
          CheckInTimeline.rattleStart +
          (CheckInTimeline.open - CheckInTimeline.rattleStart) * k / 9;
      _once('knock$k', at, () => sounds?.play(GameSound.knock));
    }
    _once('open', CheckInTimeline.open, () {
      HapticFeedback.heavyImpact();
      sounds?.play(GameSound.fanfare);
    });
    final collectAt = _collectAt;
    if (collectAt != null &&
        time >= collectAt + CheckInTimeline.collectDuration) {
      _once('collected', 0, () {
        sounds?.play(GameSound.line);
        onCollected?.call();
      });
      _finish();
    }
  }

  void _finish() {
    if (_done.isCompleted) return;
    _ticker.stop();
    _entry?.remove();
    _entry = null;
    _done.complete();
  }

  void dispose() {
    _finish();
    _ticker.dispose();
    _time.dispose();
  }
}

double _seg(double t, double a, double b) =>
    ((t - a) / (b - a)).clamp(0.0, 1.0);

class _CelebrationLayer extends StatelessWidget {
  const _CelebrationLayer(this.c);

  final CheckInCelebration c;

  @override
  Widget build(BuildContext context) {
    // Toạ độ toàn màn hình → toạ độ lớp phủ.
    final box = context.findRenderObject();
    final origin =
        box is RenderBox && box.hasSize
            ? box.localToGlobal(Offset.zero)
            : Offset.zero;
    final button = c.button.shift(-origin);
    final today = c.today.shift(-origin);
    final target = c.giftTarget?.translate(-origin.dx, -origin.dy);
    final size = MediaQuery.sizeOf(context);
    final boxCenter = Offset(size.width / 2, size.height * 0.42);
    final badge = Offset(today.right - 4, today.top + 4);
    final colors = _FxColors.of(context);

    return ValueListenableBuilder<double>(
      valueListenable: c._time,
      builder: (context, t, _) {
        final collectAt = c._collectAt;
        final ct = collectAt == null ? 0.0 : t - collectAt;
        return Stack(
          children: [
            // Chặn chạm suốt hiệu ứng; lúc chờ nhận quà thì chạm nền cũng
            // không làm gì (phải bấm "Nhận").
            const Positioned.fill(child: AbsorbPointer()),
            if (t < CheckInTimeline.pop + 0.07)
              Positioned.fromRect(rect: button, child: _buttonCopy(t)),
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _FxPainter(
                    t: t,
                    collect: collectAt == null ? null : ct,
                    button: button,
                    today: today,
                    badge: badge,
                    boxCenter: boxCenter,
                    hasGift: c.gift != null,
                    colors: colors,
                  ),
                ),
              ),
            ),
            if (c.gift != null)
              ..._gift(context, t, ct, collectAt != null, boxCenter, target),
          ],
        );
      },
    );
  }

  Widget _buttonCopy(double t) {
    double scale;
    var alpha = 1.0;
    if (t < CheckInTimeline.pop) {
      scale =
          0.94 +
          0.16 * Curves.easeOut.transform(_seg(t, 0, CheckInTimeline.pop));
    } else {
      final p = _seg(t, CheckInTimeline.pop, CheckInTimeline.pop + 0.07);
      scale = 1.1 + 0.15 * p;
      alpha = 1 - p;
    }
    return Opacity(
      opacity: alpha,
      child: Transform.scale(scale: scale, child: c.buttonChild),
    );
  }

  List<Widget> _gift(
    BuildContext context,
    double t,
    double ct,
    bool collecting,
    Offset boxCenter,
    Offset? target,
  ) {
    final gift = c.gift!;
    final l10n = context.l10n;
    const open = CheckInTimeline.open;
    final rise = _seg(t, open + 0.05, open + 0.45);
    if (rise <= 0) return const [];
    final fly =
        collecting
            ? Curves.easeInOutCubic.transform(
              _seg(ct, 0.05, CheckInTimeline.collectDuration),
            )
            : 0.0;
    final start = boxCenter + const Offset(0, -110);
    final end = target ?? start;
    final iconPos =
        Offset.lerp(start, end, fly)! + Offset(0, -80 * sin(pi * fly));
    final iconScale =
        collecting ? 1 - 0.75 * fly : Curves.easeOutBack.transform(rise);
    final hide = collecting ? _seg(ct, 0, 0.2) : 0.0;
    final textA = _seg(t, open + 0.3, open + 0.6) * (1 - hide);
    final buttonA = _seg(t, open + 0.6, open + 0.9) * (1 - hide);
    final gold = context.gameColors.reward;

    return [
      if (fly < 1)
        Positioned(
          left: iconPos.dx - 44,
          top: iconPos.dy - 44,
          width: 88,
          height: 88,
          child: IgnorePointer(
            child: Transform.scale(
              scale: iconScale,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: gold, width: 4),
                ),
                child: Icon(powerUpIcon(gift.powerUp), color: gold, size: 44),
              ),
            ),
          ),
        ),
      if (textA > 0)
        Positioned(
          left: 24,
          right: 24,
          top: boxCenter.dy + 80,
          child: IgnorePointer(
            child: Opacity(
              opacity: textA,
              child: Column(
                children: [
                  Text(
                    '+${context.rewardLabel(gift)}',
                    textAlign: TextAlign.center,
                    style: context.headlineMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.checkInGiftMilestone(c.giftCheckIns),
                    textAlign: TextAlign.center,
                    style: context.bodyMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      if (buttonA > 0)
        Positioned(
          left: 0,
          right: 0,
          top: boxCenter.dy + 170,
          child: Center(
            child: Opacity(
              opacity: buttonA,
              child: SizedBox(
                width: 200,
                height: 54,
                child: FilledButton(
                  key: const ValueKey('check-in-gift-collect'),
                  onPressed: collecting ? null : c.collect,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: context.color.primary,
                    disabledBackgroundColor: Colors.white,
                    disabledForegroundColor: context.color.primary,
                    textStyle: context.titleMedium.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  child: Text(l10n.checkInGiftCollect),
                ),
              ),
            ),
          ),
        ),
    ];
  }
}

class _FxColors {
  const _FxColors({
    required this.primary,
    required this.secondary,
    required this.gold,
    required this.scrim,
  });

  factory _FxColors.of(BuildContext context) => _FxColors(
    primary: context.gameColors.heroStart,
    secondary: context.gameColors.heroEnd,
    gold: context.gameColors.reward,
    scrim: const Color(0xFF0B0E1A),
  );

  final Color primary;
  final Color secondary;
  final Color gold;
  final Color scrim;
}

class _FxPainter extends CustomPainter {
  _FxPainter({
    required this.t,
    required this.collect,
    required this.button,
    required this.today,
    required this.badge,
    required this.boxCenter,
    required this.hasGift,
    required this.colors,
  });

  final double t;

  /// Thời gian từ lúc bấm "Nhận" (null: chưa bấm).
  final double? collect;
  final Rect button;
  final Rect today;
  final Offset badge;
  final Offset boxCenter;
  final bool hasGift;
  final _FxColors colors;

  static final _rnd = Random(7);
  static final _drops = List.generate(
    26,
    (_) => (
      x: _rnd.nextDouble() * 2 - 1,
      y: _rnd.nextDouble() * 2 - 1,
      jitter: (_rnd.nextDouble() - 0.5) * 0.8,
      speed: 150 + _rnd.nextDouble() * 230,
      r: 2.5 + _rnd.nextDouble() * 5.5,
      life: 0.35 + _rnd.nextDouble() * 0.3,
    ),
  );
  static final _rnd2 = Random(11);
  static final _confetti = List.generate(
    56,
    (i) => (
      a: -pi / 2 + (_rnd2.nextDouble() - 0.5) * 2.6,
      speed: 260 + _rnd2.nextDouble() * 360,
      w: 6 + _rnd2.nextDouble() * 6,
      h: 4 + _rnd2.nextDouble() * 4,
      spin: (_rnd2.nextDouble() - 0.5) * 16,
      color: i % 6,
      life: 1.1 + _rnd2.nextDouble() * 0.6,
    ),
  );

  Color _confettiColor(int i) => switch (i) {
    0 => colors.primary,
    1 => colors.secondary,
    2 => colors.gold,
    3 => const Color(0xFFE5486B),
    4 => const Color(0xFF22A06B),
    _ => const Color(0xFF3B82F6),
  };

  @override
  void paint(Canvas canvas, Size size) {
    _burst(canvas);
    _orb(canvas);
    _stamp(canvas);
    if (hasGift) _giftScene(canvas, size);
  }

  void _burst(Canvas c) {
    const pop = CheckInTimeline.pop;
    final center = button.center;
    final ring = _seg(t, pop, pop + 0.35);
    if (ring > 0 && ring < 1) {
      final e = Curves.easeOutCubic.transform(ring);
      c.drawRRect(
        RRect.fromRectAndRadius(
          button.inflate(36 * e),
          Radius.circular(button.height / 2 + 36 * e),
        ),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3 * (1 - ring)
          ..color = colors.primary.withValues(alpha: 0.35 * (1 - ring)),
      );
    }
    final dt = t - pop;
    if (dt <= 0 || dt >= 0.7) return;
    final flash = _seg(t, pop, pop + 0.09);
    if (flash < 1) {
      c.drawRRect(
        RRect.fromRectAndRadius(
          button.inflate(10 * flash),
          Radius.circular(button.height / 2 + 10 * flash),
        ),
        Paint()..color = Colors.white.withValues(alpha: 0.55 * (1 - flash)),
      );
    }
    for (final d in _drops) {
      final life = dt / d.life;
      if (life >= 1) continue;
      final start =
          center +
          Offset(d.x * button.width / 2 * 0.85, d.y * button.height / 2 * 0.7);
      var dir = Offset(d.x * 0.6, d.y);
      final len = dir.distance == 0 ? 1.0 : dir.distance;
      dir = Offset(dir.dx / len + d.jitter, dir.dy / len - 0.35);
      final p = start + dir * d.speed * dt + Offset(0, 520 * dt * dt);
      final r = d.r * (1 - life * 0.6);
      c.drawCircle(
        p,
        r,
        Paint()
          ..color = Color.lerp(
            colors.primary,
            colors.secondary,
            (d.x + 1) / 2,
          )!.withValues(alpha: 1 - life),
      );
      c.drawCircle(
        p - Offset(r * 0.3, r * 0.3),
        r * 0.32,
        Paint()..color = Colors.white.withValues(alpha: 0.75 * (1 - life)),
      );
    }
  }

  void _orb(Canvas c) {
    final f = _seg(t, CheckInTimeline.flyStart, CheckInTimeline.land);
    if (f <= 0 || f >= 1) return;
    final u = Curves.easeInOutCubic.transform(f);
    final p0 = button.center;
    final p2 = today.center;
    final p1 = Offset(max(p0.dx, p2.dx) + 90, (p0.dy + p2.dy) / 2);
    Offset at(double v) =>
        p0 * ((1 - v) * (1 - v)) + p1 * (2 * (1 - v) * v) + p2 * (v * v);
    for (var k = 6; k >= 0; k--) {
      final q = at((u - k * 0.03).clamp(0.0, 1.0));
      final r = 9 * (1 - k / 8) * (1 - 0.3 * u);
      if (k == 0) {
        c.drawCircle(
          q,
          r * 2.2,
          Paint()..color = colors.primary.withValues(alpha: 0.18),
        );
        c.drawCircle(
          q,
          r,
          Paint()
            ..shader = RadialGradient(
              colors: [Colors.white, colors.primary],
            ).createShader(Rect.fromCircle(center: q, radius: r)),
        );
      } else {
        c.drawCircle(
          q,
          r,
          Paint()
            ..color = colors.secondary.withValues(alpha: 0.12 * (7 - k) / 7),
        );
      }
    }
  }

  void _star(Canvas c, Offset p, double s, Color color) {
    final path = Path()..moveTo(p.dx, p.dy - s);
    for (var i = 1; i <= 8; i++) {
      final a = -pi / 2 + i * pi / 4;
      final r = i.isOdd ? s * 0.32 : s;
      path.lineTo(p.dx + cos(a) * r, p.dy + sin(a) * r);
    }
    c.drawPath(path..close(), Paint()..color = color);
  }

  void _stamp(Canvas c) {
    const land = CheckInTimeline.land;
    if (t <= land) return;
    final ripple = _seg(t, land, land + 0.5);
    if (ripple < 1) {
      c.drawRRect(
        RRect.fromRectAndRadius(
          today.inflate(20 * Curves.easeOut.transform(ripple)),
          const Radius.circular(14),
        ),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3 * (1 - ripple)
          ..color = colors.primary.withValues(alpha: 0.6 * (1 - ripple)),
      );
    }
    final sparkle = _seg(t, land + 0.05, land + 0.65);
    if (sparkle > 0 && sparkle < 1) {
      for (var i = 0; i < 8; i++) {
        final a = -pi / 2 + i * pi / 4 + 0.2;
        final dist =
            today.shortestSide * 0.55 + 26 * Curves.easeOut.transform(sparkle);
        _star(
          c,
          today.center + Offset(cos(a), sin(a)) * dist,
          7 * (1 - sparkle) * (i.isEven ? 1 : 0.7),
          (i.isEven ? colors.gold : colors.primary).withValues(
            alpha: 1 - sparkle * 0.6,
          ),
        );
      }
    }
    final into = _seg(t, land, land + 0.32);
    final fade = 1 - _seg(t, land + 0.6, land + 0.9);
    if (fade <= 0) return;
    final scale = 2.2 - 1.2 * Curves.easeOutBack.transform(into);
    final r = today.shortestSide * 0.36;
    final a = (into * 3).clamp(0.0, 1.0) * fade;
    c.save();
    c.translate(today.center.dx, today.center.dy + 2);
    c.rotate(-0.35 * (1 - into));
    c.scale(scale);
    c.drawCircle(
      Offset.zero,
      r,
      Paint()..color = colors.primary.withValues(alpha: 0.92 * a),
    );
    c.drawPath(
      Path()
        ..moveTo(-r * 0.45, 0)
        ..lineTo(-r * 0.1, r * 0.35)
        ..lineTo(r * 0.5, -r * 0.32),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.22
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = Colors.white.withValues(alpha: a),
    );
    c.restore();
  }

  void _giftScene(Canvas c, Size size) {
    final collect = this.collect;
    final dimOut = collect == null ? 0.0 : _seg(collect, 0, 0.4);
    final gone = collect == null ? 0.0 : _seg(collect, 0, 0.35);

    // Huy hiệu quà trên ô lắc nhẹ trước khi hộp quà bay ra.
    if (t < CheckInTimeline.boxOut && t > CheckInTimeline.land) {
      final shake = _seg(
        t,
        CheckInTimeline.badgeShake,
        CheckInTimeline.badgeShake + 0.35,
      );
      c.save();
      c.translate(badge.dx, badge.dy);
      if (shake > 0 && shake < 1) {
        c.rotate(sin(shake * pi * 4) * 0.45);
        c.scale(1 + 0.35 * sin(pi * shake));
      }
      c.drawCircle(Offset.zero, 9, Paint()..color = Colors.white);
      c.drawCircle(Offset.zero, 7.5, Paint()..color = colors.primary);
      giftBox(c, 9, colors);
      c.restore();
    }

    final dim =
        _seg(t, CheckInTimeline.boxOut, CheckInTimeline.boxOut + 0.3) *
        (1 - dimOut);
    if (dim > 0) {
      c.drawRect(
        Offset.zero & size,
        Paint()..color = colors.scrim.withValues(alpha: 0.62 * dim),
      );
    }

    const open = CheckInTimeline.open;
    final rays = _seg(t, open, open + 0.4) * (1 - dimOut);
    if (rays > 0) {
      c.save();
      c.translate(boxCenter.dx, boxCenter.dy - 20);
      c.rotate((t - open) * 0.6);
      const reach = 260.0;
      final shader = RadialGradient(
        colors: [
          colors.gold.withValues(alpha: 0.55 * rays),
          colors.gold.withValues(alpha: 0),
        ],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: reach));
      for (var i = 0; i < 12; i++) {
        final a = i * pi / 6;
        c.drawPath(
          Path()
            ..moveTo(0, 0)
            ..lineTo(cos(a - 0.12) * reach, sin(a - 0.12) * reach)
            ..lineTo(cos(a + 0.12) * reach, sin(a + 0.12) * reach)
            ..close(),
          Paint()..shader = shader,
        );
      }
      c.drawCircle(
        Offset.zero,
        90,
        Paint()
          ..shader = RadialGradient(
            colors: [
              Colors.white.withValues(alpha: 0.5 * rays),
              Colors.white.withValues(alpha: 0),
            ],
          ).createShader(Rect.fromCircle(center: Offset.zero, radius: 90)),
      );
      c.restore();
    }

    final out = _seg(t, CheckInTimeline.boxOut, CheckInTimeline.boxCentered);
    if (out > 0 && gone < 1) {
      final grow = Curves.easeOutBack.transform(out);
      final pos =
          Offset.lerp(badge, boxCenter, Curves.easeOutCubic.transform(out))!;
      final w = 18 + (130 - 18) * grow;
      var angle = 0.0;
      var squash = 1.0;
      if (t > CheckInTimeline.rattleStart && t < open) {
        final r = _seg(t, CheckInTimeline.rattleStart, open);
        final wave = sin(r * pi * 9);
        angle = wave * (0.04 + 0.10 * r);
        squash = 1 - 0.05 * wave.abs() * r;
      }
      final lid = _seg(t, open, open + 0.35);
      c.save();
      c.translate(pos.dx, pos.dy);
      c.rotate(angle);
      c.scale(1 / squash, squash);
      c.scale(1 - 0.4 * gone);
      giftBox(
        c,
        w,
        colors,
        lidUp: 120 * Curves.easeOutCubic.transform(lid),
        lidTurn: -0.9 * lid,
        lidAlpha: 1 - _seg(t, open + 0.15, open + 0.45),
        alpha: 1 - gone,
      );
      c.restore();
    }

    final ct = t - open;
    if (ct > 0 && ct < 1.8) {
      for (final p in _confetti) {
        final life = ct / p.life;
        if (life >= 1) continue;
        final pos =
            boxCenter +
            const Offset(0, -20) +
            Offset(cos(p.a), sin(p.a)) * p.speed * ct +
            Offset(0, 620 * ct * ct);
        c.save();
        c.translate(pos.dx, pos.dy);
        c.rotate(p.spin * ct);
        c.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: p.w,
            height: p.h * (0.4 + 0.6 * cos(p.spin * ct * 0.7).abs()),
          ),
          Paint()..color = _confettiColor(p.color).withValues(alpha: 1 - life),
        );
        c.restore();
      }
    }
  }

  /// Hộp quà tâm (0, 0), rộng [w]: thân xanh–tím, ruy băng và nơ vàng.
  static void giftBox(
    Canvas c,
    double w,
    _FxColors colors, {
    double lidUp = 0,
    double lidTurn = 0,
    double lidAlpha = 1,
    double alpha = 1,
  }) {
    final h = w * 0.62;
    final body = Rect.fromCenter(
      center: Offset(0, h * 0.28),
      width: w * 0.86,
      height: h,
    );
    c.drawRRect(
      RRect.fromRectAndRadius(body, Radius.circular(w * 0.08)),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colors.primary.withValues(alpha: alpha),
            colors.secondary.withValues(alpha: alpha),
          ],
        ).createShader(body),
    );
    c.drawRect(
      Rect.fromCenter(center: body.center, width: w * 0.16, height: h),
      Paint()..color = colors.gold.withValues(alpha: alpha),
    );

    final a = lidAlpha * alpha;
    c.save();
    c.translate(0, body.top - lidUp);
    c.rotate(lidTurn);
    final lid = Rect.fromCenter(
      center: Offset(0, -w * 0.08),
      width: w,
      height: w * 0.2,
    );
    c.drawRRect(
      RRect.fromRectAndRadius(lid, Radius.circular(w * 0.06)),
      Paint()
        ..color = Color.lerp(
          colors.primary,
          Colors.white,
          0.12,
        )!.withValues(alpha: a),
    );
    c.drawRect(
      Rect.fromCenter(center: lid.center, width: w * 0.16, height: lid.height),
      Paint()..color = colors.gold.withValues(alpha: a),
    );
    final bowFill = Paint()..color = colors.gold.withValues(alpha: a);
    final bowEdge =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = max(1, w * 0.018)
          ..color = Color.lerp(
            colors.gold,
            Colors.brown,
            0.35,
          )!.withValues(alpha: a);
    for (final side in const [-1.0, 1.0]) {
      final loop =
          Path()
            ..moveTo(0, lid.top)
            ..cubicTo(
              side * w * 0.10,
              lid.top - w * 0.30,
              side * w * 0.38,
              lid.top - w * 0.24,
              side * w * 0.26,
              lid.top - w * 0.02,
            )
            ..cubicTo(
              side * w * 0.20,
              lid.top + w * 0.02,
              side * w * 0.08,
              lid.top + w * 0.01,
              0,
              lid.top,
            )
            ..close();
      c.drawPath(loop, bowFill);
      c.drawPath(loop, bowEdge);
    }
    c.drawCircle(
      Offset(0, lid.top),
      w * 0.065,
      Paint()
        ..color = Color.lerp(
          colors.gold,
          Colors.orange,
          0.45,
        )!.withValues(alpha: a),
    );
    c.restore();
  }

  @override
  bool shouldRepaint(_FxPainter old) =>
      old.t != t || old.collect != collect || old.button != button;
}

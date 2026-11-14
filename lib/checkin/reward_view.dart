import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/core/duration_format.dart';
import 'package:nonogram/data/nonogram_repository.dart';
import 'package:nonogram/models/power_up_inventory.dart';
import 'package:provider/provider.dart';

import 'check_in_policy.dart';
import 'game_clock.dart';

IconData powerUpIcon(PowerUp p) => switch (p) {
  PowerUp.hint => LucideIcons.lightbulb,
  PowerUp.wand => LucideIcons.wand2,
};

/// Icon của một gợi ý / gậy phép. Khi [timeLimited] (lượt trong ngày của gói
/// không quảng cáo) thì cả icon chuyển màu vàng ([GameColors.reward]) và có
/// thêm đồng hồ nhỏ nằm trong góc dưới phải — để phân biệt lượt có hạn với
/// lượt vĩnh viễn bằng cả hình dạng, không chỉ bằng màu.
class PowerUpGlyph extends StatelessWidget {
  const PowerUpGlyph({
    super.key,
    required this.powerUp,
    this.timeLimited = false,
    this.size = 18,
    this.color,
    this.background,
  });

  final PowerUp powerUp;
  final bool timeLimited;
  final double size;

  /// Màu icon khi không phải lượt có hạn. Mặc định [ColorScheme.onSurface].
  final Color? color;

  /// Màu nền sau đồng hồ để tách khỏi nét icon. Mặc định nền nút trong màn
  /// chơi ([ColorScheme.surfaceContainerLow]).
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final base =
        timeLimited
            ? context.gameColors.reward
            : (color ?? context.color.onSurface);
    final icon = Icon(powerUpIcon(powerUp), size: size, color: base);
    if (!timeLimited) return icon;

    final clockSize = size * 0.6;
    return SizedBox.square(
      dimension: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(child: icon),
          Positioned(
            right: -size * 0.08,
            bottom: -size * 0.08,
            child: Container(
              decoration: BoxDecoration(
                color: background ?? context.color.surfaceContainerLow,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(size * 0.05),
              child: Icon(
                LucideIcons.clock,
                size: clockSize,
                color: context.gameColors.reward,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Lượt có hạn (trong ngày) màu vàng, lượt vĩnh viễn màu primary: cùng màu
/// với badge trên nút gợi ý / gậy phép trong màn chơi.
Color rewardColor(BuildContext context, {required bool daily}) =>
    daily ? context.gameColors.reward : context.color.primary;

extension RewardText on BuildContext {
  String rewardLabel(CheckInReward r) {
    final base = switch (r.powerUp) {
      PowerUp.hint => l10n.rewardHints(r.amount),
      PowerUp.wand => l10n.rewardWands(r.amount),
    };
    return r.daily ? l10n.rewardTodayOnly(base) : base;
  }

  /// "2 gợi ý và 1 gậy phép" cho lượt trong ngày còn lại.
  String dailyLeftLabel(PowerUpInventory inv) => [
    if (inv.dailyHints > 0) l10n.rewardHints(inv.dailyHints),
    if (inv.dailyWands > 0) l10n.rewardWands(inv.dailyWands),
  ].join(' · ');

  /// Thời gian còn lại tới [until], dạng "5 giờ 12 phút".
  String timeLeft(DateTime now, DateTime until) {
    final left = until.difference(now);
    final minutes = left.isNegative ? 0 : (left.inSeconds / 60).ceil();
    return formatPlayTime(minutes * 60 * 1000);
  }
}

/// Số lượng + icon, vd. "2 💡".
class RewardAmount extends StatelessWidget {
  const RewardAmount({
    super.key,
    required this.powerUp,
    required this.amount,
    required this.daily,
    this.size = 11,
  });

  final PowerUp powerUp;
  final int amount;
  final bool daily;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = rewardColor(context, daily: daily);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$amount',
          style: context.labelSmall.copyWith(
            fontSize: size,
            height: 1,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        SizedBox(width: size * 0.15),
        Icon(powerUpIcon(powerUp), size: size, color: color),
      ],
    );
  }
}

/// Kho hiện tại, cập nhật khi kho đổi và mỗi phút (để lượt trong ngày hết
/// hạn đúng lúc, và đồng hồ đếm ngược chạy).
class PowerUpsBuilder extends StatefulWidget {
  const PowerUpsBuilder({super.key, required this.builder});

  final Widget Function(
    BuildContext context,
    PowerUpInventory? inventory,
    DateTime now,
  )
  builder;

  @override
  State<PowerUpsBuilder> createState() => _PowerUpsBuilderState();
}

class _PowerUpsBuilderState extends State<PowerUpsBuilder> {
  PowerUpInventory? _raw;
  StreamSubscription<PowerUpInventory>? _sub;
  Timer? _timer;
  late NonogramRepository _repository;

  @override
  void initState() {
    super.initState();
    _repository = context.read<NonogramRepository>();
    _sub = _repository.powerUpChanges.listen((inv) {
      if (mounted) setState(() => _raw = inv);
    });
    _repository.getPowerUps().then((inv) {
      if (mounted) setState(() => _raw = inv);
    });
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clock = _clock(context);
    final now = clock?.now() ?? DateTime.now();
    return widget.builder(context, _raw?.activeOn(_repository.today), now);
  }
}

GameClock? _clock(BuildContext context) {
  try {
    return context.watch<GameClock>();
  } on ProviderNotFoundException {
    return null;
  }
}

/// Lúc hết ngày hôm nay theo giờ của game.
DateTime endOfTodayOf(BuildContext context, DateTime now) =>
    DateTime(now.year, now.month, now.day + 1);

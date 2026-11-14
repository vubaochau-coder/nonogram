import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/app_sounds.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/core/toast_utils.dart';
import 'package:nonogram/data/nonogram_repository.dart';
import 'package:nonogram/models/power_up_inventory.dart';
import 'package:provider/provider.dart';

import 'check_in_celebration.dart';
import 'check_in_policy.dart';
import 'check_in_service.dart';
import 'reward_view.dart';

/// Tab điểm danh: thẻ trạng thái hôm nay, quà trong ngày của gói không
/// quảng cáo, lịch tháng (xem lại được các tháng trước, từ tháng bắt đầu dùng
/// app), tổng quà đã nhận trong tháng, và nút "Điểm danh hôm nay" nổi ở dưới
/// (ẩn khi đã điểm danh).
///
/// Bấm điểm danh chạy [CheckInCelebration]; trong lúc đó ô hôm nay, thẻ
/// trạng thái và tổng quà vẫn hiện như chưa điểm danh, tới khi hiệu ứng tới
/// đúng bước (quả cầu chạm ô / phần quà bay về).
class CheckInTab extends StatefulWidget {
  const CheckInTab({super.key});

  @override
  State<CheckInTab> createState() => _CheckInTabState();
}

class _CheckInTabState extends State<CheckInTab> with TickerProviderStateMixin {
  late DateTime _month;
  bool _busy = false;
  final _scroll = ScrollController();
  final _listKey = GlobalKey(debugLabel: 'check-in-list');
  final _buttonKey = GlobalKey(debugLabel: 'check-in-button');
  final _todayKey = GlobalKey(debugLabel: 'check-in-today');
  final _totalKeys = {
    for (final kind in RewardKind.all)
      kind: GlobalKey(debugLabel: 'check-in-total-$kind'),
  };

  /// Đang chạy hiệu ứng: ô hôm nay / thẻ trạng thái chưa đổi.
  bool _holdToday = false;

  /// Hiệu ứng đã vẽ bản sao của nút trên lớp phủ: ẩn nút thật.
  bool _hideButton = false;

  /// Quà mốc hôm nay chưa bấm "Nhận": chưa cộng vào tổng quà tháng.
  CheckInReward? _heldGift;
  CheckInCelebration? _celebration;

  /// Số "Gợi ý" / "Gậy phép" vừa tăng: nảy lên.
  late final AnimationController _bump = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 380),
  );
  RewardKind? _bumpKind;

  @override
  void initState() {
    super.initState();
    _month = _thisMonth(context.read<CheckInService>());
  }

  @override
  void dispose() {
    _celebration?.dispose();
    _bump.dispose();
    _scroll.dispose();
    super.dispose();
  }

  static DateTime _thisMonth(CheckInService service) {
    final today = dateOfDayNumber(service.today);
    return DateTime(today.year, today.month);
  }

  static Rect? _rectOf(GlobalKey key) {
    final box = key.currentContext?.findRenderObject();
    if (box is! RenderBox || !box.attached || !box.hasSize) return null;
    return box.localToGlobal(Offset.zero) & box.size;
  }

  /// Ô hôm nay đang nằm trọn trong vùng nhìn (không bị nút che).
  bool _todayInView() {
    final today = _rectOf(_todayKey);
    final view = _scroll.hasClients ? _rectOf(_listKey) : null;
    if (today == null || view == null) return false;
    return today.top >= view.top && today.bottom <= view.bottom - 96;
  }

  Future<void> _checkIn(CheckInService service) async {
    if (_busy) return;
    setState(() => _busy = true);
    // Về tháng này và cuộn cho thấy ô hôm nay trước khi hiệu ứng bay tới.
    final thisMonth = _thisMonth(service);
    if (_month != thisMonth) setState(() => _month = thisMonth);
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;
    final todayContext = _todayKey.currentContext;
    if (todayContext != null && todayContext.mounted && !_todayInView()) {
      await Scrollable.ensureVisible(
        todayContext,
        alignment: 0.2,
        alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtStart,
        duration: const Duration(milliseconds: 200),
      );
    }
    if (!mounted) return;
    final button = _rectOf(_buttonKey);
    final today = _rectOf(_todayKey);
    final animate =
        !MediaQuery.disableAnimationsOf(context) &&
        button != null &&
        today != null;

    final countBefore = service.count;
    final rewards = await service.checkIn();
    if (!mounted) return;
    if (rewards == null) {
      setState(() => _busy = false);
      return;
    }
    final gift = rewards.where((r) => !r.daily).firstOrNull;
    final daily = rewards.where((r) => r.daily).toList();

    if (animate) {
      setState(() {
        _holdToday = true;
        _heldGift = gift;
        // Từ đây bản sao của nút được vẽ trên lớp phủ.
        _hideButton = true;
      });
      final giftKind =
          gift == null ? null : RewardKind(gift.powerUp, daily: false);
      final target = giftKind == null ? null : _rectOf(_totalKeys[giftKind]!);
      final celebration =
          _celebration = CheckInCelebration(
            vsync: this,
            overlay: Overlay.of(context, rootOverlay: true),
            button: button,
            buttonChild: _CheckInButton(
              giftToday: gift != null,
              left: CheckInPolicy.checkInsToNextMilestone(countBefore),
            ),
            today: today,
            gift: gift,
            giftCheckIns: countBefore + 1,
            giftTarget: target?.centerLeft.translate(-6, 0),
            sounds: AppSoundController.maybeOf(context),
            onLand: () {
              if (mounted) setState(() => _holdToday = false);
            },
            onCollected: () {
              if (!mounted) return;
              setState(() {
                _heldGift = null;
                _bumpKind = giftKind;
              });
              _bump.forward(from: 0);
            },
          );
      await celebration.run();
      celebration.dispose();
      _celebration = null;
    }
    if (!mounted) return;
    setState(() {
      _busy = false;
      _hideButton = false;
      _holdToday = false;
      _heldGift = null;
    });
    final l10n = context.l10n;
    if (!animate) {
      ToastUtils.success(
        title: l10n.checkInCheckedIn,
        description:
            rewards.isEmpty
                ? l10n.checkInNextGift(
                  CheckInPolicy.checkInsToNextMilestone(service.count),
                )
                : l10n.checkInReceived(
                  rewards.map(context.rewardLabel).join(', '),
                ),
      );
    } else if (daily.isNotEmpty) {
      // Quà trong ngày của gói không quảng cáo: chỉ báo nhỏ.
      ToastUtils.success(
        title: l10n.checkInCheckedIn,
        description: l10n.checkInReceived(
          daily.map(context.rewardLabel).join(', '),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = context.watch<CheckInService>();
    final today = dateOfDayNumber(service.today);
    final start = dateOfDayNumber(service.startDay);
    final firstMonth = DateTime(start.year, start.month);
    final lastMonth = DateTime(today.year, today.month);
    if (_month.isAfter(lastMonth)) _month = lastMonth;
    if (_month.isBefore(firstMonth)) _month = firstMonth;
    final month = service.month(_month.year, _month.month);
    // Lúc hiệu ứng chưa tới ô hôm nay: hiện như chưa điểm danh.
    final hold = _holdToday && service.checkedInToday;
    final count = service.count - (hold ? 1 : 0);
    final checkedIn = service.checkedInToday && !hold;
    final showButton = service.canCheckIn || _busy;

    return PopScope(
      // Đang chờ nhận quà: nút quay lại = nhận quà.
      canPop: _celebration == null,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _celebration?.collect();
      },
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            key: _listKey,
            controller: _scroll,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
            children: [
              _StatusCard(checkedIn: checkedIn, count: count),
              if (service.isPremium) ...[
                const SizedBox(height: 12),
                _PremiumToday(checkedIn: checkedIn),
              ],
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 6, 10, 12),
                  child: Column(
                    children: [
                      _MonthNavigator(
                        month: _month,
                        canGoBack: _month.isAfter(firstMonth),
                        canGoForward: _month.isBefore(lastMonth),
                        onChanged: (m) => setState(() => _month = m),
                      ),
                      const SizedBox(height: 4),
                      _CalendarGrid(
                        month: month,
                        todayKey: _todayKey,
                        holdToday: hold,
                        giftPending: _heldGift != null,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _MonthTotals(
                month: month,
                keys: _totalKeys,
                held: _heldGift,
                isThisMonth: _month == lastMonth,
                bumpKind: _bumpKind,
                bump: _bump,
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton:
            showButton
                ? Visibility(
                  // Lúc hiệu ứng chạy, bản sao của nút được vẽ trên lớp phủ.
                  visible: !_hideButton,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: _CheckInButton(
                    key: _buttonKey,
                    giftToday:
                        CheckInPolicy.checkInsToNextMilestone(service.count) ==
                        1,
                    left: CheckInPolicy.checkInsToNextMilestone(service.count),
                    onPressed: () => _checkIn(service),
                  ),
                )
                : null,
      ),
    );
  }
}

/// Thẻ trên cùng: hôm nay đã / chưa điểm danh, còn mấy lần tới quà.
class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.checkedIn, required this.count});

  final bool checkedIn;
  final int count;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final color =
        checkedIn ? context.gameColors.success : context.color.primary;
    return Card(
      key: const ValueKey('check-in-status'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder:
                  (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
              child: Container(
                key: ValueKey(checkedIn),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  checkedIn ? LucideIcons.checkCircle2 : LucideIcons.gift,
                  color: color,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    checkedIn ? l10n.checkInDoneToday : l10n.checkInNotYetToday,
                    style: context.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.checkInNextGift(
                      CheckInPolicy.checkInsToNextMilestone(count),
                    ),
                    style: context.bodySmall.copyWith(
                      color: context.color.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Nút "Điểm danh hôm nay": viên gradient, dòng dưới báo còn mấy lần tới
/// quà (hay hôm nay có quà). Nhấn thì lún nhẹ.
class _CheckInButton extends StatefulWidget {
  const _CheckInButton({
    super.key,
    required this.giftToday,
    required this.left,
    this.onPressed,
  });

  final bool giftToday;
  final int left;
  final VoidCallback? onPressed;

  @override
  State<_CheckInButton> createState() => _CheckInButtonState();
}

class _CheckInButtonState extends State<_CheckInButton> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final game = context.gameColors;
    final pill = Container(
      height: 62,
      padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(31),
        gradient: LinearGradient(colors: [game.heroStart, game.heroEnd]),
        boxShadow: [
          BoxShadow(
            color: game.heroStart.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              widget.giftToday ? LucideIcons.gift : LucideIcons.calendarCheck,
              color: game.heroStart,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.checkInTodayButton,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),
                Text(
                  widget.giftToday
                      ? l10n.checkInGiftToday
                      : l10n.checkInGiftsLeftShort(widget.left),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.labelMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    if (widget.onPressed == null) return pill;
    return Semantics(
      button: true,
      label: l10n.checkInTodayButton,
      child: GestureDetector(
        key: const ValueKey('check-in-button'),
        onTapDown: (_) => setState(() => _down = true),
        onTapCancel: () => setState(() => _down = false),
        onTapUp: (_) => setState(() => _down = false),
        onTap: widget.onPressed,
        child: AnimatedScale(
          scale: _down ? 0.94 : 1,
          duration: const Duration(milliseconds: 90),
          child: pill,
        ),
      ),
    );
  }
}

class _PremiumToday extends StatelessWidget {
  const _PremiumToday({required this.checkedIn});

  final bool checkedIn;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final yellow = rewardColor(context, daily: true);
    return Card(
      key: const ValueKey('check-in-premium-today'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: PowerUpsBuilder(
          builder: (context, inv, now) {
            final String detail;
            Widget? amounts;
            if (!checkedIn) {
              detail = l10n.checkInPremiumNotYet;
            } else if (inv == null || !inv.hasDaily) {
              detail = l10n.checkInPremiumUsedUp;
            } else {
              detail = l10n.checkInExpiresIn(
                context.timeLeft(now, endOfTodayOf(context, now)),
              );
              amounts = Row(
                children: [
                  if (inv.dailyHints > 0)
                    RewardAmount(
                      powerUp: PowerUp.hint,
                      amount: inv.dailyHints,
                      daily: true,
                      size: 18,
                    ),
                  if (inv.dailyHints > 0 && inv.dailyWands > 0)
                    const SizedBox(width: 16),
                  if (inv.dailyWands > 0)
                    RewardAmount(
                      powerUp: PowerUp.wand,
                      amount: inv.dailyWands,
                      daily: true,
                      size: 18,
                    ),
                ],
              );
            }
            return Row(
              children: [
                Icon(LucideIcons.crown, color: yellow),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.checkInPremiumToday, style: context.titleSmall),
                      if (amounts != null) ...[
                        const SizedBox(height: 6),
                        amounts,
                      ],
                      const SizedBox(height: 4),
                      Text(
                        detail,
                        style: context.bodySmall.copyWith(
                          color: context.color.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _MonthNavigator extends StatelessWidget {
  const _MonthNavigator({
    required this.month,
    required this.canGoBack,
    required this.canGoForward,
    required this.onChanged,
  });

  final DateTime month;
  final bool canGoBack;
  final bool canGoForward;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final material = MaterialLocalizations.of(context);
    return Row(
      children: [
        IconButton(
          key: const ValueKey('check-in-prev-month'),
          onPressed:
              canGoBack
                  ? () => onChanged(DateTime(month.year, month.month - 1))
                  : null,
          icon: const Icon(LucideIcons.chevronLeft),
          tooltip: material.previousMonthTooltip,
        ),
        Expanded(
          child: Text(
            material.formatMonthYear(month),
            textAlign: TextAlign.center,
            style: context.titleMedium,
          ),
        ),
        IconButton(
          key: const ValueKey('check-in-next-month'),
          onPressed:
              canGoForward
                  ? () => onChanged(DateTime(month.year, month.month + 1))
                  : null,
          icon: const Icon(LucideIcons.chevronRight),
          tooltip: material.nextMonthTooltip,
        ),
      ],
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({
    required this.month,
    required this.todayKey,
    required this.holdToday,
    required this.giftPending,
  });

  final CheckInMonth month;
  final GlobalKey todayKey;

  /// Ô hôm nay vẽ như chưa điểm danh (hiệu ứng chưa tới).
  final bool holdToday;

  /// Quà hôm nay chưa nhận: huy hiệu vẫn là hộp quà.
  final bool giftPending;

  @override
  Widget build(BuildContext context) {
    final material = MaterialLocalizations.of(context);
    final firstWeekday = material.firstDayOfWeekIndex; // 0 = Chủ nhật
    // DateTime.weekday: 1 = thứ Hai ... 7 = Chủ nhật.
    final weekdayOfFirst =
        DateTime(month.year, month.month).weekday % 7; // 0 = Chủ nhật
    final leading = (weekdayOfFirst - firstWeekday + 7) % 7;
    final cells = <CheckInDay?>[
      for (var i = 0; i < leading; i++) null,
      ...month.days,
    ];
    while (cells.length % 7 != 0) {
      cells.add(null);
    }

    return Column(
      children: [
        Row(
          children: [
            for (var i = 0; i < 7; i++)
              Expanded(
                child: Center(
                  child: Text(
                    material.narrowWeekdays[(firstWeekday + i) % 7],
                    style: context.labelSmall.copyWith(
                      color: context.color.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        for (var row = 0; row < cells.length ~/ 7; row++)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                for (var col = 0; col < 7; col++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: SizedBox(
                        height: 46,
                        child: switch (cells[row * 7 + col]) {
                          null => null,
                          final day => _DayCell(
                            key: day.isToday ? todayKey : null,
                            day: day,
                            checked: day.checked && !(day.isToday && holdToday),
                            giftPending: day.isToday && giftPending,
                          ),
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Một ngày trên lịch. Đã điểm danh: nền gradient, số nhỏ và dấu tích trắng.
/// Ngày có quà mốc: huy hiệu hộp quà ở góc (đã nhận: dấu tích vàng).
class _DayCell extends StatelessWidget {
  const _DayCell({
    super.key,
    required this.day,
    required this.checked,
    required this.giftPending,
  });

  final CheckInDay day;
  final bool checked;
  final bool giftPending;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final game = context.gameColors;
    final Border? border;
    if (day.beforeStart || checked) {
      border = null;
    } else if (day.isToday) {
      border = Border.all(color: colors.primary, width: 2);
    } else {
      border = Border.all(color: colors.outlineVariant);
    }
    final gotGift = day.hasMilestone && checked && !giftPending;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: Container(
            key: ValueKey('check-in-day-${day.dayOfMonth}'),
            decoration: BoxDecoration(
              gradient:
                  checked
                      ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [game.heroStart, game.heroEnd],
                      )
                      : null,
              border: border,
              borderRadius: BorderRadius.circular(10),
            ),
            child:
                checked
                    ? Column(
                      key: ValueKey('check-in-checked-${day.dayOfMonth}'),
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${day.dayOfMonth}',
                          style: context.labelSmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontWeight: FontWeight.w700,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    )
                    : Center(
                      child: Text(
                        '${day.dayOfMonth}',
                        style: context.labelLarge.copyWith(
                          fontWeight:
                              day.isToday ? FontWeight.w800 : FontWeight.w600,
                          color:
                              day.beforeStart
                                  ? colors.onSurfaceVariant.withValues(
                                    alpha: 0.4,
                                  )
                                  : colors.onSurface,
                        ),
                      ),
                    ),
          ),
        ),
        if (day.hasMilestone)
          Positioned(
            right: -5,
            top: -5,
            child: Container(
              key: ValueKey('check-in-gift-${day.dayOfMonth}'),
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: gotGift ? game.reward : colors.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: colors.surfaceContainerLow,
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: Icon(
                gotGift ? Icons.check_rounded : LucideIcons.gift,
                size: 10,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}

class _MonthTotals extends StatelessWidget {
  const _MonthTotals({
    required this.month,
    required this.keys,
    required this.held,
    required this.isThisMonth,
    required this.bumpKind,
    required this.bump,
  });

  final CheckInMonth month;
  final Map<RewardKind, GlobalKey> keys;

  /// Quà mốc hôm nay chưa bấm "Nhận": chưa cộng vào.
  final CheckInReward? held;
  final bool isThisMonth;
  final RewardKind? bumpKind;
  final Animation<double> bump;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    String label(RewardKind k) => switch ((k.powerUp, k.daily)) {
      (PowerUp.hint, false) => l10n.checkInTotalHints,
      (PowerUp.wand, false) => l10n.checkInTotalWands,
      (PowerUp.hint, true) => l10n.checkInTotalDailyHints,
      (PowerUp.wand, true) => l10n.checkInTotalDailyWands,
    };
    final held = isThisMonth ? this.held : null;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.checkInMonthGifts, style: context.titleSmall),
            const SizedBox(height: 10),
            for (final entry in month.totals.entries)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(
                      powerUpIcon(entry.key.powerUp),
                      size: 18,
                      color: rewardColor(context, daily: entry.key.daily),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(label(entry.key), style: context.bodyMedium),
                    ),
                    AnimatedBuilder(
                      key: keys[entry.key],
                      animation: bump,
                      builder: (context, child) {
                        final t =
                            entry.key == bumpKind && bump.isAnimating
                                ? bump.value
                                : 0.0;
                        return Transform.scale(
                          scale: 1 + 0.35 * (t * (1 - t) * 4),
                          alignment: Alignment.centerRight,
                          child: child,
                        );
                      },
                      child: Text(
                        '${entry.value.got - (held != null && held.powerUp == entry.key.powerUp && !entry.key.daily ? held.amount : 0)}'
                        '/${entry.value.max}',
                        key: ValueKey(
                          'check-in-total-${entry.key.powerUp.name}'
                          '-${entry.key.daily ? 'daily' : 'kept'}',
                        ),
                        style: context.titleSmall.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

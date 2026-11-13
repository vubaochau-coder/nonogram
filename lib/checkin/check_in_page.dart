import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/core/toast_utils.dart';
import 'package:nonogram/data/nonogram_repository.dart';
import 'package:nonogram/models/power_up_inventory.dart';
import 'package:provider/provider.dart';

import 'check_in_policy.dart';
import 'check_in_service.dart';
import 'reward_view.dart';

/// Mở màn điểm danh.
Future<void> openCheckIn(BuildContext context) => Navigator.of(
  context,
).push(MaterialPageRoute<void>(builder: (_) => const CheckInPage()));

/// Màn điểm danh: nút điểm danh, quà trong ngày của gói không quảng cáo,
/// lịch tháng (xem lại được các tháng trước, từ tháng bắt đầu dùng app) và
/// tổng quà đã nhận trong tháng.
class CheckInPage extends StatefulWidget {
  const CheckInPage({super.key});

  @override
  State<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  late DateTime _month;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    final today = dateOfDayNumber(context.read<CheckInService>().today);
    _month = DateTime(today.year, today.month);
  }

  Future<void> _checkIn(CheckInService service) async {
    setState(() => _busy = true);
    final rewards = await service.checkIn();
    if (!mounted) return;
    setState(() => _busy = false);
    if (rewards == null) return;
    final l10n = context.l10n;
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
  }

  @override
  Widget build(BuildContext context) {
    final service = context.watch<CheckInService>();
    final l10n = context.l10n;
    final today = dateOfDayNumber(service.today);
    final start = dateOfDayNumber(service.startDay);
    final firstMonth = DateTime(start.year, start.month);
    final lastMonth = DateTime(today.year, today.month);
    if (_month.isAfter(lastMonth)) _month = lastMonth;
    if (_month.isBefore(firstMonth)) _month = firstMonth;
    final month = service.month(_month.year, _month.month);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.checkInTitle)),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            _CheckInHeader(
              service: service,
              busy: _busy,
              onCheckIn: () => _checkIn(service),
            ),
            if (service.isPremium) ...[
              const SizedBox(height: 12),
              _PremiumToday(checkedIn: service.checkedInToday),
            ],
            const SizedBox(height: 20),
            _MonthNavigator(
              month: _month,
              canGoBack: _month.isAfter(firstMonth),
              canGoForward: _month.isBefore(lastMonth),
              onChanged: (m) => setState(() => _month = m),
            ),
            const SizedBox(height: 8),
            _CalendarGrid(month: month),
            const SizedBox(height: 20),
            _MonthTotals(month: month),
          ],
        ),
      ),
    );
  }
}

class _CheckInHeader extends StatelessWidget {
  const _CheckInHeader({
    required this.service,
    required this.busy,
    required this.onCheckIn,
  });

  final CheckInService service;
  final bool busy;
  final VoidCallback onCheckIn;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final next = CheckInPolicy.nextMilestone(service.count);
    final left = CheckInPolicy.checkInsToNextMilestone(service.count);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                key: const ValueKey('check-in-button'),
                onPressed: service.canCheckIn && !busy ? onCheckIn : null,
                icon: Icon(
                  service.checkedInToday
                      ? LucideIcons.checkCircle
                      : LucideIcons.calendarCheck,
                ),
                label: Text(
                  service.checkedInToday
                      ? l10n.checkInDoneToday
                      : l10n.checkInAction,
                ),
                style: FilledButton.styleFrom(minimumSize: const Size(0, 52)),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(LucideIcons.gift, size: 16),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    l10n.checkInNextGift(left),
                    style: context.bodyMedium,
                  ),
                ),
                const SizedBox(width: 6),
                RewardAmount(
                  powerUp: next.powerUp,
                  amount: next.amount,
                  daily: false,
                  size: 14,
                ),
              ],
            ),
          ],
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
  const _CalendarGrid({required this.month});

  final CheckInMonth month;

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
    // Ô cao vừa đủ cho số dòng quà nhiều nhất trong tháng.
    final maxLines = month.days.fold<int>(
      0,
      (m, d) => d.rewards.length > m ? d.rewards.length : m,
    );
    final cellHeight = 34.0 + maxLines * 14;

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
                        height: cellHeight,
                        child:
                            cells[row * 7 + col] == null
                                ? null
                                : _DayCell(day: cells[row * 7 + col]!),
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

class _DayCell extends StatelessWidget {
  const _DayCell({required this.day});

  final CheckInDay day;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    // Nền nhạt (không dùng màu đậm) để quà màu primary / vàng vẫn đọc rõ.
    final Color? fill =
        day.checked ? colors.primary.withValues(alpha: 0.14) : null;
    final Border? border;
    if (day.beforeStart) {
      border = null;
    } else if (day.isToday) {
      border = Border.all(color: colors.primary, width: 2);
    } else if (day.checked) {
      border = null;
    } else {
      border = Border.all(color: colors.outlineVariant);
    }
    final numberColor =
        day.beforeStart
            ? colors.onSurfaceVariant.withValues(alpha: 0.4)
            : day.checked
            ? colors.primary
            : colors.onSurface;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: Container(
            key: ValueKey('check-in-day-${day.dayOfMonth}'),
            decoration: BoxDecoration(
              color: fill,
              border: border,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.only(top: 6, bottom: 4),
            child: Column(
              children: [
                Text(
                  '${day.dayOfMonth}',
                  style: context.labelLarge.copyWith(
                    fontWeight: day.isToday ? FontWeight.w800 : FontWeight.w600,
                    color: numberColor,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                // Quà dự kiến (chưa tới) vẽ mờ hơn quà đã nhận.
                Opacity(
                  opacity: day.upcoming ? 0.55 : 1,
                  child: Column(
                    children: [
                      for (final r in day.rewards)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: RewardAmount(
                            powerUp: r.powerUp,
                            amount: r.amount,
                            daily: r.daily,
                            size: 10,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (day.hasMilestone)
          Positioned(
            right: -4,
            top: -4,
            child: Container(
              key: ValueKey('check-in-gift-${day.dayOfMonth}'),
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: colors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: colors.surface, width: 1.5),
              ),
              alignment: Alignment.center,
              child: Icon(LucideIcons.gift, size: 9, color: colors.onPrimary),
            ),
          ),
      ],
    );
  }
}

class _MonthTotals extends StatelessWidget {
  const _MonthTotals({required this.month});

  final CheckInMonth month;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    String label(RewardKind k) => switch ((k.powerUp, k.daily)) {
      (PowerUp.hint, false) => l10n.checkInTotalHints,
      (PowerUp.wand, false) => l10n.checkInTotalWands,
      (PowerUp.hint, true) => l10n.checkInTotalDailyHints,
      (PowerUp.wand, true) => l10n.checkInTotalDailyWands,
    };
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
                    Text(
                      '${entry.value.got}/${entry.value.max}',
                      key: ValueKey(
                        'check-in-total-${entry.key.powerUp.name}'
                        '-${entry.key.daily ? 'daily' : 'kept'}',
                      ),
                      style: context.titleSmall.copyWith(
                        fontWeight: FontWeight.w800,
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

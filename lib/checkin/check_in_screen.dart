import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/ads/ad_scope.dart';
import 'package:nonogram/ads/ad_service.dart';
import 'package:nonogram/core/app_sounds.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/core/toast_utils.dart';
import 'package:nonogram/data/nonogram_repository.dart';
import 'package:provider/provider.dart';

import 'check_in_celebration.dart';
import 'check_in_policy.dart';
import 'check_in_service.dart';
import 'reward_view.dart';

/// Màu cam của chuỗi (ngọn lửa, thanh tiến trình, hộp quà).
Color _fireColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
    ? const Color(0xFFFF8A3D)
    : const Color(0xFFF76707);

/// Màu của ngày bỏ lỡ (bù được).
Color _missedColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
    ? const Color(0xFFFFB547)
    : const Color(0xFFF08C00);

/// Tab điểm danh: lịch tháng (xem lại từ tháng bắt đầu dùng app), thanh chuỗi
/// của tháng với các mốc quà, và nút "Điểm danh hôm nay" ở dưới.
///
/// - Ngày bỏ lỡ: chạm để bù (xem quảng cáo có thưởng sau khi xác nhận).
/// - Điểm danh / bù xong: [CheckInCelebration] đóng dấu ô ngày, thanh chuỗi
///   chạy tới chuỗi dài nhất mới, rồi mở lần lượt quà các mốc vừa đạt (hộp
///   quà nhảy ra từ mốc, phần quà bay về mốc). Lúc mở quà có nút "Nhận x2":
///   xem quảng cáo để nhận gấp đôi.
///
/// Trong lúc hiệu ứng chạy, ô ngày, thanh chuỗi và các mốc vẫn hiện như cũ
/// tới đúng bước của hiệu ứng.
class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen>
    with TickerProviderStateMixin {
  late DateTime _month;
  bool _busy = false;
  final _scroll = ScrollController();
  final _listKey = GlobalKey(debugLabel: 'check-in-list');
  final _buttonKey = GlobalKey(debugLabel: 'check-in-button');
  final _stampKey = GlobalKey(debugLabel: 'check-in-stamp');
  final _streakKey = GlobalKey(debugLabel: 'check-in-streak');
  final _nodeKeys = {
    for (final m in CheckInPolicy.streakMilestones)
      m: GlobalKey(debugLabel: 'check-in-milestone-$m'),
  };

  /// Ô nhận [_stampKey] (ô sắp được đóng dấu); mặc định hôm nay.
  int? _stampDay;

  /// Đang chạy hiệu ứng: ô này vẽ như chưa điểm danh, thẻ chuỗi hiện số cũ.
  int? _holdDay;
  StreakStats? _heldStats;

  /// Thanh chuỗi đang chạy (null: theo chuỗi dài nhất thật).
  double? _barOverride;

  /// Các mốc đã nhận đang hiện (null: theo service). Quà vừa đạt chưa bấm
  /// "Nhận" thì chưa có trong này.
  Set<int>? _claimedOverride;

  /// Quà vừa đạt, đang chờ mở.
  Set<int> _pendingGifts = const {};

  /// Hiệu ứng đã vẽ bản sao của nút trên lớp phủ: ẩn nút thật.
  bool _hideButton = false;
  CheckInCelebration? _celebration;
  late final AnimationController _bar = AnimationController.unbounded(
    vsync: this,
  );

  @override
  void initState() {
    super.initState();
    _month = _monthOf(context.read<CheckInService>().today);
    _bar.addListener(() => setState(() => _barOverride = _bar.value));
  }

  @override
  void dispose() {
    _celebration?.dispose();
    _bar.dispose();
    _scroll.dispose();
    super.dispose();
  }

  static DateTime _monthOf(int day) {
    final date = dateOfDayNumber(day);
    return DateTime(date.year, date.month);
  }

  static Rect? _rectOf(GlobalKey key) {
    final box = key.currentContext?.findRenderObject();
    if (box is! RenderBox || !box.attached || !box.hasSize) return null;
    return box.localToGlobal(Offset.zero) & box.size;
  }

  /// Cuộn cho [key] nằm trọn trong vùng nhìn, phía trên nút điểm danh.
  Future<void> _reveal(GlobalKey key) async {
    final rect = _rectOf(key);
    final view = _scroll.hasClients ? _rectOf(_listKey) : null;
    final target = key.currentContext;
    if (rect == null || view == null || target == null || !target.mounted) {
      return;
    }
    if (rect.top >= view.top && rect.bottom <= view.bottom - 110) return;
    await Scrollable.ensureVisible(
      target,
      alignment: 0.5,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _checkIn(CheckInService service) =>
      _record(service, service.today, service.checkIn, withButton: true);

  Future<void> _makeUp(CheckInService service, int day) async {
    if (_busy || !service.canMakeUp(day)) return;
    final l10n = context.l10n;
    final date = MaterialLocalizations.of(
      context,
    ).formatShortMonthDay(dateOfDayNumber(day));
    final ads = context.ads;
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (context) => _MakeUpSheet(date: date),
    );
    if (confirmed != true || !mounted) return;
    if (ads.isEnabled) {
      if (!ads.isReady(AdPlacement.checkInMakeUp)) {
        ToastUtils.warning(title: l10n.adRewardNotReady);
        return;
      }
      setState(() => _busy = true);
      final rewarded = await ads.showRewarded(AdPlacement.checkInMakeUp);
      if (!mounted) return;
      setState(() => _busy = false);
      if (!rewarded) return;
    }
    await _record(service, day, () => service.makeUp(day), withButton: false);
  }

  /// Điểm danh / bù [day] rồi chạy hiệu ứng.
  Future<void> _record(
    CheckInService service,
    int day,
    Future<CheckInOutcome?> Function() action, {
    required bool withButton,
  }) async {
    if (_busy) return;
    final month = _monthOf(day);
    final before = service.streak(month.year, month.month);
    setState(() {
      _busy = true;
      _month = month;
      _stampDay = day;
    });
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;
    await _reveal(_stampKey);
    if (!mounted) return;
    final button = withButton ? _rectOf(_buttonKey) : null;
    final cell = _rectOf(_stampKey);
    final animate =
        !MediaQuery.disableAnimationsOf(context) &&
        cell != null &&
        (!withButton || button != null);

    // Giữ ô, thanh và mốc như cũ trước khi service báo đổi.
    setState(() {
      _holdDay = animate ? day : null;
      _heldStats = animate ? before : null;
      _barOverride = animate ? before.longest.toDouble() : null;
      _claimedOverride = animate
          ? {...service.claimedMilestones(month.year, month.month)}
          : null;
    });
    final outcome = await action();
    if (!mounted) return;
    if (outcome == null) {
      _reset();
      return;
    }

    if (animate) {
      await _celebrate(service, outcome, button: button, cell: cell);
    }
    if (!mounted) return;
    _reset();
    _toast(outcome, animated: animate);
  }

  Future<void> _celebrate(
    CheckInService service,
    CheckInOutcome outcome, {
    required Rect? button,
    required Rect cell,
  }) async {
    final sounds = AppSoundController.maybeOf(context);
    final overlay = Overlay.of(context, rootOverlay: true);
    final ads = context.ads;
    final l10n = context.l10n;

    // 1. Đóng dấu ô ngày.
    setState(() => _hideButton = button != null);
    final stamp = _celebration = CheckInCelebration(
      vsync: this,
      overlay: overlay,
      button: button,
      buttonChild: button == null ? null : _buttonFor(service),
      today: cell,
      sounds: sounds,
      onLand: () {
        if (mounted) setState(() => _holdDay = null);
      },
    );
    await stamp.run();
    stamp.dispose();
    _celebration = null;
    if (!mounted) return;
    setState(() {
      _hideButton = false;
      _holdDay = null;
      _heldStats = null;
      _pendingGifts = {for (final g in outcome.gifts) g.milestone};
    });

    // 2. Thanh chuỗi chạy tới chuỗi dài nhất mới.
    if (outcome.longestAfter > outcome.longestBefore) {
      await _reveal(_streakKey);
      if (!mounted) return;
      final from = outcome.longestBefore.toDouble();
      final to = math.min(outcome.longestAfter, 28).toDouble();
      _bar.value = from;
      final ms = math.max(450, ((to - from) * 60).round());
      await _bar.animateTo(
        to,
        duration: Duration(milliseconds: ms),
        curve: Curves.easeOutCubic,
      );
      if (!mounted) return;
    }

    // 3. Mở lần lượt quà các mốc vừa đạt.
    for (final gift in outcome.gifts) {
      final node = _rectOf(_nodeKeys[gift.milestone]!);
      if (node == null) continue;
      final open = _celebration = CheckInCelebration(
        vsync: this,
        overlay: overlay,
        gift: gift.reward,
        giftMilestone: gift.milestone,
        badge: node,
        giftTarget: node.center,
        sounds: sounds,
        // Không có quảng cáo (web, iOS): không có nút "Nhận x2".
        onDouble: ads.isEnabled
            ? () async {
                if (!ads.isReady(AdPlacement.checkInDoubleGift)) {
                  ToastUtils.warning(title: l10n.adRewardNotReady);
                  return false;
                }
                if (!await ads.showRewarded(AdPlacement.checkInDoubleGift)) {
                  return false;
                }
                return service.doubleGift(
                  day: outcome.day,
                  milestone: gift.milestone,
                );
              }
            : null,
        onCollected: () {
          if (!mounted) return;
          setState(() {
            _claimedOverride = {...?_claimedOverride, gift.milestone};
            _pendingGifts = {..._pendingGifts}..remove(gift.milestone);
          });
        },
      );
      await open.run();
      open.dispose();
      _celebration = null;
      if (!mounted) return;
    }
  }

  void _reset() {
    if (!mounted) return;
    setState(() {
      _busy = false;
      _hideButton = false;
      _holdDay = null;
      _heldStats = null;
      _barOverride = null;
      _claimedOverride = null;
      _pendingGifts = const {};
      _stampDay = null;
    });
  }

  void _toast(CheckInOutcome outcome, {required bool animated}) {
    final l10n = context.l10n;
    final isToday = outcome.day == context.read<CheckInService>().today;
    final title = isToday
        ? l10n.checkInCheckedIn
        : l10n.checkInMadeUp(
            MaterialLocalizations.of(
              context,
            ).formatShortMonthDay(dateOfDayNumber(outcome.day)),
          );
    // Có hiệu ứng: quà chuỗi đã hiện trong hiệu ứng, chỉ báo quà trong ngày.
    final rewards = animated ? outcome.daily : outcome.rewards;
    if (animated && rewards.isEmpty) return;
    ToastUtils.success(
      title: title,
      description: rewards.isEmpty
          ? null
          : l10n.checkInReceived(rewards.map(context.rewardLabel).join(', ')),
    );
  }

  _CheckInButton _buttonFor(CheckInService service, {VoidCallback? onPressed}) {
    final today = dateOfDayNumber(service.today);
    final stats = service.streak(today.year, today.month);
    final next = CheckInPolicy.nextMilestone(
      service.claimedMilestones(today.year, today.month),
    );
    return _CheckInButton(
      key: onPressed == null ? null : _buttonKey,
      done: !service.canCheckIn && !_busy,
      daysLeft: next == null ? null : next - stats.current,
      onPressed: onPressed,
    );
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
    final stats = _heldStats ?? service.streak(_month.year, _month.month);
    final claimed =
        _claimedOverride ??
        service.claimedMilestones(_month.year, _month.month);
    final stampDay = _stampDay ?? service.today;

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
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 6, 10, 12),
                  child: Column(
                    children: [
                      _MonthNavigator(
                        month: _month,
                        canGoBack: !_busy && _month.isAfter(firstMonth),
                        canGoForward: !_busy && _month.isBefore(lastMonth),
                        onChanged: (m) => setState(() => _month = m),
                      ),
                      const SizedBox(height: 4),
                      _CalendarGrid(
                        month: month,
                        stampDay: stampDay,
                        stampKey: _stampKey,
                        holdDay: _holdDay,
                        onMakeUp: _busy ? null : (d) => _makeUp(service, d),
                      ),
                      const _CalendarLegend(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _StreakCard(
                key: _streakKey,
                stats: stats,
                isThisMonth: _month == lastMonth,
                longest: _barOverride ?? stats.longest.toDouble(),
                claimed: claimed,
                pending: _pendingGifts,
                nodeKeys: _nodeKeys,
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Visibility(
          // Lúc hiệu ứng chạy, bản sao của nút được vẽ trên lớp phủ.
          visible: !_hideButton,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: _buttonFor(
            service,
            onPressed: service.canCheckIn ? () => _checkIn(service) : () {},
          ),
        ),
      ),
    );
  }
}

/// Hỏi lại trước khi phát quảng cáo bù ngày.
class _MakeUpSheet extends StatelessWidget {
  const _MakeUpSheet({required this.date});

  final String date;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final missed = _missedColor(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: missed.withValues(alpha: 0.16),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.play_arrow_rounded, color: missed, size: 32),
            ),
            const SizedBox(height: 14),
            Text(
              l10n.checkInMakeUpTitle(date),
              textAlign: TextAlign.center,
              style: context.titleLarge.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.checkInMakeUpBody,
              textAlign: TextAlign.center,
              style: context.bodyMedium.copyWith(
                color: context.color.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                key: const ValueKey('check-in-make-up-watch'),
                onPressed: () => Navigator.of(context).pop(true),
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(l10n.checkInMakeUpWatch),
              ),
            ),
            const SizedBox(height: 6),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.commonCancel),
            ),
          ],
        ),
      ),
    );
  }
}

/// Nút "Điểm danh hôm nay": viên gradient, dòng dưới báo còn mấy ngày tới
/// quà chuỗi (hay hôm nay có quà). Đã điểm danh: viên xám, không bấm được.
class _CheckInButton extends StatefulWidget {
  const _CheckInButton({
    super.key,
    required this.done,
    required this.daysLeft,
    this.onPressed,
  });

  final bool done;

  /// Còn mấy ngày tới mốc kế tiếp (null: đã nhận hết quà tháng này).
  final int? daysLeft;
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
    final colors = context.color;
    final done = widget.done;
    final daysLeft = widget.daysLeft;
    final giftToday = daysLeft != null && daysLeft <= 1;
    final subtitle = daysLeft == null
        ? l10n.checkInStreakAllDone
        : giftToday
        ? l10n.checkInGiftToday
        : l10n.checkInStreakDaysLeft(daysLeft);
    final ink = done ? colors.onSurfaceVariant : Colors.white;
    final pill = Container(
      height: 62,
      padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(31),
        color: done ? colors.surfaceContainerHigh : null,
        gradient: done
            ? null
            : LinearGradient(colors: [game.heroStart, game.heroEnd]),
        boxShadow: done
            ? null
            : [
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
            decoration: BoxDecoration(
              color: done ? colors.surface : Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              done
                  ? LucideIcons.check
                  : giftToday
                  ? LucideIcons.gift
                  : LucideIcons.calendarCheck,
              color: done ? colors.onSurfaceVariant : game.heroStart,
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
                  done ? l10n.checkInDoneToday : l10n.checkInTodayButton,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.titleMedium.copyWith(
                    color: ink,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.labelMedium.copyWith(
                    color: ink.withValues(alpha: 0.85),
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
      enabled: !done,
      label: done ? l10n.checkInDoneToday : l10n.checkInTodayButton,
      child: GestureDetector(
        key: const ValueKey('check-in-button'),
        onTapDown: done ? null : (_) => setState(() => _down = true),
        onTapCancel: () => setState(() => _down = false),
        onTapUp: (_) => setState(() => _down = false),
        onTap: done ? null : widget.onPressed,
        child: AnimatedScale(
          scale: _down ? 0.94 : 1,
          duration: const Duration(milliseconds: 90),
          child: pill,
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
          onPressed: canGoBack
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
          onPressed: canGoForward
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
    required this.stampDay,
    required this.stampKey,
    required this.holdDay,
    required this.onMakeUp,
  });

  final CheckInMonth month;

  /// Ô nhận [stampKey]: ô hiệu ứng đóng dấu bay tới.
  final int stampDay;
  final GlobalKey stampKey;

  /// Ô vẽ như chưa điểm danh (hiệu ứng chưa tới).
  final int? holdDay;

  /// Chạm ngày bỏ lỡ (null: đang bận).
  final ValueChanged<int>? onMakeUp;

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
                        height: 50,
                        child: switch (cells[row * 7 + col]) {
                          null => null,
                          final day => _DayCell(
                            key: day.day == stampDay ? stampKey : null,
                            day: day,
                            status: day.day == holdDay
                                ? (day.isToday
                                      ? CheckInDayStatus.today
                                      : CheckInDayStatus.missed)
                                : day.status,
                            onMakeUp: onMakeUp == null
                                ? null
                                : () => onMakeUp!(day.day),
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

/// Một ngày trên lịch (icon trơn, không chữ):
/// - Đã điểm danh: nền xanh nhạt, dấu tích.
/// - Bỏ lỡ: nền cam nhạt, viền cam nét đứt, nút ▶ (chạm để bù).
/// - Hôm nay chưa điểm danh: viền xanh đậm, chấm xanh.
/// - Chưa tới: nền xám nhạt, ổ khoá.
/// - Trước ngày bắt đầu dùng app: chỉ có số, mờ.
class _DayCell extends StatelessWidget {
  const _DayCell({
    super.key,
    required this.day,
    required this.status,
    this.onMakeUp,
  });

  final CheckInDay day;
  final CheckInDayStatus status;
  final VoidCallback? onMakeUp;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final missed = _missedColor(context);
    final soft = Color.alphaBlend(
      colors.primary.withValues(alpha: dark ? 0.22 : 0.14),
      colors.surfaceContainerLow,
    );

    final (Color? background, Color ink, Widget? icon) = switch (status) {
      CheckInDayStatus.checked => (
        soft,
        colors.primary,
        Icon(LucideIcons.check, size: 16, color: colors.primary),
      ),
      CheckInDayStatus.missed => (
        Color.alphaBlend(
          missed.withValues(alpha: dark ? 0.18 : 0.14),
          colors.surfaceContainerLow,
        ),
        missed,
        Icon(Icons.play_arrow_rounded, size: 18, color: missed),
      ),
      CheckInDayStatus.today => (
        colors.surface,
        colors.primary,
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: colors.primary,
            shape: BoxShape.circle,
          ),
        ),
      ),
      CheckInDayStatus.future => (
        colors.surfaceContainerHigh.withValues(alpha: 0.6),
        colors.onSurfaceVariant.withValues(alpha: 0.6),
        Icon(
          LucideIcons.lock,
          size: 13,
          color: colors.onSurfaceVariant.withValues(alpha: 0.5),
        ),
      ),
      CheckInDayStatus.beforeStart => (
        null,
        colors.onSurfaceVariant.withValues(alpha: 0.4),
        null,
      ),
    };

    Widget cell = Container(
      key: ValueKey('check-in-day-${day.dayOfMonth}-${status.name}'),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
        border: status == CheckInDayStatus.today
            ? Border.all(color: colors.primary, width: 2.5)
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${day.dayOfMonth}',
            style: context.labelLarge.copyWith(
              color: ink,
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),
          if (icon != null) ...[const SizedBox(height: 3), icon],
        ],
      ),
    );
    if (status == CheckInDayStatus.missed) {
      cell = CustomPaint(
        foregroundPainter: _DashedBorderPainter(color: missed),
        child: cell,
      );
      cell = Semantics(
        button: true,
        label: context.l10n.checkInLegendMissed,
        child: GestureDetector(
          key: ValueKey('check-in-make-up-${day.dayOfMonth}'),
          behavior: HitTestBehavior.opaque,
          onTap: onMakeUp,
          child: cell,
        ),
      );
    }
    return cell;
  }
}

/// Viền nét đứt bo góc của ngày bỏ lỡ.
class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          (Offset.zero & size).deflate(0.75),
          const Radius.circular(12),
        ),
      );
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    for (final metric in path.computeMetrics()) {
      for (var d = 0.0; d < metric.length; d += 7) {
        canvas.drawPath(metric.extractPath(d, d + 4), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) => old.color != color;
}

/// Chú thích dưới lịch: đã điểm danh, bỏ lỡ, chưa tới.
class _CalendarLegend extends StatelessWidget {
  const _CalendarLegend();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.color;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final missed = _missedColor(context);
    final style = context.bodySmall.copyWith(color: colors.onSurfaceVariant);

    Widget item(Widget swatch, String label) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        swatch,
        const SizedBox(width: 6),
        Text(label, style: style),
      ],
    );
    Widget swatch(Color color, {Color? dashed}) => SizedBox.square(
      dimension: 12,
      child: CustomPaint(
        foregroundPainter: dashed == null
            ? null
            : _DashedBorderPainter(color: dashed),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 6, 6, 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Wrap(
          spacing: 16,
          runSpacing: 6,
          children: [
            item(
              swatch(colors.primary.withValues(alpha: dark ? 0.3 : 0.18)),
              l10n.checkInLegendChecked,
            ),
            item(
              swatch(
                missed.withValues(alpha: dark ? 0.2 : 0.16),
                dashed: missed,
              ),
              l10n.checkInLegendMissed,
            ),
            item(swatch(colors.surfaceContainerHigh), l10n.checkInLegendFuture),
          ],
        ),
      ),
    );
  }
}

/// Thẻ chuỗi của tháng: ngọn lửa và chuỗi hiện tại, dòng nhắc bù ngày, và
/// thanh tiến trình đứng ở chuỗi dài nhất trong tháng với các mốc quà. Phần
/// sọc cam là chỗ chuỗi dài thêm được nếu bù hết ngày bỏ lỡ.
class _StreakCard extends StatelessWidget {
  const _StreakCard({
    super.key,
    required this.stats,
    required this.isThisMonth,
    required this.longest,
    required this.claimed,
    required this.pending,
    required this.nodeKeys,
  });

  final StreakStats stats;
  final bool isThisMonth;

  /// Vị trí thanh (chuỗi dài nhất, có thể đang chạy).
  final double longest;
  final Set<int> claimed;

  /// Mốc vừa đạt, quà chưa mở.
  final Set<int> pending;
  final Map<int, GlobalKey> nodeKeys;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.color;
    final fire = _fireColor(context);
    final missed = _missedColor(context);
    final allClaimed = CheckInPolicy.nextMilestone(claimed) == null;
    final canGrow = stats.missed.isNotEmpty && stats.potential > longest;

    final Widget sub;
    if (canGrow) {
      // Ký tự riêng (vùng Private Use) đánh dấu chỗ số ngày được tô màu.
      const mark = '';
      final text = l10n.checkInStreakMakeUp(stats.missed.length, mark);
      final parts = text.split(mark);
      sub = Text.rich(
        TextSpan(
          children: [
            TextSpan(text: parts.first),
            TextSpan(
              text: l10n.checkInStreakDays(stats.potential),
              style: TextStyle(color: missed, fontWeight: FontWeight.w800),
            ),
            if (parts.length > 1) TextSpan(text: parts.sublist(1).join(mark)),
          ],
        ),
        key: const ValueKey('check-in-streak-make-up'),
      );
    } else {
      sub = Text(
        allClaimed ? l10n.checkInStreakAllDone : l10n.checkInStreakKeepGoing,
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_fire_department_rounded, color: fire),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    l10n.checkInStreakTitle(
                      isThisMonth ? stats.current : stats.longest,
                    ),
                    key: const ValueKey('check-in-streak-title'),
                    style: context.titleMedium.copyWith(
                      color: fire,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            DefaultTextStyle.merge(
              style: context.bodySmall.copyWith(
                color: colors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
              child: sub,
            ),
            const SizedBox(height: 22),
            _StreakBar(
              longest: longest,
              potential: canGrow ? stats.potential.toDouble() : null,
              claimed: claimed,
              pending: pending,
              nodeKeys: nodeKeys,
            ),
          ],
        ),
      ),
    );
  }
}

class _StreakBar extends StatelessWidget {
  const _StreakBar({
    required this.longest,
    required this.potential,
    required this.claimed,
    required this.pending,
    required this.nodeKeys,
  });

  final double longest;
  final double? potential;
  final Set<int> claimed;
  final Set<int> pending;
  final Map<int, GlobalKey> nodeKeys;

  static const _max = 28.0;
  static const _node = 34.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final fire = _fireColor(context);
    final missed = _missedColor(context);
    final next = CheckInPolicy.nextMilestone({...claimed, ...pending});
    return LayoutBuilder(
      builder: (context, constraints) {
        // Chừa nửa mốc ở hai đầu cho mốc 28 và nhãn không bị cắt.
        const inset = _node / 2 + 6;
        final width = constraints.maxWidth - inset * 2;
        double x(double v) => inset + width * (v.clamp(0, _max) / _max);
        final fillEnd = x(longest);
        final potentialEnd = potential == null ? null : x(potential!);
        return SizedBox(
          height: _node + 22,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: inset,
                right: inset,
                top: _node / 2 - 5,
                height: 10,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              if (potentialEnd != null && potentialEnd > fillEnd)
                Positioned(
                  left: fillEnd - 5,
                  width: potentialEnd - fillEnd + 5,
                  top: _node / 2 - 5,
                  height: 10,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CustomPaint(
                      key: const ValueKey('check-in-streak-potential'),
                      painter: _StripesPainter(
                        color: missed.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ),
              if (longest > 0)
                Positioned(
                  left: inset,
                  width: math.max(10, fillEnd - inset),
                  top: _node / 2 - 5,
                  height: 10,
                  child: DecoratedBox(
                    key: const ValueKey('check-in-streak-fill'),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: LinearGradient(
                        colors: [const Color(0xFFFAB005), fire],
                      ),
                    ),
                  ),
                ),
              for (final m in CheckInPolicy.streakMilestones)
                Positioned(
                  left: x(m.toDouble()) - _node / 2,
                  top: 0,
                  width: _node,
                  child: _MilestoneNode(
                    key: nodeKeys[m],
                    milestone: m,
                    state: claimed.contains(m)
                        ? _NodeState.claimed
                        : pending.contains(m) && longest >= m
                        ? _NodeState.ready
                        : m == next
                        ? _NodeState.next
                        : _NodeState.later,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

enum _NodeState { claimed, ready, next, later }

/// Mốc trên thanh chuỗi: hộp quà (đã nhận: dấu tích). Nảy lên mỗi khi đổi
/// trạng thái (thanh vừa chạm tới, vừa nhận quà).
class _MilestoneNode extends StatefulWidget {
  const _MilestoneNode({
    super.key,
    required this.milestone,
    required this.state,
  });

  final int milestone;
  final _NodeState state;

  @override
  State<_MilestoneNode> createState() => _MilestoneNodeState();
}

class _MilestoneNodeState extends State<_MilestoneNode>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bump = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );

  @override
  void didUpdateWidget(_MilestoneNode old) {
    super.didUpdateWidget(old);
    if (old.state != widget.state &&
        (widget.state == _NodeState.ready ||
            widget.state == _NodeState.claimed)) {
      _bump.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _bump.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final fire = _fireColor(context);
    final state = widget.state;
    final filled = state == _NodeState.claimed || state == _NodeState.ready;
    final border = switch (state) {
      _NodeState.claimed || _NodeState.ready || _NodeState.next => fire,
      _NodeState.later => colors.outlineVariant,
    };
    final ink = switch (state) {
      _NodeState.claimed || _NodeState.ready => Colors.white,
      _NodeState.next => fire,
      _NodeState.later => colors.onSurfaceVariant,
    };
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _bump,
          builder: (context, child) {
            final t = _bump.value;
            final scale = _bump.isAnimating
                ? 1 + 0.45 * math.sin(math.pi * t)
                : 1.0;
            return Transform.scale(scale: scale, child: child);
          },
          child: Container(
            key: ValueKey(
              'check-in-milestone-${widget.milestone}-${state.name}',
            ),
            width: _StreakBar._node,
            height: _StreakBar._node,
            decoration: BoxDecoration(
              color: filled ? fire : colors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: border, width: 2),
            ),
            child: Icon(
              state == _NodeState.claimed
                  ? LucideIcons.check
                  : LucideIcons.gift,
              size: 17,
              color: ink,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          context.l10n.checkInStreakDays(widget.milestone),
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.visible,
          style: context.labelSmall.copyWith(
            fontWeight: FontWeight.w700,
            color: colors.onSurface,
          ),
        ),
      ],
    );
  }
}

/// Sọc chéo của phần chuỗi có thể nối thêm nếu bù ngày.
class _StripesPainter extends CustomPainter {
  _StripesPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3;
    for (var x = -size.height; x < size.width + size.height; x += 7) {
      canvas.drawLine(
        Offset(x, size.height),
        Offset(x + size.height, 0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_StripesPainter old) => old.color != color;
}

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
              _StatusCard(
                checkedIn: checkedIn,
                count: count,
                premium: service.isPremium,
              ),
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
                      ),
                      _CalendarLegend(
                        // Vương miện: đang có gói, hoặc tháng này từng nhận
                        // quà của gói.
                        premium:
                            service.isPremium ||
                            month.days.any(
                              (d) => d.checked && d.rewards.any((r) => r.daily),
                            ),
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

/// Thẻ trên cùng: hôm nay đã / chưa điểm danh, còn mấy lần tới quà. Chưa
/// điểm danh: nền gradient để kéo chú ý (người có gói thấy thêm dòng nhắc
/// nhận quà gói). Đã điểm danh: nền xanh lá nhạt.
class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.checkedIn,
    required this.count,
    required this.premium,
  });

  final bool checkedIn;
  final int count;
  final bool premium;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.color;
    final game = context.gameColors;
    final success = game.success;
    final next = l10n.checkInNextGift(
      CheckInPolicy.checkInsToNextMilestone(count),
    );

    final Widget icon;
    final Widget text;
    final BoxDecoration decoration;
    if (checkedIn) {
      decoration = BoxDecoration(
        color: Color.alphaBlend(
          success.withValues(alpha: 0.12),
          colors.surfaceContainerLow,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: success.withValues(alpha: 0.35)),
      );
      icon = _StatusIcon(
        background: success.withValues(alpha: 0.22),
        child: Icon(LucideIcons.checkCircle2, color: success, size: 22),
      );
      text = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.checkInDoneToday,
            style: context.titleSmall.copyWith(color: success),
          ),
          const SizedBox(height: 4),
          Text(
            next,
            style: context.bodySmall.copyWith(color: colors.onSurfaceVariant),
          ),
        ],
      );
    } else {
      decoration = BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [game.heroStart, game.heroEnd],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: game.heroStart.withValues(alpha: 0.28),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      );
      icon = _StatusIcon(
        background: Colors.white.withValues(alpha: 0.2),
        child: const Icon(LucideIcons.gift, color: Colors.white, size: 22),
      );
      text = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.checkInNotYetToday,
            style: context.titleSmall.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            next,
            style: context.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.88),
            ),
          ),
          if (premium) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 1),
                  child: Icon(
                    LucideIcons.crown,
                    size: 15,
                    color: Color(0xFFFFD66B),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    l10n.checkInPremiumNotYet,
                    style: context.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      );
    }

    return AnimatedContainer(
      key: const ValueKey('check-in-status'),
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: decoration,
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder:
                (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
            child: KeyedSubtree(key: ValueKey(checkedIn), child: icon),
          ),
          const SizedBox(width: 14),
          Expanded(child: text),
        ],
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.background, required this.child});

  final Color background;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: child,
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
  });

  final CheckInMonth month;
  final GlobalKey todayKey;

  /// Ô hôm nay vẽ như chưa điểm danh (hiệu ứng chưa tới).
  final bool holdToday;

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

/// Màu của ngày mốc quà (mỗi [CheckInPolicy.milestoneEvery] lần điểm danh).
/// Chế độ tối dùng nền đậm và gradient tươi hơn để ngày mốc vẫn nổi.
class _MilestoneColors {
  _MilestoneColors.of(BuildContext context)
    : this._(context, Theme.of(context).brightness == Brightness.dark);

  _MilestoneColors._(BuildContext context, bool dark)
    : background = Color.alphaBlend(
        context.color.primary.withValues(alpha: dark ? 0.40 : 0.13),
        context.color.surfaceContainerLow,
      ),
      ink = dark ? const Color(0xFFDCE3FF) : context.color.primary,
      gradient =
          dark
              ? const [Color(0xFF4C6EF5), Color(0xFF7950F2)]
              : [context.gameColors.heroStart, context.gameColors.heroEnd];

  /// Nền của ngày mốc chưa tới.
  final Color background;

  /// Chữ của ngày mốc chưa tới.
  final Color ink;

  /// Nền của ngày mốc đã điểm danh.
  final List<Color> gradient;
}

/// Một ngày trên lịch.
/// - Đã điểm danh: nền nhạt, số nhỏ và dấu tích mảnh; ngày mốc quà thì nền
///   gradient, dấu tích đậm.
/// - Ngày mốc chưa tới: số to, nền màu, không viền (viền dành cho hôm nay).
/// - Hôm nay: luôn có vòng viền bao ngoài ô.
/// - Ngày có quà gói không quảng cáo: vương miện ở góc (đã nhận: đặc; sắp
///   tới: viền).
class _DayCell extends StatelessWidget {
  const _DayCell({super.key, required this.day, required this.checked});

  final CheckInDay day;
  final bool checked;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final milestone = day.hasMilestone;
    final ms = _MilestoneColors.of(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final premiumDay = day.rewards.any((r) => r.daily);

    final Widget content;
    BoxDecoration decoration;
    if (checked) {
      final ink = milestone ? Colors.white : colors.primary;
      decoration = BoxDecoration(
        color:
            milestone
                ? null
                : Color.alphaBlend(
                  colors.primary.withValues(alpha: dark ? 0.20 : 0.14),
                  colors.surfaceContainerLow,
                ),
        gradient:
            milestone
                ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: ms.gradient,
                )
                : null,
        boxShadow:
            milestone
                ? [
                  BoxShadow(
                    color: ms.gradient.first.withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
                : null,
        borderRadius: BorderRadius.circular(10),
      );
      content = Column(
        key: ValueKey('check-in-checked-${day.dayOfMonth}'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${day.dayOfMonth}',
            style: context.labelSmall.copyWith(
              color:
                  milestone
                      ? Colors.white
                      : Color.lerp(colors.primary, colors.onSurface, 0.25),
              fontSize: milestone ? 13.5 : null,
              fontWeight: milestone ? FontWeight.w800 : FontWeight.w700,
              height: 1,
            ),
          ),
          const SizedBox(height: 2),
          milestone
              ? Icon(Icons.check_rounded, color: ink, size: 20)
              : Icon(LucideIcons.check, color: ink, size: 16),
        ],
      );
    } else {
      final upcomingMilestone = milestone && !day.beforeStart;
      final Border? border;
      if (day.beforeStart || upcomingMilestone || day.isToday) {
        border = null;
      } else {
        border = Border.all(color: colors.outlineVariant);
      }
      decoration = BoxDecoration(
        color: upcomingMilestone ? ms.background : null,
        border: border,
        borderRadius: BorderRadius.circular(10),
      );
      final TextStyle style;
      if (upcomingMilestone) {
        style = context.labelLarge.copyWith(
          fontSize: 17,
          fontWeight: FontWeight.w800,
          color: ms.ink,
        );
      } else {
        style = context.labelLarge.copyWith(
          fontSize: day.isToday ? 13.5 : 12.5,
          fontWeight: day.isToday ? FontWeight.w800 : FontWeight.w600,
          color:
              day.beforeStart
                  ? colors.onSurfaceVariant.withValues(alpha: 0.4)
                  : colors.onSurface,
        );
      }
      content = Center(child: Text('${day.dayOfMonth}', style: style));
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: KeyedSubtree(
            key:
                milestone
                    ? ValueKey('check-in-milestone-${day.dayOfMonth}')
                    : null,
            child: Container(
              key: ValueKey('check-in-day-${day.dayOfMonth}'),
              decoration: decoration,
              child: content,
            ),
          ),
        ),
        // Hôm nay: vòng viền bao ngoài ô (cách 1px), thấy rõ cả trên nền
        // gradient của ngày mốc.
        if (day.isToday)
          Positioned(
            left: -3,
            top: -3,
            right: -3,
            bottom: -3,
            child: IgnorePointer(
              child: DecoratedBox(
                key: const ValueKey('check-in-today-ring'),
                decoration: BoxDecoration(
                  border: Border.all(color: colors.primary, width: 2),
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
            ),
          ),
        if (premiumDay)
          Positioned(
            right: -5,
            top: -5,
            child: _CrownBadge(
              key: ValueKey('check-in-crown-${day.dayOfMonth}'),
              upcoming: !checked,
            ),
          ),
      ],
    );
  }
}

/// Vương miện ở góc ô: ngày nhận quà của gói không quảng cáo. Đã nhận: nền
/// vàng đặc; sắp tới: viền vàng.
class _CrownBadge extends StatelessWidget {
  const _CrownBadge({super.key, this.upcoming = false});

  final bool upcoming;

  @override
  Widget build(BuildContext context) {
    final gold = context.gameColors.reward;
    final card = context.color.surfaceContainerLow;
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: upcoming ? card : gold,
        shape: BoxShape.circle,
        border: Border.all(
          color: upcoming ? gold.withValues(alpha: 0.65) : card,
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: Icon(
        LucideIcons.crown,
        size: 10,
        color: upcoming ? gold : const Color(0xFF2B1A00),
      ),
    );
  }
}

/// Chú thích dưới lịch: ô mốc quà, và vương miện của gói (nếu có).
class _CalendarLegend extends StatelessWidget {
  const _CalendarLegend({required this.premium});

  final bool premium;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final ms = _MilestoneColors.of(context);
    final style = context.bodySmall.copyWith(
      color: context.color.onSurfaceVariant,
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 6, 6, 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Wrap(
          spacing: 16,
          runSpacing: 6,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  constraints: const BoxConstraints(minWidth: 22),
                  height: 22,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ms.background,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${CheckInPolicy.milestoneEvery}',
                    style: context.labelSmall.copyWith(
                      color: ms.ink,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    l10n.checkInLegendMilestone(CheckInPolicy.milestoneEvery),
                    style: style,
                  ),
                ),
              ],
            ),
            if (premium)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _CrownBadge(),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(l10n.checkInLegendPremium, style: style),
                  ),
                ],
              ),
          ],
        ),
      ),
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
                    PowerUpGlyph(
                      powerUp: entry.key.powerUp,
                      timeLimited: entry.key.daily,
                      color: rewardColor(context, daily: false),
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

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:nonogram/ads/ad_scope.dart';
import 'package:nonogram/ads/ad_service.dart';
import 'package:nonogram/core/app_sounds.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/core/toast_utils.dart';
import 'package:nonogram/data/nonogram_repository.dart';
import 'package:provider/provider.dart';

import 'check_in_celebration.dart';
import 'check_in_policy.dart';
import 'check_in_service.dart';
import 'reward_view.dart';
import 'widgets/check_in_button.dart';
import 'widgets/check_in_calendar_grid.dart';
import 'widgets/check_in_make_up_sheet.dart';
import 'widgets/check_in_month_navigator.dart';
import 'widgets/check_in_streak_card.dart';

part 'check_in_flow.dart';

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
    with TickerProviderStateMixin, _CheckInFlow {
  @override
  void initState() {
    super.initState();
    _month = _CheckInFlow._monthOf(context.read<CheckInService>().today);
    _bar.addListener(() => setState(() => _barOverride = _bar.value));
  }

  @override
  void dispose() {
    _celebration?.dispose();
    _bar.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
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

  @override
  CheckInButton _buttonFor(CheckInService service, {VoidCallback? onPressed}) {
    final today = dateOfDayNumber(service.today);
    final stats = service.streak(today.year, today.month);
    final next = CheckInPolicy.nextMilestone(
      service.claimedMilestones(today.year, today.month),
    );
    return CheckInButton(
      key: onPressed == null ? null : _buttonKey,
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
                      CheckInMonthNavigator(
                        month: _month,
                        canGoBack: !_busy && _month.isAfter(firstMonth),
                        canGoForward: !_busy && _month.isBefore(lastMonth),
                        onChanged: (m) => setState(() => _month = m),
                      ),
                      const SizedBox(height: 4),
                      CheckInCalendarGrid(
                        month: month,
                        stampDay: stampDay,
                        stampKey: _stampKey,
                        holdDay: _holdDay,
                        onMakeUp: _busy ? null : (d) => _makeUp(service, d),
                      ),
                      const CheckInCalendarLegend(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CheckInStreakCard(
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
        // Chỉ hiện khi hôm nay chưa điểm danh: điểm danh xong thì nút biến mất
        // (số ngày còn tới quà vẫn xem ở thẻ chuỗi).
        floatingActionButton: service.canCheckIn
            ? Visibility(
                // Lúc hiệu ứng chạy, bản sao của nút được vẽ trên lớp phủ.
                visible: !_hideButton,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: _buttonFor(service, onPressed: () => _checkIn(service)),
              )
            : null,
      ),
    );
  }
}

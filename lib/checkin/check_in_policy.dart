import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:nonogram/data/nonogram_repository.dart';
import 'package:nonogram/models/power_up_inventory.dart';

/// Một phần quà điểm danh.
class CheckInReward extends Equatable {
  const CheckInReward(this.powerUp, this.amount, {this.daily = false});

  final PowerUp powerUp;
  final int amount;

  /// Chỉ dùng được trong ngày điểm danh (quà của gói không quảng cáo);
  /// false = lượt vĩnh viễn (quà mốc).
  final bool daily;

  List<int> toList() => [powerUp.index, amount, daily ? 1 : 0];

  factory CheckInReward.fromList(List<dynamic> raw) => CheckInReward(
    PowerUp.values[raw[0] as int],
    raw[1] as int,
    daily: raw.length > 2 && raw[2] == 1,
  );

  @override
  List<Object?> get props => [powerUp, amount, daily];
}

/// Luật điểm danh:
///
/// - Mỗi ngày điểm danh một lần. Bỏ lỡ không mất tiến độ: chỉ đếm tổng số
///   lần đã điểm danh.
/// - Cứ mỗi [milestoneEvery] lần điểm danh nhận một quà mốc vĩnh viễn, xoay
///   vòng theo [milestoneCycle] (gợi ý, gợi ý, gậy phép).
/// - Người mua gói không quảng cáo: mỗi lần điểm danh còn nhận thêm
///   [premiumDailyHints] gợi ý và [premiumDailyWands] gậy phép dùng trong
///   ngày (không cộng dồn sang hôm sau).
/// - Chống chỉnh giờ: chỉ điểm danh được khi hôm nay sau ngày điểm danh gần
///   nhất và không sớm hơn ngày muộn nhất từng thấy (bánh cóc).
class CheckInPolicy {
  const CheckInPolicy._();

  static const milestoneEvery = 5;
  static const milestoneCycle = [PowerUp.hint, PowerUp.hint, PowerUp.wand];
  static const premiumDailyHints = 2;
  static const premiumDailyWands = 1;

  /// Quà mốc của lần điểm danh thứ [number] (bắt đầu từ 1); null nếu không
  /// phải mốc.
  static CheckInReward? milestoneFor(int number) {
    if (number <= 0 || number % milestoneEvery != 0) return null;
    final index = (number ~/ milestoneEvery - 1) % milestoneCycle.length;
    return CheckInReward(milestoneCycle[index], 1);
  }

  /// Toàn bộ quà của lần điểm danh thứ [number].
  static List<CheckInReward> rewardsFor(int number, {required bool premium}) {
    final milestone = milestoneFor(number);
    return [
      if (milestone != null) milestone,
      if (premium) ...[
        const CheckInReward(PowerUp.hint, premiumDailyHints, daily: true),
        const CheckInReward(PowerUp.wand, premiumDailyWands, daily: true),
      ],
    ];
  }

  /// Còn bao nhiêu lần điểm danh nữa tới quà mốc tiếp theo (đã điểm danh
  /// [count] lần).
  static int checkInsToNextMilestone(int count) =>
      milestoneEvery - count % milestoneEvery;

  /// Quà mốc tiếp theo.
  static CheckInReward nextMilestone(int count) =>
      milestoneFor(count + checkInsToNextMilestone(count))!;

  static bool canCheckIn({
    required int today,
    required int? lastCheckInDay,
    required int? maxSeenDay,
  }) =>
      (lastCheckInDay == null || today > lastCheckInDay) &&
      (maxSeenDay == null || today >= maxSeenDay);

  /// Dựng lịch tháng [month] / [year].
  ///
  /// - Ngày đã qua và hôm nay (đã điểm danh): quà thực tế trong [history].
  /// - Hôm nay (chưa điểm danh) và ngày tới: quà dự kiến nếu từ nay ngày nào
  ///   cũng điểm danh ([CheckInDay.projected]).
  /// - Tổng quà tháng: đã nhận / tối đa nhận được nếu ngày nào cũng điểm danh
  ///   (từ [startDay], ngày bắt đầu dùng app).
  static CheckInMonth buildMonth({
    required int year,
    required int month,
    required int today,
    required int startDay,
    required Map<int, List<CheckInReward>> history,
    required bool premium,
  }) {
    final first = dayNumberOf(DateTime(year, month));
    final last = dayNumberOf(DateTime(year, month + 1, 0));
    final checkedDays = history.keys.toList()..sort();

    // Dự kiến cho những ngày chưa tới.
    var projectedCount = history.length;
    final days = <CheckInDay>[];
    for (var d = first; d <= last; d++) {
      final checked = history.containsKey(d);
      final upcoming = !checked && d >= today && d >= startDay;
      List<CheckInReward> rewards = const [];
      if (checked) {
        rewards = history[d]!;
      } else if (upcoming) {
        projectedCount++;
        rewards = rewardsFor(projectedCount, premium: premium);
      }
      days.add(
        CheckInDay(
          day: d,
          dayOfMonth: d - first + 1,
          checked: checked,
          isToday: d == today,
          beforeStart: d < startDay,
          upcoming: upcoming,
          rewards: rewards,
        ),
      );
    }

    // Tổng quà tháng.
    final got = <RewardKind, int>{};
    for (final d in checkedDays.where((d) => d >= first && d <= last)) {
      for (final r in history[d]!) {
        final k = RewardKind(r.powerUp, daily: r.daily);
        got[k] = (got[k] ?? 0) + r.amount;
      }
    }
    final most = <RewardKind, int>{};
    final eligibleFrom = max(first, startDay);
    var count = checkedDays.where((d) => d < eligibleFrom).length;
    for (var d = eligibleFrom; d <= last; d++) {
      count++;
      for (final r in rewardsFor(count, premium: premium)) {
        final k = RewardKind(r.powerUp, daily: r.daily);
        most[k] = (most[k] ?? 0) + r.amount;
      }
    }
    final totals = <RewardKind, MonthTotal>{
      for (final k in RewardKind.all)
        if ((got[k] ?? 0) > 0 || (most[k] ?? 0) > 0)
          k: MonthTotal(got: got[k] ?? 0, max: max(most[k] ?? 0, got[k] ?? 0)),
    };

    return CheckInMonth(year: year, month: month, days: days, totals: totals);
  }
}

/// Loại quà để cộng tổng: gợi ý / gậy phép, vĩnh viễn / trong ngày.
class RewardKind extends Equatable {
  const RewardKind(this.powerUp, {required this.daily});

  final PowerUp powerUp;
  final bool daily;

  static const all = [
    RewardKind(PowerUp.hint, daily: false),
    RewardKind(PowerUp.wand, daily: false),
    RewardKind(PowerUp.hint, daily: true),
    RewardKind(PowerUp.wand, daily: true),
  ];

  @override
  List<Object?> get props => [powerUp, daily];
}

class MonthTotal extends Equatable {
  const MonthTotal({required this.got, required this.max});

  final int got;
  final int max;

  @override
  List<Object?> get props => [got, max];
}

class CheckInDay {
  const CheckInDay({
    required this.day,
    required this.dayOfMonth,
    required this.checked,
    required this.isToday,
    required this.beforeStart,
    required this.upcoming,
    required this.rewards,
  });

  final int day;
  final int dayOfMonth;
  final bool checked;
  final bool isToday;

  /// Trước ngày bắt đầu dùng app.
  final bool beforeStart;

  /// Hôm nay (chưa điểm danh) hoặc ngày tới: [rewards] là quà dự kiến.
  final bool upcoming;
  final List<CheckInReward> rewards;

  bool get hasMilestone => rewards.any((r) => !r.daily);
}

class CheckInMonth {
  const CheckInMonth({
    required this.year,
    required this.month,
    required this.days,
    required this.totals,
  });

  final int year;
  final int month;
  final List<CheckInDay> days;
  final Map<RewardKind, MonthTotal> totals;
}

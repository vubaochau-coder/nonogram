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
  /// false = lượt vĩnh viễn (quà mốc chuỗi).
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

/// Quà của một mốc chuỗi vừa đạt.
class StreakGift extends Equatable {
  const StreakGift(this.milestone, this.reward);

  /// Số ngày liên tiếp của mốc (7, 14, 21, 28).
  final int milestone;
  final CheckInReward reward;

  @override
  List<Object?> get props => [milestone, reward];
}

/// Số tháng tính từ năm 0, làm khoá lưu các mốc đã nhận theo tháng.
int monthKeyOf(DateTime date) => date.year * 12 + date.month - 1;

/// Luật điểm danh:
///
/// - Mỗi ngày điểm danh một lần. Ngày đã qua mà bỏ lỡ (từ ngày bắt đầu dùng
///   app) thì bù được, không giới hạn số lần; bù xong ngày đó tính như đã
///   điểm danh.
/// - Chuỗi là số ngày điểm danh liên tiếp **trong một tháng**; sang tháng
///   mới thì tính lại từ đầu.
/// - Chuỗi dài nhất trong tháng chạm mốc [streakMilestones] thì nhận quà của
///   mốc đó, mỗi mốc một lần mỗi tháng (chuỗi đứt rồi chạy lại tới mốc cũ
///   thì không nhận lại). Bù ngày làm chuỗi nối dài qua mốc cũng nhận quà.
/// - Người mua gói không quảng cáo: mỗi lần điểm danh đúng ngày còn nhận thêm
///   [premiumDailyHints] gợi ý và [premiumDailyWands] gậy phép dùng trong
///   ngày (không cộng dồn sang hôm sau; ngày bù không có).
/// - Chống chỉnh giờ: chỉ điểm danh / bù được khi hôm nay không sớm hơn ngày
///   muộn nhất từng thấy (bánh cóc).
class CheckInPolicy {
  const CheckInPolicy._();

  static const streakMilestones = [7, 14, 21, 28];
  static const premiumDailyHints = 2;
  static const premiumDailyWands = 1;

  /// Quà của mốc chuỗi [milestone]: 7, 14, 21 ngày được 1 gợi ý, 28 ngày
  /// được 1 gậy phép. Lúc mở quà, xem quảng cáo thì nhận gấp đôi.
  static CheckInReward streakReward(int milestone) => switch (milestone) {
    28 => const CheckInReward(PowerUp.wand, 1),
    _ => const CheckInReward(PowerUp.hint, 1),
  };

  /// Quà trong ngày của gói không quảng cáo.
  static List<CheckInReward> dailyRewards({required bool premium}) => [
    if (premium) ...[
      const CheckInReward(PowerUp.hint, premiumDailyHints, daily: true),
      const CheckInReward(PowerUp.wand, premiumDailyWands, daily: true),
    ],
  ];

  /// Các mốc chuỗi mới đạt khi chuỗi dài nhất lên tới [longest] mà chưa nhận
  /// ([claimed]).
  static List<StreakGift> newGifts({
    required int longest,
    required Set<int> claimed,
  }) => [
    for (final m in streakMilestones)
      if (m <= longest && !claimed.contains(m)) StreakGift(m, streakReward(m)),
  ];

  /// Mốc chuỗi kế tiếp chưa nhận trong tháng; null nếu đã nhận hết.
  static int? nextMilestone(Set<int> claimed) =>
      streakMilestones.where((m) => !claimed.contains(m)).firstOrNull;

  static bool canCheckIn({
    required int today,
    required int? lastCheckInDay,
    required int? maxSeenDay,
  }) =>
      (lastCheckInDay == null || today > lastCheckInDay) &&
      (maxSeenDay == null || today >= maxSeenDay);

  /// Bù được ngày [day]: đã qua, từ ngày bắt đầu dùng app, chưa điểm danh.
  static bool canMakeUp({
    required int day,
    required int today,
    required int startDay,
    required bool checked,
    required int? maxSeenDay,
  }) =>
      !checked &&
      day >= startDay &&
      day < today &&
      (maxSeenDay == null || today >= maxSeenDay);

  /// Chuỗi trong tháng [month] / [year], tính tới hôm nay.
  static StreakStats streakStats({
    required int year,
    required int month,
    required int today,
    required int startDay,
    required Set<int> checkedDays,
  }) {
    final first = dayNumberOf(DateTime(year, month));
    final last = min(dayNumberOf(DateTime(year, month + 1, 0)), today);
    var run = 0;
    var longest = 0;
    var potentialRun = 0;
    var potential = 0;
    final missed = <int>[];
    for (var d = first; d <= last; d++) {
      final checked = checkedDays.contains(d);
      final makeUp = !checked && d >= startDay && d < today;
      if (makeUp) missed.add(d);
      if (checked) {
        run++;
        longest = max(longest, run);
      } else {
        run = 0;
      }
      if (checked || makeUp) {
        potentialRun++;
        potential = max(potential, potentialRun);
      } else {
        potentialRun = 0;
      }
    }
    // Chuỗi hiện tại: tính tới hôm nay nếu đã điểm danh, không thì tới hôm
    // qua (hôm nay chưa điểm danh chưa làm đứt chuỗi).
    var current = 0;
    if (today >= first) {
      var d = checkedDays.contains(last) || last < today ? last : last - 1;
      while (d >= first && checkedDays.contains(d)) {
        current++;
        d--;
      }
    }
    return StreakStats(
      current: current,
      longest: longest,
      potential: potential,
      missed: missed,
    );
  }

  /// Dựng lịch tháng [month] / [year]: trạng thái từng ngày.
  static CheckInMonth buildMonth({
    required int year,
    required int month,
    required int today,
    required int startDay,
    required Set<int> checkedDays,
  }) {
    final first = dayNumberOf(DateTime(year, month));
    final last = dayNumberOf(DateTime(year, month + 1, 0));
    return CheckInMonth(
      year: year,
      month: month,
      days: [
        for (var d = first; d <= last; d++)
          CheckInDay(
            day: d,
            dayOfMonth: d - first + 1,
            status: switch (d) {
              _ when checkedDays.contains(d) => CheckInDayStatus.checked,
              _ when d == today => CheckInDayStatus.today,
              _ when d > today => CheckInDayStatus.future,
              _ when d < startDay => CheckInDayStatus.beforeStart,
              _ => CheckInDayStatus.missed,
            },
            isToday: d == today,
          ),
      ],
    );
  }
}

/// Chuỗi điểm danh của một tháng.
class StreakStats extends Equatable {
  const StreakStats({
    required this.current,
    required this.longest,
    required this.potential,
    required this.missed,
  });

  /// Số ngày liên tiếp tính tới hôm nay (hoặc hôm qua nếu hôm nay chưa
  /// điểm danh).
  final int current;

  /// Chuỗi dài nhất trong tháng: thanh tiến trình đứng ở đây.
  final int longest;

  /// Chuỗi dài nhất nếu bù hết các ngày bỏ lỡ.
  final int potential;

  /// Các ngày bỏ lỡ bù được.
  final List<int> missed;

  @override
  List<Object?> get props => [current, longest, potential, missed];
}

enum CheckInDayStatus {
  /// Đã điểm danh (đúng ngày hoặc bù).
  checked,

  /// Hôm nay, chưa điểm danh.
  today,

  /// Đã qua, chưa điểm danh: bù được.
  missed,

  /// Trước ngày bắt đầu dùng app.
  beforeStart,

  /// Chưa tới.
  future,
}

class CheckInDay {
  const CheckInDay({
    required this.day,
    required this.dayOfMonth,
    required this.status,
    required this.isToday,
  });

  final int day;
  final int dayOfMonth;
  final CheckInDayStatus status;
  final bool isToday;

  bool get checked => status == CheckInDayStatus.checked;
}

class CheckInMonth {
  const CheckInMonth({
    required this.year,
    required this.month,
    required this.days,
  });

  final int year;
  final int month;
  final List<CheckInDay> days;
}

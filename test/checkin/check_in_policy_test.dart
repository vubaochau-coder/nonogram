import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/checkin/check_in_policy.dart';
import 'package:nonogram/data/nonogram_repository.dart';
import 'package:nonogram/models/power_up_inventory.dart';

void main() {
  const hint = CheckInReward(PowerUp.hint, 1);
  const wand = CheckInReward(PowerUp.wand, 1);
  const dailyHints = CheckInReward(PowerUp.hint, 2, daily: true);
  const dailyWand = CheckInReward(PowerUp.wand, 1, daily: true);

  test('every 5th check-in: hint, hint, wand, then again', () {
    final milestones = [
      for (var n = 1; n <= 30; n++) CheckInPolicy.milestoneFor(n),
    ];
    expect(milestones.whereType<CheckInReward>(), [
      hint, hint, wand, hint, hint, wand, //
    ]);
    expect(CheckInPolicy.milestoneFor(4), isNull);
    expect(CheckInPolicy.milestoneFor(5), hint);
    expect(CheckInPolicy.milestoneFor(15), wand);
  });

  test('premium adds today-only uses on every check-in', () {
    expect(CheckInPolicy.rewardsFor(1, premium: true), [dailyHints, dailyWand]);
    expect(CheckInPolicy.rewardsFor(5, premium: true), [
      hint,
      dailyHints,
      dailyWand,
    ]);
    expect(CheckInPolicy.rewardsFor(1, premium: false), isEmpty);
  });

  test('next milestone', () {
    expect(CheckInPolicy.checkInsToNextMilestone(0), 5);
    expect(CheckInPolicy.checkInsToNextMilestone(3), 2);
    expect(CheckInPolicy.checkInsToNextMilestone(5), 5);
    expect(CheckInPolicy.nextMilestone(12), wand);
  });

  test('ratchet: once a day, never on an earlier day', () {
    expect(
      CheckInPolicy.canCheckIn(today: 10, lastCheckInDay: null, maxSeenDay: 10),
      isTrue,
    );
    expect(
      CheckInPolicy.canCheckIn(today: 10, lastCheckInDay: 10, maxSeenDay: 10),
      isFalse,
    );
    // Lùi giờ.
    expect(
      CheckInPolicy.canCheckIn(today: 9, lastCheckInDay: 8, maxSeenDay: 12),
      isFalse,
    );
    // Vặn tới ngày 15 rồi chỉnh lại ngày 11: phải đợi qua ngày 15.
    expect(
      CheckInPolicy.canCheckIn(today: 11, lastCheckInDay: 15, maxSeenDay: 15),
      isFalse,
    );
    expect(
      CheckInPolicy.canCheckIn(today: 16, lastCheckInDay: 15, maxSeenDay: 15),
      isTrue,
    );
  });

  group('month calendar', () {
    final nov1 = dayNumberOf(DateTime(2026, 11, 1));
    int nov(int d) => nov1 + d - 1;

    test('past days show what was received, future days are projected', () {
      // Bắt đầu 3/11, điểm danh 3, 4, 6 (bỏ lỡ 5); hôm nay 8/11 chưa
      // điểm danh.
      final month = CheckInPolicy.buildMonth(
        year: 2026,
        month: 11,
        today: nov(8),
        startDay: nov(3),
        history: {nov(3): const [], nov(4): const [], nov(6): const []},
        premium: false,
      );
      expect(month.days.length, 30);
      final d = {for (final day in month.days) day.dayOfMonth: day};
      expect(d[1]!.beforeStart, isTrue);
      expect(d[3]!.checked, isTrue);
      expect(d[5]!.checked, isFalse);
      expect(d[5]!.upcoming, isFalse);
      expect(d[8]!.isToday, isTrue);
      expect(d[8]!.upcoming, isTrue);
      // Đã điểm danh 3 lần: lần thứ 5 rơi vào 9/11 nếu từ nay ngày nào cũng
      // điểm danh, lần thứ 10 vào 14/11.
      expect(d[8]!.rewards, isEmpty);
      expect(d[9]!.rewards, [hint]);
      expect(d[9]!.hasMilestone, isTrue);
      expect(d[14]!.rewards, [hint]);
      expect(d[19]!.rewards, [wand]);
    });

    test('monthly totals: received out of the most possible', () {
      final month = CheckInPolicy.buildMonth(
        year: 2026,
        month: 11,
        today: nov(20),
        startDay: nov(1),
        history: {
          for (var d = 1; d <= 5; d++) nov(d): d == 5 ? const [hint] : const [],
        },
        premium: false,
      );
      // 30 ngày: tối đa 6 mốc = 4 gợi ý + 2 gậy phép; đã nhận 1 gợi ý.
      expect(
        month.totals[const RewardKind(PowerUp.hint, daily: false)],
        const MonthTotal(got: 1, max: 4),
      );
      expect(
        month.totals[const RewardKind(PowerUp.wand, daily: false)],
        const MonthTotal(got: 0, max: 2),
      );
      expect(
        month.totals.containsKey(const RewardKind(PowerUp.hint, daily: true)),
        isFalse,
      );
    });

    test('premium totals count today-only uses apart', () {
      final month = CheckInPolicy.buildMonth(
        year: 2026,
        month: 11,
        today: nov(2),
        startDay: nov(1),
        history: {
          nov(1): const [dailyHints, dailyWand],
        },
        premium: true,
      );
      expect(
        month.totals[const RewardKind(PowerUp.hint, daily: true)],
        const MonthTotal(got: 2, max: 60),
      );
      expect(
        month.totals[const RewardKind(PowerUp.wand, daily: true)],
        const MonthTotal(got: 1, max: 30),
      );
      final d2 = month.days[1];
      expect(d2.rewards, [dailyHints, dailyWand]);
    });

    test('a month that started mid-way only counts days since install', () {
      final month = CheckInPolicy.buildMonth(
        year: 2026,
        month: 11,
        today: nov(26),
        startDay: nov(26),
        history: const {},
        premium: false,
      );
      // 26..30: 5 ngày, đủ một mốc gợi ý.
      expect(
        month.totals[const RewardKind(PowerUp.hint, daily: false)],
        const MonthTotal(got: 0, max: 1),
      );
    });
  });
}

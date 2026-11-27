import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/checkin/check_in_policy.dart';
import 'package:nonogram/data/nonogram_repository.dart';
import 'package:nonogram/models/power_up_inventory.dart';

void main() {
  /// Ngày [d] của tháng 11/2026 (1/11/2026 là Chủ nhật).
  int nov(int d) => dayNumberOf(DateTime(2026, 11, d));

  Set<int> days(Iterable<int> list) => {for (final d in list) nov(d)};

  StreakStats stats(
    Set<int> checked, {
    int today = 22,
    int startDay = 1,
    int month = 11,
  }) => CheckInPolicy.streakStats(
    year: 2026,
    month: month,
    today: nov(today),
    startDay: nov(startDay),
    checkedDays: checked,
  );

  Iterable<int> range(int a, int b) => [for (var d = a; d <= b; d++) d];

  test('milestones every 7 days, each with a gift', () {
    expect(CheckInPolicy.streakMilestones, [7, 14, 21, 28]);
    for (final m in CheckInPolicy.streakMilestones) {
      expect(CheckInPolicy.streakReward(m).daily, isFalse);
    }
  });

  test('premium adds today-only uses', () {
    expect(CheckInPolicy.dailyRewards(premium: false), isEmpty);
    expect(CheckInPolicy.dailyRewards(premium: true), const [
      CheckInReward(PowerUp.hint, 2, daily: true),
      CheckInReward(PowerUp.wand, 1, daily: true),
    ]);
  });

  test('new gifts: milestones reached and not claimed yet', () {
    expect(CheckInPolicy.newGifts(longest: 6, claimed: {}), isEmpty);
    expect(
      CheckInPolicy.newGifts(longest: 22, claimed: {7}).map((g) => g.milestone),
      [14, 21],
    );
    expect(CheckInPolicy.nextMilestone({7, 14}), 21);
    expect(CheckInPolicy.nextMilestone({7, 14, 21, 28}), isNull);
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

  test('make-up: missed past days since install or in this month', () {
    bool can(int day, {bool checked = false, int? maxSeen}) =>
        CheckInPolicy.canMakeUp(
          day: nov(day),
          today: nov(22),
          startDay: nov(5),
          checked: checked,
          maxSeenDay: maxSeen,
        );
    expect(can(10), isTrue);
    expect(can(21), isTrue);
    expect(can(10, checked: true), isFalse);
    expect(can(22), isFalse, reason: 'hôm nay: điểm danh, không bù');
    expect(can(25), isFalse, reason: 'chưa tới');
    expect(can(4), isTrue, reason: 'trước khi tải app nhưng cùng tháng');
    expect(can(1), isTrue);
    expect(can(0), isFalse, reason: '31/10: trước khi tải app, tháng trước');
    expect(can(10, maxSeen: nov(24)), isFalse, reason: 'lùi giờ');
  });

  group('streak', () {
    test('current, longest and what make-ups could reach', () {
      // 1–12, bỏ lỡ 13, 14–21; hôm nay 22 chưa điểm danh.
      final s = stats(days([...range(1, 12), ...range(14, 21)]));
      expect(s.current, 8);
      expect(s.longest, 12);
      expect(s.potential, 21);
      expect(s.missed, [nov(13)]);
    });

    test('checking in today extends the current streak', () {
      final s = stats(days([...range(14, 22)]), startDay: 14);
      expect(s.current, 9);
      expect(s.longest, 9);
    });

    test('a missed day before today breaks the current streak', () {
      final s = stats(days([...range(1, 20)]));
      // Bỏ lỡ hôm qua (21): chuỗi hiện tại về 0, chuỗi dài nhất vẫn 20.
      expect(s.current, 0);
      expect(s.longest, 20);
      expect(s.potential, 21);
    });

    test('resets every month', () {
      // Cả tháng 10 và tháng 11 tới hôm nay đều điểm danh.
      final checked = {
        for (var d = 1; d <= 31; d++) dayNumberOf(DateTime(2026, 10, d)),
        ...days(range(1, 5)),
      };
      final s = stats(checked, today: 5, startDay: -40);
      expect(s.current, 5);
      expect(s.longest, 5);
      final october = CheckInPolicy.streakStats(
        year: 2026,
        month: 10,
        today: nov(5),
        startDay: nov(-40),
        checkedDays: checked,
      );
      expect(october.longest, 31);
    });

    test('days before install in this month can be made up', () {
      final s = stats(days(range(10, 21)), startDay: 10);
      expect(s.missed, range(1, 9).map(nov));
      expect(s.potential, 21);
    });

    test('days before install in an earlier month cannot', () {
      // Tải app 25/11, xem lại tháng 11 từ 3/12.
      final s = stats(days(range(25, 30)), today: 33, startDay: 25);
      expect(s.missed, isEmpty);
      expect(s.potential, 6);
    });
  });

  test('month calendar: one status per day', () {
    final month = CheckInPolicy.buildMonth(
      year: 2026,
      month: 11,
      today: nov(22),
      startDay: nov(3),
      checkedDays: days([...range(3, 9), ...range(11, 21)]),
    );
    CheckInDayStatus at(int d) => month.days[d - 1].status;
    expect(month.days, hasLength(30));
    expect(at(1), CheckInDayStatus.missed, reason: 'cùng tháng: bù được');
    expect(at(3), CheckInDayStatus.checked);
    expect(at(10), CheckInDayStatus.missed);
    expect(at(22), CheckInDayStatus.today);
    expect(month.days[21].isToday, isTrue);
    expect(at(23), CheckInDayStatus.future);
  });

  test(
    'month calendar: days before install in an earlier month stay locked',
    () {
      final month = CheckInPolicy.buildMonth(
        year: 2026,
        month: 11,
        today: nov(33),
        startDay: nov(25),
        checkedDays: days([25]),
      );
      expect(month.days[23].status, CheckInDayStatus.beforeStart);
      expect(month.days[25].status, CheckInDayStatus.missed);
    },
  );
}

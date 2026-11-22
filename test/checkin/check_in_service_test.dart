import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/checkin/check_in_policy.dart';
import 'package:nonogram/checkin/check_in_service.dart';
import 'package:nonogram/checkin/game_clock.dart';
import 'package:nonogram/data/nonogram_repository.dart';
import 'package:nonogram/models/power_up_inventory.dart';

import '../mocks/fake_nonogram_repository.dart';
import '../mocks/fake_purchase_gateway.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DateTime device;
  late FakeTrustedClock network;
  late GameClock clock;
  late FakeNonogramRepository repository;
  late bool premium;

  CheckInService service({int? startDay}) {
    final s = CheckInService.inMemory(
      clock: clock,
      isPremium: () => premium,
      startDay: startDay,
    )..attach(repository);
    addTearDown(s.dispose);
    return s;
  }

  setUp(() async {
    device = DateTime(2026, 11, 13, 9);
    network = FakeTrustedClock(DateTime(2026, 11, 13, 9));
    clock = GameClock.inMemory(trusted: network, device: () => device);
    repository = FakeNonogramRepository(today: () => clock.today);
    await repository.savePowerUps(const PowerUpInventory(hints: 0, wands: 0));
    premium = false;
  });

  void nextDay() {
    device = device.add(const Duration(days: 1));
    network.time = network.time!.add(const Duration(days: 1));
  }

  test('a gift at 7 days in a row, each milestone once a month', () async {
    final s = service();
    for (var i = 1; i <= 15; i++) {
      final outcome = await s.checkIn();
      expect(outcome, isNotNull, reason: 'day $i');
      expect(
        outcome!.gifts.map((g) => g.milestone),
        i == 7
            ? [7]
            : i == 14
            ? [14]
            : isEmpty,
      );
      // Đã điểm danh hôm nay: không điểm danh lại được.
      expect(await s.checkIn(), isNull);
      nextDay();
    }
    expect(s.count, 15);
    expect(
      await repository.getPowerUps(),
      PowerUpInventory(hints: 0, wands: 0)
          .addPermanent(PowerUp.hint, CheckInPolicy.streakReward(7).amount)
          .addPermanent(PowerUp.wand, CheckInPolicy.streakReward(14).amount),
    );
    expect(s.claimedMilestones(2026, 11), {7, 14});
  });

  test('a broken streak does not give the same milestone twice', () async {
    final s = service();
    for (var i = 0; i < 7; i++) {
      await s.checkIn();
      nextDay();
    }
    nextDay(); // bỏ lỡ một ngày
    for (var i = 0; i < 7; i++) {
      final outcome = await s.checkIn();
      expect(outcome!.gifts, isEmpty);
      nextDay();
    }
    expect(s.claimedMilestones(2026, 11), {7});
  });

  test('making up a missed day joins the streak and gives the gifts', () async {
    // 13/11 bắt đầu; điểm danh 13–19, bỏ lỡ 20, điểm danh 21–27.
    final s = service();
    for (var day = 13; day <= 27; day++) {
      if (day != 20) await s.checkIn();
      nextDay();
    }
    // Hôm nay 28/11, chưa điểm danh.
    final missed = dayNumberOf(DateTime(2026, 11, 20));
    expect(s.streak(2026, 11).longest, 7);
    expect(s.streak(2026, 11).potential, 15);
    expect(s.canMakeUp(missed), isTrue);

    final outcome = await s.makeUp(missed);
    expect(outcome, isNotNull);
    expect(outcome!.day, missed);
    expect(outcome.daily, isEmpty);
    expect(outcome.longestBefore, 7);
    expect(outcome.longestAfter, 15);
    expect(outcome.gifts.map((g) => g.milestone), [14]);
    expect(s.isChecked(missed), isTrue);
    expect(s.canMakeUp(missed), isFalse);
    expect(await s.makeUp(missed), isNull);
    // Bù không làm mất lượt điểm danh hôm nay.
    expect(s.canCheckIn, isTrue);
  });

  test('cannot make up today, future days or days before install', () async {
    final s = service();
    nextDay();
    nextDay();
    final today = clock.today;
    expect(s.canMakeUp(today), isFalse);
    expect(s.canMakeUp(today + 1), isFalse);
    expect(s.canMakeUp(s.startDay - 1), isFalse);
    expect(s.canMakeUp(s.startDay), isTrue);
  });

  test('premium: 2 hints and 1 wand for the day, not stacking', () async {
    premium = true;
    final s = service();
    expect((await s.checkIn())!.daily, const [
      CheckInReward(PowerUp.hint, 2, daily: true),
      CheckInReward(PowerUp.wand, 1, daily: true),
    ]);
    var inv = await repository.getPowerUps();
    expect(inv.totalHints, 2);
    expect(inv.dailyHints, 2);

    // Hôm sau chưa điểm danh: lượt hôm qua đã hết hạn.
    nextDay();
    inv = await repository.getPowerUps();
    expect(inv.totalHints, 0);

    // Điểm danh: lại đúng 2, không cộng dồn.
    await s.checkIn();
    inv = await repository.getPowerUps();
    expect(inv.dailyHints, 2);
    expect(inv.dailyWands, 1);
  });

  test('premium: making up a day gives no today-only uses', () async {
    premium = true;
    final s = service();
    nextDay();
    final outcome = await s.makeUp(s.startDay);
    expect(outcome!.daily, isEmpty);
    expect((await repository.getPowerUps()).dailyHints, 0);
  });

  test('buying the pack after checking in gives today\'s uses', () async {
    final s = service();
    await s.checkIn();
    expect((await repository.getPowerUps()).dailyHints, 0);
    premium = true;
    await s.premiumChanged();
    expect((await repository.getPowerUps()).dailyHints, 2);
    // Gọi lại không phát thêm.
    await s.premiumChanged();
    expect((await repository.getPowerUps()).dailyHints, 2);
  });

  test('phone clock changes do not matter while online', () async {
    final s = service();
    await s.initialize();
    await s.checkIn();
    // Vặn giờ máy sang mai, giờ mạng vẫn là hôm nay.
    device = device.add(const Duration(days: 1));
    await clock.sync();
    expect(s.canCheckIn, isFalse);
  });

  test('offline clock rollback is blocked by the ratchet', () async {
    network.time = null;
    final s = service();
    await s.initialize();
    await s.checkIn();
    device = device.subtract(const Duration(days: 3));
    expect(s.canCheckIn, isFalse);
  });
}

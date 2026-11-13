import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/checkin/check_in_policy.dart';
import 'package:nonogram/checkin/check_in_service.dart';
import 'package:nonogram/checkin/game_clock.dart';
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

  test('free player: a gift every 5th check-in, added for good', () async {
    final s = service();
    for (var i = 1; i <= 15; i++) {
      final rewards = await s.checkIn();
      expect(rewards, isNotNull, reason: 'day $i');
      // Đã điểm danh hôm nay: không điểm danh lại được.
      expect(await s.checkIn(), isNull);
      nextDay();
    }
    expect(s.count, 15);
    expect(
      await repository.getPowerUps(),
      const PowerUpInventory(hints: 2, wands: 1),
    );
  });

  test('premium: 2 hints and 1 wand for the day, not stacking', () async {
    premium = true;
    final s = service();
    expect(await s.checkIn(), const [
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

  test('premium also gets the milestone gifts', () async {
    premium = true;
    final s = service();
    for (var i = 0; i < 5; i++) {
      await s.checkIn();
      if (i < 4) nextDay();
    }
    final inv = await repository.getPowerUps();
    expect(inv.hints, 1); // quà mốc, vĩnh viễn
    expect(inv.dailyHints, 2);
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

import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/models/power_up_inventory.dart';
import 'package:nonogram/premium/daily_reward.dart';
import 'package:nonogram/premium/premium_controller.dart';
import 'package:nonogram/premium/purchase_gateway.dart';

import '../mocks/fake_nonogram_repository.dart';
import '../mocks/fake_purchase_gateway.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakePurchaseGateway gateway;
  late FakeTrustedClock clock;
  late FakeNonogramRepository repository;
  late DateTime device;

  PremiumController controller({
    bool owned = false,
    DailyRewardState daily = const DailyRewardState(),
  }) {
    // Cửa hàng xác nhận lại trạng thái đã lưu (không phải hoàn tiền).
    if (owned) gateway.owned = {PremiumController.productId};
    final c = PremiumController.inMemory(
      gateway: gateway,
      clock: clock,
      owned: owned,
      daily: daily,
      deviceClock: () => device,
    )..attach(repository);
    addTearDown(c.dispose);
    return c;
  }

  setUp(() async {
    gateway = FakePurchaseGateway();
    clock = FakeTrustedClock(DateTime(2026, 11, 13, 9));
    device = DateTime(2026, 11, 13, 9);
    repository = FakeNonogramRepository();
    await repository.savePowerUps(const PowerUpInventory(hints: 0, wands: 0));
  });

  test('not owned: offers the pack with its price, ads stay on', () async {
    final c = controller();
    await c.initialize();
    expect(c.isPremium, isFalse);
    expect(c.canPurchase, isTrue);
    expect(c.price, '49.000 ₫');
    expect(c.adsRemoved, isFalse);
    expect(
      await repository.getPowerUps(),
      const PowerUpInventory(hints: 0, wands: 0),
    );
  });

  test('buying turns ads off and gives today\'s gift', () async {
    final c = controller();
    await c.initialize();
    expect(await c.buy(), PurchaseOutcome.purchased);
    expect(c.isPremium, isTrue);
    expect(c.adsRemoved, isTrue);
    expect(
      await repository.getPowerUps(),
      const PowerUpInventory(hints: 2, wands: 1),
    );
  });

  test('cancelled purchase changes nothing', () async {
    gateway.buyOutcome = PurchaseOutcome.cancelled;
    final c = controller();
    await c.initialize();
    expect(await c.buy(), PurchaseOutcome.cancelled);
    expect(c.isPremium, isFalse);
  });

  test('a pending purchase activates when it goes through', () async {
    gateway.buyOutcome = PurchaseOutcome.pending;
    final c = controller();
    await c.initialize();
    expect(await c.buy(), PurchaseOutcome.pending);
    expect(c.isPremium, isFalse);
    gateway.completePending(PremiumController.productId);
    await Future<void>.delayed(Duration.zero);
    expect(c.isPremium, isTrue);
  });

  test('restores the pack after reinstalling', () async {
    gateway.owned = {PremiumController.productId};
    final c = controller();
    await c.initialize();
    expect(c.isPremium, isTrue);
  });

  test('a refunded pack is taken back', () async {
    final c = controller(owned: true);
    gateway.owned = {};
    await c.initialize();
    expect(c.isPremium, isFalse);
  });

  test('offline: keeps the saved pack', () async {
    final c = controller(owned: true);
    gateway.owned = null;
    await c.initialize();
    expect(c.isPremium, isTrue);
  });

  test('daily gift tops up without stacking, once per day', () async {
    final c = controller(owned: true);
    await c.initialize();
    expect(
      await repository.getPowerUps(),
      const PowerUpInventory(hints: 2, wands: 1),
    );

    // Dùng hết trong ngày: không nhận thêm hôm nay.
    await repository.savePowerUps(const PowerUpInventory(hints: 0, wands: 0));
    expect(await c.claimDailyReward(), isNull);

    // Hôm sau còn 3 gợi ý: giữ 3, chỉ nạp gậy phép.
    await repository.savePowerUps(const PowerUpInventory(hints: 3, wands: 0));
    clock.time = DateTime(2026, 11, 14, 9);
    expect(
      await c.claimDailyReward(),
      const PowerUpInventory(hints: 3, wands: 1),
    );
  });

  test('uses network time, not the phone clock', () async {
    final c = controller(owned: true);
    await c.initialize();
    await repository.savePowerUps(const PowerUpInventory(hints: 0, wands: 0));

    // Vặn giờ máy sang mai: giờ mạng vẫn là hôm nay.
    device = DateTime(2026, 11, 14, 9);
    expect(await c.claimDailyReward(), isNull);
  });

  test('offline it falls back to the phone clock, rollback blocked', () async {
    final c = controller(owned: true);
    await c.initialize();
    await repository.savePowerUps(const PowerUpInventory(hints: 0, wands: 0));

    clock.time = null;
    device = DateTime(2026, 11, 14, 9);
    expect(await c.claimDailyReward(), isNotNull);

    // Lùi giờ máy về hôm qua rồi tới lại: không được thêm.
    await repository.savePowerUps(const PowerUpInventory(hints: 0, wands: 0));
    device = DateTime(2026, 11, 13, 9);
    expect(await c.claimDailyReward(), isNull);
    device = DateTime(2026, 11, 14, 9);
    expect(await c.claimDailyReward(), isNull);
  });

  test('no store on this device: nothing to sell', () async {
    gateway.available = false;
    final c = controller();
    await c.initialize();
    expect(c.canPurchase, isFalse);
    expect(await c.buy(), PurchaseOutcome.unavailable);
  });
}

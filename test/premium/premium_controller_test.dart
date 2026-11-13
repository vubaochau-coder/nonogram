import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/premium/premium_controller.dart';
import 'package:nonogram/premium/purchase_gateway.dart';

import '../mocks/fake_purchase_gateway.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakePurchaseGateway gateway;

  PremiumController controller({bool owned = false}) {
    // Cửa hàng xác nhận lại trạng thái đã lưu (không phải hoàn tiền).
    if (owned) gateway.owned = {PremiumController.productId};
    final c = PremiumController.inMemory(gateway: gateway, owned: owned);
    addTearDown(c.dispose);
    return c;
  }

  setUp(() => gateway = FakePurchaseGateway());

  test('not owned: offers the pack with its price, ads stay on', () async {
    final c = controller();
    await c.initialize();
    expect(c.isPremium, isFalse);
    expect(c.canPurchase, isTrue);
    expect(c.price, '49.000 ₫');
    expect(c.adsRemoved, isFalse);
  });

  test('buying turns ads off', () async {
    final c = controller();
    await c.initialize();
    expect(await c.buy(), PurchaseOutcome.purchased);
    expect(c.isPremium, isTrue);
    expect(c.adsRemoved, isTrue);
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

  test('no store on this device: nothing to sell', () async {
    gateway.available = false;
    final c = controller();
    await c.initialize();
    expect(c.canPurchase, isFalse);
    expect(await c.buy(), PurchaseOutcome.unavailable);
  });
}

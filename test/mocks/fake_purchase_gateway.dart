import 'dart:async';

import 'package:nonogram/premium/purchase_gateway.dart';
import 'package:nonogram/premium/trusted_clock.dart';

class FakePurchaseGateway implements PurchaseGateway {
  FakePurchaseGateway({
    this.available = true,
    this.price = '49.000 ₫',
    this.owned = const {},
    this.buyOutcome = PurchaseOutcome.purchased,
  });

  bool available;
  String? price;

  /// null = không hỏi được cửa hàng.
  Set<String>? owned;
  PurchaseOutcome buyOutcome;
  int buys = 0;
  final _purchased = StreamController<String>.broadcast();

  void completePending(String id) => _purchased.add(id);

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<String?> priceOf(String productId) async => price;

  @override
  Future<Set<String>?> ownedProducts() async => owned;

  @override
  Future<PurchaseOutcome> buy(String productId) async {
    buys++;
    return buyOutcome;
  }

  @override
  Stream<String> get purchased => _purchased.stream;

  @override
  void dispose() {}
}

class FakeTrustedClock implements TrustedClock {
  FakeTrustedClock(this.time);

  /// null = mất mạng.
  DateTime? time;

  @override
  Future<DateTime?> now() async => time;
}

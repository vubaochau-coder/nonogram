import 'dart:async';

import 'package:nonogram/premium/premium_controller.dart';
import 'package:nonogram/premium/purchase_gateway.dart';

import 'tester_settings.dart';

/// Cửa hàng của bản `dev`: chuyển giữa Google Play thật ([real]) và cửa hàng
/// giả theo [TesterSettings.store]. Đổi cửa hàng xong phải gọi
/// `PremiumController.refresh()` để hỏi lại.
class TesterPurchaseGateway implements PurchaseGateway {
  TesterPurchaseGateway({required this.settings, this.real}) {
    _realSub = real?.purchased.listen((id) {
      if (settings.store == TesterStore.real) _purchased.add(id);
    });
  }

  static const fakePrice = '49.000 ₫ (test)';

  final TesterSettings settings;

  /// Null khi máy không có Google Play Billing (iOS, web).
  final PurchaseGateway? real;

  final _purchased = StreamController<String>.broadcast();
  StreamSubscription<String>? _realSub;

  /// Giao dịch giả đang chờ thanh toán (đã bấm mua, kết quả "chờ").
  String? _pending;
  String? get pendingProduct => _pending;

  bool get _fake => settings.store == TesterStore.fake;

  @override
  Future<bool> isAvailable() async =>
      _fake || (await real?.isAvailable() ?? false);

  @override
  Future<String?> priceOf(String productId) async =>
      _fake ? fakePrice : await real?.priceOf(productId);

  @override
  Future<Set<String>?> ownedProducts() async {
    if (!_fake) return real?.ownedProducts();
    // Cửa hàng giả chỉ bán một gói nên chỉ cần một cờ.
    return settings.fakeOwned ? {PremiumController.productId} : {};
  }

  @override
  Future<PurchaseOutcome> buy(String productId) async {
    if (!_fake) return real?.buy(productId) ?? PurchaseOutcome.unavailable;
    // Giả độ trễ của màn thanh toán.
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final outcome = settings.fakeBuyOutcome;
    if (outcome == PurchaseOutcome.purchased) await settings.setFakeOwned(true);
    if (outcome == PurchaseOutcome.pending) _pending = productId;
    return outcome;
  }

  /// Giao dịch đang chờ vừa thanh toán xong (vd. đã trả tiền tại cửa hàng).
  Future<bool> completePending() async {
    final id = _pending;
    if (id == null) return false;
    _pending = null;
    await settings.setFakeOwned(true);
    _purchased.add(id);
    return true;
  }

  @override
  Stream<String> get purchased => _purchased.stream;

  @override
  void dispose() {
    _realSub?.cancel();
    real?.dispose();
    _purchased.close();
  }
}

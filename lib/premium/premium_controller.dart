import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nonogram/ads/ad_entitlements.dart';

import 'purchase_gateway.dart';

/// Gói "Chơi không quảng cáo" (mua một lần qua Google Play):
/// - tắt quảng cáo xen kẽ (quảng cáo có thưởng vẫn còn để lấy thêm lượt);
/// - mỗi lần điểm danh nhận thêm 2 gợi ý và 1 gậy phép dùng trong ngày (xem
///   `CheckInPolicy`).
///
/// Trạng thái đã mua được lưu trên máy để vẫn đúng khi mất mạng, và đối chiếu
/// lại với Google Play mỗi lần mở app (khôi phục khi cài lại, thu hồi khi đã
/// hoàn tiền).
class PremiumController extends ChangeNotifier implements AdEntitlements {
  PremiumController._(this._box, {required this.gateway, required bool owned})
    : _owned = owned;

  /// Mã sản phẩm trên Play Console (Sản phẩm trong ứng dụng, mua một lần).
  static const productId = 'remove_ads';

  /// Dùng chung box tuỳ chọn với `OnboardingPreferences`.
  static const _boxName = 'nonogram_preferences_v1';
  static const _ownedKey = 'premium_owned';

  final Box<dynamic>? _box;
  final PurchaseGateway gateway;

  bool _owned;
  bool _available = false;
  String? _price;
  bool _busy = false;
  StreamSubscription<String>? _purchasedSub;

  static Future<PremiumController> load({
    required PurchaseGateway gateway,
  }) async {
    Box<dynamic>? box;
    try {
      box = await Hive.openBox<dynamic>(_boxName);
    } catch (_) {}
    return PremiumController._(
      box,
      gateway: gateway,
      owned: box?.get(_ownedKey) == true,
    );
  }

  /// Dùng trong test: không lưu.
  @visibleForTesting
  PremiumController.inMemory({required this.gateway, bool owned = false})
    : _box = null,
      _owned = owned;

  /// Đã mua gói.
  bool get isPremium => _owned;

  /// Cửa hàng dùng được và có sản phẩm để bán.
  bool get canPurchase => _available && _price != null;

  /// Giá đã định dạng (vd. "49.000 ₫").
  String? get price => _price;

  /// Đang mua.
  bool get isBusy => _busy;

  @override
  bool get adsRemoved => _owned;

  /// Gọi một lần khi mở app: hỏi cửa hàng giá và các gói đã mua.
  Future<void> initialize() async {
    _purchasedSub = gateway.purchased.listen((id) {
      if (id == productId) _setOwned(true);
    });
    _available = await gateway.isAvailable();
    if (_available) {
      _price = await gateway.priceOf(productId);
      final owned = await gateway.ownedProducts();
      if (owned != null) await _setOwned(owned.contains(productId));
    }
    notifyListeners();
  }

  Future<PurchaseOutcome> buy() async {
    if (_busy) return PurchaseOutcome.failed;
    if (!_available) return PurchaseOutcome.unavailable;
    _busy = true;
    notifyListeners();
    try {
      final outcome = await gateway.buy(productId);
      if (outcome == PurchaseOutcome.purchased) await _setOwned(true);
      return outcome;
    } finally {
      _busy = false;
      notifyListeners();
    }
  }

  Future<void> _setOwned(bool owned) async {
    if (_owned == owned) return;
    _owned = owned;
    await _box?.put(_ownedKey, owned);
    notifyListeners();
  }

  @override
  void dispose() {
    _purchasedSub?.cancel();
    gateway.dispose();
    super.dispose();
  }
}

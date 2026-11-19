import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import 'purchase_gateway.dart';

/// Google Play Billing qua package `in_app_purchase`.
///
/// Mọi giao dịch thành công đều được xác nhận (`completePurchase`); Google
/// tự hoàn tiền những giao dịch không được xác nhận trong 3 ngày.
///
/// Có lúc Play không báo kết quả nào (người dùng rời app giữa chừng rồi mở
/// lại, sheet thanh toán bị đóng ngang...). Vì vậy khi app quay lại sau màn
/// thanh toán mà sau [resumeGrace] vẫn chưa có kết quả, hỏi lại Play các gói
/// đã sở hữu để kết thúc lượt mua, thay vì để nút mua chờ mãi.
class PlayBillingGateway implements PurchaseGateway {
  PlayBillingGateway({
    InAppPurchase? iap,
    this.resumeGrace = const Duration(seconds: 2),
  }) : _iap = iap ?? InAppPurchase.instance {
    _subscription = _iap.purchaseStream.listen(
      _onPurchases,
      onError: (Object e) => debugPrint('Purchase stream: $e'),
    );
  }

  final InAppPurchase _iap;
  late final StreamSubscription<List<PurchaseDetails>> _subscription;
  final _purchased = StreamController<String>.broadcast();
  final Map<String, ProductDetails> _products = {};
  final Map<String, Completer<PurchaseOutcome>> _pendingBuys = {};

  /// Thời gian chờ Play tự báo kết quả sau khi app quay lại.
  final Duration resumeGrace;

  /// Nghe app quay lại, chỉ trong lúc có lượt mua đang chờ.
  AppLifecycleListener? _lifecycle;
  Timer? _resumeCheck;

  @override
  Stream<String> get purchased => _purchased.stream;

  @override
  Future<bool> isAvailable() async {
    try {
      return await _iap.isAvailable();
    } catch (_) {
      return false;
    }
  }

  Future<ProductDetails?> _product(String id) async {
    final cached = _products[id];
    if (cached != null) return cached;
    try {
      final response = await _iap.queryProductDetails({id});
      for (final p in response.productDetails) {
        _products[p.id] = p;
      }
    } catch (e) {
      debugPrint('Query product $id: $e');
    }
    return _products[id];
  }

  @override
  Future<String?> priceOf(String productId) async =>
      (await _product(productId))?.price;

  @override
  Future<Set<String>?> ownedProducts() async {
    try {
      final addition =
          _iap.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
      final response = await addition.queryPastPurchases();
      if (response.error != null) return null;
      final owned = <String>{};
      for (final p in response.pastPurchases) {
        if (p.status == PurchaseStatus.purchased ||
            p.status == PurchaseStatus.restored) {
          owned.add(p.productID);
          if (p.pendingCompletePurchase) await _iap.completePurchase(p);
        }
      }
      return owned;
    } catch (e) {
      debugPrint('Query past purchases: $e');
      return null;
    }
  }

  @override
  Future<PurchaseOutcome> buy(String productId) async {
    final product = await _product(productId);
    if (product == null) return PurchaseOutcome.unavailable;
    final existing = _pendingBuys[productId];
    if (existing != null) return existing.future;
    final completer = _pendingBuys[productId] = Completer<PurchaseOutcome>();
    _lifecycle ??= AppLifecycleListener(onResume: _onResume);
    try {
      final started = await _iap.buyNonConsumable(
        purchaseParam: PurchaseParam(productDetails: product),
      );
      if (!started) _finish(productId, PurchaseOutcome.failed);
    } catch (e) {
      debugPrint('Buy $productId: $e');
      // Đã sở hữu thì Play báo lỗi "item already owned".
      final owned = await ownedProducts();
      _finish(
        productId,
        owned?.contains(productId) == true
            ? PurchaseOutcome.purchased
            : PurchaseOutcome.failed,
      );
    }
    return completer.future;
  }

  void _finish(String productId, PurchaseOutcome outcome) {
    final completer = _pendingBuys.remove(productId);
    if (completer != null && !completer.isCompleted) {
      completer.complete(outcome);
    }
    if (_pendingBuys.isEmpty) _stopWatchingResume();
  }

  void _onResume() {
    _resumeCheck?.cancel();
    _resumeCheck = Timer(resumeGrace, _settleStalledBuys);
  }

  /// App đã quay lại sau màn thanh toán mà Play vẫn im lặng: đã sở hữu thì
  /// coi như mua xong, chưa thì coi như người dùng đã bỏ.
  Future<void> _settleStalledBuys() async {
    if (_pendingBuys.isEmpty) return;
    final ids = _pendingBuys.keys.toList();
    final owned = await ownedProducts();
    for (final id in ids) {
      if (owned?.contains(id) == true) {
        _purchased.add(id);
        _finish(id, PurchaseOutcome.purchased);
      } else {
        _finish(id, PurchaseOutcome.cancelled);
      }
    }
  }

  void _stopWatchingResume() {
    _resumeCheck?.cancel();
    _resumeCheck = null;
    _lifecycle?.dispose();
    _lifecycle = null;
  }

  Future<void> _onPurchases(List<PurchaseDetails> purchases) async {
    for (final p in purchases) {
      switch (p.status) {
        case PurchaseStatus.pending:
          _finish(p.productID, PurchaseOutcome.pending);
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _purchased.add(p.productID);
          _finish(p.productID, PurchaseOutcome.purchased);
        case PurchaseStatus.canceled:
          _finish(p.productID, PurchaseOutcome.cancelled);
        case PurchaseStatus.error:
          debugPrint('Purchase error: ${p.error}');
          _finish(p.productID, PurchaseOutcome.failed);
      }
      if (p.pendingCompletePurchase) {
        try {
          await _iap.completePurchase(p);
        } catch (e) {
          debugPrint('Complete purchase: $e');
        }
      }
    }
  }

  @override
  void dispose() {
    _stopWatchingResume();
    _subscription.cancel();
    _purchased.close();
  }
}

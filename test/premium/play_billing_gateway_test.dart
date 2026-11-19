import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:nonogram/premium/play_billing_gateway.dart';
import 'package:nonogram/premium/purchase_gateway.dart';

/// Play giả: mở được màn thanh toán nhưng không tự báo kết quả.
class _SilentIap implements InAppPurchase {
  final purchases = StreamController<List<PurchaseDetails>>.broadcast();

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => purchases.stream;

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<ProductDetailsResponse> queryProductDetails(
    Set<String> identifiers,
  ) async => ProductDetailsResponse(
    productDetails: [
      for (final id in identifiers)
        ProductDetails(
          id: id,
          title: id,
          description: '',
          price: '49.000 ₫',
          rawPrice: 49000,
          currencyCode: 'VND',
        ),
    ],
    notFoundIDs: const [],
  );

  @override
  Future<bool> buyNonConsumable({required PurchaseParam purchaseParam}) async =>
      true;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Bỏ phần hỏi Play các gói đã mua (cần plugin Android thật).
class _TestGateway extends PlayBillingGateway {
  _TestGateway(InAppPurchase iap) : super(iap: iap);

  Set<String>? owned = {};

  @override
  Future<Set<String>?> ownedProducts() async => owned;
}

void _goBackground(WidgetTester tester) {
  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
}

void _comeBack(WidgetTester tester) {
  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
}

void main() {
  testWidgets('rời app giữa lúc mua rồi quay lại: kết thúc là đã huỷ', (
    tester,
  ) async {
    final iap = _SilentIap();
    final gateway = _TestGateway(iap);
    addTearDown(gateway.dispose);

    PurchaseOutcome? outcome;
    unawaited(gateway.buy('remove_ads').then((o) => outcome = o));
    await tester.pump();
    _goBackground(tester);
    await tester.pump();
    _comeBack(tester);
    await tester.pump(const Duration(seconds: 1));
    expect(outcome, isNull, reason: 'còn chờ Play tự báo kết quả');

    await tester.pump(const Duration(seconds: 2));
    expect(outcome, PurchaseOutcome.cancelled);
  });

  testWidgets('quay lại mà Play đã ghi nhận gói: coi như mua xong', (
    tester,
  ) async {
    final iap = _SilentIap();
    final gateway = _TestGateway(iap)..owned = {'remove_ads'};
    addTearDown(gateway.dispose);
    final purchased = <String>[];
    final sub = gateway.purchased.listen(purchased.add);
    addTearDown(sub.cancel);

    PurchaseOutcome? outcome;
    unawaited(gateway.buy('remove_ads').then((o) => outcome = o));
    await tester.pump();
    _goBackground(tester);
    _comeBack(tester);
    await tester.pump(const Duration(seconds: 3));

    expect(outcome, PurchaseOutcome.purchased);
    expect(purchased, ['remove_ads']);
  });

  testWidgets('Play báo kết quả kịp: không hỏi lại', (tester) async {
    final iap = _SilentIap();
    final gateway = _TestGateway(iap)..owned = {'remove_ads'};
    addTearDown(gateway.dispose);

    PurchaseOutcome? outcome;
    unawaited(gateway.buy('remove_ads').then((o) => outcome = o));
    await tester.pump();
    _goBackground(tester);
    _comeBack(tester);
    iap.purchases.add([
      PurchaseDetails(
        productID: 'remove_ads',
        verificationData: PurchaseVerificationData(
          localVerificationData: '',
          serverVerificationData: '',
          source: 'test',
        ),
        transactionDate: null,
        status: PurchaseStatus.canceled,
      ),
    ]);
    await tester.pump(const Duration(seconds: 3));

    expect(outcome, PurchaseOutcome.cancelled);
  });
}

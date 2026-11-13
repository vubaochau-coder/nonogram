import 'dart:async';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nonogram/ads/ad_entitlements.dart';
import 'package:nonogram/data/nonogram_repository.dart';
import 'package:nonogram/models/power_up_inventory.dart';

import 'daily_reward.dart';
import 'purchase_gateway.dart';
import 'trusted_clock.dart';

/// Gói "Chơi không quảng cáo" (mua một lần qua Google Play):
/// - tắt quảng cáo xen kẽ (quảng cáo có thưởng vẫn còn để lấy thêm lượt);
/// - mỗi ngày kho được nạp lên tối thiểu 2 gợi ý và 1 gậy phép
///   ([DailyRewardPolicy]).
///
/// Trạng thái đã mua được lưu trên máy để vẫn đúng khi mất mạng, và đối chiếu
/// lại với Google Play mỗi lần mở app (khôi phục khi cài lại, thu hồi khi đã
/// hoàn tiền).
class PremiumController extends ChangeNotifier
    with WidgetsBindingObserver
    implements AdEntitlements {
  PremiumController._(
    this._box, {
    required this.gateway,
    required this.clock,
    required bool owned,
    required DailyRewardState daily,
    DateTime Function()? deviceClock,
  }) : _owned = owned,
       _daily = daily,
       _deviceClock = deviceClock ?? DateTime.now;

  /// Mã sản phẩm trên Play Console (Sản phẩm trong ứng dụng, mua một lần).
  static const productId = 'remove_ads';

  /// Dùng chung box tuỳ chọn với `OnboardingPreferences`.
  static const _boxName = 'nonogram_preferences_v1';
  static const _ownedKey = 'premium_owned';
  static const _lastGrantKey = 'premium_daily_last_day';
  static const _maxSeenKey = 'premium_daily_max_seen_day';

  final Box<dynamic>? _box;
  final PurchaseGateway gateway;
  final TrustedClock clock;
  final DateTime Function() _deviceClock;

  bool _owned;
  DailyRewardState _daily;
  bool _available = false;
  String? _price;
  bool _busy = false;
  NonogramRepository? _repository;
  StreamSubscription<String>? _purchasedSub;
  Future<PowerUpInventory?>? _claiming;

  /// Gọi khi vừa nhận quà hằng ngày (kho có thay đổi), để báo người chơi.
  void Function(PowerUpInventory inventory)? onDailyReward;

  static Future<PremiumController> load({
    required PurchaseGateway gateway,
    required TrustedClock clock,
  }) async {
    Box<dynamic>? box;
    try {
      box = await Hive.openBox<dynamic>(_boxName);
    } catch (_) {}
    return PremiumController._(
      box,
      gateway: gateway,
      clock: clock,
      owned: box?.get(_ownedKey) == true,
      daily: DailyRewardState(
        lastGrantDay: box?.get(_lastGrantKey) as int?,
        maxSeenDay: box?.get(_maxSeenKey) as int?,
      ),
    );
  }

  /// Dùng trong test: không lưu.
  @visibleForTesting
  PremiumController.inMemory({
    required this.gateway,
    required this.clock,
    bool owned = false,
    DailyRewardState daily = const DailyRewardState(),
    DateTime Function()? deviceClock,
  }) : _box = null,
       _owned = owned,
       _daily = daily,
       _deviceClock = deviceClock ?? DateTime.now;

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
    WidgetsBinding.instance.addObserver(this);
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
    await claimDailyReward();
  }

  /// Kho của chế độ chơi đang mở (quà hằng ngày nạp vào đây).
  void attach(NonogramRepository repository) {
    _repository = repository;
    claimDailyReward();
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
    if (owned) await claimDailyReward();
  }

  /// Nạp quà hôm nay nếu chưa nhận. Trả về kho mới nếu có thay đổi.
  Future<PowerUpInventory?> claimDailyReward() =>
      _claiming ??= _claim().whenComplete(() => _claiming = null);

  Future<PowerUpInventory?> _claim() async {
    final repository = _repository;
    if (!_owned || repository == null) return null;

    // Giờ mạng nếu có, mất mạng thì giờ máy (bánh cóc vẫn chặn lùi giờ).
    final now = await clock.now() ?? _deviceClock();
    final decision = DailyRewardPolicy.decide(
      today: DailyRewardPolicy.dayOf(now),
      state: _daily,
    );
    _daily = decision.next;
    await _box?.putAll({
      if (_daily.lastGrantDay != null) _lastGrantKey: _daily.lastGrantDay,
      if (_daily.maxSeenDay != null) _maxSeenKey: _daily.maxSeenDay,
    });
    if (!decision.grant) return null;

    final current = await repository.getPowerUps();
    final next = PowerUpInventory(
      hints: max(current.hints, DailyRewardPolicy.hints),
      wands: max(current.wands, DailyRewardPolicy.wands),
    );
    if (next == current) return null;
    await repository.savePowerUps(next);
    onDailyReward?.call(next);
    return next;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Để app chạy qua đêm rồi mở lại: nhận quà ngày mới.
    if (state == AppLifecycleState.resumed) claimDailyReward();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _purchasedSub?.cancel();
    gateway.dispose();
    super.dispose();
  }
}

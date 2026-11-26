import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nonogram/premium/purchase_gateway.dart';

/// Cửa hàng mà gói "Chơi không quảng cáo" dùng ở bản `dev`.
enum TesterStore {
  /// Google Play thật (cần cài từ kênh thử nghiệm và tài khoản tester).
  real,

  /// Cửa hàng giả trong app: mua không tốn tiền, chọn được kết quả mua.
  fake,
}

/// Cài đặt của công cụ tester. Chỉ tạo ở flavor `dev`; bản `store` không có
/// đối tượng này nên mọi lối tắt của tester đều tắt.
///
/// Lưu trong box riêng để xoá được mà không đụng dữ liệu người chơi.
class TesterSettings extends ChangeNotifier {
  TesterSettings._(this._box) {
    _dayShift.value = Duration(days: _box?.get(_dayShiftKey) as int? ?? 0);
    _store = TesterStore.values.byName(
      _box?.get(_storeKey) as String? ?? TesterStore.fake.name,
    );
    _fakeOwned = _box?.get(_fakeOwnedKey) == true;
    _fakeBuyOutcome = PurchaseOutcome.values.byName(
      _box?.get(_fakeOutcomeKey) as String? ?? PurchaseOutcome.purchased.name,
    );
    _showSolveButton = _box?.get(_solveButtonKey) as bool? ?? true;
    _adsNoInterval = _box?.get(_adsNoIntervalKey) == true;
  }

  static const _boxName = 'nonogram_tester_v1';
  static const _dayShiftKey = 'day_shift';
  static const _storeKey = 'store';
  static const _fakeOwnedKey = 'fake_owned';
  static const _fakeOutcomeKey = 'fake_buy_outcome';
  static const _solveButtonKey = 'solve_button';
  static const _adsNoIntervalKey = 'ads_no_interval';

  final Box<dynamic>? _box;
  final _dayShift = ValueNotifier(Duration.zero);
  late TesterStore _store;
  late bool _fakeOwned;
  late PurchaseOutcome _fakeBuyOutcome;
  late bool _showSolveButton;
  late bool _adsNoInterval;

  static Future<TesterSettings> load() async {
    Box<dynamic>? box;
    try {
      box = await Hive.openBox<dynamic>(_boxName);
    } catch (_) {}
    return TesterSettings._(box);
  }

  /// Dùng trong test: không lưu.
  @visibleForTesting
  TesterSettings.inMemory() : this._(null);

  /// Giờ của game được tua thêm bao nhiêu (cộng vào `GameClock`).
  ValueListenable<Duration> get dayShift => _dayShift;
  int get dayShiftDays => _dayShift.value.inDays;

  Future<void> shiftDays(int days) => setDayShift(dayShiftDays + days);

  Future<void> setDayShift(int days) async {
    _dayShift.value = Duration(days: days);
    await _box?.put(_dayShiftKey, days);
    notifyListeners();
  }

  TesterStore get store => _store;
  Future<void> setStore(TesterStore value) async {
    _store = value;
    await _box?.put(_storeKey, value.name);
    notifyListeners();
  }

  /// Cửa hàng giả: đã mua gói chưa.
  bool get fakeOwned => _fakeOwned;
  Future<void> setFakeOwned(bool value) async {
    _fakeOwned = value;
    await _box?.put(_fakeOwnedKey, value);
    notifyListeners();
  }

  /// Cửa hàng giả: bấm mua thì ra kết quả gì.
  PurchaseOutcome get fakeBuyOutcome => _fakeBuyOutcome;
  Future<void> setFakeBuyOutcome(PurchaseOutcome value) async {
    _fakeBuyOutcome = value;
    await _box?.put(_fakeOutcomeKey, value.name);
    notifyListeners();
  }

  /// Hiện nút "Giải ngay" trên thanh tiêu đề màn chơi.
  bool get showSolveButton => _showSolveButton;
  Future<void> setShowSolveButton(bool value) async {
    _showSolveButton = value;
    await _box?.put(_solveButtonKey, value);
    notifyListeners();
  }

  /// Bỏ giãn cách quảng cáo xen kẽ: rời màn nào cũng hiện.
  bool get adsNoInterval => _adsNoInterval;
  Future<void> setAdsNoInterval(bool value) async {
    _adsNoInterval = value;
    await _box?.put(_adsNoIntervalKey, value);
    notifyListeners();
  }

  @override
  void dispose() {
    _dayShift.dispose();
    super.dispose();
  }
}

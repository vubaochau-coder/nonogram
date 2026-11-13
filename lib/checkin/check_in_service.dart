import 'dart:async';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nonogram/data/nonogram_repository.dart';
import 'package:nonogram/models/power_up_inventory.dart';

import 'check_in_policy.dart';
import 'game_clock.dart';

/// Điểm danh hằng ngày: lưu lịch sử, phát quà vào kho ([NonogramRepository]),
/// dựng lịch tháng cho màn điểm danh.
///
/// [isPremium] cho biết người chơi đã mua gói không quảng cáo chưa (quà
/// trong ngày). Mua gói sau khi đã điểm danh hôm nay thì nhận luôn quà trong
/// ngày của hôm nay ([premiumChanged]).
class CheckInService extends ChangeNotifier with WidgetsBindingObserver {
  CheckInService._(
    this._box, {
    required this.clock,
    required bool Function() isPremium,
    required Map<int, List<CheckInReward>> history,
    required int startDay,
    int? maxSeenDay,
    int? autoOpenDay,
  }) : _isPremium = isPremium,
       _history = history,
       _startDay = startDay,
       _maxSeenDay = maxSeenDay,
       _autoOpenDay = autoOpenDay;

  static const _boxName = 'nonogram_preferences_v1';
  static const _historyKey = 'checkin_history';
  static const _startKey = 'checkin_start_day';
  static const _maxSeenKey = 'checkin_max_seen_day';
  static const _autoOpenKey = 'checkin_auto_open_day';

  final Box<dynamic>? _box;
  final GameClock clock;
  final bool Function() _isPremium;
  final Map<int, List<CheckInReward>> _history;
  final int _startDay;
  int? _maxSeenDay;
  int? _autoOpenDay;
  NonogramRepository? _repository;
  bool _busy = false;

  static Future<CheckInService> load({
    required GameClock clock,
    required bool Function() isPremium,
  }) async {
    Box<dynamic>? box;
    try {
      box = await Hive.openBox<dynamic>(_boxName);
    } catch (_) {}
    final history = <int, List<CheckInReward>>{};
    final raw = box?.get(_historyKey);
    if (raw is Map) {
      for (final entry in raw.entries) {
        try {
          history[int.parse('${entry.key}')] = [
            for (final r in entry.value as List)
              CheckInReward.fromList(r as List),
          ];
        } catch (_) {}
      }
    }
    var start = box?.get(_startKey) as int?;
    if (start == null) {
      start = clock.today;
      await box?.put(_startKey, start);
    }
    return CheckInService._(
      box,
      clock: clock,
      isPremium: isPremium,
      history: history,
      startDay: start,
      maxSeenDay: box?.get(_maxSeenKey) as int?,
      autoOpenDay: box?.get(_autoOpenKey) as int?,
    );
  }

  /// Dùng trong test: không lưu.
  @visibleForTesting
  CheckInService.inMemory({
    required this.clock,
    bool Function()? isPremium,
    Map<int, List<CheckInReward>>? history,
    int? startDay,
    int? maxSeenDay,
  }) : _box = null,
       _isPremium = isPremium ?? (() => false),
       _history = history ?? {},
       _startDay = startDay ?? clock.today,
       _maxSeenDay = maxSeenDay,
       _autoOpenDay = null;

  int get today => clock.today;

  /// Ngày bắt đầu dùng app: lịch chỉ xem được từ tháng này.
  int get startDay => _startDay;

  /// Tổng số lần đã điểm danh.
  int get count => _history.length;

  int? get lastCheckInDay =>
      _history.isEmpty ? null : _history.keys.reduce(max);

  bool get checkedInToday => _history.containsKey(today);

  bool get canCheckIn => CheckInPolicy.canCheckIn(
    today: today,
    lastCheckInDay: lastCheckInDay,
    maxSeenDay: _maxSeenDay,
  );

  /// Hôm nay chưa tự mở màn điểm danh và còn điểm danh được.
  bool get shouldAutoOpen => canCheckIn && _autoOpenDay != today;

  bool get isPremium => _isPremium();

  Future<void> markAutoOpened() async {
    _autoOpenDay = today;
    await _box?.put(_autoOpenKey, today);
  }

  /// Gọi khi mở app: đồng bộ giờ mạng ở nền, theo dõi lúc mở lại app.
  Future<void> initialize() async {
    WidgetsBinding.instance.addObserver(this);
    clock.addListener(_onDayMaybeChanged);
    await _observeToday();
    await clock.sync();
    await _observeToday();
    notifyListeners();
  }

  /// Kho của chế độ chơi đang mở.
  void attach(NonogramRepository repository) => _repository = repository;

  void _onDayMaybeChanged() {
    _observeToday();
    notifyListeners();
  }

  /// Bánh cóc: nhớ ngày muộn nhất từng thấy.
  Future<void> _observeToday() async {
    final t = today;
    if (_maxSeenDay == null || t > _maxSeenDay!) {
      _maxSeenDay = t;
      await _box?.put(_maxSeenKey, t);
    }
  }

  /// Điểm danh hôm nay. Trả về quà nhận được; null nếu chưa điểm danh được.
  Future<List<CheckInReward>?> checkIn() async {
    final repository = _repository;
    if (_busy || repository == null) return null;
    _busy = true;
    try {
      await _observeToday();
      if (!canCheckIn) return null;
      final day = today;
      final rewards = CheckInPolicy.rewardsFor(count + 1, premium: isPremium);
      await _grant(repository, rewards, day);
      _history[day] = rewards;
      await _saveHistory();
      notifyListeners();
      return rewards;
    } finally {
      _busy = false;
    }
  }

  /// Vừa mua (hoặc khôi phục) gói: nếu hôm nay đã điểm danh mà chưa có quà
  /// trong ngày thì phát luôn.
  Future<void> premiumChanged() async {
    final repository = _repository;
    final day = today;
    final todays = _history[day];
    if (!isPremium || repository == null || todays == null) {
      notifyListeners();
      return;
    }
    if (todays.any((r) => r.daily)) return;
    final daily =
        CheckInPolicy.rewardsFor(
          0,
          premium: true,
        ).where((r) => r.daily).toList();
    await _grant(repository, daily, day);
    _history[day] = [...todays, ...daily];
    await _saveHistory();
    notifyListeners();
  }

  Future<void> _grant(
    NonogramRepository repository,
    List<CheckInReward> rewards,
    int day,
  ) async {
    var inventory = await repository.getPowerUps();
    var dailyHints = 0;
    var dailyWands = 0;
    for (final r in rewards) {
      if (!r.daily) {
        inventory = inventory.addPermanent(r.powerUp, r.amount);
      } else if (r.powerUp == PowerUp.hint) {
        dailyHints += r.amount;
      } else {
        dailyWands += r.amount;
      }
    }
    if (dailyHints > 0 || dailyWands > 0) {
      // Không cộng dồn: thay hẳn lượt trong ngày cũ.
      inventory = inventory.withDaily(
        hints: dailyHints,
        wands: dailyWands,
        day: day,
      );
    }
    await repository.savePowerUps(inventory);
  }

  Future<void> _saveHistory() async {
    await _box?.put(_historyKey, {
      for (final e in _history.entries)
        '${e.key}': [for (final r in e.value) r.toList()],
    });
  }

  CheckInMonth month(int year, int month) => CheckInPolicy.buildMonth(
    year: year,
    month: month,
    today: today,
    startDay: _startDay,
    history: _history,
    premium: isPremium,
  );

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    // Mở lại app (có thể đã sang ngày mới): đồng bộ giờ, cập nhật lịch.
    clock.sync().whenComplete(_onDayMaybeChanged);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    clock.removeListener(_onDayMaybeChanged);
    super.dispose();
  }
}

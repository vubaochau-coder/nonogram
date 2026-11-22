import 'dart:async';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nonogram/data/nonogram_repository.dart';
import 'package:nonogram/models/power_up_inventory.dart';

import 'check_in_policy.dart';
import 'game_clock.dart';

/// Kết quả một lần điểm danh (đúng ngày hoặc bù).
class CheckInOutcome {
  const CheckInOutcome({
    required this.day,
    required this.daily,
    required this.gifts,
    required this.longestBefore,
    required this.longestAfter,
  });

  /// Ngày vừa được điểm danh.
  final int day;

  /// Quà trong ngày của gói không quảng cáo (chỉ khi điểm danh đúng ngày).
  final List<CheckInReward> daily;

  /// Quà các mốc chuỗi vừa đạt, theo thứ tự mốc.
  final List<StreakGift> gifts;

  /// Chuỗi dài nhất của tháng chứa [day], trước và sau lần này.
  final int longestBefore;
  final int longestAfter;

  List<CheckInReward> get rewards => [
    ...daily,
    for (final g in gifts) g.reward,
  ];
}

/// Điểm danh hằng ngày: lưu lịch sử, bù ngày bỏ lỡ, phát quà vào kho
/// ([NonogramRepository]), dựng lịch tháng và chuỗi cho màn điểm danh.
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
    required Map<int, Set<int>> claims,
    int? maxSeenDay,
  }) : _isPremium = isPremium,
       _history = history,
       _startDay = startDay,
       _claims = claims,
       _maxSeenDay = maxSeenDay;

  static const _boxName = 'nonogram_preferences_v1';
  static const _historyKey = 'checkin_history';
  static const _startKey = 'checkin_start_day';
  static const _maxSeenKey = 'checkin_max_seen_day';
  static const _claimsKey = 'checkin_streak_claims';

  final Box<dynamic>? _box;
  final GameClock clock;
  final bool Function() _isPremium;
  final Map<int, List<CheckInReward>> _history;
  final int _startDay;

  /// Các mốc chuỗi đã nhận, theo tháng ([monthKeyOf]).
  final Map<int, Set<int>> _claims;
  int? _maxSeenDay;
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
    final claims = <int, Set<int>>{};
    final rawClaims = box?.get(_claimsKey);
    if (rawClaims is Map) {
      for (final entry in rawClaims.entries) {
        try {
          claims[int.parse('${entry.key}')] = {
            for (final m in entry.value as List) m as int,
          };
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
      claims: claims,
      maxSeenDay: box?.get(_maxSeenKey) as int?,
    );
  }

  /// Dùng trong test: không lưu.
  @visibleForTesting
  CheckInService.inMemory({
    required this.clock,
    bool Function()? isPremium,
    Map<int, List<CheckInReward>>? history,
    int? startDay,
    Map<int, Set<int>>? claims,
    int? maxSeenDay,
  }) : _box = null,
       _isPremium = isPremium ?? (() => false),
       _history = history ?? {},
       _startDay = startDay ?? clock.today,
       _claims = claims ?? {},
       _maxSeenDay = maxSeenDay;

  int get today => clock.today;

  /// Ngày bắt đầu dùng app: lịch chỉ xem được từ tháng này.
  int get startDay => _startDay;

  /// Tổng số ngày đã điểm danh (kể cả ngày bù).
  int get count => _history.length;

  bool isChecked(int day) => _history.containsKey(day);

  int? get lastCheckInDay =>
      _history.isEmpty ? null : _history.keys.reduce(max);

  bool get checkedInToday => _history.containsKey(today);

  bool get canCheckIn => CheckInPolicy.canCheckIn(
    today: today,
    lastCheckInDay: lastCheckInDay,
    maxSeenDay: _maxSeenDay,
  );

  bool get isPremium => _isPremium();

  bool canMakeUp(int day) => CheckInPolicy.canMakeUp(
    day: day,
    today: today,
    startDay: _startDay,
    checked: isChecked(day),
    maxSeenDay: _maxSeenDay,
  );

  /// Chuỗi của tháng [month] / [year].
  StreakStats streak(int year, int month) => CheckInPolicy.streakStats(
    year: year,
    month: month,
    today: today,
    startDay: _startDay,
    checkedDays: _history.keys.toSet(),
  );

  /// Các mốc chuỗi đã nhận trong tháng [month] / [year].
  Set<int> claimedMilestones(int year, int month) =>
      Set.unmodifiable(_claims[monthKeyOf(DateTime(year, month))] ?? const {});

  /// Gọi khi mở app: đồng bộ giờ mạng ở nền, theo dõi lúc mở lại app.
  Future<void> initialize() async {
    WidgetsBinding.instance.addObserver(this);
    clock.addListener(_onDayMaybeChanged);
    await _observeToday();
    await clock.sync();
    await _observeToday();
    notifyListeners();
  }

  /// Kho tiến độ và lượt gợi ý / gậy phép của người chơi.
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
  Future<CheckInOutcome?> checkIn() => _record(
    allowed: () => canCheckIn,
    day: () => today,
    daily: () => CheckInPolicy.dailyRewards(premium: isPremium),
  );

  /// Bù ngày bỏ lỡ [day] (gọi sau khi người chơi đã xem xong quảng cáo).
  /// Null nếu ngày đó không bù được.
  Future<CheckInOutcome?> makeUp(int day) => _record(
    allowed: () => canMakeUp(day),
    day: () => day,
    daily: () => const [],
  );

  Future<CheckInOutcome?> _record({
    required bool Function() allowed,
    required int Function() day,
    required List<CheckInReward> Function() daily,
  }) async {
    final repository = _repository;
    if (_busy || repository == null) return null;
    _busy = true;
    try {
      await _observeToday();
      if (!allowed()) return null;
      final d = day();
      final date = dateOfDayNumber(d);
      final key = monthKeyOf(date);
      final before = streak(date.year, date.month).longest;
      _history[d] = const [];
      final after = streak(date.year, date.month).longest;
      final gifts = CheckInPolicy.newGifts(
        longest: after,
        claimed: _claims[key] ?? const {},
      );
      final dailyRewards = daily();
      final outcome = CheckInOutcome(
        day: d,
        daily: dailyRewards,
        gifts: gifts,
        longestBefore: before,
        longestAfter: after,
      );
      await _grant(repository, outcome.rewards, today);
      _history[d] = outcome.rewards;
      if (gifts.isNotEmpty) {
        _claims[key] = {...?_claims[key], for (final g in gifts) g.milestone};
        await _saveClaims();
      }
      await _saveHistory();
      notifyListeners();
      return outcome;
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
    final daily = CheckInPolicy.dailyRewards(premium: true);
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

  Future<void> _saveClaims() async {
    await _box?.put(_claimsKey, {
      for (final e in _claims.entries) '${e.key}': e.value.toList(),
    });
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
    checkedDays: _history.keys.toSet(),
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

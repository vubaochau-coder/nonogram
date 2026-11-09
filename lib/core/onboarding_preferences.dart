import 'package:hive_flutter/hive_flutter.dart';

/// Ghi nhớ các hướng dẫn đã hiện cho người chơi: bài "Cách chơi" lần đầu mở
/// app, hướng dẫn thao tác trong màn chơi, và mẹo di chuyển trên màn lớn.
/// Dùng chung box tuỳ chọn với `AppThemeModeController`.
class OnboardingPreferences {
  OnboardingPreferences._(
    this._box, {
    required bool tutorialSeen,
    required bool playCoachSeen,
    required bool scrollTipSeen,
  }) : _tutorialSeen = tutorialSeen,
       _playCoachSeen = playCoachSeen,
       _scrollTipSeen = scrollTipSeen;

  static const _boxName = 'nonogram_preferences_v1';
  static const _tutorialSeenKey = 'tutorial_seen';
  static const _playCoachSeenKey = 'play_coach_seen';
  static const _scrollTipSeenKey = 'scroll_tip_seen';

  final Box<dynamic>? _box;
  bool _tutorialSeen;
  bool _playCoachSeen;
  bool _scrollTipSeen;

  /// Gọi sau `Hive.initFlutter()`.
  static Future<OnboardingPreferences> load() async {
    try {
      final box = await Hive.openBox<dynamic>(_boxName);
      return OnboardingPreferences._(
        box,
        tutorialSeen: box.get(_tutorialSeenKey) == true,
        playCoachSeen: box.get(_playCoachSeenKey) == true,
        scrollTipSeen: box.get(_scrollTipSeenKey) == true,
      );
    } catch (_) {
      return OnboardingPreferences._(
        null,
        tutorialSeen: false,
        playCoachSeen: false,
        scrollTipSeen: false,
      );
    }
  }

  /// Dùng trong test: không lưu.
  OnboardingPreferences.inMemory({
    bool tutorialSeen = false,
    bool playCoachSeen = false,
    bool scrollTipSeen = false,
  }) : _box = null,
       _tutorialSeen = tutorialSeen,
       _playCoachSeen = playCoachSeen,
       _scrollTipSeen = scrollTipSeen;

  bool get tutorialSeen => _tutorialSeen;

  /// Đã xem hướng dẫn các nút / cử chỉ trong màn chơi.
  bool get playCoachSeen => _playCoachSeen;

  /// Đã xem mẹo kéo bàn chơi trên màn lớn.
  bool get scrollTipSeen => _scrollTipSeen;

  Future<void> markTutorialSeen() async {
    if (_tutorialSeen) return;
    _tutorialSeen = true;
    await _box?.put(_tutorialSeenKey, true);
  }

  Future<void> markPlayCoachSeen() async {
    if (_playCoachSeen) return;
    _playCoachSeen = true;
    await _box?.put(_playCoachSeenKey, true);
  }

  Future<void> markScrollTipSeen() async {
    if (_scrollTipSeen) return;
    _scrollTipSeen = true;
    await _box?.put(_scrollTipSeenKey, true);
  }
}

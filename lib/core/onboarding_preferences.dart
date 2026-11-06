import 'package:hive_flutter/hive_flutter.dart';

/// Ghi nhớ người chơi đã được mở bài hướng dẫn "Cách chơi" lần đầu hay chưa.
/// Dùng chung box tuỳ chọn với `AppThemeModeController`.
class OnboardingPreferences {
  OnboardingPreferences._(this._box, this._tutorialSeen);

  static const _boxName = 'nonogram_preferences_v1';
  static const _tutorialSeenKey = 'tutorial_seen';

  final Box<dynamic>? _box;
  bool _tutorialSeen;

  /// Gọi sau `Hive.initFlutter()`.
  static Future<OnboardingPreferences> load() async {
    try {
      final box = await Hive.openBox<dynamic>(_boxName);
      return OnboardingPreferences._(box, box.get(_tutorialSeenKey) == true);
    } catch (_) {
      return OnboardingPreferences._(null, false);
    }
  }

  /// Dùng trong test: không lưu.
  OnboardingPreferences.inMemory({bool tutorialSeen = false})
    : _box = null,
      _tutorialSeen = tutorialSeen;

  bool get tutorialSeen => _tutorialSeen;

  Future<void> markTutorialSeen() async {
    if (_tutorialSeen) return;
    _tutorialSeen = true;
    await _box?.put(_tutorialSeenKey, true);
  }
}

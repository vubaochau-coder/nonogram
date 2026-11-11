import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Chế độ chơi: mỗi chế độ có bộ màn và tiến độ riêng.
enum PlayMode {
  /// Bộ màn có bản quyền, giống bản phát hành trên store.
  user(
    levelsPath: 'assets/levels',
    progressBoxName: 'nonogram_offline_user_v1',
  ),

  /// Bộ màn gốc lấy từ nonogram.org, chỉ có ở flavor `dev`.
  ///
  /// Dùng lại box tiến độ cũ (`nonogram_offline_v1`) để người đã chơi các bản
  /// thử trước đây không mất tiến độ.
  developer(
    levelsPath: 'assets/levels_dev',
    progressBoxName: 'nonogram_offline_v1',
  );

  const PlayMode({required this.levelsPath, required this.progressBoxName});

  /// Thư mục asset chứa `index.json` và các gói màn.
  final String levelsPath;

  /// Box Hive lưu tiến độ của chế độ này.
  final String progressBoxName;

  static PlayMode? tryParse(Object? name) {
    for (final mode in values) {
      if (mode.name == name) return mode;
    }
    return null;
  }
}

/// Ghi nhớ chế độ chơi chọn lần trước (dùng chung box tuỳ chọn với
/// `OnboardingPreferences`).
class PlayModePreferences {
  PlayModePreferences._(this._box, this._lastMode);

  static const _boxName = 'nonogram_preferences_v1';
  static const _lastModeKey = 'play_mode';

  final Box<dynamic>? _box;
  PlayMode? _lastMode;

  /// Gọi sau `Hive.initFlutter()`.
  static Future<PlayModePreferences> load() async {
    try {
      final box = await Hive.openBox<dynamic>(_boxName);
      return PlayModePreferences._(
        box,
        PlayMode.tryParse(box.get(_lastModeKey)),
      );
    } catch (_) {
      return PlayModePreferences._(null, null);
    }
  }

  /// Dùng trong test: không lưu.
  PlayModePreferences.inMemory([PlayMode? lastMode])
    : _box = null,
      _lastMode = lastMode;

  PlayMode? get lastMode => _lastMode;

  Future<void> save(PlayMode mode) async {
    _lastMode = mode;
    try {
      await _box?.put(_lastModeKey, mode.name);
    } catch (_) {}
  }
}

/// Cho phép quay lại màn chọn chế độ (chỉ có ở flavor `dev`).
class PlayModeSwitcher {
  const PlayModeSwitcher({required this.current, required this.switchMode});

  final PlayMode current;
  final VoidCallback switchMode;
}

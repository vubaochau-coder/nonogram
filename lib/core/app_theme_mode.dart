import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Chế độ giao diện người chơi chọn (Sáng / Tối / Theo hệ thống), lưu trên máy.
class AppThemeModeController extends ValueNotifier<ThemeMode> {
  AppThemeModeController._(this._box, ThemeMode initial) : super(initial);

  static const _boxName = 'nonogram_preferences_v1';
  static const _themeModeKey = 'theme_mode';

  final Box<dynamic>? _box;

  /// Gọi sau `Hive.initFlutter()`.
  static Future<AppThemeModeController> load() async {
    try {
      final box = await Hive.openBox<dynamic>(_boxName);
      final raw = box.get(_themeModeKey);
      final mode = ThemeMode.values.firstWhere(
        (m) => m.name == raw,
        orElse: () => ThemeMode.system,
      );
      return AppThemeModeController._(box, mode);
    } catch (_) {
      return AppThemeModeController._(null, ThemeMode.system);
    }
  }

  /// Dùng trong test: không lưu.
  AppThemeModeController.inMemory([super.initial = ThemeMode.system])
    : _box = null;

  Future<void> setMode(ThemeMode mode) async {
    if (value == mode) return;
    value = mode;
    await _box?.put(_themeModeKey, mode.name);
  }
}

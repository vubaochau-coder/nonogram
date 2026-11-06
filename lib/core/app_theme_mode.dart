import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Chế độ giao diện người chơi chọn: chỉ Sáng hoặc Tối (mặc định Sáng), lưu
/// trên máy.
class AppThemeModeController extends ValueNotifier<ThemeMode> {
  AppThemeModeController._(this._box, ThemeMode initial) : super(initial);

  static const _boxName = 'nonogram_preferences_v1';
  static const _themeModeKey = 'theme_mode';

  final Box<dynamic>? _box;

  /// Gọi sau `Hive.initFlutter()`. Giá trị cũ không phải `dark` (kể cả
  /// `system` từ bản trước) đều về Sáng.
  static Future<AppThemeModeController> load() async {
    try {
      final box = await Hive.openBox<dynamic>(_boxName);
      final raw = box.get(_themeModeKey);
      return AppThemeModeController._(box, _parse(raw));
    } catch (_) {
      return AppThemeModeController._(null, ThemeMode.light);
    }
  }

  static ThemeMode _parse(Object? raw) =>
      raw == ThemeMode.dark.name ? ThemeMode.dark : ThemeMode.light;

  /// Dùng trong test: không lưu.
  AppThemeModeController.inMemory([super.initial = ThemeMode.light])
    : _box = null;

  bool get isDark => value == ThemeMode.dark;

  /// Đổi qua lại Sáng ⇄ Tối.
  Future<void> toggle() => setMode(isDark ? ThemeMode.light : ThemeMode.dark);

  Future<void> setMode(ThemeMode mode) async {
    final next = mode == ThemeMode.dark ? ThemeMode.dark : ThemeMode.light;
    if (value == next) return;
    value = next;
    await _box?.put(_themeModeKey, next.name);
  }
}

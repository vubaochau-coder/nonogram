import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Màn ngang: bảng thông tin màn chơi đang mở hay thu gọn. Nhớ trên máy (box
/// tuỳ chọn mở sẵn lúc khởi động); test không có box thì mặc định mở.
abstract final class LandscapeInfoPanelVisibility {
  static const _boxName = 'nonogram_preferences_v1';
  static const _key = 'landscape_info_visible';

  static final ValueNotifier<bool> notifier = ValueNotifier(_read());

  static bool _read() {
    try {
      if (!Hive.isBoxOpen(_boxName)) return true;
      return Hive.box<dynamic>(_boxName).get(_key) != false;
    } catch (_) {
      return true;
    }
  }

  static void toggle() {
    notifier.value = !notifier.value;
    try {
      if (Hive.isBoxOpen(_boxName)) {
        Hive.box<dynamic>(_boxName).put(_key, notifier.value);
      }
    } catch (_) {}
  }
}

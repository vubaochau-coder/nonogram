import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Whether the play screen shows the clock (Settings). Hidden, the clock
/// still counts so completion times and records stay right. Kept on the
/// device in the preferences box opened at start-up; tests without the box
/// default to shown.
abstract final class PlayClockVisibility {
  static const _boxName = 'nonogram_preferences_v1';
  static const _key = 'play_clock_visible';

  static final ValueNotifier<bool> notifier = ValueNotifier(_read());

  static bool _read() {
    try {
      if (!Hive.isBoxOpen(_boxName)) return true;
      return Hive.box<dynamic>(_boxName).get(_key) != false;
    } catch (_) {
      return true;
    }
  }

  static void set(bool visible) {
    notifier.value = visible;
    try {
      if (Hive.isBoxOpen(_boxName)) {
        Hive.box<dynamic>(_boxName).put(_key, visible);
      }
    } catch (_) {}
  }
}

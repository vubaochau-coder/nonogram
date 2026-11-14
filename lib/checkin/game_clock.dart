import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nonogram/data/nonogram_repository.dart';

import 'trusted_clock.dart';

/// Giờ của game: giờ máy cộng độ lệch so với giờ mạng đo được lần gần nhất.
///
/// Chỉnh giờ điện thoại khi có mạng không có tác dụng: lần đồng bộ sau
/// ([sync], khi mở app / mở lại app) đo lại độ lệch. Mất mạng thì dùng độ
/// lệch đã lưu; còn ai tắt mạng rồi chỉnh giờ thì bánh cóc của điểm danh
/// chặn (xem `CheckInPolicy`).
///
/// [debugShift] (chỉ bản `dev`, công cụ tester): tua giờ của game thêm một
/// khoảng để test điểm danh / lượt trong ngày mà không phải chờ.
class GameClock extends ChangeNotifier {
  GameClock._(
    this._box,
    this._trusted,
    this._device,
    Duration offset, {
    ValueListenable<Duration>? debugShift,
  }) : _offset = offset,
       _debugShift = debugShift {
    _debugShift?.addListener(notifyListeners);
  }

  static const _boxName = 'nonogram_preferences_v1';
  static const _offsetKey = 'clock_offset_ms';

  final Box<dynamic>? _box;
  final TrustedClock _trusted;
  final DateTime Function() _device;
  Duration _offset;
  final ValueListenable<Duration>? _debugShift;

  static Future<GameClock> load({
    required TrustedClock trusted,
    ValueListenable<Duration>? debugShift,
  }) async {
    Box<dynamic>? box;
    try {
      box = await Hive.openBox<dynamic>(_boxName);
    } catch (_) {}
    final ms = box?.get(_offsetKey) as int? ?? 0;
    return GameClock._(
      box,
      trusted,
      DateTime.now,
      Duration(milliseconds: ms),
      debugShift: debugShift,
    );
  }

  /// Dùng trong test: không lưu.
  @visibleForTesting
  GameClock.inMemory({
    required TrustedClock trusted,
    DateTime Function()? device,
    Duration offset = Duration.zero,
    ValueListenable<Duration>? debugShift,
  }) : _box = null,
       _trusted = trusted,
       _device = device ?? DateTime.now,
       _offset = offset,
       _debugShift = debugShift {
    _debugShift?.addListener(notifyListeners);
  }

  DateTime now() =>
      _device().add(_offset).add(_debugShift?.value ?? Duration.zero);

  /// Số ngày kể từ 1970-01-01 theo lịch địa phương.
  int get today => dayNumberOf(now());

  /// Lúc hết ngày hôm nay (nửa đêm sắp tới).
  DateTime get endOfToday {
    final n = now();
    return DateTime(n.year, n.month, n.day + 1);
  }

  /// Đo lại độ lệch với giờ mạng. Trả về false nếu không lấy được giờ mạng.
  Future<bool> sync() async {
    final network = await _trusted.now();
    if (network == null) return false;
    final offset = network.difference(_device());
    // Bỏ qua lệch nhỏ (độ trễ mạng) để không ghi liên tục.
    if ((offset - _offset).abs() > const Duration(seconds: 30)) {
      final dayBefore = today;
      _offset = offset;
      await _box?.put(_offsetKey, offset.inMilliseconds);
      if (today != dayBefore) notifyListeners();
    }
    return true;
  }

  @override
  void dispose() {
    _debugShift?.removeListener(notifyListeners);
    super.dispose();
  }
}

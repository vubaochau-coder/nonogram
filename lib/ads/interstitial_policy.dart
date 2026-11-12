/// Quyết định khi nào hiện quảng cáo xen kẽ sau khi giải xong màn, để người
/// chơi không bị làm phiền quá nhiều:
///
/// - [graceLevels] màn đầu tiên mỗi lần mở app không có quảng cáo xen kẽ;
/// - sau đó cứ [everyLevels] màn giải xong mới hiện một lần;
/// - cách quảng cáo toàn màn hình trước đó (kể cả quảng cáo có thưởng người
///   chơi tự chọn xem) ít nhất [minInterval].
class InterstitialPolicy {
  InterstitialPolicy({
    InterstitialPolicyConfig config = const InterstitialPolicyConfig(),
    DateTime Function()? clock,
  }) : graceLevels = config.graceLevels,
       everyLevels = config.everyLevels,
       minInterval = config.minInterval,
       _clock = clock ?? DateTime.now;

  final int graceLevels;
  final int everyLevels;
  final Duration minInterval;
  final DateTime Function() _clock;

  int _completedLevels = 0;
  int _levelsSinceAd = 0;
  DateTime? _lastFullScreenAd;

  /// Ghi nhận một màn vừa giải xong; trả về true nếu nên hiện quảng cáo xen
  /// kẽ lúc này.
  bool recordLevelCompleted() {
    _completedLevels++;
    _levelsSinceAd++;
    if (_completedLevels <= graceLevels) return false;
    if (_levelsSinceAd < everyLevels) return false;
    final last = _lastFullScreenAd;
    if (last != null && _clock().difference(last) < minInterval) return false;
    return true;
  }

  /// Ghi nhận vừa hiện một quảng cáo toàn màn hình (xen kẽ hoặc có thưởng).
  void recordFullScreenAdShown() {
    _levelsSinceAd = 0;
    _lastFullScreenAd = _clock();
  }
}

/// Thông số của [InterstitialPolicy] (đọc được từ Remote Config).
class InterstitialPolicyConfig {
  const InterstitialPolicyConfig({
    this.graceLevels = 2,
    this.everyLevels = 3,
    this.minInterval = const Duration(minutes: 3),
  });

  final int graceLevels;
  final int everyLevels;
  final Duration minInterval;
}

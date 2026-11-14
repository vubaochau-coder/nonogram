/// Quyết định khi nào hiện quảng cáo xen kẽ lúc rời màn hoàn thành: chỉ theo
/// thời gian, không đếm số màn.
///
/// - Hiện khi đã qua [minInterval] kể từ quảng cáo xen kẽ trước đó. Quảng
///   cáo có thưởng (người chơi tự chọn xem) không tính.
/// - Chưa có quảng cáo nào thì tính từ lúc mở app, để người chơi không gặp
///   quảng cáo ngay khi vừa vào game.
/// - Đến lúc mà quảng cáo chưa tải xong thì lần rời màn sau thử lại.
class InterstitialPolicy {
  InterstitialPolicy({
    InterstitialPolicyConfig config = const InterstitialPolicyConfig(),
    DateTime Function()? clock,
    bool Function()? ignoreInterval,
  }) : minInterval = config.minInterval,
       _clock = clock ?? DateTime.now,
       _ignoreInterval = ignoreInterval {
    _since = _clock();
  }

  final Duration minInterval;
  final DateTime Function() _clock;

  /// Công cụ tester: bỏ giãn cách, rời màn nào cũng hiện quảng cáo xen kẽ.
  final bool Function()? _ignoreInterval;

  /// Lúc mở app, hoặc lúc hiện quảng cáo xen kẽ gần nhất.
  late DateTime _since;

  /// Người chơi vừa rời màn hoàn thành: có nên hiện quảng cáo xen kẽ không.
  bool shouldShowOnLevelExit() =>
      (_ignoreInterval?.call() ?? false) ||
      _clock().difference(_since) >= minInterval;

  /// Ghi nhận vừa hiện một quảng cáo xen kẽ.
  void recordInterstitialShown() => _since = _clock();
}

/// Thông số của [InterstitialPolicy] (đọc được từ Remote Config).
class InterstitialPolicyConfig {
  const InterstitialPolicyConfig({
    this.minInterval = const Duration(minutes: 5),
  });

  final Duration minInterval;
}

/// Dạng quảng cáo toàn màn hình.
enum AdFormat { rewarded, interstitial }

/// Chỗ đặt quảng cáo trong game. Game chỉ làm việc với các vị trí này, không
/// biết mạng quảng cáo nào đứng sau; mỗi vị trí có [id] ổn định để báo cáo
/// doanh thu theo vị trí (và làm placement name khi chuyển sang mediation như
/// AppLovin MAX / LevelPlay).
enum AdPlacement {
  /// Hết gợi ý: xem quảng cáo để dùng một gợi ý.
  hintRefill('hint_refill', AdFormat.rewarded),

  /// Hết gậy phép: xem quảng cáo để dùng một lượt gậy phép.
  wandRefill('wand_refill', AdFormat.rewarded),

  /// Rời màn hình hoàn thành (sang màn sau / về trang chính).
  levelComplete('level_complete', AdFormat.interstitial);

  const AdPlacement(this.id, this.format);

  final String id;
  final AdFormat format;
}

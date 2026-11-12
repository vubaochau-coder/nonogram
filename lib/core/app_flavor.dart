import 'package:flutter/services.dart' show appFlavor;

/// Bản build của app, chọn bằng `--flavor` khi build.
///
/// - [dev]: bản thử nội bộ (mặc định trên GitHub Actions). Có màn chọn chế độ
///   chơi và đóng gói thêm bộ màn của chế độ nhà phát triển.
/// - [store]: bản phát hành lên store. Không có màn chọn chế độ, chỉ có bộ màn
///   có bản quyền.
///
/// Build không truyền `--flavor` (iOS, web, `flutter test`) được coi là
/// [store]: bộ màn của chế độ nhà phát triển chỉ được đóng gói khi build flavor
/// `dev`, nên không thể bật chế độ đó ở các bản build này.
enum AppFlavor {
  dev,
  store;

  static AppFlavor get current => fromName(appFlavor);

  static AppFlavor fromName(String? name) => name == 'dev' ? dev : store;

  bool get hasPlayModeSelection => this == dev;

  /// Chỉ bản phát hành có quảng cáo; bản thử nội bộ để sạch.
  bool get hasAds => this == store;
}

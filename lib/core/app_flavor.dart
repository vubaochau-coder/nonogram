import 'package:flutter/services.dart' show appFlavor;

/// Bản build của app, chọn bằng `--flavor` khi build.
///
/// - [dev]: bản thử nội bộ (Distribute lên Firebase App Distribution). Có công
///   cụ tester và dùng ID quảng cáo thử nghiệm.
/// - [store]: bản phát hành lên store. Không có công cụ tester, dùng ID quảng
///   cáo thật.
///
/// Build không truyền `--flavor` (iOS, web, `flutter test`) được coi là
/// [store].
enum AppFlavor {
  dev,
  store;

  static AppFlavor get current => fromName(appFlavor);

  static AppFlavor fromName(String? name) => name == 'dev' ? dev : store;

  /// Công cụ tester (tua giờ, cửa hàng giả, giải ngay...) trong tab "Tôi".
  bool get hasTesterTools => this == dev;
}

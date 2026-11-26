import 'package:nonogram/core/app_flavor.dart';

import 'ad_placement.dart';
import 'interstitial_policy.dart';

/// Cấu hình quảng cáo, tách khỏi code để sau này đọc từ Remote Config (đổi
/// tần suất, ID mà không cần phát hành bản mới).
class AdConfig {
  const AdConfig({
    required this.unitIds,
    this.interstitial = const InterstitialPolicyConfig(),
  });

  /// ID đơn vị quảng cáo theo dạng. Với đấu giá / mediation, mỗi dạng thường
  /// chỉ cần một đơn vị; các mạng khác được thêm trên web AdMob.
  final Map<AdFormat, String> unitIds;

  final InterstitialPolicyConfig interstitial;

  /// Bản `store` dùng ID thật của Pixel Nonogram; bản `dev` dùng ID thử nghiệm của
  /// Google, để người thử nội bộ không bấm nhầm vào quảng cáo thật (AdMob có
  /// thể khoá tài khoản vì lượt bấm không hợp lệ).
  factory AdConfig.forFlavor(AppFlavor flavor) => AdConfig(
    unitIds: switch (flavor) {
      AppFlavor.store => const {
        AdFormat.rewarded: AppAdMobIds.rewarded,
        AdFormat.interstitial: AppAdMobIds.interstitial,
      },
      AppFlavor.dev => const {
        AdFormat.rewarded: AdMobTestIds.rewarded,
        AdFormat.interstitial: AdMobTestIds.interstitial,
      },
    },
  );
}

/// ID đơn vị quảng cáo thật của Pixel Nonogram trên AdMob (không phải bí mật: chúng
/// nằm sẵn trong APK). App ID tương ứng nằm trong android/app/build.gradle.kts.
class AppAdMobIds {
  AppAdMobIds._();

  /// Đơn vị "power_up_refill" (Quảng cáo có tặng thưởng).
  static const rewarded = 'ca-app-pub-8391885617554349/6022270752';

  /// Đơn vị "level_complete" (Trung gian).
  static const interstitial = 'ca-app-pub-8391885617554349/6489349626';
}

/// Máy của nhà phát triển: luôn nhận quảng cáo mẫu (có nhãn "Test Ad") kể cả
/// ở bản release dùng ID thật, để thử luồng quảng cáo mà không bấm vào quảng
/// cáo thật. Chỉ ảnh hưởng đúng các máy này.
///
/// Lấy mã: mở app trên máy, chạy `adb logcat | grep "setTestDeviceIds"`, chép
/// chuỗi trong dòng "Use RequestConfiguration.Builder().setTestDeviceIds(...)".
abstract final class AdTestDevices {
  static const ids = [
    // Poco X7 Pro.
    'DB4FF7003D8724BA6E3BFF2F10685548',
  ];
}

/// ID thử nghiệm của Google: luôn hiện quảng cáo mẫu, không tính tiền.
class AdMobTestIds {
  AdMobTestIds._();

  static const rewarded = 'ca-app-pub-3940256099942544/5224354917';
  static const interstitial = 'ca-app-pub-3940256099942544/1033173712';
}

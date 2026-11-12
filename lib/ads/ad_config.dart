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

  /// Bản `store` dùng ID thật của Nonopix; bản `dev` dùng ID thử nghiệm của
  /// Google, để người thử nội bộ không bấm nhầm vào quảng cáo thật (AdMob có
  /// thể khoá tài khoản vì lượt bấm không hợp lệ).
  factory AdConfig.forFlavor(AppFlavor flavor) => AdConfig(
    unitIds: switch (flavor) {
      AppFlavor.store => const {
        AdFormat.rewarded: NonopixAdMobIds.rewarded,
        AdFormat.interstitial: NonopixAdMobIds.interstitial,
      },
      AppFlavor.dev => const {
        AdFormat.rewarded: AdMobTestIds.rewarded,
        AdFormat.interstitial: AdMobTestIds.interstitial,
      },
    },
  );
}

/// ID đơn vị quảng cáo thật của Nonopix trên AdMob (không phải bí mật: chúng
/// nằm sẵn trong APK). App ID tương ứng nằm trong android/app/build.gradle.kts.
class NonopixAdMobIds {
  NonopixAdMobIds._();

  /// Đơn vị "power_up_refill" (Quảng cáo có tặng thưởng).
  static const rewarded = 'ca-app-pub-8391885617554349/6022270752';

  /// Đơn vị "level_complete" (Trung gian).
  static const interstitial = 'ca-app-pub-8391885617554349/6489349626';
}

/// ID thử nghiệm của Google: luôn hiện quảng cáo mẫu, không tính tiền.
class AdMobTestIds {
  AdMobTestIds._();

  static const rewarded = 'ca-app-pub-3940256099942544/5224354917';
  static const interstitial = 'ca-app-pub-3940256099942544/1033173712';
}

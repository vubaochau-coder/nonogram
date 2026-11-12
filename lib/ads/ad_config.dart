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

  /// ID truyền lúc build (`--dart-define`), mặc định là ID thử nghiệm.
  factory AdConfig.fromEnvironment() => const AdConfig(
    unitIds: {
      AdFormat.rewarded: String.fromEnvironment(
        'ADMOB_REWARDED_ID',
        defaultValue: AdMobTestIds.rewarded,
      ),
      AdFormat.interstitial: String.fromEnvironment(
        'ADMOB_INTERSTITIAL_ID',
        defaultValue: AdMobTestIds.interstitial,
      ),
    },
  );
}

/// ID thử nghiệm của Google: luôn hiện quảng cáo mẫu, không tính tiền.
///
/// Bản phát hành truyền ID thật lúc build:
///
/// ```bash
/// ADMOB_APP_ID=ca-app-pub-xxx~yyy flutter build appbundle --release \
///   --flavor store \
///   --dart-define=ADMOB_REWARDED_ID=ca-app-pub-xxx/zzz \
///   --dart-define=ADMOB_INTERSTITIAL_ID=ca-app-pub-xxx/www
/// ```
class AdMobTestIds {
  AdMobTestIds._();

  static const rewarded = 'ca-app-pub-3940256099942544/5224354917';
  static const interstitial = 'ca-app-pub-3940256099942544/1033173712';
}

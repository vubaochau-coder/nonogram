/// ID đơn vị quảng cáo AdMob (Android).
///
/// Mặc định là ID thử nghiệm của Google: luôn hiện quảng cáo mẫu, không tính
/// tiền, an toàn khi dev. Bản phát hành truyền ID thật lúc build:
///
/// ```bash
/// flutter build appbundle --release --flavor store \
///   --dart-define=ADMOB_REWARDED_ID=ca-app-pub-xxx/yyy \
///   --dart-define=ADMOB_INTERSTITIAL_ID=ca-app-pub-xxx/zzz
/// ```
///
/// App ID (dạng `ca-app-pub-xxx~yyy`) nằm trong AndroidManifest, truyền bằng
/// biến môi trường `ADMOB_APP_ID` (xem android/app/build.gradle.kts).
class AdUnitIds {
  AdUnitIds._();

  static const _testRewarded = 'ca-app-pub-3940256099942544/5224354917';
  static const _testInterstitial = 'ca-app-pub-3940256099942544/1033173712';

  static const rewarded = String.fromEnvironment(
    'ADMOB_REWARDED_ID',
    defaultValue: _testRewarded,
  );

  static const interstitial = String.fromEnvironment(
    'ADMOB_INTERSTITIAL_ID',
    defaultValue: _testInterstitial,
  );

  /// Đang dùng ID thử nghiệm (chưa truyền ID thật khi build).
  static bool get usingTestIds =>
      rewarded == _testRewarded || interstitial == _testInterstitial;
}

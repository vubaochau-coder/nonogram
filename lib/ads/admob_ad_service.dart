import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_service.dart';
import 'ad_unit_ids.dart';
import 'interstitial_policy.dart';

/// Quảng cáo qua Google AdMob: có thưởng (thêm lượt gợi ý / gậy phép) và xen
/// kẽ (sau khi giải xong màn, theo [InterstitialPolicy]).
///
/// Không có mạng thì quảng cáo không tải được: game vẫn chơi bình thường,
/// chỉ là không xem được quảng cáo để nhận thêm lượt.
class AdMobAdService extends AdService {
  AdMobAdService({InterstitialPolicy? policy})
    : _policy = policy ?? InterstitialPolicy();

  final InterstitialPolicy _policy;

  final _rewardedReady = ValueNotifier(false);
  final _privacyOptionsRequired = ValueNotifier(false);

  bool _sdkStarted = false;
  bool _showingFullScreen = false;

  RewardedAd? _rewarded;
  bool _loadingRewarded = false;
  int _rewardedRetries = 0;

  InterstitialAd? _interstitial;
  bool _loadingInterstitial = false;
  int _interstitialRetries = 0;

  @override
  bool get isEnabled => true;

  @override
  ValueListenable<bool> get rewardedReady => _rewardedReady;

  @override
  ValueListenable<bool> get privacyOptionsRequired => _privacyOptionsRequired;

  @override
  Future<void> initialize() async {
    await _gatherConsent();
    await _refreshPrivacyOptionsStatus();
    await _startSdkIfAllowed();
  }

  /// Hỏi ý kiến người dùng theo GDPR (chỉ hiện ở vùng bắt buộc, và chỉ khi
  /// chưa hỏi). Lỗi mạng thì bỏ qua: lần mở app sau sẽ hỏi lại.
  Future<void> _gatherConsent() {
    final done = Completer<void>();
    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () {
        ConsentForm.loadAndShowConsentFormIfRequired((error) {
          if (error != null) debugPrint('Consent form: ${error.message}');
          if (!done.isCompleted) done.complete();
        });
      },
      (error) {
        debugPrint('Consent info update: ${error.message}');
        if (!done.isCompleted) done.complete();
      },
    );
    return done.future;
  }

  Future<void> _refreshPrivacyOptionsStatus() async {
    final status =
        await ConsentInformation.instance.getPrivacyOptionsRequirementStatus();
    _privacyOptionsRequired.value =
        status == PrivacyOptionsRequirementStatus.required;
  }

  Future<void> _startSdkIfAllowed() async {
    if (_sdkStarted) return;
    if (!await ConsentInformation.instance.canRequestAds()) return;
    _sdkStarted = true;
    await MobileAds.instance.initialize();
    _loadRewarded();
    _loadInterstitial();
  }

  @override
  Future<void> showPrivacyOptions() {
    final done = Completer<void>();
    ConsentForm.showPrivacyOptionsForm((error) {
      if (error != null) debugPrint('Privacy options: ${error.message}');
      if (!done.isCompleted) done.complete();
    });
    return done.future.then((_) async {
      await _refreshPrivacyOptionsStatus();
      await _startSdkIfAllowed();
    });
  }

  // --- Quảng cáo có thưởng ---

  void _loadRewarded() {
    if (!_sdkStarted || _rewarded != null || _loadingRewarded) return;
    _loadingRewarded = true;
    RewardedAd.load(
      adUnitId: AdUnitIds.rewarded,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _loadingRewarded = false;
          _rewardedRetries = 0;
          _rewarded = ad;
          _rewardedReady.value = true;
        },
        onAdFailedToLoad: (error) {
          _loadingRewarded = false;
          debugPrint('Rewarded failed to load: ${error.message}');
          _retry(() => _rewardedRetries++, _loadRewarded);
        },
      ),
    );
  }

  @override
  Future<bool> showRewarded() async {
    final ad = _rewarded;
    if (ad == null || _showingFullScreen) {
      _loadRewarded();
      return false;
    }
    _rewarded = null;
    _rewardedReady.value = false;

    var earned = false;
    await _showFullScreen(ad, (onDismissed) {
      ad.fullScreenContentCallback = onDismissed;
      ad.show(onUserEarnedReward: (_, _) => earned = true);
    }, reload: _loadRewarded);
    return earned;
  }

  // --- Quảng cáo xen kẽ ---

  void _loadInterstitial() {
    if (!_sdkStarted || _interstitial != null || _loadingInterstitial) return;
    _loadingInterstitial = true;
    InterstitialAd.load(
      adUnitId: AdUnitIds.interstitial,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _loadingInterstitial = false;
          _interstitialRetries = 0;
          _interstitial = ad;
        },
        onAdFailedToLoad: (error) {
          _loadingInterstitial = false;
          debugPrint('Interstitial failed to load: ${error.message}');
          _retry(() => _interstitialRetries++, _loadInterstitial);
        },
      ),
    );
  }

  @override
  Future<void> onLevelCompleteExit() async {
    if (!_policy.recordLevelCompleted()) return;
    final ad = _interstitial;
    if (ad == null || _showingFullScreen) {
      _loadInterstitial();
      return;
    }
    _interstitial = null;
    await _showFullScreen(ad, (onDismissed) {
      ad.fullScreenContentCallback = onDismissed;
      ad.show();
    }, reload: _loadInterstitial);
  }

  // --- Dùng chung ---

  /// Hiện một quảng cáo toàn màn hình và đợi đến khi nó đóng (hoặc lỗi), rồi
  /// huỷ nó và tải sẵn cái tiếp theo.
  Future<void> _showFullScreen<T extends AdWithoutView>(
    T ad,
    void Function(FullScreenContentCallback<T> callback) show, {
    required VoidCallback reload,
  }) async {
    final closed = Completer<void>();
    void finish(T ad) {
      ad.dispose();
      if (!closed.isCompleted) closed.complete();
    }

    _showingFullScreen = true;
    show(
      FullScreenContentCallback<T>(
        onAdShowedFullScreenContent: (_) => _policy.recordFullScreenAdShown(),
        onAdDismissedFullScreenContent: finish,
        onAdFailedToShowFullScreenContent: (ad, error) {
          debugPrint('Ad failed to show: ${error.message}');
          finish(ad);
        },
      ),
    );
    await closed.future;
    _showingFullScreen = false;
    reload();
  }

  /// Tải lại sau 10 s, 20 s, 40 s... (tối đa ~5 phút), để không dồn yêu cầu
  /// khi mất mạng.
  void _retry(int Function() bumpAttempt, VoidCallback load) {
    final attempt = bumpAttempt();
    final seconds = (10 * (1 << attempt.clamp(0, 5))).clamp(10, 320);
    Timer(Duration(seconds: seconds), load);
  }
}

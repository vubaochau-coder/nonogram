import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../ad_events.dart';
import '../../ad_placement.dart';
import '../ad_network.dart';
import '../retry_backoff.dart';

/// Phần chung của khe quảng cáo toàn màn hình AdMob: giữ một quảng cáo đã
/// tải, hiện rồi tải lại, báo sự kiện và doanh thu.
abstract class _AdMobSlot<T extends AdWithoutView> implements FullScreenAdSlot {
  _AdMobSlot({required this.unitId, required this.events});

  final String unitId;
  final AdEventSink events;

  final _ready = ValueNotifier(false);
  final _retry = RetryBackoff();
  T? _ad;
  bool _loading = false;
  bool _disposed = false;

  @override
  ValueListenable<bool> get ready => _ready;

  /// Gọi API tải của AdMob cho dạng quảng cáo này.
  void loadAd(void Function(T ad) onLoaded, void Function(LoadAdError) onFail);

  /// Gọi API hiện quảng cáo; [onReward] chỉ có ý nghĩa với quảng cáo có
  /// thưởng.
  void showAd(T ad, VoidCallback onReward);

  void setCallback(T ad, FullScreenContentCallback<T> callback);

  @override
  void load() {
    if (_disposed || _ad != null || _loading) return;
    _loading = true;
    loadAd(
      (ad) {
        _loading = false;
        if (_disposed) {
          ad.dispose();
          return;
        }
        _retry.reset();
        _ad = ad;
        _ready.value = true;
        events.onEvent(AdLoaded(format: format, adSource: _source(ad)));
      },
      (error) {
        _loading = false;
        events.onEvent(AdLoadFailed(format: format, message: error.message));
        if (!_disposed) _retry.schedule(load);
      },
    );
  }

  @override
  Future<AdShowResult> show(AdPlacement placement) async {
    final ad = _ad;
    if (ad == null) {
      load();
      return AdShowResult.notShown;
    }
    _ad = null;
    _ready.value = false;

    final closed = Completer<void>();
    var shown = false;
    var rewarded = false;
    final source = _source(ad);

    ad.onPaidEvent = (_, valueMicros, precision, currencyCode) {
      events.onEvent(
        AdPaid(
          format: format,
          placement: placement,
          adSource: source,
          valueMicros: valueMicros,
          currencyCode: currencyCode,
          precision: precision.name,
        ),
      );
    };
    setCallback(
      ad,
      FullScreenContentCallback<T>(
        onAdShowedFullScreenContent: (_) {
          shown = true;
          events.onEvent(
            AdShown(format: format, placement: placement, adSource: source),
          );
        },
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          if (!closed.isCompleted) closed.complete();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          events.onEvent(
            AdShowFailed(
              format: format,
              placement: placement,
              message: error.message,
            ),
          );
          ad.dispose();
          if (!closed.isCompleted) closed.complete();
        },
      ),
    );
    showAd(ad, () {
      rewarded = true;
      events.onEvent(
        AdRewardEarned(format: format, placement: placement, adSource: source),
      );
    });

    await closed.future;
    load();
    return AdShowResult(shown: shown, rewarded: rewarded);
  }

  @override
  void dispose() {
    _disposed = true;
    _retry.dispose();
    _ad?.dispose();
    _ad = null;
  }

  static String? _source(Ad ad) =>
      ad.responseInfo?.loadedAdapterResponseInfo?.adSourceName;
}

class AdMobRewardedSlot extends _AdMobSlot<RewardedAd> {
  AdMobRewardedSlot({required super.unitId, required super.events});

  @override
  AdFormat get format => AdFormat.rewarded;

  @override
  void loadAd(onLoaded, onFail) => RewardedAd.load(
    adUnitId: unitId,
    request: const AdRequest(),
    rewardedAdLoadCallback: RewardedAdLoadCallback(
      onAdLoaded: onLoaded,
      onAdFailedToLoad: onFail,
    ),
  );

  @override
  void setCallback(RewardedAd ad, FullScreenContentCallback<RewardedAd> c) =>
      ad.fullScreenContentCallback = c;

  @override
  void showAd(RewardedAd ad, VoidCallback onReward) =>
      ad.show(onUserEarnedReward: (_, _) => onReward());
}

class AdMobInterstitialSlot extends _AdMobSlot<InterstitialAd> {
  AdMobInterstitialSlot({required super.unitId, required super.events});

  @override
  AdFormat get format => AdFormat.interstitial;

  @override
  void loadAd(onLoaded, onFail) => InterstitialAd.load(
    adUnitId: unitId,
    request: const AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(
      onAdLoaded: onLoaded,
      onAdFailedToLoad: onFail,
    ),
  );

  @override
  void setCallback(
    InterstitialAd ad,
    FullScreenContentCallback<InterstitialAd> c,
  ) => ad.fullScreenContentCallback = c;

  @override
  void showAd(InterstitialAd ad, VoidCallback onReward) => ad.show();
}

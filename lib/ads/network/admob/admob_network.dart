import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../ad_events.dart';
import '../../ad_placement.dart';
import '../ad_network.dart';
import 'admob_slot.dart';

/// Google AdMob. Bật đấu giá (bidding) với các mạng khác chỉ cần cấu hình
/// trên web AdMob và thêm package adapter tương ứng (`gma_mediation_*`), không
/// phải sửa lớp này.
class AdMobNetwork implements AdNetwork {
  AdMobNetwork();

  @override
  final ConsentGate consent = _UmpConsentGate();

  @override
  Future<void> initialize() => MobileAds.instance.initialize();

  @override
  FullScreenAdSlot createSlot({
    required AdFormat format,
    required String unitId,
    required AdEventSink events,
  }) => switch (format) {
    AdFormat.rewarded => AdMobRewardedSlot(unitId: unitId, events: events),
    AdFormat.interstitial => AdMobInterstitialSlot(
      unitId: unitId,
      events: events,
    ),
  };
}

/// Google User Messaging Platform: hỏi ý kiến theo GDPR (chỉ ở vùng bắt
/// buộc). Lỗi mạng thì bỏ qua, lần mở app sau sẽ hỏi lại.
class _UmpConsentGate implements ConsentGate {
  @override
  Future<void> gather() {
    final done = Completer<void>();
    void finish() {
      if (!done.isCompleted) done.complete();
    }

    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () => ConsentForm.loadAndShowConsentFormIfRequired((error) {
        if (error != null) debugPrint('Consent form: ${error.message}');
        finish();
      }),
      (error) {
        debugPrint('Consent info update: ${error.message}');
        finish();
      },
    );
    return done.future;
  }

  @override
  Future<bool> canRequestAds() => ConsentInformation.instance.canRequestAds();

  @override
  Future<bool> privacyOptionsRequired() async =>
      await ConsentInformation.instance.getPrivacyOptionsRequirementStatus() ==
      PrivacyOptionsRequirementStatus.required;

  @override
  Future<void> showPrivacyOptions() {
    final done = Completer<void>();
    ConsentForm.showPrivacyOptionsForm((error) {
      if (error != null) debugPrint('Privacy options: ${error.message}');
      if (!done.isCompleted) done.complete();
    });
    return done.future;
  }
}

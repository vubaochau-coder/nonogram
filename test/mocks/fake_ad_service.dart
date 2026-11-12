import 'package:flutter/foundation.dart';
import 'package:nonogram/ads/ad_service.dart';

/// Quảng cáo giả cho test: bật sẵn, tuỳ chỉnh được đã tải xong chưa và người
/// chơi có xem hết không.
class FakeAdService extends AdService {
  FakeAdService({this.ready = true, this.earnReward = true});

  bool ready;
  bool earnReward;
  final _privacy = ValueNotifier(false);

  final List<AdPlacement> rewardedShown = [];
  int levelExits = 0;
  int privacyShown = 0;

  set privacyRequired(bool value) => _privacy.value = value;

  @override
  bool get isEnabled => true;

  @override
  bool isReady(AdPlacement placement) => ready;

  @override
  ValueListenable<bool> get privacyOptionsRequired => _privacy;

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> showRewarded(AdPlacement placement) async {
    rewardedShown.add(placement);
    return earnReward;
  }

  @override
  Future<void> onLevelCompleteExit() async => levelExits++;

  @override
  Future<void> showPrivacyOptions() async => privacyShown++;
}

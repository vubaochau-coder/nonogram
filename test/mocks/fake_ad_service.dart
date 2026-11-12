import 'package:flutter/foundation.dart';
import 'package:nonogram/ads/ad_service.dart';

/// Quảng cáo giả cho test: bật sẵn, tuỳ chỉnh được đã tải xong chưa và người
/// chơi có xem hết không.
class FakeAdService extends AdService {
  FakeAdService({bool ready = true, this.earnReward = true})
    : _ready = ValueNotifier(ready);

  final ValueNotifier<bool> _ready;
  final _privacy = ValueNotifier(false);
  bool earnReward;

  int rewardedShown = 0;
  int levelExits = 0;

  set ready(bool value) => _ready.value = value;

  set privacyRequired(bool value) => _privacy.value = value;

  @override
  bool get isEnabled => true;

  @override
  ValueListenable<bool> get rewardedReady => _ready;

  @override
  ValueListenable<bool> get privacyOptionsRequired => _privacy;

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> showRewarded() async {
    rewardedShown++;
    return earnReward;
  }

  @override
  Future<void> onLevelCompleteExit() async => levelExits++;

  int privacyShown = 0;

  @override
  Future<void> showPrivacyOptions() async => privacyShown++;
}

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/ads/ad_config.dart';
import 'package:nonogram/ads/ad_entitlements.dart';
import 'package:nonogram/ads/ad_events.dart';
import 'package:nonogram/ads/ad_manager.dart';
import 'package:nonogram/ads/ad_service.dart';
import 'package:nonogram/ads/interstitial_policy.dart';
import 'package:nonogram/ads/network/ad_network.dart';

class _FakeConsent implements ConsentGate {
  bool allowed = true;
  bool privacyRequired = false;

  @override
  Future<void> gather() async {}

  @override
  Future<bool> canRequestAds() async => allowed;

  @override
  Future<bool> privacyOptionsRequired() async => privacyRequired;

  @override
  Future<void> showPrivacyOptions() async => allowed = true;
}

class _FakeSlot implements FullScreenAdSlot {
  _FakeSlot(this.format);

  @override
  final AdFormat format;

  @override
  final ValueNotifier<bool> ready = ValueNotifier(false);

  bool reward = true;
  final List<AdPlacement> shown = [];

  @override
  void load() => ready.value = true;

  @override
  Future<AdShowResult> show(AdPlacement placement) async {
    if (!ready.value) return AdShowResult.notShown;
    shown.add(placement);
    return AdShowResult(shown: true, rewarded: reward);
  }

  @override
  void dispose() {}
}

class _FakeNetwork implements AdNetwork {
  @override
  final _FakeConsent consent = _FakeConsent();

  bool initialized = false;
  final Map<AdFormat, _FakeSlot> slots = {};

  @override
  Future<void> initialize() async => initialized = true;

  @override
  FullScreenAdSlot createSlot({
    required AdFormat format,
    required String unitId,
    required AdEventSink events,
  }) => slots[format] = _FakeSlot(format);
}

class _Entitlements implements AdEntitlements {
  @override
  bool adsRemoved = false;
}

void main() {
  late _FakeNetwork network;
  late _Entitlements entitlements;
  late DateTime now;

  AdManager manager() => AdManager(
    network: network,
    config: AdConfig.fromEnvironment(),
    entitlements: entitlements,
    policy: InterstitialPolicy(
      config: const InterstitialPolicyConfig(graceLevels: 0, everyLevels: 1),
      clock: () => now,
    ),
  );

  setUp(() {
    network = _FakeNetwork();
    entitlements = _Entitlements();
    now = DateTime(2026, 1, 1, 12);
  });

  test('starts the SDK and preloads one slot per format', () async {
    final ads = manager();
    await ads.initialize();
    expect(network.initialized, isTrue);
    expect(network.slots.keys, unorderedEquals(AdFormat.values));
    expect(ads.isReady(AdPlacement.hintRefill), isTrue);
  });

  test('no consent: no SDK, no ads until privacy options allow it', () async {
    network.consent
      ..allowed = false
      ..privacyRequired = true;
    final ads = manager();
    await ads.initialize();
    expect(network.initialized, isFalse);
    expect(ads.privacyOptionsRequired.value, isTrue);
    expect(await ads.showRewarded(AdPlacement.hintRefill), isFalse);

    await ads.showPrivacyOptions();
    expect(network.initialized, isTrue);
  });

  test('rewarded ads report the placement and the reward', () async {
    final ads = manager();
    await ads.initialize();
    expect(await ads.showRewarded(AdPlacement.wandRefill), isTrue);
    expect(network.slots[AdFormat.rewarded]!.shown, [AdPlacement.wandRefill]);

    network.slots[AdFormat.rewarded]!.reward = false;
    expect(await ads.showRewarded(AdPlacement.hintRefill), isFalse);
  });

  test('a rewarded ad delays the next interstitial', () async {
    final ads = manager();
    await ads.initialize();
    final interstitial = network.slots[AdFormat.interstitial]!;

    await ads.showRewarded(AdPlacement.hintRefill);
    await ads.onLevelCompleteExit();
    expect(interstitial.shown, isEmpty);

    now = now.add(const Duration(minutes: 5));
    await ads.onLevelCompleteExit();
    expect(interstitial.shown, [AdPlacement.levelComplete]);
  });

  test('remove-ads purchase stops interstitials but keeps rewarded', () async {
    entitlements.adsRemoved = true;
    final ads = manager();
    await ads.initialize();

    await ads.onLevelCompleteExit();
    expect(network.slots[AdFormat.interstitial]!.shown, isEmpty);
    expect(await ads.showRewarded(AdPlacement.hintRefill), isTrue);
  });
}

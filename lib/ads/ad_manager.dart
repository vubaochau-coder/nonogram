import 'package:flutter/foundation.dart';

import 'ad_config.dart';
import 'ad_events.dart';
import 'ad_service.dart';
import 'interstitial_policy.dart';
import 'network/ad_network.dart';

/// Điều phối quảng cáo: xin đồng ý, giữ sẵn mỗi dạng một khe quảng cáo, áp
/// giới hạn tần suất, ghi sự kiện. Không phụ thuộc mạng quảng cáo cụ thể:
/// mọi thứ riêng của AdMob nằm trong [AdNetwork].
///
/// Trước khi hiện quảng cáo xen kẽ, kiểm tra lần lượt: giới hạn tần suất
/// ([InterstitialPolicy]) → đã tải sẵn chưa. Quảng cáo có thưởng chỉ cần đã
/// tải sẵn.
class AdManager extends AdService {
  AdManager({
    required AdNetwork network,
    required AdConfig config,
    AdEventSink events = const DebugAdEventSink(),
    InterstitialPolicy? policy,
  }) : _network = network,
       _config = config,
       _events = events,
       _policy = policy ?? InterstitialPolicy(config: config.interstitial);

  final AdNetwork _network;
  final AdConfig _config;
  final AdEventSink _events;
  final InterstitialPolicy _policy;

  final _privacyOptionsRequired = ValueNotifier(false);
  final Map<AdFormat, FullScreenAdSlot> _slots = {};
  bool _started = false;
  bool _showing = false;

  @override
  bool get isEnabled => true;

  @override
  bool isReady(AdPlacement placement) =>
      _slots[placement.format]?.ready.value ?? false;

  @override
  ValueListenable<bool> get privacyOptionsRequired => _privacyOptionsRequired;

  @override
  Future<void> initialize() async {
    await _network.consent.gather();
    await _refreshPrivacyStatus();
    await _startIfAllowed();
  }

  Future<void> _refreshPrivacyStatus() async {
    _privacyOptionsRequired.value =
        await _network.consent.privacyOptionsRequired();
  }

  Future<void> _startIfAllowed() async {
    if (_started) return;
    if (!await _network.consent.canRequestAds()) return;
    _started = true;
    await _network.initialize();
    for (final entry in _config.unitIds.entries) {
      _slots[entry.key] = _network.createSlot(
        format: entry.key,
        unitId: entry.value,
        events: _events,
      )..load();
    }
  }

  @override
  Future<void> showPrivacyOptions() async {
    await _network.consent.showPrivacyOptions();
    await _refreshPrivacyStatus();
    await _startIfAllowed();
  }

  @override
  Future<bool> showRewarded(AdPlacement placement) async {
    assert(placement.format == AdFormat.rewarded);
    final result = await _show(placement);
    return result.rewarded;
  }

  @override
  Future<void> onLevelCompleteExit() async {
    if (!_policy.shouldShowOnLevelExit()) return;
    await _show(AdPlacement.levelComplete);
  }

  Future<AdShowResult> _show(AdPlacement placement) async {
    final slot = _slots[placement.format];
    if (slot == null || _showing) return AdShowResult.notShown;
    _showing = true;
    try {
      final result = await slot.show(placement);
      // Chỉ quảng cáo xen kẽ mới tính lại giãn cách; quảng cáo có thưởng
      // (người chơi tự chọn xem) không ảnh hưởng.
      if (result.shown && placement.format == AdFormat.interstitial) {
        _policy.recordInterstitialShown();
      }
      return result;
    } finally {
      _showing = false;
    }
  }
}

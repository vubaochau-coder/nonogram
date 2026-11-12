import 'package:flutter/foundation.dart';

import '../ad_events.dart';
import '../ad_placement.dart';

/// Một mạng / nền tảng mediation quảng cáo (AdMob hôm nay; AppLovin MAX,
/// LevelPlay... sau này). Đổi nền tảng = viết một [AdNetwork] mới, phần còn
/// lại của game không đổi.
abstract class AdNetwork {
  /// Xin đồng ý (GDPR...) theo cách của nền tảng.
  ConsentGate get consent;

  /// Khởi động SDK (chỉ gọi khi [ConsentGate.canRequestAds]).
  Future<void> initialize();

  /// Một "khe" quảng cáo toàn màn hình cho [format], dùng ID [unitId].
  FullScreenAdSlot createSlot({
    required AdFormat format,
    required String unitId,
    required AdEventSink events,
  });
}

/// Hỏi ý kiến đồng ý quảng cáo.
abstract class ConsentGate {
  /// Cập nhật trạng thái và hiện hộp thoại nếu bắt buộc (chỉ khi chưa hỏi).
  Future<void> gather();

  Future<bool> canRequestAds();

  /// Người dùng phải đổi lại được lựa chọn (cần nút trong cài đặt).
  Future<bool> privacyOptionsRequired();

  Future<void> showPrivacyOptions();
}

/// Kết quả hiện một quảng cáo toàn màn hình.
class AdShowResult {
  const AdShowResult({required this.shown, this.rewarded = false});

  static const notShown = AdShowResult(shown: false);

  /// Quảng cáo đã thực sự hiện lên.
  final bool shown;

  /// Người xem đã xem đủ để nhận thưởng (chỉ với quảng cáo có thưởng).
  final bool rewarded;
}

/// Giữ sẵn một quảng cáo toàn màn hình đã tải: tự tải lại sau khi hiện, tự
/// thử lại (có giãn cách) khi tải lỗi.
abstract class FullScreenAdSlot {
  AdFormat get format;

  ValueListenable<bool> get ready;

  void load();

  /// Hiện quảng cáo đang giữ cho [placement] và đợi đến khi nó đóng.
  Future<AdShowResult> show(AdPlacement placement);

  void dispose();
}

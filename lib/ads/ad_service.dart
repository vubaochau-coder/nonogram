import 'package:flutter/foundation.dart';

import 'ad_placement.dart';

export 'ad_placement.dart';

/// Quảng cáo nhìn từ phía game: chỉ có vị trí đặt ([AdPlacement]), không có
/// mạng quảng cáo. Bản cài đặt thật là `AdManager`; test và các bản không có
/// quảng cáo (iOS, web) dùng [NoAdService].
abstract class AdService {
  const AdService();

  /// Có quảng cáo hay không. Không có thì game cho lượt miễn phí ở những chỗ
  /// lẽ ra phải xem quảng cáo (để bản web vẫn chơi được).
  bool get isEnabled;

  /// Quảng cáo cho [placement] đã tải xong, hiện được ngay.
  bool isReady(AdPlacement placement);

  /// Có cần nút "Quyền riêng tư quảng cáo" trong cài đặt không (người dùng ở
  /// vùng áp dụng GDPR phải đổi được lựa chọn đồng ý).
  ValueListenable<bool> get privacyOptionsRequired;

  /// Xin đồng ý (nếu cần), khởi động SDK và tải sẵn quảng cáo.
  Future<void> initialize();

  /// Hiện quảng cáo có thưởng ở [placement], đợi người xem đóng. Trả về true
  /// nếu đã xem đủ để nhận thưởng.
  Future<bool> showRewarded(AdPlacement placement);

  /// Người chơi rời màn hình hoàn thành. Có thể hiện quảng cáo xen kẽ (theo
  /// giới hạn tần suất), đợi đến khi nó đóng.
  Future<void> onLevelCompleteExit();

  /// Mở lại hộp thoại lựa chọn đồng ý quảng cáo.
  Future<void> showPrivacyOptions();
}

/// Không có quảng cáo.
class NoAdService extends AdService {
  NoAdService();

  static final _off = ValueNotifier(false);

  @override
  bool get isEnabled => false;

  @override
  bool isReady(AdPlacement placement) => false;

  @override
  ValueListenable<bool> get privacyOptionsRequired => _off;

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> showRewarded(AdPlacement placement) async => false;

  @override
  Future<void> onLevelCompleteExit() async {}

  @override
  Future<void> showPrivacyOptions() async {}
}

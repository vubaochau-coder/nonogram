import 'package:flutter/foundation.dart';

/// Phần thưởng của quảng cáo có thưởng: thêm lượt gợi ý hoặc gậy phép.
enum AdReward { hint, wand }

/// Quảng cáo trong game. Màn chơi chỉ làm việc với lớp này, nên test và các
/// bản không có quảng cáo (flavor `dev`, iOS, web) dùng [NoAdService].
abstract class AdService {
  const AdService();

  /// Có quảng cáo hay không. Tắt thì nút gợi ý / gậy phép hết lượt vẫn bị
  /// vô hiệu hoá như trước.
  bool get isEnabled;

  /// Quảng cáo có thưởng đã tải xong, sẵn sàng hiện.
  ValueListenable<bool> get rewardedReady;

  /// Có cần nút "Quyền riêng tư quảng cáo" trong cài đặt không (người dùng ở
  /// vùng áp dụng GDPR phải đổi được lựa chọn đồng ý).
  ValueListenable<bool> get privacyOptionsRequired;

  /// Xin đồng ý (nếu cần), khởi động SDK và tải sẵn quảng cáo.
  Future<void> initialize();

  /// Hiện quảng cáo có thưởng, đợi người chơi đóng. Trả về true nếu người
  /// chơi đã xem đủ để nhận thưởng.
  Future<bool> showRewarded();

  /// Gọi khi người chơi rời màn hình hoàn thành (sang màn sau / về trang
  /// chính). Có thể hiện quảng cáo xen kẽ, đợi đến khi nó đóng.
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
  ValueListenable<bool> get rewardedReady => _off;

  @override
  ValueListenable<bool> get privacyOptionsRequired => _off;

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> showRewarded() async => false;

  @override
  Future<void> onLevelCompleteExit() async {}

  @override
  Future<void> showPrivacyOptions() async {}
}

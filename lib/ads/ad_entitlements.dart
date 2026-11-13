/// Quyền lợi đã mua liên quan tới quảng cáo (gói "Chơi không quảng cáo").
abstract class AdEntitlements {
  /// Đã mua gói: tắt quảng cáo xen kẽ. Quảng cáo có thưởng vẫn giữ, vì người
  /// chơi tự chọn xem để nhận thêm lượt.
  bool get adsRemoved;
}

class NoAdEntitlements implements AdEntitlements {
  const NoAdEntitlements();

  @override
  bool get adsRemoved => false;
}

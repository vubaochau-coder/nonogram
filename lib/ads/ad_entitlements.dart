/// Quyền lợi đã mua liên quan tới quảng cáo. Hôm nay chưa bán gói nào; khi
/// có gói "Xoá quảng cáo" (Google Play Billing), chỉ cần một lớp cài đặt đọc
/// trạng thái mua hàng.
abstract class AdEntitlements {
  /// Đã mua gói xoá quảng cáo: tắt quảng cáo xen kẽ (và banner nếu có). Quảng
  /// cáo có thưởng vẫn giữ, vì người chơi tự chọn xem để nhận lượt.
  bool get adsRemoved;
}

class NoAdEntitlements implements AdEntitlements {
  const NoAdEntitlements();

  @override
  bool get adsRemoved => false;
}

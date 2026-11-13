/// Kết quả một lần bấm mua.
enum PurchaseOutcome {
  /// Đã mua (hoặc đã sở hữu từ trước).
  purchased,

  /// Đang chờ thanh toán xong (vd. trả tiền mặt tại cửa hàng); khi xong sẽ
  /// tự kích hoạt.
  pending,

  /// Người dùng tự đóng màn hình thanh toán.
  cancelled,

  failed,

  /// Cửa hàng không dùng được / chưa có sản phẩm.
  unavailable,
}

/// Cửa hàng bán hàng trong app (Google Play Billing hôm nay). Tách ra để test
/// và để sau này thêm App Store.
abstract class PurchaseGateway {
  /// Cửa hàng có dùng được trên máy này không.
  Future<bool> isAvailable();

  /// Giá đã định dạng theo tiền của người dùng (vd. "49.000 ₫"); null nếu
  /// không tìm thấy sản phẩm.
  Future<String?> priceOf(String productId);

  /// Các sản phẩm người dùng đang sở hữu; null nếu không hỏi được cửa hàng
  /// (khi đó giữ nguyên trạng thái đã lưu).
  Future<Set<String>?> ownedProducts();

  Future<PurchaseOutcome> buy(String productId);

  /// Sản phẩm vừa được mua / khôi phục ngoài lúc bấm mua (vd. giao dịch chờ
  /// vừa hoàn tất).
  Stream<String> get purchased;

  void dispose();
}

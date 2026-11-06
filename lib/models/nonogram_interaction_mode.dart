/// Chạm vào ô sẽ làm gì.
enum NonogramInteractionMode {
  /// Chạm = tô / xoá ô tô, kéo = tô liên tiếp, nhấn giữ = đánh X.
  fill,

  /// Chạm = đánh / bỏ X, kéo = đánh X liên tiếp, nhấn giữ = tô.
  mark;

  /// Mã lưu trong ván dở. Bản cũ lưu 0 = "bàn tay", 1 = "tô", nên giữ 1
  /// cho tô và dùng 2 cho X; mọi giá trị khác đọc thành tô.
  int get storageCode => this == mark ? 2 : 1;

  static NonogramInteractionMode fromStorageCode(int? code) =>
      code == 2 ? mark : fill;
}

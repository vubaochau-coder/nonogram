/// Số con số bị khuất của một hàng / cột trong dải gợi ý đang bị cắt.
///
/// Dải gợi ý chỉ hiện một khung [visibleExtent] (tối đa 30% màn hình) và
/// cuộn được. Phía nào của dãy số còn số khuất thì ở mép phía đó hiện một
/// chip "+n" to bằng một ô số, đè lên ô số ngoài cùng; vì vậy n đếm cả số bị
/// chip che, để người chơi luôn biết còn bao nhiêu số chưa thấy.
class ClueOverflow {
  const ClueOverflow({required this.far, required this.near});

  static const none = ClueOverflow(far: 0, near: 0);

  /// Số con số chưa thấy ở phía xa lưới (bên trái của hàng / phía trên của
  /// cột), kể cả số nằm dưới chip.
  final int far;

  /// Số con số chưa thấy ở phía sát lưới (khi đã cuộn dải ra xa).
  final int near;

  bool get any => far > 0 || near > 0;

  /// [count] số trong dãy, mỗi số dày [depth]. [scroll] là khoảng đã cuộn
  /// dải ra phía xa (0 = số sát lưới nằm sát mép lưới).
  static ClueOverflow of({
    required int count,
    required double depth,
    required double visibleExtent,
    required double scroll,
  }) {
    if (count == 0 || depth <= 0) return none;
    const eps = 0.5;
    // Số thứ i (0 = sát lưới) chiếm đoạn [i*depth - scroll, (i+1)*depth -
    // scroll], tính từ mép lưới ra xa; phần nhìn thấy là [0, visibleExtent].
    double start(int i) => i * depth - scroll;
    double end(int i) => (i + 1) * depth - scroll;

    var farHidden = false;
    var nearHidden = false;
    for (var i = 0; i < count; i++) {
      if (end(i) > visibleExtent + eps) farHidden = true;
      if (start(i) < -eps) nearHidden = true;
    }

    var far = 0;
    var near = 0;
    for (var i = 0; i < count; i++) {
      // Chip phía xa chiếm ô số cuối cùng của khung nhìn.
      if (farHidden && end(i) > visibleExtent - depth + eps) far++;
      // Chip phía gần chiếm ô số đầu tiên của khung nhìn.
      if (nearHidden && start(i) < depth - eps) near++;
    }
    return ClueOverflow(far: far, near: near);
  }
}

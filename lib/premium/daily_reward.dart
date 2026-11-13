import 'dart:math';

/// Quà hằng ngày của gói không quảng cáo: mỗi ngày kho được nạp lên tối
/// thiểu [hints] gợi ý và [wands] gậy phép (không cộng dồn: còn nhiều hơn
/// thì giữ nguyên, ngày không chơi thì mất).
///
/// Chống chỉnh giờ điện thoại:
/// - "Hôm nay" lấy theo giờ mạng ([TrustedClock]) khi có mạng; mất mạng mới
///   dùng giờ máy.
/// - Bánh cóc: nhớ ngày muộn nhất từng thấy và ngày đã phát gần nhất, chỉ
///   phát khi sang một ngày mới hơn cả hai. Lùi giờ thì không được gì; vặn
///   giờ tới trước chỉ "vay" lượt của tương lai, chỉnh lại giờ đúng thì phải
///   đợi tới ngày đã vặn tới mới được nhận tiếp.
class DailyRewardPolicy {
  const DailyRewardPolicy._();

  static const hints = 2;
  static const wands = 1;

  /// Số ngày kể từ 1970-01-01 theo lịch địa phương của [time].
  static int dayOf(DateTime time) {
    final local = time.toLocal();
    return DateTime.utc(
          local.year,
          local.month,
          local.day,
        ).millisecondsSinceEpoch ~/
        Duration.millisecondsPerDay;
  }

  static DailyRewardDecision decide({
    required int today,
    required DailyRewardState state,
  }) {
    final maxSeen = max(state.maxSeenDay ?? today, today);
    final last = state.lastGrantDay;
    // Hôm nay phải là ngày muộn nhất từng thấy (không lùi giờ) và sau ngày
    // đã phát gần nhất.
    final grant = today == maxSeen && (last == null || today > last);
    return DailyRewardDecision(
      grant: grant,
      next: DailyRewardState(
        lastGrantDay: grant ? today : last,
        maxSeenDay: maxSeen,
      ),
    );
  }
}

class DailyRewardState {
  const DailyRewardState({this.lastGrantDay, this.maxSeenDay});

  /// Ngày đã phát quà gần nhất.
  final int? lastGrantDay;

  /// Ngày muộn nhất từng thấy.
  final int? maxSeenDay;
}

class DailyRewardDecision {
  const DailyRewardDecision({required this.grant, required this.next});

  final bool grant;
  final DailyRewardState next;
}

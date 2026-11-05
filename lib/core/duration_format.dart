import 'package:flutter/widgets.dart';
import 'package:nonogram/core/context_ext.dart';

extension DurationFormat on BuildContext {
  /// "3m 05s" cho thời gian ngắn, "2h 14m" khi từ một giờ trở lên.
  String formatPlayTime(int milliseconds) {
    final d = Duration(milliseconds: milliseconds);
    if (d.inHours > 0) {
      return l10n.nonogramDurationHoursMinutes(d.inHours, d.inMinutes % 60);
    }
    return l10n.nonogramPlayDurationFormat(d.inMinutes, d.inSeconds % 60);
  }
}

import 'package:flutter/foundation.dart';

import 'ad_placement.dart';

/// Sự kiện quảng cáo, để đo hiệu quả từng vị trí và từng nguồn quảng cáo
/// (quan trọng khi bật đấu giá: biết mạng nào thắng, trả bao nhiêu).
sealed class AdEvent {
  const AdEvent({required this.format, this.placement, this.adSource});

  final AdFormat format;

  /// Null với sự kiện tải (quảng cáo chưa gắn với vị trí nào).
  final AdPlacement? placement;

  /// Nguồn quảng cáo đã thắng (vd. "AdMob Network", "Meta Audience Network").
  final String? adSource;
}

class AdLoaded extends AdEvent {
  const AdLoaded({required super.format, super.adSource});
}

class AdLoadFailed extends AdEvent {
  const AdLoadFailed({required super.format, required this.message});
  final String message;
}

class AdShown extends AdEvent {
  const AdShown({required super.format, super.placement, super.adSource});
}

class AdShowFailed extends AdEvent {
  const AdShowFailed({
    required super.format,
    super.placement,
    required this.message,
  });
  final String message;
}

class AdRewardEarned extends AdEvent {
  const AdRewardEarned({
    required super.format,
    super.placement,
    super.adSource,
  });
}

/// Doanh thu của một lượt hiển thị (impression-level revenue).
class AdPaid extends AdEvent {
  const AdPaid({
    required super.format,
    super.placement,
    super.adSource,
    required this.valueMicros,
    required this.currencyCode,
    required this.precision,
  });

  /// Giá trị tính bằng micro (1.000.000 = 1 đơn vị tiền).
  final double valueMicros;
  final String currencyCode;

  /// unknown / estimated / publisherProvided / precise.
  final String precision;
}

/// Nơi nhận sự kiện quảng cáo. Sau này nối vào Firebase Analytics / AppsFlyer
/// / Adjust bằng một lớp mới, không phải sửa phần quảng cáo.
abstract class AdEventSink {
  void onEvent(AdEvent event);
}

/// Ghi sự kiện ra log khi debug.
class DebugAdEventSink implements AdEventSink {
  const DebugAdEventSink();

  @override
  void onEvent(AdEvent event) {
    if (!kDebugMode) return;
    final where = [
      event.format.name,
      if (event.placement != null) event.placement!.id,
      if (event.adSource != null) event.adSource!,
    ].join(' / ');
    final detail = switch (event) {
      AdPaid(:final valueMicros, :final currencyCode) =>
        ' ${valueMicros / 1e6} $currencyCode',
      AdLoadFailed(:final message) ||
      AdShowFailed(:final message) => ' $message',
      _ => '',
    };
    debugPrint('[ads] ${event.runtimeType} $where$detail');
  }
}

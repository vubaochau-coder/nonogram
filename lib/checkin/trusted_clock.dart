import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

/// Giờ không phụ thuộc đồng hồ của điện thoại.
abstract class TrustedClock {
  /// Giờ hiện tại (UTC), hoặc null nếu không lấy được (mất mạng...).
  Future<DateTime?> now();
}

/// Đọc header `Date` trong phản hồi HTTPS của một server Google (yêu cầu
/// rất nhẹ, trả về 204 không có nội dung). HTTPS nên không giả được bằng
/// cách chỉnh máy.
class NetworkTrustedClock implements TrustedClock {
  NetworkTrustedClock({
    Uri? endpoint,
    this.timeout = const Duration(seconds: 5),
  }) : endpoint = endpoint ?? Uri.parse('https://www.google.com/generate_204');

  final Uri endpoint;
  final Duration timeout;

  @override
  Future<DateTime?> now() async {
    final client = HttpClient()..connectionTimeout = timeout;
    try {
      final request = await client.headUrl(endpoint).timeout(timeout);
      final response = await request.close().timeout(timeout);
      await response.drain<void>();
      final date = response.headers.value(HttpHeaders.dateHeader);
      return date == null ? null : HttpDate.parse(date);
    } catch (e) {
      debugPrint('Trusted clock: $e');
      return null;
    } finally {
      client.close(force: true);
    }
  }
}

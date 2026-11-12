import 'dart:async';

/// Thử lại sau 10 s, 20 s, 40 s... (tối đa ~5 phút), để không dồn yêu cầu khi
/// mất mạng.
class RetryBackoff {
  int _attempt = 0;
  Timer? _timer;

  void reset() {
    _attempt = 0;
    _timer?.cancel();
    _timer = null;
  }

  void schedule(void Function() action) {
    _timer?.cancel();
    final seconds = 10 * (1 << _attempt.clamp(0, 5));
    _attempt++;
    _timer = Timer(Duration(seconds: seconds), action);
  }

  void dispose() => _timer?.cancel();
}

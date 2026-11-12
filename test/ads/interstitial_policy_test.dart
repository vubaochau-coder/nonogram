import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/ads/interstitial_policy.dart';

void main() {
  late DateTime now;
  InterstitialPolicy policy() => InterstitialPolicy(clock: () => now);

  setUp(() => now = DateTime(2026, 1, 1, 12));

  test('no interstitial during the first levels of a session', () {
    final p = policy();
    expect(p.recordLevelCompleted(), isFalse);
    expect(p.recordLevelCompleted(), isFalse);
    // Màn thứ 3: đã qua 2 màn miễn và đủ 3 màn.
    expect(p.recordLevelCompleted(), isTrue);
  });

  test('then at most one every 3 levels', () {
    final p = policy();
    for (var i = 0; i < 2; i++) {
      p.recordLevelCompleted();
    }
    expect(p.recordLevelCompleted(), isTrue);
    p.recordFullScreenAdShown();

    now = now.add(const Duration(minutes: 10));
    expect(p.recordLevelCompleted(), isFalse);
    expect(p.recordLevelCompleted(), isFalse);
    expect(p.recordLevelCompleted(), isTrue);
  });

  test('waits at least 3 minutes after any full-screen ad', () {
    final p = policy();
    for (var i = 0; i < 2; i++) {
      p.recordLevelCompleted();
    }
    // Người chơi vừa xem quảng cáo có thưởng.
    p.recordFullScreenAdShown();
    for (var i = 0; i < 2; i++) {
      expect(p.recordLevelCompleted(), isFalse);
    }
    now = now.add(const Duration(minutes: 1));
    expect(p.recordLevelCompleted(), isFalse);
    now = now.add(const Duration(minutes: 2));
    expect(p.recordLevelCompleted(), isTrue);
  });

  test('an ad that failed to load is offered on the next level', () {
    final p = policy();
    for (var i = 0; i < 2; i++) {
      p.recordLevelCompleted();
    }
    expect(p.recordLevelCompleted(), isTrue);
    // Không hiện được (chưa tải xong): màn sau thử lại.
    expect(p.recordLevelCompleted(), isTrue);
  });
}

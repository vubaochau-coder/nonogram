import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/ads/interstitial_policy.dart';

void main() {
  late DateTime now;
  late InterstitialPolicy policy;

  setUp(() {
    now = DateTime(2026, 1, 1, 12);
    policy = InterstitialPolicy(clock: () => now);
  });

  void wait(int minutes) => now = now.add(Duration(minutes: minutes));

  test('no interstitial in the first 5 minutes after opening the app', () {
    wait(4);
    expect(policy.shouldShowOnLevelExit(), isFalse);
    wait(1);
    expect(policy.shouldShowOnLevelExit(), isTrue);
  });

  test('then one every 5 minutes, however many levels are solved', () {
    wait(5);
    expect(policy.shouldShowOnLevelExit(), isTrue);
    policy.recordInterstitialShown();

    // Giải nhiều màn nhanh: không có quảng cáo cho tới khi đủ 5 phút.
    for (var i = 0; i < 10; i++) {
      expect(policy.shouldShowOnLevelExit(), isFalse);
    }
    wait(5);
    expect(policy.shouldShowOnLevelExit(), isTrue);
  });

  test('an ad that was not ready is offered on the next level exit', () {
    wait(5);
    expect(policy.shouldShowOnLevelExit(), isTrue);
    expect(policy.shouldShowOnLevelExit(), isTrue);
  });
}

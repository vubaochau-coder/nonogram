import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/premium/daily_reward.dart';

void main() {
  DailyRewardDecision decide(int today, [DailyRewardState? state]) =>
      DailyRewardPolicy.decide(
        today: today,
        state: state ?? const DailyRewardState(),
      );

  test('first day grants', () {
    final d = decide(100);
    expect(d.grant, isTrue);
    expect(d.next.lastGrantDay, 100);
    expect(d.next.maxSeenDay, 100);
  });

  test('once per day', () {
    final first = decide(100);
    expect(decide(100, first.next).grant, isFalse);
    expect(decide(101, first.next).grant, isTrue);
  });

  test('turning the clock back gives nothing', () {
    final state = decide(100).next;
    expect(decide(99, state).grant, isFalse);
    expect(decide(90, state).next.maxSeenDay, 100);
  });

  test('jumping ahead only borrows future days', () {
    // Ngày thật là 100, đã nhận. Vặn tới 105: nhận sớm một lần.
    var state = decide(100).next;
    final jumped = decide(105, state);
    expect(jumped.grant, isTrue);
    state = jumped.next;
    // Chỉnh lại giờ đúng: không nhận gì cho tới khi qua ngày 105.
    for (var day = 101; day <= 105; day++) {
      final d = decide(day, state);
      expect(d.grant, isFalse, reason: 'day $day');
      state = d.next;
    }
    expect(decide(106, state).grant, isTrue);
  });

  test('dayOf uses the local calendar day', () {
    final a = DailyRewardPolicy.dayOf(DateTime(2026, 11, 13, 0, 1));
    final b = DailyRewardPolicy.dayOf(DateTime(2026, 11, 13, 23, 59));
    final c = DailyRewardPolicy.dayOf(DateTime(2026, 11, 14, 0, 1));
    expect(a, b);
    expect(c, a + 1);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/rating/rating_policy.dart';

void main() {
  const policy = RatingPolicy();

  bool ask(int solved, [RatingState state = const RatingState()]) =>
      policy.shouldPrompt(solvedLevels: solved, state: state);

  test('first asks after 5 solved levels', () {
    expect(ask(4), isFalse);
    expect(ask(5), isTrue);
  });

  test('"later" asks again 15 levels later, at most 3 times', () {
    const once = RatingState(prompts: 1, lastPromptSolved: 5);
    expect(ask(19, once), isFalse);
    expect(ask(20, once), isTrue);
    expect(
      ask(200, const RatingState(prompts: 3, lastPromptSolved: 35)),
      isFalse,
    );
  });

  test('never asks again once a rating was given', () {
    expect(ask(100, const RatingState(answered: true, prompts: 1)), isFalse);
  });
}

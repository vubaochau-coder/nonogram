import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/l10n/app_localizations.dart';
import 'package:nonogram/rating/app_rating.dart';
import 'package:nonogram/rating/app_rating_dialog.dart';
import 'package:nonogram/rating/rating_policy.dart';
import 'package:provider/provider.dart';

class _FakeStore implements StoreLauncher {
  int opened = 0;

  @override
  Future<void> openStoreListing() async => opened++;
}

void main() {
  late _FakeStore store;
  late AppRatingController rating;
  bool? asked;

  Future<void> pump(WidgetTester tester, int solved) async {
    asked = null;
    await tester.pumpWidget(
      Provider.value(
        value: rating,
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder:
                (context) => TextButton(
                  onPressed:
                      () async =>
                          asked = await maybeAskForRating(context, solved),
                  child: const Text('leave'),
                ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('leave'));
    await tester.pumpAndSettle();
  }

  setUp(() {
    store = _FakeStore();
    rating = AppRatingController.inMemory(store: store);
  });

  testWidgets('not asked before 5 solved levels', (tester) async {
    await pump(tester, 4);
    expect(find.byType(AppRatingDialog), findsNothing);
    expect(asked, isFalse);
  });

  testWidgets('5 stars opens the Play Store', (tester) async {
    await pump(tester, 5);
    expect(find.byType(AppRatingDialog), findsOneWidget);
    final submit = find.byKey(const ValueKey('rating-submit'));
    // Chưa chọn sao thì chưa gửi được.
    expect(tester.widget<ButtonStyleButton>(submit).onPressed, isNull);

    await tester.tap(find.byKey(const ValueKey('rating-star-5')));
    await tester.pump();
    await tester.tap(submit);
    await tester.pumpAndSettle();

    expect(store.opened, 1);
    expect(rating.state.answered, isTrue);
    expect(asked, isTrue);
  });

  testWidgets('fewer stars thank the player and stay in the app', (
    tester,
  ) async {
    await pump(tester, 5);
    await tester.tap(find.byKey(const ValueKey('rating-star-3')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('rating-submit')));
    await tester.pumpAndSettle();

    expect(store.opened, 0);
    expect(rating.state.answered, isTrue);
    expect(rating.shouldPrompt(100), isFalse);
  });

  testWidgets('"later" asks again 15 levels later', (tester) async {
    await pump(tester, 5);
    await tester.tap(find.byKey(const ValueKey('rating-later')));
    await tester.pumpAndSettle();

    expect(store.opened, 0);
    expect(rating.state.answered, isFalse);
    expect(rating.state.prompts, 1);
    expect(rating.shouldPrompt(19), isFalse);
    expect(rating.shouldPrompt(20), isTrue);
  });

  testWidgets('a rated player is not asked again', (tester) async {
    rating = AppRatingController.inMemory(
      store: store,
      state: const RatingState(answered: true, prompts: 1),
    );
    await pump(tester, 50);
    expect(find.byType(AppRatingDialog), findsNothing);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/l10n/app_localizations.dart';
import 'package:nonogram/premium/premium_card.dart';
import 'package:nonogram/premium/premium_controller.dart';
import 'package:provider/provider.dart';

import '../mocks/fake_purchase_gateway.dart';

void main() {
  Future<void> pump(WidgetTester tester, PremiumController? premium) async {
    final card = MaterialApp(
      theme: AppTheme.lightTheme,
      locale: const Locale('vi'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Scaffold(body: PremiumCard()),
    );
    await tester.pumpWidget(
      premium == null
          ? card
          : ChangeNotifierProvider.value(value: premium, child: card),
    );
    await tester.pump();
  }

  PremiumController premium(FakePurchaseGateway gateway, {bool owned = false}) {
    final c = PremiumController.inMemory(
      gateway: gateway,
      clock: FakeTrustedClock(DateTime(2026, 11, 13)),
      owned: owned,
    );
    addTearDown(c.dispose);
    return c;
  }

  testWidgets('hidden where the pack is not sold', (tester) async {
    await pump(tester, null);
    expect(find.byKey(const ValueKey('premium-buy')), findsNothing);

    final c = premium(FakePurchaseGateway(available: false));
    await c.initialize();
    await pump(tester, c);
    expect(find.byKey(const ValueKey('premium-buy')), findsNothing);
  });

  testWidgets('offers the pack with its price, then shows it active', (
    tester,
  ) async {
    final gateway = FakePurchaseGateway();
    final c = premium(gateway);
    await c.initialize();
    await pump(tester, c);

    expect(find.text('Chơi không quảng cáo'), findsOneWidget);
    expect(find.text('Mua · 49.000 ₫'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('premium-buy')));
    await tester.pumpAndSettle();
    expect(gateway.buys, 1);
    expect(find.byKey(const ValueKey('premium-active')), findsOneWidget);
    expect(find.byKey(const ValueKey('premium-buy')), findsNothing);
  });

  testWidgets('owners see the active card', (tester) async {
    final c = premium(FakePurchaseGateway(), owned: true);
    await pump(tester, c);
    expect(find.text('Gói không quảng cáo đã kích hoạt'), findsOneWidget);
  });
}

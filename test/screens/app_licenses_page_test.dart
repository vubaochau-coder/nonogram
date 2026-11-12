import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/core/app_flavor.dart';
import 'package:nonogram/core/app_licenses.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/l10n/app_localizations.dart';
import 'package:nonogram/screens/licenses/app_licenses_page.dart';

Future<void> _pump(WidgetTester tester, AppFlavor flavor) async {
  tester.view.physicalSize = const Size(412, 1400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.lightTheme,
      locale: const Locale('en'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: AppLicensesPage(flavor: flavor),
    ),
  );
  // Đếm số màn đọc asset thật: chạy ngoài fake async.
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 300)),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('credits every level art set with its level count', (
    tester,
  ) async {
    await _pump(tester, AppFlavor.store);

    for (final source in levelArtSources) {
      expect(find.byKey(ValueKey('licenses-${source.name}')), findsOneWidget);
    }
    expect(find.textContaining('By Streamline · CC BY 4.0'), findsOneWidget);
    expect(find.textContaining('By Gerrit Halfmann · MIT'), findsOneWidget);
    expect(
      find.textContaining(RegExp(r'· \d+ puzzles')),
      findsNWidgets(levelArtSources.length),
    );
    expect(find.text('Nunito'), findsOneWidget);
    expect(find.textContaining('By Jan Wolter · CC BY 3.0'), findsOneWidget);
    expect(find.textContaining('CC BY-SA 4.0'), findsNWidgets(2));
    expect(find.textContaining('nonogram.org'), findsNothing);
  });

  testWidgets('dev flavor notes where developer mode levels come from', (
    tester,
  ) async {
    await _pump(tester, AppFlavor.dev);
    expect(find.textContaining('nonogram.org'), findsOneWidget);
  });

  testWidgets('opens the open-source software licenses', (tester) async {
    await _pump(tester, AppFlavor.store);
    await tester.tap(find.byKey(const ValueKey('licenses-software')));
    await tester.pumpAndSettle();
    expect(find.byType(LicensePage), findsOneWidget);
  });

  test('license texts for level art and font are bundled', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerAppLicenses();
    final packages = <String>{};
    await for (final entry in LicenseRegistry.licenses) {
      packages.addAll(entry.packages);
    }
    expect(
      packages,
      containsAll([...levelArtSources.map((s) => s.name), 'Nunito']),
    );
  });
}

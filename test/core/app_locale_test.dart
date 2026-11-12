import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/core/app_locale.dart';
import 'package:nonogram/l10n/app_localizations.dart';
import 'package:nonogram/widgets/app_language_selector.dart';
import 'package:provider/provider.dart';

void main() {
  const supported = AppLocalizations.supportedLocales;

  String tag(Locale l) => AppLanguage(l, '').tag;

  group('resolveAppLocale', () {
    Locale resolve(List<Locale>? preferred) =>
        resolveAppLocale(preferred, supported);

    test('picks the first device language the app has', () {
      expect(
        resolve(const [Locale('sw'), Locale('fr', 'CA')]),
        const Locale('fr'),
      );
      expect(resolve(const [Locale('pt', 'BR')]), const Locale('pt'));
      expect(resolve(const [Locale('vi', 'VN')]), const Locale('vi'));
    });

    test('falls back to English', () {
      expect(resolve(const [Locale('sw')]), const Locale('en'));
      expect(resolve(const []), const Locale('en'));
      expect(resolve(null), const Locale('en'));
    });

    test(
      'Chinese: script code wins, Taiwan/Hong Kong/Macau use Traditional',
      () {
        for (final device in const [
          Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode: 'Hant',
            countryCode: 'TW',
          ),
          Locale('zh', 'TW'),
          Locale('zh', 'HK'),
          Locale('zh', 'MO'),
        ]) {
          expect(tag(resolve([device])), 'zh_Hant', reason: '$device');
        }
        for (final device in const [
          Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode: 'Hans',
            countryCode: 'CN',
          ),
          Locale('zh', 'CN'),
          Locale('zh', 'SG'),
          Locale('zh'),
        ]) {
          expect(tag(resolve([device])), 'zh', reason: '$device');
        }
      },
    );
  });

  test('every generated locale is in the language picker and vice versa', () {
    expect(appLanguages.map((l) => l.tag).toSet(), supported.map(tag).toSet());
  });

  test('every .arb file has the same messages and placeholders as English', () {
    final dir = Directory('lib/l10n');
    Map<String, dynamic> read(File f) =>
        jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;
    Set<String> placeholders(String s) =>
        RegExp(r'\{(\w+)\}').allMatches(s).map((m) => m.group(1)!).toSet();

    final en = read(File('${dir.path}/app_en.arb'));
    final keys = en.keys.where((k) => !k.startsWith('@')).toSet();
    final files = dir.listSync().whereType<File>().where(
      (f) => f.path.endsWith('.arb'),
    );
    expect(files.length, appLanguages.length);

    for (final file in files) {
      final arb = read(file);
      final name = file.uri.pathSegments.last;
      expect(
        arb.keys.where((k) => !k.startsWith('@')).toSet(),
        keys,
        reason: '$name: messages differ from app_en.arb',
      );
      for (final key in keys) {
        final value = arb[key];
        expect(value, isA<String>(), reason: '$name: $key');
        expect(
          (value as String).trim(),
          isNotEmpty,
          reason: '$name: $key is empty',
        );
        expect(
          placeholders(value),
          placeholders(en[key] as String),
          reason: '$name: $key placeholders differ',
        );
      }
    }
  });

  group('AppLocaleController', () {
    test('follows the device language by default', () {
      expect(AppLocaleController.inMemory().value, isNull);
    });

    test(
      'setLocale picks an app language; null goes back to the device',
      () async {
        final controller = AppLocaleController.inMemory();
        await controller.setLocale(const Locale('ja'));
        expect(controller.value, const Locale('ja'));
        await controller.setLocale(
          const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
        );
        expect(tag(controller.value!), 'zh_Hant');
        await controller.setLocale(null);
        expect(controller.value, isNull);
      },
    );
  });

  testWidgets('choosing a language in the picker switches the UI', (
    tester,
  ) async {
    final controller = AppLocaleController.inMemory();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: controller,
        child: ListenableBuilder(
          listenable: controller,
          builder:
              (context, _) => MaterialApp(
                locale: controller.value,
                localeListResolutionCallback: resolveAppLocale,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: supported,
                home: const Scaffold(
                  body: Center(child: AppLanguageSelector()),
                ),
              ),
        ),
      ),
    );

    // Máy thử mặc định là en_US.
    expect(find.text('Language: English'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('app-language')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('app-language-de')));
    await tester.pumpAndSettle();
    expect(controller.value, const Locale('de'));
    expect(find.text('Sprache: Deutsch'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('app-language')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('app-language-system')));
    await tester.pumpAndSettle();
    expect(controller.value, isNull);
    expect(find.text('Language: English'), findsOneWidget);
  });
}

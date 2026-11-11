import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/play_mode.dart';
import 'package:nonogram/l10n/app_localizations.dart';
import 'package:nonogram/screens/play_mode/play_mode_selection_page.dart';

Future<void> _pump(
  WidgetTester tester, {
  required ValueChanged<PlayMode> onSelected,
  PlayMode? lastMode,
}) async {
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
      home: PlayModeSelectionPage(
        lastMode: lastMode,
        onSelected: onSelected,
        loadStats:
            (mode) async =>
                mode == PlayMode.user
                    ? (solved: 3, total: 121)
                    : (solved: 40, total: 574),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows both modes with their own progress', (tester) async {
    await _pump(tester, onSelected: (_) {}, lastMode: PlayMode.developer);

    expect(find.text('Choose a play mode'), findsOneWidget);
    expect(find.text('Player mode'), findsOneWidget);
    expect(find.text('Developer mode'), findsOneWidget);
    expect(find.text('3/121 solved'), findsOneWidget);
    expect(find.text('40/574 solved'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('play-mode-developer')),
        matching: find.text('Last used'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('tapping a mode selects it once', (tester) async {
    final selected = <PlayMode>[];
    await _pump(tester, onSelected: selected.add);

    await tester.tap(find.byKey(const ValueKey('play-mode-user')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('play-mode-developer')));
    await tester.pump();

    expect(selected, [PlayMode.user]);
  });
}

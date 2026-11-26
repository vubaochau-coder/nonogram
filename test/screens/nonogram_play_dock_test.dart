import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/app_theme_mode.dart';
import 'package:nonogram/data/nonogram_repository.dart';
import 'package:nonogram/l10n/app_localizations.dart';
import 'package:nonogram/screens/play/nonogram_play_screen.dart';
import 'package:nonogram/screens/play/widgets/nonogram_play_dock.dart';
import 'package:nonogram/screens/play/widgets/rotate_screen_icon.dart';
import 'package:provider/provider.dart';

import '../mocks/fake_nonogram_repository.dart';

Future<void> _pumpPlay(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<NonogramRepository>.value(
          value: FakeNonogramRepository(),
        ),
        ChangeNotifierProvider.value(value: AppThemeModeController.inMemory()),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('en'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const NonogramPlayScreen(),
      ),
    ),
  );
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

RotateScreenIcon _rotateIcon(WidgetTester tester) =>
    tester.widget<RotateScreenIcon>(find.byType(RotateScreenIcon));

void main() {
  testWidgets('portrait: undo and Fill / X sit in the bottom right corner, '
      'the other buttons stay in the top row', (tester) async {
    const size = Size(400, 800);
    await _pumpPlay(tester, size);
    Offset at(Finder finder) => tester.getCenter(finder);

    final undo = at(find.byKey(const ValueKey('nonogram-undo')));
    final mark = at(find.byKey(const ValueKey('nonogram-mode-mark')));
    for (final p in [undo, mark]) {
      expect(p.dx, greaterThan(size.width - 80));
      expect(p.dy, greaterThan(size.height / 2));
    }
    expect(undo.dy, lessThan(mark.dy));
    expect(find.byType(NonogramPlayDock), findsOneWidget);

    final top = [
      at(find.byIcon(LucideIcons.lightbulb)),
      at(find.byKey(const ValueKey('nonogram-wand'))),
      at(find.byKey(const ValueKey('nonogram-rotate-screen'))),
    ];
    for (final p in top) {
      expect(p.dy, lessThan(size.height / 4));
    }
    expect(_rotateIcon(tester).landscape, isFalse);
  });

  testWidgets('landscape keeps the side rail and no bottom dock', (
    tester,
  ) async {
    await _pumpPlay(tester, const Size(900, 400));
    expect(find.byType(NonogramPlayDock), findsNothing);
    expect(_rotateIcon(tester).landscape, isTrue);
  });

  test('the rotate icon repaints only when its state or color changes', () {
    final painter = RotateScreenIconPainter(
      landscape: false,
      color: Colors.black,
    );
    bool repaints(bool landscape, Color color) => RotateScreenIconPainter(
      landscape: landscape,
      color: color,
    ).shouldRepaint(painter);

    expect(repaints(false, Colors.black), isFalse);
    expect(repaints(true, Colors.black), isTrue);
    expect(repaints(false, Colors.white), isTrue);
  });
}

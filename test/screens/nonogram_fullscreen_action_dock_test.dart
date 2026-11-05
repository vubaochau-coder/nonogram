import 'package:nonogram/l10n/app_localizations.dart';
import 'package:nonogram/screens/play/widgets/nonogram_fullscreen_action_dock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const bodyKey = ValueKey('nonogram-fullscreen-action-dock-body');
  const actionKey = ValueKey('dock-test-action');

  Widget buildDockHarness({
    Duration autoCollapseDelay = const Duration(milliseconds: 300),
    Duration animationDuration = const Duration(milliseconds: 1),
    VoidCallback? onActionPressed,
  }) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 80, right: 16),
            child: NonogramFullscreenActionDock(
              autoCollapseDelay: autoCollapseDelay,
              animationDuration: animationDuration,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    key: actionKey,
                    onPressed: onActionPressed,
                    child: const Text('Action'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Size dockBodySize(WidgetTester tester) {
    return tester.getSize(find.byKey(bodyKey));
  }

  group('NonogramFullscreenActionDock', () {
    testWidgets('starts expanded then auto-collapses', (tester) async {
      await tester.pumpWidget(buildDockHarness());

      expect(dockBodySize(tester).height, greaterThan(0));

      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 1));

      expect(dockBodySize(tester).height, 0);
    });

    testWidgets('tapping an action restarts the auto-collapse timer', (
      tester,
    ) async {
      var pressedCount = 0;

      await tester.pumpWidget(
        buildDockHarness(
          autoCollapseDelay: const Duration(milliseconds: 250),
          onActionPressed: () => pressedCount++,
        ),
      );

      await tester.pump(const Duration(milliseconds: 200));
      await tester.tap(find.byKey(actionKey));
      await tester.pump();

      expect(pressedCount, 1);

      await tester.pump(const Duration(milliseconds: 100));
      expect(dockBodySize(tester).height, greaterThan(0));

      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump(const Duration(milliseconds: 1));
      expect(dockBodySize(tester).height, 0);
    });
  });
}

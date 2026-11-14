import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/checkin/reward_view.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/models/power_up_inventory.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
    theme: AppTheme.lightTheme,
    home: Scaffold(body: Center(child: child)),
  );

  testWidgets('PowerUpGlyph adds a clock only when time-limited', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(const PowerUpGlyph(powerUp: PowerUp.hint, timeLimited: true)),
    );
    expect(find.byIcon(LucideIcons.lightbulb), findsOneWidget);
    expect(find.byIcon(LucideIcons.clock), findsOneWidget);

    await tester.pumpWidget(
      wrap(const PowerUpGlyph(powerUp: PowerUp.hint, timeLimited: false)),
    );
    expect(find.byIcon(LucideIcons.lightbulb), findsOneWidget);
    expect(find.byIcon(LucideIcons.clock), findsNothing);
  });

  testWidgets('PowerUpGlyph uses the wand icon for wands', (tester) async {
    await tester.pumpWidget(
      wrap(const PowerUpGlyph(powerUp: PowerUp.wand, timeLimited: true)),
    );
    expect(find.byIcon(LucideIcons.wand2), findsOneWidget);
    expect(find.byIcon(LucideIcons.clock), findsOneWidget);
  });
}

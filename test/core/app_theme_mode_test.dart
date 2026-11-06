import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/core/app_theme_mode.dart';

void main() {
  test('defaults to light mode', () {
    expect(AppThemeModeController.inMemory().value, ThemeMode.light);
  });

  test('toggle switches between light and dark', () async {
    final controller = AppThemeModeController.inMemory();
    await controller.toggle();
    expect(controller.value, ThemeMode.dark);
    await controller.toggle();
    expect(controller.value, ThemeMode.light);
  });

  test('system mode is not supported and falls back to light', () async {
    final controller = AppThemeModeController.inMemory(ThemeMode.dark);
    await controller.setMode(ThemeMode.system);
    expect(controller.value, ThemeMode.light);
  });
}

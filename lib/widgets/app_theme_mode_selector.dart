import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/app_theme_mode.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/widgets/dialogs/app_dialog.dart';

/// Chọn Sáng / Tối / Theo hệ thống; áp dụng và lưu ngay khi bấm.
class AppThemeModeSelector extends StatelessWidget {
  const AppThemeModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<AppThemeModeController>();
    final l10n = context.l10n;

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: controller,
      builder: (context, mode, _) {
        return SizedBox(
          width: double.infinity,
          child: SegmentedButton<ThemeMode>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(
                value: ThemeMode.system,
                icon: const Icon(LucideIcons.smartphone, size: 16),
                label: Text(l10n.appThemeSystem),
              ),
              ButtonSegment(
                value: ThemeMode.light,
                icon: const Icon(LucideIcons.sun, size: 16),
                label: Text(l10n.appThemeLight),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                icon: const Icon(LucideIcons.moon, size: 16),
                label: Text(l10n.appThemeDark),
              ),
            ],
            selected: {mode},
            onSelectionChanged: (selection) {
              controller.setMode(selection.first);
            },
          ),
        );
      },
    );
  }
}

Future<void> showAppThemeModeDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AppDialog(
        title: Text(context.l10n.appThemeTitle),
        content: const AppThemeModeSelector(),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(MaterialLocalizations.of(context).closeButtonLabel),
          ),
        ],
      );
    },
  );
}

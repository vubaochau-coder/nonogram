import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/app_locale.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/widgets/dialogs/app_dialog.dart';

/// Nút chọn ngôn ngữ giao diện: hiện ngôn ngữ đang dùng, bấm thì mở danh
/// sách (đầu danh sách là "theo ngôn ngữ của máy"). Đổi là áp dụng và lưu ngay.
class AppLanguageSelector extends StatelessWidget {
  const AppLanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<AppLocaleController>();
    final current = Localizations.localeOf(context);

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        key: const ValueKey('app-language'),
        onPressed: () => showAppLanguageDialog(context, controller),
        icon: const Icon(LucideIcons.globe, size: 18),
        label: Text(
          '${context.l10n.settingsLanguage}: ${appLanguageName(current)}',
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}

Future<void> showAppLanguageDialog(
  BuildContext context,
  AppLocaleController controller,
) async {
  final l10n = context.l10n;
  final selected = controller.value;

  // Bọc trong record để phân biệt "chọn theo máy" (locale null) với đóng hộp thoại.
  final result = await showDialog<({Locale? locale})>(
    context: context,
    builder: (dialogContext) {
      Widget option({
        required Key key,
        required String label,
        required Locale? locale,
      }) {
        final isSelected = locale == selected;
        return ListTile(
          key: key,
          contentPadding: EdgeInsets.zero,
          dense: true,
          title: Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          trailing:
              isSelected
                  ? Icon(LucideIcons.check, color: dialogContext.color.primary)
                  : null,
          onTap: () => Navigator.pop(dialogContext, (locale: locale)),
        );
      }

      return AppDialog(
        title: Text(l10n.settingsLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            option(
              key: const ValueKey('app-language-system'),
              label: l10n.settingsLanguageSystem,
              locale: null,
            ),
            for (final language in appLanguages)
              option(
                key: ValueKey('app-language-${language.tag}'),
                label: language.nativeName,
                locale: language.locale,
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.commonCancel),
          ),
        ],
      );
    },
  );
  if (result != null) await controller.setLocale(result.locale);
}

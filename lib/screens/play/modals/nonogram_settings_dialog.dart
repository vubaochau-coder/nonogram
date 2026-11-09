import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/widgets/app_theme_mode_selector.dart';
import 'package:nonogram/widgets/dialogs/app_dialog.dart';

import '../bloc/nonogram_play_bloc.dart';
import '../coach/nonogram_play_coach.dart';
import '../bloc/nonogram_play_event.dart';
import '../nonogram_transformation_controller_provider.dart';

Future<void> showNonogramSettingsDialog(BuildContext context) async {
  final bloc = context.read<NonogramPlayBloc>();
  final controller = NonogramTransformationControllerProvider.of(context);
  final coach = context.read<NonogramCoachReplayNotifier>();

  final result = await showDialog<_SettingsResult>(
    context: context,
    builder: (dialogContext) {
      return NonogramTransformationControllerProvider(
        controller: controller,
        child: BlocProvider.value(
          value: bloc,
          child: const NonogramSettingsDialog(),
        ),
      );
    },
  );
  // Đóng hộp thoại xong mới hiện hướng dẫn, để vùng sáng trỏ đúng các nút.
  if (result == _SettingsResult.showControlsGuide) coach.requestReplay();
}

enum _SettingsResult { showControlsGuide }

/// Cài đặt khi đang chơi: giao diện sáng/tối, xem lại hướng dẫn thao tác và
/// chơi lại màn từ đầu.
class NonogramSettingsDialog extends StatelessWidget {
  const NonogramSettingsDialog({super.key});

  Future<void> _confirmRestart(BuildContext context) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (dialogContext) => AppDialog(
            title: Text(l10n.nonogramSettingsRestartConfirmTitle),
            content: Text(l10n.nonogramSettingsRestartConfirmMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text(l10n.commonCancel),
              ),
              TextButton(
                key: const ValueKey('nonogram-restart-confirm'),
                onPressed: () => Navigator.pop(dialogContext, true),
                style: TextButton.styleFrom(
                  foregroundColor: dialogContext.color.error,
                  // Giữ font của theme, chỉ đậm hơn.
                  textStyle: dialogContext.labelLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Text(l10n.nonogramSettingsRestartConfirm),
              ),
            ],
          ),
    );
    if (confirmed != true || !context.mounted) return;

    final t =
        NonogramTransformationControllerProvider.of(
          context,
        ).value.getTranslation();
    context.read<NonogramPlayBloc>().add(
      BoardReset(offsetX: t.x, offsetY: t.y),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.color;

    return AppDialog(
      title: Text(l10n.nonogramSettingsTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.appThemeTitle,
            style: context.titleSmall.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const AppThemeModeSelector(),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              key: const ValueKey('nonogram-controls-guide'),
              onPressed:
                  () =>
                      Navigator.pop(context, _SettingsResult.showControlsGuide),
              icon: const Icon(LucideIcons.graduationCap, size: 18),
              label: Text(l10n.nonogramSettingsControlsGuide),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              key: const ValueKey('nonogram-restart'),
              onPressed: () => _confirmRestart(context),
              icon: const Icon(LucideIcons.rotateCcw, size: 18),
              label: Text(l10n.nonogramSettingsRestart),
              style: OutlinedButton.styleFrom(
                foregroundColor: colors.error,
                side: BorderSide(color: colors.error.withValues(alpha: 0.5)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.commonClose),
        ),
      ],
    );
  }
}

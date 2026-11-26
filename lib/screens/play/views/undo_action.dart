import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/context_ext.dart';

import '../bloc/nonogram_play_bloc.dart';
import '../bloc/nonogram_play_event.dart';
import '../bloc/nonogram_play_state.dart';
import '../nonogram_transformation_controller_provider.dart';
import '../widgets/overlay_button.dart';
import 'wand_action.dart';

/// Nút hoàn tác: quay lại bàn trước lần chạm / lần kéo gần nhất. Mờ đi khi
/// chưa có gì để hoàn tác hoặc đã giải xong.
class UndoAction extends StatelessWidget {
  const UndoAction({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NonogramPlayBloc, NonogramPlayState>(
      buildWhen: (p, c) =>
          p.canUndo != c.canUndo ||
          p.isSolved != c.isSolved ||
          p.isWandActive != c.isWandActive,
      builder: (context, state) {
        final label = context.l10n.nonogramPlayUndo;
        return Semantics(
          button: true,
          label: label,
          child: Tooltip(
            message: label,
            child: OverlayButton(
              key: const ValueKey('nonogram-undo'),
              icon: LucideIcons.undo2,
              enabled: state.canUndo && !state.isSolved,
              // Gậy phép đang chờ chọn hàng / cột: chạm vào chỉ nhắc.
              muted: state.isWandActive,
              onPressed: () {
                if (state.isWandActive) {
                  WandNudge.of(context);
                  return;
                }
                HapticFeedback.selectionClick();
                final t = NonogramTransformationControllerProvider.of(
                  context,
                ).value.getTranslation();
                context.read<NonogramPlayBloc>().add(
                  UndoRequested(offsetX: t.x, offsetY: t.y),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

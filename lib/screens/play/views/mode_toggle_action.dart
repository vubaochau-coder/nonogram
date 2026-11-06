import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/models/nonogram_interaction_mode.dart';

import '../bloc/nonogram_play_bloc.dart';
import '../bloc/nonogram_play_event.dart';
import '../bloc/nonogram_play_state.dart';
import '../nonogram_transformation_controller_provider.dart';

/// Nút gạt hai lựa chọn: chạm vào ô sẽ tô (ô vuông đặc) hay đánh X. Cả hai
/// lựa chọn luôn hiện, lựa chọn đang bật được tô màu.
class ModeToggleAction extends StatelessWidget {
  const ModeToggleAction({super.key, this.vertical = false});

  /// Xếp dọc (cột nút khi màn ngang).
  final bool vertical;

  static const double _segment = 38;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NonogramPlayBloc, NonogramPlayState>(
      buildWhen: (p, c) => p.interactionMode != c.interactionMode,
      builder: (context, state) {
        final l10n = context.l10n;
        final colors = context.color;

        void select(NonogramInteractionMode mode) {
          if (state.interactionMode == mode) return;
          final t =
              NonogramTransformationControllerProvider.of(
                context,
              ).value.getTranslation();
          context.read<NonogramPlayBloc>().add(
            InteractionModeChanged(offsetX: t.x, offsetY: t.y),
          );
        }

        Widget segment(
          NonogramInteractionMode mode,
          String label,
          Widget Function(Color color) icon,
        ) {
          final selected = state.interactionMode == mode;
          final foreground = selected ? colors.onPrimary : colors.onSurface;
          return Semantics(
            button: true,
            selected: selected,
            label: label,
            child: Tooltip(
              message: label,
              child: InkWell(
                key: ValueKey('nonogram-mode-${mode.name}'),
                onTap: () => select(mode),
                borderRadius: BorderRadius.circular(11),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  width: _segment,
                  height: _segment,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? colors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: icon(foreground),
                ),
              ),
            ),
          );
        }

        final children = [
          segment(
            NonogramInteractionMode.fill,
            l10n.nonogramPlayModeFill,
            (color) => Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          segment(
            NonogramInteractionMode.mark,
            l10n.nonogramPlayModeMark,
            (color) => Icon(LucideIcons.x, size: 20, color: color),
          ),
        ];

        return Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: colors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: context.gameColors.cardBorder),
            ),
            child: Flex(
              direction: vertical ? Axis.vertical : Axis.horizontal,
              mainAxisSize: MainAxisSize.min,
              children: children,
            ),
          ),
        );
      },
    );
  }
}

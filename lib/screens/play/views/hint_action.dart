import 'package:nonogram/core/context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../bloc/nonogram_play_bloc.dart';
import '../bloc/nonogram_play_event.dart';
import '../bloc/nonogram_play_state.dart';
import '../nonogram_transformation_controller_provider.dart';
import '../widgets/overlay_button.dart';
import 'wand_action.dart';

class HintAction extends StatelessWidget {
  const HintAction({super.key, this.compact = false});

  /// Nút vuông, số lượt còn lại hiện thành huy hiệu nhỏ (cột nút hẹp khi
  /// màn ngang).
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NonogramPlayBloc, NonogramPlayState>(
      buildWhen:
          (p, c) =>
              p.remainingHints != c.remainingHints || p.isSolved != c.isSolved,
      builder: (context, state) {
        final l10n = context.l10n;
        final button = OverlayButton(
          icon: LucideIcons.lightbulb,
          label:
              compact ? null : l10n.nonogramPlayHintLabel(state.remainingHints),
          enabled: state.remainingHints > 0 && !state.isSolved,
          onPressed: () {
            final controller = NonogramTransformationControllerProvider.of(
              context,
            );
            final translation = controller.value.getTranslation();
            context.read<NonogramPlayBloc>().add(
              HintRequested(offsetX: translation.x, offsetY: translation.y),
            );
          },
        );
        if (!compact) return button;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            button,
            Positioned(
              right: -4,
              top: -4,
              child: IgnorePointer(
                child: CountBadge(
                  count: state.remainingHints,
                  active: state.remainingHints > 0,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

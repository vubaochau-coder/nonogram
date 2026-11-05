import 'package:nonogram/core/context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../bloc/nonogram_play_bloc.dart';
import '../bloc/nonogram_play_event.dart';
import '../bloc/nonogram_play_state.dart';
import '../nonogram_transformation_controller_provider.dart';
import '../widgets/overlay_button.dart';

class HintAction extends StatelessWidget {
  const HintAction({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NonogramPlayBloc, NonogramPlayState>(
      buildWhen:
          (p, c) =>
              p.remainingHints != c.remainingHints || p.isSolved != c.isSolved,
      builder: (context, state) {
        final l10n = context.l10n;
        return OverlayButton(
          icon: LucideIcons.lightbulb,
          label: l10n.nonogramPlayHintLabel(state.remainingHints),
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
      },
    );
  }
}

import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/models/nonogram_interaction_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../bloc/nonogram_play_bloc.dart';
import '../bloc/nonogram_play_event.dart';
import '../bloc/nonogram_play_state.dart';
import '../nonogram_transformation_controller_provider.dart';
import '../widgets/overlay_button.dart';

class ModeToggleAction extends StatelessWidget {
  const ModeToggleAction({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NonogramPlayBloc, NonogramPlayState>(
      buildWhen: (p, c) => p.interactionMode != c.interactionMode,
      builder: (context, state) {
        final isPanMode =
            state.interactionMode == NonogramInteractionMode.explore;

        return OverlayButton(
          icon: isPanMode ? LucideIcons.hand : LucideIcons.pencil,
          color: isPanMode ? context.color.primary : null,
          onPressed: () {
            final controller = NonogramTransformationControllerProvider.of(
              context,
            );
            final translation = controller.value.getTranslation();
            context.read<NonogramPlayBloc>().add(
              InteractionModeChanged(
                offsetX: translation.x,
                offsetY: translation.y,
              ),
            );
          },
        );
      },
    );
  }
}

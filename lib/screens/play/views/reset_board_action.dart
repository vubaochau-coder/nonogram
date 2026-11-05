import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../bloc/nonogram_play_bloc.dart';
import '../bloc/nonogram_play_event.dart';
import '../nonogram_transformation_controller_provider.dart';
import '../widgets/overlay_button.dart';

class ResetBoardAction extends StatelessWidget {
  const ResetBoardAction({super.key});

  @override
  Widget build(BuildContext context) {
    // This action doesn't depend on state for rendering,
    // but we can wrap it in BlocBuilder if we ever want to hide it or change color based on state.
    // For now, it's a simple stateless button that interacts with the Bloc.
    return OverlayButton(
      icon: LucideIcons.eraser,
      onPressed: () {
        final controller = NonogramTransformationControllerProvider.of(context);
        final translation = controller.value.getTranslation();
        context.read<NonogramPlayBloc>().add(
          BoardReset(offsetX: translation.x, offsetY: translation.y),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../bloc/nonogram_play_bloc.dart';
import '../bloc/nonogram_play_event.dart';
import '../bloc/nonogram_play_state.dart';
import '../widgets/overlay_button.dart';

class FullscreenToggleAction extends StatelessWidget {
  const FullscreenToggleAction({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NonogramPlayBloc, NonogramPlayState>(
      buildWhen: (p, c) => p.isFullscreen != c.isFullscreen,
      builder: (context, state) {
        return OverlayButton(
          icon:
              state.isFullscreen
                  ? LucideIcons.minimize2
                  : LucideIcons.maximize2,
          onPressed: () {
            context.read<NonogramPlayBloc>().add(const FullscreenToggled());
          },
        );
      },
    );
  }
}

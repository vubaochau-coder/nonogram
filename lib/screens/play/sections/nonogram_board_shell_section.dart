import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/nonogram_play_bloc.dart';
import '../bloc/nonogram_play_event.dart';
import '../bloc/nonogram_play_state.dart';
import '../nonogram_transformation_controller_provider.dart';
import 'nonogram_grid_section.dart';
import 'nonogram_top_clues_section.dart';
import 'nonogram_left_clues_section.dart';
import '../views/fullscreen_toggle_action.dart';
import '../views/mode_toggle_action.dart';
import '../views/reset_board_action.dart';
import '../views/hint_action.dart';
import '../widgets/nonogram_fullscreen_action_dock.dart';
import '../widgets/nonogram_hint_highlight_overlay.dart';

class NonogramBoardShellSection extends StatelessWidget {
  const NonogramBoardShellSection({super.key});

  void _syncViewportToBloc(
    BuildContext context,
    TransformationController controller,
  ) {
    final translation = controller.value.getTranslation();
    context.read<NonogramPlayBloc>().add(
      ViewportChanged(translation.x, translation.y),
    );
  }

  Widget _buildOverlayActions() {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        HintAction(),
        SizedBox(width: 8),
        ModeToggleAction(),
        SizedBox(width: 8),
        ResetBoardAction(),
        SizedBox(width: 8),
        FullscreenToggleAction(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = NonogramTransformationControllerProvider.of(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<NonogramPlayBloc, NonogramPlayState>(
          listenWhen: (p, c) {
            return p.startTime != c.startTime || p.puzzle != c.puzzle;
          },
          listener: (context, state) {
            // Reset viewport khi bắt đầu màn mới hoặc reset bàn cờ
            controller.value = Matrix4.identity();
          },
        ),
        BlocListener<NonogramPlayBloc, NonogramPlayState>(
          listenWhen: (p, c) => c is NonogramPlayRestoredState,
          listener: (context, state) {
            if (state is NonogramPlayRestoredState) {
              controller.value =
                  Matrix4.identity()
                    ..setTranslationRaw(state.offsetX, state.offsetY, 0);
            }
          },
        ),
        // Periodic/Interaction-based sync:
        // Sync viewport to Bloc (for local DB storage) whenever the grid changes.
        BlocListener<NonogramPlayBloc, NonogramPlayState>(
          listenWhen: (p, c) => p.gridData != c.gridData,
          listener: (context, state) {
            _syncViewportToBloc(context, controller);
          },
        ),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              InteractiveViewer(
                transformationController: controller,
                panEnabled: true,
                scaleEnabled: false,
                minScale: 1.0,
                maxScale: 1.0,
                constrained: false,
                boundaryMargin: const EdgeInsets.all(48),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: constraints.maxWidth,
                    minHeight: constraints.maxHeight,
                  ),
                  child: Center(
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.all(16),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const NonogramTopCluesSection(),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const NonogramLeftCluesSection(),
                                  const NonogramGridSection(),
                                ],
                              ),
                            ],
                          ),
                          // Hint Highlight Layer
                          const NonogramHintHighlightOverlay(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 16,
                child: BlocSelector<NonogramPlayBloc, NonogramPlayState, bool>(
                  selector: (state) => state.isFullscreen,
                  builder: (context, isFullscreen) {
                    return SafeArea(
                      left: false,
                      right: false,
                      bottom: false,
                      minimum: EdgeInsets.only(top: isFullscreen ? 16 : 0),
                      child:
                          isFullscreen
                              ? NonogramFullscreenActionDock(
                                child: _buildOverlayActions(),
                              )
                              : _buildOverlayActions(),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

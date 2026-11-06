import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/models/nonogram_interaction_mode.dart';

import '../bloc/nonogram_play_bloc.dart';
import '../bloc/nonogram_play_event.dart';
import '../bloc/nonogram_play_state.dart';
import '../engine/nonogram_board_layout.dart';
import '../modals/nonogram_settings_dialog.dart';
import '../nonogram_transformation_controller_provider.dart';
import '../views/clue_strip_toggle_action.dart';
import '../views/fullscreen_toggle_action.dart';
import '../views/hint_action.dart';
import '../views/mode_toggle_action.dart';
import '../views/reset_board_action.dart';
import '../widgets/hold_to_pan_button.dart';
import '../widgets/nonogram_fullscreen_action_dock.dart';
import '../widgets/overlay_button.dart';
import 'nonogram_board_viewport.dart';

/// Bàn chơi + nút công cụ: hàng nút nổi ở góc trên-phải khi màn dọc, cột
/// nút dọc mép phải khi màn ngang, và nút "giữ để kéo" ở góc dưới-trái.
class NonogramBoardShellSection extends StatelessWidget {
  const NonogramBoardShellSection({super.key});

  Widget _buildOverlayActions() {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        HintAction(),
        SizedBox(width: 8),
        ModeToggleAction(),
        SizedBox(width: 8),
        ClueStripToggleAction(),
        SizedBox(width: 8),
        ResetBoardAction(),
        SizedBox(width: 8),
        FullscreenToggleAction(),
      ],
    );
  }

  Widget _buildRail(BuildContext context) {
    const gap = SizedBox(height: 6);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OverlayButton(
            icon: LucideIcons.arrowLeft,
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          gap,
          const HintAction(compact: true),
          gap,
          const ModeToggleAction(),
          gap,
          const ClueStripToggleAction(),
          gap,
          const ResetBoardAction(),
          gap,
          const FullscreenToggleAction(),
          gap,
          OverlayButton(
            icon: LucideIcons.settings,
            onPressed: () => showNonogramSettingsDialog(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NonogramPlayBloc, NonogramPlayState>(
      // Lưu vị trí lưới cùng ván mỗi khi bàn thay đổi.
      listenWhen: (p, c) => p.gridData != c.gridData,
      listener: (context, state) {
        final controller = NonogramTransformationControllerProvider.of(context);
        final t = controller.value.getTranslation();
        context.read<NonogramPlayBloc>().add(ViewportChanged(t.x, t.y));
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final landscape = NonogramBoardLayout.isLandscapeViewport(
            constraints.biggest,
          );
          return Stack(
            children: [
              const Positioned.fill(child: NonogramBoardViewport()),
              if (landscape)
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  width: NonogramBoardLayout.railReserve,
                  child: Center(child: _buildRail(context)),
                )
              else
                Positioned(
                  top: 0,
                  right: 16,
                  child:
                      BlocSelector<NonogramPlayBloc, NonogramPlayState, bool>(
                        selector: (state) => state.isFullscreen,
                        builder: (context, isFullscreen) {
                          return SafeArea(
                            left: false,
                            right: false,
                            bottom: false,
                            minimum: EdgeInsets.only(
                              top: isFullscreen ? 16 : 0,
                            ),
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
              Positioned(
                left: 12,
                bottom: 12,
                child: SafeArea(
                  top: false,
                  right: false,
                  child:
                      BlocSelector<NonogramPlayBloc, NonogramPlayState, bool>(
                        selector:
                            (state) =>
                                state.interactionMode ==
                                NonogramInteractionMode.draw,
                        builder: (context, isDrawMode) {
                          return isDrawMode
                              ? const HoldToPanButton()
                              : const SizedBox.shrink();
                        },
                      ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

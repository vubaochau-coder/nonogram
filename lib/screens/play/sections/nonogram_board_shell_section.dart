import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/nonogram_play_bloc.dart';
import '../bloc/nonogram_play_event.dart';
import '../bloc/nonogram_play_state.dart';
import '../nonogram_transformation_controller_provider.dart';
import '../views/fullscreen_toggle_action.dart';
import '../views/hint_action.dart';
import '../views/mode_toggle_action.dart';
import '../views/reset_board_action.dart';
import '../widgets/nonogram_fullscreen_action_dock.dart';
import 'nonogram_board_viewport.dart';

/// Bàn chơi + hàng nút công cụ nổi ở góc trên-phải.
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
        ResetBoardAction(),
        SizedBox(width: 8),
        FullscreenToggleAction(),
      ],
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
      child: Stack(
        children: [
          const Positioned.fill(child: NonogramBoardViewport()),
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
      ),
    );
  }
}

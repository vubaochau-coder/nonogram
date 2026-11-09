import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/nonogram_play_bloc.dart';
import '../bloc/nonogram_play_event.dart';
import '../bloc/nonogram_play_state.dart';
import '../engine/nonogram_board_layout.dart';
import '../nonogram_transformation_controller_provider.dart';
import '../views/fullscreen_toggle_action.dart';
import '../views/hint_action.dart';
import '../views/mode_toggle_action.dart';
import '../views/rotate_screen_action.dart';
import '../widgets/nonogram_fullscreen_action_dock.dart';
import 'nonogram_board_viewport.dart';

/// Bàn chơi + nút công cụ: hàng nút nổi ở góc trên-phải khi màn dọc, cột
/// nút dọc mép phải khi màn ngang.
class NonogramBoardShellSection extends StatelessWidget {
  const NonogramBoardShellSection({super.key});

  Widget _buildOverlayActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const HintAction(),
        const SizedBox(width: 8),
        const ModeToggleAction(),
        if (RotateScreenAction.isSupported) ...[
          const SizedBox(width: 8),
          const RotateScreenAction(),
        ],
        const SizedBox(width: 8),
        const FullscreenToggleAction(),
      ],
    );
  }

  /// Màn ngang: mép phải chỉ giữ hai thao tác chơi, ở góc trên (thẳng hàng
  /// với nút quay lại bên trái): Tô / X trên, gợi ý dưới.
  /// Quay lại, thông tin màn, xoay màn hình và cài đặt nằm ở cột trái
  /// (`NonogramLandscapeLeftRail`).
  Widget _buildRail() {
    // Lề trên 12 trùng với cột trái để hai cột thẳng hàng.
    return const Padding(
      padding: EdgeInsets.only(top: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ModeToggleAction(vertical: true),
          SizedBox(height: 12),
          HintAction(compact: true),
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
                  right: 0,
                  width: NonogramBoardLayout.railReserve,
                  child: _buildRail(),
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
            ],
          );
        },
      ),
    );
  }
}

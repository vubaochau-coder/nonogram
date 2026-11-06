import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/context_ext.dart';

import '../bloc/nonogram_play_bloc.dart';
import '../bloc/nonogram_play_event.dart';
import '../bloc/nonogram_play_state.dart';
import '../engine/nonogram_board_layout.dart';
import '../modals/nonogram_settings_dialog.dart';
import '../nonogram_transformation_controller_provider.dart';
import '../views/fullscreen_toggle_action.dart';
import '../views/hint_action.dart';
import '../views/mode_toggle_action.dart';
import '../views/rotate_screen_action.dart';
import '../widgets/nonogram_fullscreen_action_dock.dart';
import '../widgets/overlay_button.dart';
import 'nonogram_landscape_info_panel.dart';
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

  /// Màn ngang, xếp theo tầm với của ngón cái tay phải: nút ít dùng (quay
  /// lại, thông tin màn, xoay màn hình, cài đặt) dồn lên trên, nút dùng liên
  /// tục (gợi ý, Tô / X) dồn xuống dưới, Tô / X sát mép dưới nhất. Màn ngang
  /// đã tự toàn màn hình nên không cần nút toàn màn hình.
  Widget _buildRail(BuildContext context) {
    const gap = SizedBox(height: 10);
    final colors = context.color;
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          // Đủ rộng cả cột để huy hiệu số lượt gợi ý không bị cắt.
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: NonogramBoardLayout.railReserve,
              maxWidth: NonogramBoardLayout.railReserve,
              minHeight: constraints.maxHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OverlayButton(
                        icon: LucideIcons.arrowLeft,
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                      gap,
                      ValueListenableBuilder<bool>(
                        valueListenable: LandscapeInfoPanelVisibility.notifier,
                        builder: (context, visible, _) {
                          return OverlayButton(
                            key: const ValueKey('nonogram-landscape-info'),
                            icon: LucideIcons.info,
                            color: visible ? colors.primary : null,
                            onPressed: LandscapeInfoPanelVisibility.toggle,
                          );
                        },
                      ),
                      gap,
                      if (RotateScreenAction.isSupported) ...[
                        const RotateScreenAction(),
                        gap,
                      ],
                      OverlayButton(
                        icon: LucideIcons.settings,
                        onPressed: () => showNonogramSettingsDialog(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HintAction(compact: true),
                      gap,
                      ModeToggleAction(vertical: true),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
                  child: _buildRail(context),
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

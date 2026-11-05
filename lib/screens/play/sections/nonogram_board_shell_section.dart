import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/nonogram_play_bloc.dart';
import '../bloc/nonogram_play_event.dart';
import '../bloc/nonogram_play_state.dart';
import '../engine/nonogram_engine.dart';
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

  /// Áp vị trí khung nhìn bloc đang giữ (ván dở hoặc màn mới).
  static void _applyPendingViewport(
    BuildContext context,
    TransformationController controller, {
    bool resetIfNone = false,
  }) {
    final offset = context.read<NonogramPlayBloc>().takePendingViewport();
    if (offset != null) {
      controller.value =
          Matrix4.identity()..setTranslationRaw(offset.dx, offset.dy, 0);
    } else if (resetIfNone) {
      controller.value = Matrix4.identity();
    }
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
        // Màn mới, chơi lại, hoặc cỡ ô vừa được tự co: áp vị trí khung nhìn
        // mà bloc chuẩn bị (hoặc về gốc nếu không có).
        BlocListener<NonogramPlayBloc, NonogramPlayState>(
          listenWhen: (p, c) {
            return p.startTime != c.startTime || p.puzzle != c.puzzle;
          },
          listener: (context, state) {
            _applyPendingViewport(context, controller, resetIfNone: true);
          },
        ),
        // Cỡ ô đổi: chỉ dịch khung nhìn nếu bloc có vị trí mới (tự co cho màn
        // mới); đổi cỡ ô trong cài đặt thì giữ nguyên vị trí người chơi.
        BlocListener<NonogramPlayBloc, NonogramPlayState>(
          listenWhen: (p, c) => p.cellSize != c.cellSize,
          listener: (context, state) {
            _applyPendingViewport(context, controller);
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
          return _OnMount(
            onMount: () => _applyPendingViewport(context, controller),
            child: Stack(
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
                        padding: const EdgeInsets.fromLTRB(
                          16,
                          NonogramEngine.boardTopPadding,
                          16,
                          16,
                        ),
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
            ),
          );
        },
      ),
    );
  }
}

/// Gọi [onMount] một lần sau khung hình đầu tiên.
class _OnMount extends StatefulWidget {
  const _OnMount({required this.onMount, required this.child});

  final VoidCallback onMount;
  final Widget child;

  @override
  State<_OnMount> createState() => _OnMountState();
}

class _OnMountState extends State<_OnMount> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onMount();
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

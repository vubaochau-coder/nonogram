import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nonogram/core/onboarding_preferences.dart';

import '../bloc/nonogram_play_bloc.dart';
import '../bloc/nonogram_play_event.dart';
import '../bloc/nonogram_play_state.dart';
import '../coach/nonogram_play_coach.dart';
import '../engine/nonogram_board_layout.dart';
import '../nonogram_transformation_controller_provider.dart';
import '../views/fullscreen_toggle_action.dart';
import '../views/hint_action.dart';
import '../views/mode_toggle_action.dart';
import '../views/rotate_screen_action.dart';
import '../views/wand_action.dart';
import '../widgets/nonogram_fullscreen_action_dock.dart';
import 'nonogram_board_viewport.dart';

/// Bàn chơi + nút công cụ: hàng nút nổi ở góc trên-phải khi màn dọc, cột
/// nút dọc mép phải khi màn ngang.
///
/// Cũng là nơi hiện hướng dẫn thao tác (lần đầu vào màn chơi, hoặc khi mở
/// lại từ cài đặt) và mẹo kéo bàn chơi ở màn lớn đầu tiên.
class NonogramBoardShellSection extends StatefulWidget {
  const NonogramBoardShellSection({super.key});

  @override
  State<NonogramBoardShellSection> createState() =>
      _NonogramBoardShellSectionState();
}

class _NonogramBoardShellSectionState extends State<NonogramBoardShellSection> {
  final _hintKey = GlobalKey(debugLabel: 'coach-hint');
  final _wandKey = GlobalKey(debugLabel: 'coach-wand');
  final _modeKey = GlobalKey(debugLabel: 'coach-mode');

  NonogramCoachReplayNotifier? _replay;
  Size? _boardSize;
  bool _coachShowing = false;
  Timer? _autoCoachTimer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final replay = context.read<NonogramCoachReplayNotifier>();
    if (replay != _replay) {
      _replay?.removeListener(_onReplayRequested);
      _replay = replay..addListener(_onReplayRequested);
    }
  }

  @override
  void initState() {
    super.initState();
    _scheduleAutoCoach();
  }

  @override
  void dispose() {
    _autoCoachTimer?.cancel();
    _replay?.removeListener(_onReplayRequested);
    super.dispose();
  }

  OnboardingPreferences? get _prefs {
    try {
      return context.read<OnboardingPreferences>();
    } on ProviderNotFoundException {
      return null;
    }
  }

  NonogramBoardLayout? _currentLayout() {
    final state = context.read<NonogramPlayBloc>().state;
    final puzzle = state.puzzle;
    final size = _boardSize;
    if (puzzle == null || size == null || state.isLoading) return null;
    return NonogramBoardLayout.forPuzzle(
      puzzle: puzzle,
      cellSize: state.cellSize,
      viewport: size,
    );
  }

  /// Lưới lớn hơn khung nhìn (phải kéo mới xem hết).
  bool _boardOverflows() {
    final layout = _currentLayout();
    if (layout == null) return false;
    return layout.xRange.min < layout.xRange.max ||
        layout.yRange.min < layout.yRange.max;
  }

  /// Đợi bàn chơi ổn định (tải màn, tự chọn cỡ ô) rồi mới xét có cần hiện
  /// hướng dẫn không.
  void _scheduleAutoCoach() {
    _autoCoachTimer?.cancel();
    _autoCoachTimer = Timer(const Duration(milliseconds: 600), _maybeAutoCoach);
  }

  void _maybeAutoCoach() {
    if (!mounted || _coachShowing) return;
    final prefs = _prefs;
    if (prefs == null) return;
    final state = context.read<NonogramPlayBloc>().state;
    if (state.isLoading || state.isSolved || state.puzzle == null) return;

    final overflow = _boardOverflows();
    final steps = <NonogramCoachStep>[
      if (!prefs.playCoachSeen) ..._basicSteps,
      if (overflow && !prefs.scrollTipSeen) NonogramCoachStep.scroll,
    ];
    if (steps.isEmpty) return;
    // Đánh dấu ngay, để thoát giữa chừng cũng không bị hiện lại.
    if (!prefs.playCoachSeen) prefs.markPlayCoachSeen();
    if (steps.contains(NonogramCoachStep.scroll)) prefs.markScrollTipSeen();
    _showCoach(steps);
  }

  static const _basicSteps = [
    NonogramCoachStep.hint,
    NonogramCoachStep.wand,
    NonogramCoachStep.mode,
    NonogramCoachStep.longPress,
  ];

  void _onReplayRequested() {
    if (_coachShowing) return;
    _showCoach([..._basicSteps, NonogramCoachStep.scroll]);
  }

  Future<void> _showCoach(List<NonogramCoachStep> steps) async {
    if (!mounted) return;
    final bloc = context.read<NonogramPlayBloc>();
    if (bloc.state.isWandActive) bloc.add(const WandToggled());
    _coachShowing = true;
    await showNonogramPlayCoach(context, steps: steps, targetFor: _targetFor);
    _coachShowing = false;
  }

  Rect? _keyRect(GlobalKey key) {
    final box = key.currentContext?.findRenderObject();
    if (box is! RenderBox || !box.hasSize || !box.attached) return null;
    return box.localToGlobal(Offset.zero) & box.size;
  }

  /// Phần lưới đang hiện trên màn hình (toạ độ toàn màn hình).
  Rect? _visibleGridRect() {
    final layout = _currentLayout();
    final box = context.findRenderObject();
    if (layout == null || box is! RenderBox || !box.attached) return null;
    final t =
        NonogramTransformationControllerProvider.of(
          context,
        ).value.getTranslation();
    final offset = layout.clamp(Offset(t.x, t.y));
    final grid = offset & Size(layout.gridWidth, layout.gridHeight);
    final visible = grid.intersect(layout.gridArea(offset));
    if (visible.isEmpty) return null;
    return visible.shift(box.localToGlobal(Offset.zero));
  }

  Rect? _targetFor(NonogramCoachStep step) {
    return switch (step) {
      NonogramCoachStep.hint => _keyRect(_hintKey),
      NonogramCoachStep.wand => _keyRect(_wandKey),
      NonogramCoachStep.mode => _keyRect(_modeKey),
      NonogramCoachStep.longPress ||
      NonogramCoachStep.scroll => _visibleGridRect(),
    };
  }

  Widget _buildOverlayActions({required bool compactHint}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        KeyedSubtree(key: _hintKey, child: HintAction(compact: compactHint)),
        const SizedBox(width: 8),
        KeyedSubtree(key: _wandKey, child: const WandAction()),
        const SizedBox(width: 8),
        KeyedSubtree(key: _modeKey, child: const ModeToggleAction()),
        if (RotateScreenAction.isSupported) ...[
          const SizedBox(width: 8),
          const RotateScreenAction(),
        ],
        const SizedBox(width: 8),
        const FullscreenToggleAction(),
      ],
    );
  }

  /// Màn ngang: mép phải chỉ giữ các thao tác chơi (gợi ý, gậy phép, Tô / X)
  /// ở góc dưới, trong tầm ngón cái; Tô / X sát mép dưới nhất. Quay lại,
  /// thông tin màn, xoay màn hình và cài đặt nằm ở cột trái
  /// (`NonogramLandscapeLeftRail`).
  Widget _buildRail() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          KeyedSubtree(key: _hintKey, child: const HintAction(compact: true)),
          const SizedBox(height: 10),
          KeyedSubtree(key: _wandKey, child: const WandAction()),
          const SizedBox(height: 10),
          KeyedSubtree(
            key: _modeKey,
            child: const ModeToggleAction(vertical: true),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<NonogramPlayBloc, NonogramPlayState>(
          // Lưu vị trí lưới cùng ván mỗi khi bàn thay đổi.
          listenWhen: (p, c) => p.gridData != c.gridData,
          listener: (context, state) {
            final controller = NonogramTransformationControllerProvider.of(
              context,
            );
            final t = controller.value.getTranslation();
            context.read<NonogramPlayBloc>().add(ViewportChanged(t.x, t.y));
          },
        ),
        BlocListener<NonogramPlayBloc, NonogramPlayState>(
          // Sang màn mới: xét lại mẹo kéo bàn chơi cho màn lớn.
          listenWhen: (p, c) => p.puzzle?.id != c.puzzle?.id,
          listener: (context, state) => _scheduleAutoCoach(),
        ),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          _boardSize = constraints.biggest;
          final landscape = NonogramBoardLayout.isLandscapeViewport(
            constraints.biggest,
          );
          // Màn dọc hẹp: nút gợi ý chỉ còn icon + huy hiệu để hàng nút vừa.
          final compactHint = constraints.maxWidth < 400;
          return Stack(
            children: [
              const Positioned.fill(child: NonogramBoardViewport()),
              if (landscape)
                Positioned(
                  bottom: 0,
                  right: 0,
                  width: NonogramBoardLayout.railReserve,
                  child: _buildRail(),
                )
              else
                Positioned(
                  top: 0,
                  right: 16,
                  child: BlocSelector<
                    NonogramPlayBloc,
                    NonogramPlayState,
                    bool
                  >(
                    selector: (state) => state.isFullscreen,
                    builder: (context, isFullscreen) {
                      final actions = _buildOverlayActions(
                        compactHint: compactHint,
                      );
                      return SafeArea(
                        left: false,
                        right: false,
                        bottom: false,
                        minimum: EdgeInsets.only(top: isFullscreen ? 16 : 0),
                        child:
                            isFullscreen
                                ? NonogramFullscreenActionDock(child: actions)
                                : actions,
                      );
                    },
                  ),
                ),
              // Đang chọn hàng / cột cho gậy phép: dải hướng dẫn ở mép dưới.
              Positioned(
                left: 16,
                right: landscape ? NonogramBoardLayout.railReserve + 8 : 16,
                bottom: 16,
                child: BlocSelector<NonogramPlayBloc, NonogramPlayState, bool>(
                  selector: (state) => state.isWandActive,
                  builder:
                      (context, active) => AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        child:
                            active
                                ? const Center(child: WandSelectBanner())
                                : const SizedBox.shrink(),
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

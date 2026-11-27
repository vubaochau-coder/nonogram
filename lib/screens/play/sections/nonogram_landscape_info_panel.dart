import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/tester/tester_solve_button.dart';

import '../coach/nonogram_play_coach.dart';
import '../layout/nonogram_board_layout.dart';
import '../modals/nonogram_settings_dialog.dart';
import '../views/clock_action.dart';
import '../views/rotate_screen_action.dart';
import '../widgets/overlay_button.dart';
import 'landscape_info_panel_visibility.dart';
import 'nonogram_landscape_info_card.dart';

export 'landscape_info_panel_visibility.dart';
export 'nonogram_landscape_info_card.dart';

/// Màn ngang: cột trái của bàn chơi. Góc trên: quay lại, thông tin màn; góc
/// dưới: xoay màn hình, cài đặt (đều ít dùng, để tay phải chỉ lo gợi ý và
/// Tô / X).
///
/// Bấm thông tin thì bảng thông tin màn trượt ra từ trái, phủ lên hai nút
/// góc trên; cột nới rộng theo bảng để bảng không che bàn chơi. Cột nằm ngoài
/// vùng đo của bàn chơi nên bàn tự tính lại cỡ ô khi cột đổi bề rộng.
class NonogramLandscapeLeftRail extends StatefulWidget {
  const NonogramLandscapeLeftRail({super.key, this.allowPanel = true});

  /// Màn gần vuông thì không có chỗ cho bảng: ẩn luôn nút thông tin.
  final bool allowPanel;

  /// Bề rộng cột khi mở bảng (gồm lề).
  static const double panelWidth = 184;

  @override
  State<NonogramLandscapeLeftRail> createState() =>
      _NonogramLandscapeLeftRailState();
}

class _NonogramLandscapeLeftRailState extends State<NonogramLandscapeLeftRail>
    with SingleTickerProviderStateMixin {
  final _visibility = LandscapeInfoPanelVisibility.notifier;

  late final AnimationController _slide;
  late final Animation<Offset> _offset;

  /// Cột đang rộng theo bảng. Mở: nới ngay rồi trượt bảng ra; đóng: trượt
  /// bảng vào xong mới thu cột, để bàn chơi chỉ dịch một lần mỗi chiều.
  late bool _wide;

  bool get _showPanel => widget.allowPanel && _visibility.value;

  @override
  void initState() {
    super.initState();
    _wide = _showPanel;
    _slide = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      value: _wide ? 1.0 : 0.0,
    );
    _offset = Tween(
      begin: const Offset(-1.05, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slide, curve: Curves.easeOutCubic));
    _visibility.addListener(_sync);
  }

  @override
  void didUpdateWidget(covariant NonogramLandscapeLeftRail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.allowPanel == widget.allowPanel) return;
    // Đổi giữa chừng (xoay sang màn gần vuông): áp ngay, build theo sau.
    _wide = _showPanel;
    _slide.value = _wide ? 1.0 : 0.0;
  }

  @override
  void dispose() {
    _visibility.removeListener(_sync);
    _slide.dispose();
    super.dispose();
  }

  void _sync() {
    if (_showPanel) {
      if (!_wide) setState(() => _wide = true);
      _slide.forward();
    } else {
      _slide.reverse().whenComplete(() {
        if (mounted && !_showPanel && _wide) setState(() => _wide = false);
      });
    }
  }

  /// Để hướng dẫn thao tác làm nổi bật nút xoay (không có khi dựng cột
  /// riêng lẻ, ngoài trang chơi).
  static GlobalKey? _coachRotateKey(BuildContext context) {
    try {
      return context.read<NonogramCoachReplayNotifier>().railRotateKey;
    } on ProviderNotFoundException {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 10);
    final colors = context.color;
    const rail = NonogramBoardLayout.railReserve;

    return SizedBox(
      width: _wide ? NonogramLandscapeLeftRail.panelWidth : rail,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: rail,
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
                      if (widget.allowPanel) ...[
                        gap,
                        ValueListenableBuilder<bool>(
                          valueListenable: _visibility,
                          builder: (context, visible, _) {
                            return OverlayButton(
                              key: const ValueKey('nonogram-landscape-info'),
                              icon: LucideIcons.info,
                              color: visible ? colors.primary : null,
                              onPressed: LandscapeInfoPanelVisibility.toggle,
                            );
                          },
                        ),
                      ],
                      // Card folded away (or none): a compact clock here.
                      ValueListenableBuilder<bool>(
                        valueListenable: _visibility,
                        builder: (context, _, _) => _showPanel
                            ? const SizedBox.shrink()
                            : const Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: ClockAction(vertical: true),
                              ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Chỉ bản `dev` (công cụ tester).
                      const TesterSolveButton(),
                      if (RotateScreenAction.isSupported) ...[
                        KeyedSubtree(
                          key: _coachRotateKey(context),
                          child: const RotateScreenAction(),
                        ),
                        gap,
                      ],
                      OverlayButton(
                        icon: LucideIcons.settings,
                        onPressed: () => showNonogramSettingsDialog(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_wide)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: NonogramLandscapeLeftRail.panelWidth,
              child: Align(
                alignment: Alignment.topLeft,
                child: SlideTransition(
                  position: _offset,
                  child: const NonogramLandscapeInfoPanel(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

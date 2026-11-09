import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/context_ext.dart';

import '../bloc/nonogram_play_bloc.dart';
import '../bloc/nonogram_play_state.dart';
import '../engine/nonogram_board_layout.dart';
import '../modals/nonogram_settings_dialog.dart';
import '../views/rotate_screen_action.dart';
import '../widgets/overlay_button.dart';

/// Màn ngang: bảng thông tin màn chơi đang mở hay thu gọn. Nhớ trên máy (box
/// tuỳ chọn mở sẵn lúc khởi động); test không có box thì mặc định mở.
abstract final class LandscapeInfoPanelVisibility {
  static const _boxName = 'nonogram_preferences_v1';
  static const _key = 'landscape_info_visible';

  static final ValueNotifier<bool> notifier = ValueNotifier(_read());

  static bool _read() {
    try {
      if (!Hive.isBoxOpen(_boxName)) return true;
      return Hive.box<dynamic>(_boxName).get(_key) != false;
    } catch (_) {
      return true;
    }
  }

  static void toggle() {
    notifier.value = !notifier.value;
    try {
      if (Hive.isBoxOpen(_boxName)) {
        Hive.box<dynamic>(_boxName).put(_key, notifier.value);
      }
    } catch (_) {}
  }
}

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
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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

/// Màn ngang: tên màn, số màn, kích thước, độ khó (giống app bar màn dọc).
class NonogramLandscapeInfoPanel extends StatelessWidget {
  const NonogramLandscapeInfoPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final l10n = context.l10n;

    return BlocBuilder<NonogramPlayBloc, NonogramPlayState>(
      buildWhen: (p, c) => p.puzzle != c.puzzle || p.level != c.level,
      builder: (context, state) {
        final puzzle = state.puzzle;
        final level = puzzle?.level ?? state.level;

        Widget fact(IconData icon, String text) {
          return Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Icon(icon, size: 16, color: colors.onSurfaceVariant),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.labelLarge.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Container(
          key: const ValueKey('nonogram-landscape-info-panel'),
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.fromLTRB(16, 10, 8, 16),
          decoration: BoxDecoration(
            color: colors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colors.primary.withValues(alpha: 0.7),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 16,
                offset: const Offset(4, 4),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nút đóng cùng cỡ dòng tiêu đề, căn giữa theo chiều dọc.
                SizedBox(
                  height: 32,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.nonogramDashboardContinueLevel(level),
                          maxLines: 1,
                          style: context.labelLarge.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.w800,
                            height: 1,
                          ),
                        ),
                      ),
                      IconButton(
                        key: const ValueKey('nonogram-landscape-info-hide'),
                        tooltip: l10n.nonogramPlayInfoHide,
                        onPressed: LandscapeInfoPanelVisibility.toggle,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints.tightFor(
                          width: 32,
                          height: 32,
                        ),
                        iconSize: 18,
                        icon: const Icon(LucideIcons.chevronLeft),
                      ),
                    ],
                  ),
                ),
                if (puzzle != null) ...[
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      puzzle.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: context.titleMedium.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  fact(LucideIcons.grid, '${puzzle.cols} × ${puzzle.rows}'),
                  if (puzzle.difficulty.isNotEmpty)
                    fact(LucideIcons.gauge, puzzle.difficulty),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

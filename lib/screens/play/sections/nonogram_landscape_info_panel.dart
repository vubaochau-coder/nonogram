import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/context_ext.dart';

import '../bloc/nonogram_play_bloc.dart';
import '../bloc/nonogram_play_state.dart';

/// Màn ngang: bảng thông tin màn chơi bên trái đang mở hay thu gọn. Nhớ trên
/// máy (box tuỳ chọn mở sẵn lúc khởi động); test không có box thì mặc định mở.
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

/// Màn ngang: tên màn, số màn, kích thước, độ khó (giống app bar màn dọc),
/// thành một cột hẹp bên trái bàn chơi. Thu gọn thì không chiếm chỗ; mở lại
/// bằng nút thông tin trên cột nút bên phải.
class NonogramLandscapeInfoPanel extends StatelessWidget {
  const NonogramLandscapeInfoPanel({super.key});

  static const double width = 168;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: LandscapeInfoPanelVisibility.notifier,
      builder: (context, visible, _) {
        if (!visible) return const SizedBox.shrink();
        return SizedBox(
          key: const ValueKey('nonogram-landscape-info-panel'),
          width: width,
          child: const _PanelBody(),
        );
      },
    );
  }
}

class _PanelBody extends StatelessWidget {
  const _PanelBody();

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
          margin: const EdgeInsets.fromLTRB(8, 8, 0, 8),
          padding: const EdgeInsets.fromLTRB(14, 6, 4, 14),
          decoration: BoxDecoration(
            color: colors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.gameColors.cardBorder),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.nonogramDashboardContinueLevel(level),
                        style: context.labelLarge.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton(
                      key: const ValueKey('nonogram-landscape-info-hide'),
                      tooltip: l10n.nonogramPlayInfoHide,
                      visualDensity: VisualDensity.compact,
                      iconSize: 18,
                      onPressed: LandscapeInfoPanelVisibility.toggle,
                      icon: const Icon(LucideIcons.chevronLeft),
                    ),
                  ],
                ),
                if (puzzle != null) ...[
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
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

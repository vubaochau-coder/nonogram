import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/context_ext.dart';

import '../bloc/nonogram_play_bloc.dart';
import '../bloc/nonogram_play_state.dart';
import '../views/clock_action.dart';
import 'landscape_info_panel_visibility.dart';

/// Màn ngang: tên màn, số màn, kích thước, độ khó (giống app bar màn dọc) và
/// đồng hồ.
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
            // Bóng gọn trong lề 8px: bàn chơi bên phải vẽ đè lên phần tràn.
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 6,
                offset: const Offset(0, 2),
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
                // The clock lives here while the card is open (the side rail
                // shows a compact one when it is folded away).
                const SizedBox(height: 12),
                const ClockAction(),
              ],
            ),
          ),
        );
      },
    );
  }
}

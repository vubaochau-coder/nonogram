import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/tester/tester_solve_button.dart';
import '../bloc/nonogram_play_bloc.dart';
import '../bloc/nonogram_play_state.dart';

import '../modals/nonogram_settings_dialog.dart';

class NonogramPlayAppBarSection extends StatelessWidget
    implements PreferredSizeWidget {
  const NonogramPlayAppBarSection({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NonogramPlayBloc, NonogramPlayState>(
      buildWhen:
          (p, c) =>
              p.isFullscreen != c.isFullscreen ||
              p.isSolved != c.isSolved ||
              p.puzzle != c.puzzle,
      builder: (context, state) {
        if (state.isFullscreen) return const SizedBox.shrink();

        final puzzle = state.puzzle;
        final title = puzzle?.title ?? 'Nonogram';
        final level = puzzle?.level ?? state.level;
        final subtitle = [
          context.l10n.nonogramDashboardContinueLevel(level),
          if (puzzle != null) '${puzzle.cols} × ${puzzle.rows}',
          if (puzzle != null && puzzle.difficulty.isNotEmpty) puzzle.difficulty,
        ].join('  ·  ');

        return AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.titleMedium.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (puzzle != null)
                Text(
                  subtitle,
                  style: context.labelMedium.copyWith(
                    color: context.color.onSurfaceVariant,
                  ),
                ),
            ],
          ),
          actions: [
            if (!state.isSolved) const TesterSolveButton(),
            if (!state.isSolved)
              IconButton(
                icon: const Icon(LucideIcons.settings, size: 20),
                onPressed: () => showNonogramSettingsDialog(context),
              ),
            const SizedBox(width: 8),
          ],
        );
      },
    );
  }
}

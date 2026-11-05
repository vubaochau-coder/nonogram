import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/context_ext.dart';
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
        final difficulty = puzzle?.difficulty ?? '';

        return AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (puzzle != null)
                Text(
                  'Level $level • $difficulty',
                  style: context.labelSmall.copyWith(
                    color: context.color.onSurfaceVariant,
                  ),
                ),
            ],
          ),
          actions: [
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

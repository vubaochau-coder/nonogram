import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/app_route_intent.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/data/nonogram_repository.dart';
import 'package:nonogram/widgets/nonogram_pixel_art.dart';

import '../bloc/nonogram_dashboard_bloc.dart';
import '../bloc/nonogram_dashboard_state.dart';
import '../dashboard_navigation.dart';

/// Bộ sưu tập: hình của các màn vừa giải.
class NonogramDashboardRecentSection extends StatelessWidget {
  const NonogramDashboardRecentSection({super.key});

  static const _tileWidth = 116.0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NonogramDashboardBloc, NonogramDashboardState>(
      buildWhen: (p, c) => p.isLoading != c.isLoading || p.summary != c.summary,
      builder: (context, state) {
        if (state.isLoading) return const SizedBox.shrink();
        final recent = state.summary.recent;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.l10n.nonogramDashboardRecentTitle,
                    style: context.titleMedium,
                  ),
                ),
                if (recent.isNotEmpty)
                  TextButton(
                    onPressed:
                        () => openFromDashboard(
                          context,
                          const NonogramCompletedResultsIntent(),
                        ),
                    child: Text(context.l10n.nonogramDashboardSeeAll),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (recent.isEmpty)
              const _EmptyCollection()
            else
              SizedBox(
                height: _tileWidth + 52,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  itemCount: recent.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder:
                      (context, index) =>
                          _RecentTile(item: recent[index], width: _tileWidth),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _RecentTile extends StatelessWidget {
  const _RecentTile({required this.item, required this.width});

  final NonogramSolvedPuzzle item;
  final double width;

  @override
  Widget build(BuildContext context) {
    final puzzle = item.puzzle;
    return SizedBox(
      width: width,
      child: Card(
        child: InkWell(
          onTap:
              () => openFromDashboard(
                context,
                NonogramCompletedResultDetailIntent(level: puzzle.level),
              ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: width - 8,
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: context.color.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: NonogramPixelArt.picture(context, puzzle.solution),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 2, 10, 0),
                child: Text(
                  puzzle.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.labelLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
                child: Text(
                  context.l10n.nonogramDashboardContinueLevel(puzzle.level),
                  style: context.labelSmall.copyWith(
                    color: context.color.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyCollection extends StatelessWidget {
  const _EmptyCollection();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: context.color.surfaceContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                LucideIcons.image,
                color: context.color.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                context.l10n.nonogramDashboardRecentEmpty,
                style: context.bodyMedium.copyWith(
                  color: context.color.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

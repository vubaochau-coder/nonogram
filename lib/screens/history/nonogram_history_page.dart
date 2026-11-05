import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/models/nonogram_completed_progress.dart';
import 'package:nonogram/widgets/app_skeleton_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nonogram/core/app_route_intent.dart';
import 'bloc/nonogram_history_bloc.dart';
import 'bloc/nonogram_history_event.dart';
import 'bloc/nonogram_history_state.dart';

class NonogramHistoryPage extends StatelessWidget {
  const NonogramHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return NonogramHistoryBloc(repository: context.read())
          ..add(const HistoryInitialized());
      },
      child: const _NonogramHistoryView(),
    );
  }
}

class _NonogramHistoryView extends StatefulWidget {
  const _NonogramHistoryView();

  @override
  State<_NonogramHistoryView> createState() => _NonogramHistoryViewState();
}

class _NonogramHistoryViewState extends State<_NonogramHistoryView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.nonogramHistoryTitle),
        centerTitle: true,
      ),
      body: BlocBuilder<NonogramHistoryBloc, NonogramHistoryState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const _HistoryLoadingShimmer();
          }

          if (state.error != null && state.items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 48,
                      color: context.color.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.error.toString(),
                      textAlign: TextAlign.center,
                      style: context.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.tonal(
                      onPressed:
                          () => context.read<NonogramHistoryBloc>().add(
                            const HistoryInitialized(),
                          ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state.items.isEmpty) {
            return Center(
              child: Text(
                context.l10n.nonogramHistoryEmpty,
                style: context.bodyLarge.copyWith(
                  color: context.color.onSurfaceVariant,
                ),
              ),
            );
          }

          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
            itemCount: state.items.length + (state.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (state.hasMore && index == state.items.length) {
                context.read<NonogramHistoryBloc>().add(
                  const LoadMoreRequested(),
                );
                return const _HistoryLoadMoreShimmer();
              }

              final item = state.items[index];

              return _HistoryListTile(item: item);
            },
          );
        },
      ),
    );
  }
}

class _HistoryLoadingShimmer extends StatelessWidget {
  const _HistoryLoadingShimmer();

  @override
  Widget build(BuildContext context) {
    final baseColor = context.color.surfaceContainerHigh;
    final highlightColor = context.color.surfaceContainerHighest;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
        itemCount: 6,
        itemBuilder: (context, index) {
          return const _HistorySkeletonTile();
        },
      ),
    );
  }
}

class _HistoryLoadMoreShimmer extends StatelessWidget {
  const _HistoryLoadMoreShimmer();

  @override
  Widget build(BuildContext context) {
    final baseColor = context.color.surfaceContainerHigh;
    final highlightColor = context.color.surfaceContainerHighest;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: const _HistorySkeletonTile(),
    );
  }
}

class _HistorySkeletonTile extends StatelessWidget {
  const _HistorySkeletonTile();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: context.color.surfaceContainerHigh.withValues(alpha: 0.72),
          ),
        ),
        child: const Row(
          children: [
            AppSkeletonBox(width: 44, height: 44, borderRadius: 100),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSkeletonBox(width: 120, height: 16, borderRadius: 8),
                  SizedBox(height: 8),
                  AppSkeletonBox(width: 180, height: 12, borderRadius: 8),
                  SizedBox(height: 6),
                  AppSkeletonBox(width: 132, height: 12, borderRadius: 8),
                ],
              ),
            ),
            SizedBox(width: 16),
            AppSkeletonBox(width: 18, height: 18, borderRadius: 9),
          ],
        ),
      ),
    );
  }
}

class _HistoryListTile extends StatelessWidget {
  final NonogramCompletedProgress item;

  const _HistoryListTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat.yMMMd().format(item.completedAt);

    final duration = Duration(milliseconds: item.bestCompletionMs);
    final timeStr = context.l10n.nonogramPlayDurationFormat(
      duration.inMinutes,
      duration.inSeconds % 60,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: () {
          context.navigate(
            NonogramCompletedResultDetailIntent(level: item.level),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: context.color.surfaceContainerHigh.withValues(alpha: 0.72),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: context.color.primary.withValues(alpha: 0.4),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${item.level}',
                  style: context.labelLarge.copyWith(
                    color: context.color.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.nonogramHistoryLevel(item.level),
                      style: context.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${context.l10n.nonogramHistoryCompletionDate}: $dateStr',
                      style: context.labelSmall.copyWith(
                        color: context.color.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '${context.l10n.nonogramHistoryPlayTime}: $timeStr',
                      style: context.labelSmall.copyWith(
                        color: context.color.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: context.color.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

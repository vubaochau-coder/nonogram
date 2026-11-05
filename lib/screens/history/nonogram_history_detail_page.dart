import 'dart:math';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/core/duration_format.dart';
import 'package:nonogram/models/nonogram_completed_progress.dart';
import 'package:nonogram/models/nonogram_puzzle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nonogram/data/nonogram_repository.dart';
import 'package:nonogram/screens/play/widgets/nonogram_completion_board.dart';

class NonogramHistoryDetailPage extends StatefulWidget {
  final int level;

  const NonogramHistoryDetailPage({super.key, required this.level});

  @override
  State<NonogramHistoryDetailPage> createState() =>
      _NonogramHistoryDetailPageState();
}

class _NonogramHistoryDetailPageState extends State<NonogramHistoryDetailPage> {
  late Future<({NonogramCompletedProgress record, NonogramPuzzle puzzle})?>
  _detailFuture;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  void _loadDetail() {
    _detailFuture = context.read<NonogramRepository>().getCompletedLevelDetail(
      widget.level,
    );
  }

  int _getMaxClueCount(List<List<int>> clues) {
    if (clues.isEmpty) return 0;
    return clues.map((c) => c.length).reduce(max);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<
      ({NonogramCompletedProgress record, NonogramPuzzle puzzle})?
    >(
      future: _detailFuture,
      builder: (context, snapshot) {
        final levelTitle = context.l10n.nonogramHistoryLevel(widget.level);

        return Scaffold(
          appBar: AppBar(title: Text(levelTitle)),
          body: _buildBody(context, snapshot),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    AsyncSnapshot<({NonogramCompletedProgress record, NonogramPuzzle puzzle})?>
    snapshot,
  ) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
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
                snapshot.error.toString(),
                textAlign: TextAlign.center,
                style: context.bodyMedium,
              ),
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: () => setState(() => _loadDetail()),
                child: Text(context.l10n.commonRetry),
              ),
            ],
          ),
        ),
      );
    }

    final data = snapshot.data;
    if (data == null) {
      return Center(
        child: Text(
          context.l10n.nonogramHistoryDetailNotFound,
          style: context.bodyLarge.copyWith(
            color: context.color.onSurfaceVariant,
          ),
        ),
      );
    }

    final dateStr = DateFormat.yMMMMd(
      Localizations.localeOf(context).toLanguageTag(),
    ).format(data.record.completedAt);
    final timeStr = context.formatPlayTime(data.record.bestCompletionMs);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                data.puzzle.title,
                style: context.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.nonogramHistoryCompletedOn(dateStr),
                style: context.bodyMedium.copyWith(
                  color: context.color.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: context.color.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  context.l10n.nonogramHistoryBestTime(timeStr),
                  style: context.labelLarge.copyWith(
                    color: context.color.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Vừa khung màn hình, ô từ 12 đến 36px.
              final puzzle = data.puzzle;
              final cols = puzzle.cols + _getMaxClueCount(puzzle.leftClues);
              final rows = puzzle.rows + _getMaxClueCount(puzzle.topClues);
              final cellSize = min(
                (constraints.maxWidth - 32) / cols,
                (constraints.maxHeight - 32) / rows,
              ).clamp(12.0, 36.0);
              return NonogramCompletionBoard(
                puzzle: puzzle,
                cellSize: cellSize,
                getMaxClueCount: _getMaxClueCount,
                showClueToggle: false,
                initialShowClues: true,
              );
            },
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

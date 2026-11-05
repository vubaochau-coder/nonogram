import 'dart:math';
import 'package:nonogram/core/context_ext.dart';
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
        final data = snapshot.data;
        final levelTitle = context.l10n.nonogramHistoryLevel(widget.level);

        return Scaffold(
          appBar: AppBar(
            title: Text(
              data != null ? '$levelTitle: ${data.puzzle.title}' : levelTitle,
            ),
            centerTitle: true,
          ),
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
                child: const Text('Retry'),
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

    final dateStr = DateFormat.yMMMMd().format(data.record.completedAt);
    final duration = Duration(milliseconds: data.record.bestCompletionMs);
    final timeStr = context.l10n.nonogramPlayDurationFormat(
      duration.inMinutes,
      duration.inSeconds % 60,
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                data.puzzle.title,
                style: context.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.nonogramHistoryCompletedOn(dateStr),
                style: context.bodySmall.copyWith(
                  color: context.color.onSurfaceVariant,
                ),
              ),
              Text(
                '${context.l10n.nonogramHistoryBest}: $timeStr',
                style: context.labelSmall.copyWith(
                  color: context.color.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: NonogramCompletionBoard(
            puzzle: data.puzzle,
            cellSize: 24.0,
            getMaxClueCount: _getMaxClueCount,
            showClueToggle: false,
            initialShowClues: true,
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

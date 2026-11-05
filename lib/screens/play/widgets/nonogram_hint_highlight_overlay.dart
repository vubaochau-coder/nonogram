import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nonogram/core/context_ext.dart';
import '../bloc/nonogram_play_bloc.dart';
import '../bloc/nonogram_play_state.dart';

class NonogramHintHighlightOverlay extends StatefulWidget {
  const NonogramHintHighlightOverlay({super.key});

  @override
  State<NonogramHintHighlightOverlay> createState() =>
      _NonogramHintHighlightOverlayState();
}

class _NonogramHintHighlightOverlayState
    extends State<NonogramHintHighlightOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  Axis? _highlightAxis;
  int? _highlightIndex;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _triggerHighlight(Axis axis, int index) {
    setState(() {
      _highlightAxis = axis;
      _highlightIndex = index;
    });
    _pulseController.forward(from: 0.0).then((_) {
      if (mounted) {
        setState(() {
          _highlightAxis = null;
          _highlightIndex = null;
        });
      }
    });
  }

  int _getMaxClueCount(List<List<int>> clues) {
    if (clues.isEmpty) return 0;
    return clues.map((c) => c.length).reduce(max);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NonogramPlayBloc, NonogramPlayState>(
      listenWhen: (p, c) => c is NonogramPlayHintAppliedState,
      listener: (context, state) {
        if (state is NonogramPlayHintAppliedState) {
          _triggerHighlight(state.axis, state.lineIndex);
        }
      },
      child:
          _highlightAxis == null
              ? const SizedBox.shrink()
              : BlocBuilder<NonogramPlayBloc, NonogramPlayState>(
                buildWhen:
                    (p, c) => p.puzzle != c.puzzle || p.cellSize != c.cellSize,
                builder: (context, state) {
                  final puzzle = state.puzzle;
                  if (puzzle == null) return const SizedBox.shrink();
                  final cellSize = state.cellSize;

                  final leftClueWidth =
                      _getMaxClueCount(puzzle.leftClues) * cellSize;
                  final topClueHeight =
                      _getMaxClueCount(puzzle.topClues) * cellSize;

                  double? left, top, width, height;

                  if (_highlightAxis == Axis.vertical) {
                    // Column
                    left = leftClueWidth + _highlightIndex! * cellSize;
                    top = 0;
                    width = cellSize;
                    height = topClueHeight + puzzle.rows * cellSize;
                  } else {
                    // Row
                    left = 0;
                    top = topClueHeight + _highlightIndex! * cellSize;
                    width = leftClueWidth + puzzle.cols * cellSize;
                    height = cellSize;
                  }

                  return Positioned(
                    left: left,
                    top: top,
                    width: width,
                    height: height,
                    child: IgnorePointer(
                      child: AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          final opacity = (1.0 - _pulseController.value).clamp(
                            0.0,
                            1.0,
                          );
                          return Container(
                            decoration: BoxDecoration(
                              color: context.color.primary.withValues(
                                alpha: 0.3 * opacity,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
    );
  }
}

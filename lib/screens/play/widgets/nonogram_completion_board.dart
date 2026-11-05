import 'package:nonogram/core/app_spacing.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/models/nonogram_puzzle.dart';
import 'package:flutter/material.dart';
import '../../painters/nonogram_left_clues_painter.dart';
import '../../painters/nonogram_solution_painter.dart';
import '../../painters/nonogram_top_clues_painter.dart';

class NonogramCompletionBoard extends StatefulWidget {
  final NonogramPuzzle puzzle;
  final double cellSize;
  final int Function(List<List<int>>) getMaxClueCount;
  final bool showClueToggle;
  final bool initialShowClues;

  const NonogramCompletionBoard({
    super.key,
    required this.puzzle,
    required this.cellSize,
    required this.getMaxClueCount,
    this.showClueToggle = true,
    this.initialShowClues = false,
  });

  @override
  State<NonogramCompletionBoard> createState() =>
      _NonogramCompletionBoardState();
}

class _NonogramCompletionBoardState extends State<NonogramCompletionBoard> {
  bool _showClues = false;
  late final TransformationController _controller;

  @override
  void initState() {
    super.initState();
    _showClues = widget.initialShowClues;
    _controller = TransformationController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxTopClues = widget.getMaxClueCount(widget.puzzle.topClues);
    final maxLeftClues = widget.getMaxClueCount(widget.puzzle.leftClues);

    final topClueHeight = _showClues ? maxTopClues * widget.cellSize : 0.0;
    final leftClueWidth = _showClues ? maxLeftClues * widget.cellSize : 0.0;

    final gridWidth = widget.puzzle.cols * widget.cellSize;
    final gridHeight = widget.puzzle.rows * widget.cellSize;

    final totalWidth = leftClueWidth + gridWidth;
    final totalHeight = topClueHeight + gridHeight;

    return Stack(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return InteractiveViewer(
              transformationController: _controller,
              minScale: 0.1,
              maxScale: 5.0,
              constrained: false,
              boundaryMargin: const EdgeInsets.all(double.infinity),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  minHeight: constraints.maxHeight,
                ),
                child: Center(
                  child: SizedBox(
                    width: totalWidth,
                    height: totalHeight,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // 1. Solution Grid
                        Positioned(
                          left: leftClueWidth,
                          top: topClueHeight,
                          child: CustomPaint(
                            size: Size(gridWidth, gridHeight),
                            painter: NonogramSolutionPainter(
                              solution: widget.puzzle.solution,
                              cellSize: widget.cellSize,
                              filledColor: context.color.onSurface,
                              gridLineColor: context.color.outlineVariant,
                            ),
                          ),
                        ),

                        // 2. Top Clues
                        if (_showClues)
                          Positioned(
                            left: leftClueWidth,
                            top: 0,
                            child: CustomPaint(
                              size: Size(gridWidth, topClueHeight),
                              painter: NonogramTopCluesPainter(
                                clues: widget.puzzle.topClues,
                                satisfiedColumns: List<bool>.filled(
                                  widget.puzzle.cols,
                                  false,
                                  growable: false,
                                ),
                                cellSize: widget.cellSize,
                                lineColor: context.color.surface,
                                majorLineColor: context.color.outline,
                                backgroundColor:
                                    context.gameColors.clueBackground,
                                bandColor: context.gameColors.clueBand,
                                textStyle: context.labelSmall.copyWith(
                                  fontSize: (widget.cellSize * 0.4).clamp(
                                    9.0,
                                    15.0,
                                  ),
                                  fontWeight: FontWeight.w800,
                                  height: 1,
                                ),
                                satisfiedTextStyle: context.labelSmall,
                              ),
                            ),
                          ),

                        // 3. Left Clues
                        if (_showClues)
                          Positioned(
                            left: 0,
                            top: topClueHeight,
                            child: CustomPaint(
                              size: Size(leftClueWidth, gridHeight),
                              painter: NonogramLeftCluesPainter(
                                clues: widget.puzzle.leftClues,
                                satisfiedRows: List<bool>.filled(
                                  widget.puzzle.rows,
                                  false,
                                  growable: false,
                                ),
                                cellSize: widget.cellSize,
                                lineColor: context.color.surface,
                                majorLineColor: context.color.outline,
                                backgroundColor:
                                    context.gameColors.clueBackground,
                                bandColor: context.gameColors.clueBand,
                                textStyle: context.labelSmall.copyWith(
                                  fontSize: (widget.cellSize * 0.4).clamp(
                                    9.0,
                                    15.0,
                                  ),
                                  fontWeight: FontWeight.w800,
                                  height: 1,
                                ),
                                satisfiedTextStyle: context.labelSmall,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        // 4. Local Clue Toggle
        if (widget.showClueToggle)
          Positioned(
            right: AppSpacing.pageHorizontalPadding,
            bottom: AppSpacing.pageHorizontalPadding,
            child: _ClueToggle(
              isActive: _showClues,
              onChanged: (val) => setState(() => _showClues = val),
            ),
          ),
      ],
    );
  }
}

class _ClueToggle extends StatelessWidget {
  final bool isActive;
  final ValueChanged<bool> onChanged;

  const _ClueToggle({required this.isActive, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.color.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(16),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => onChanged(!isActive),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isActive ? Icons.visibility : Icons.visibility_off,
                size: 18,
                color: context.color.primary,
              ),
              const SizedBox(width: 8),
              Text(
                context.l10n.nonogramPlayActionShowClues,
                style: context.bodySmall.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

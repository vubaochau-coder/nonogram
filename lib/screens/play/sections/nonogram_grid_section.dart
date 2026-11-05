import 'package:nonogram/models/nonogram_grid_equality.dart';
import 'package:nonogram/models/nonogram_interaction_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nonogram/core/context_ext.dart';
import '../../painters/nonogram_grid_painter.dart';
import '../../painters/nonogram_cells_painter.dart';
import '../nonogram_transformation_controller_provider.dart';
import '../bloc/nonogram_play_bloc.dart';
import '../bloc/nonogram_play_event.dart';
import '../bloc/nonogram_play_state.dart';

class NonogramGridSection extends StatefulWidget {
  const NonogramGridSection({super.key});

  @override
  State<NonogramGridSection> createState() => _NonogramGridSectionState();
}

class _NonogramGridSectionState extends State<NonogramGridSection> {
  // Local gesture gate to prevent flicker and conflicting events
  bool _didPanDuringPointerSequence = false;

  void _onPanStart(Offset localPosition, NonogramPlayState state) {
    if (state.interactionMode != NonogramInteractionMode.draw) return;

    _didPanDuringPointerSequence = true;

    final cell = _getCellFromPosition(localPosition);
    if (cell == null) return;

    context.read<NonogramPlayBloc>().add(DragStarted(cell.row, cell.col));
  }

  void _onPanUpdate(Offset localPosition, NonogramPlayState state) {
    if (state.interactionMode != NonogramInteractionMode.draw) return;

    final cell = _getCellFromPosition(localPosition);
    if (cell == null) return;

    context.read<NonogramPlayBloc>().add(DragUpdated(cell.row, cell.col));
  }

  void _onPanEnd(NonogramPlayState state) {
    if (state.interactionMode != NonogramInteractionMode.draw) return;
    _resetGestureFlags();

    final controller = NonogramTransformationControllerProvider.of(context);
    final translation = controller.value.getTranslation();

    context.read<NonogramPlayBloc>().add(
      DragEnded(offsetX: translation.x, offsetY: translation.y),
    );
  }

  void _resetGestureFlags() {
    _didPanDuringPointerSequence = false;
  }

  ({int row, int col})? _getCellFromPosition(Offset localPosition) {
    final state = context.read<NonogramPlayBloc>().state;
    final puzzle = state.puzzle;
    if (puzzle == null) return null;
    final cellSize = state.cellSize;

    final col = localPosition.dx ~/ cellSize;
    final row = localPosition.dy ~/ cellSize;

    if (row >= 0 && row < puzzle.rows && col >= 0 && col < puzzle.cols) {
      return (row: row, col: col);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NonogramPlayBloc, NonogramPlayState>(
      buildWhen: (p, c) {
        return p.puzzle != c.puzzle ||
            p.cellSize != c.cellSize ||
            p.interactionMode != c.interactionMode ||
            p.satisfiedRows != c.satisfiedRows ||
            p.satisfiedCols != c.satisfiedCols ||
            !NonogramGridEquality.equals(p.gridData, c.gridData);
      },
      builder: (context, state) {
        final puzzle = state.puzzle;
        if (puzzle == null) return const SizedBox.shrink();
        final cellSize = state.cellSize;

        final gridWidth = puzzle.cols * cellSize;
        final gridHeight = puzzle.rows * cellSize;
        final isDrawMode =
            state.interactionMode == NonogramInteractionMode.draw;
        final markedMarkerColor =
            Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFFF2B84B)
                : const Color(0xFFB06A00);

        return IgnorePointer(
          // Ignore hits in pan mode or when loading
          ignoring: !isDrawMode || state.isLoading,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapUp: (details) {
              if (isDrawMode && !_didPanDuringPointerSequence) {
                final cell = _getCellFromPosition(details.localPosition);
                if (cell != null) {
                  final controller =
                      NonogramTransformationControllerProvider.of(context);
                  final translation = controller.value.getTranslation();

                  context.read<NonogramPlayBloc>().add(
                    CellTapped(
                      cell.row,
                      cell.col,
                      offsetX: translation.x,
                      offsetY: translation.y,
                    ),
                  );
                }
              }
              _resetGestureFlags();
            },
            onPanStart: (details) => _onPanStart(details.localPosition, state),
            onPanUpdate:
                (details) => _onPanUpdate(details.localPosition, state),
            onPanEnd: (_) => _onPanEnd(state),
            onPanCancel: () => _onPanEnd(state),
            onLongPressStart: (details) {
              if (isDrawMode && !_didPanDuringPointerSequence) {
                final cell = _getCellFromPosition(details.localPosition);
                if (cell != null) {
                  final controller =
                      NonogramTransformationControllerProvider.of(context);
                  final translation = controller.value.getTranslation();

                  context.read<NonogramPlayBloc>().add(
                    CellLongPressed(
                      row: cell.row,
                      col: cell.col,
                      offsetX: translation.x,
                      offsetY: translation.y,
                    ),
                  );
                }
              }
            },
            child: SizedBox(
              width: gridWidth,
              height: gridHeight,
              child: Stack(
                children: [
                  // Layer 1: Cells (Background)
                  RepaintBoundary(
                    child: CustomPaint(
                      size: Size(gridWidth, gridHeight),
                      painter: NonogramCellsPainter(
                        rows: puzzle.rows,
                        cols: puzzle.cols,
                        gridData: state.gridData,
                        satisfiedRows: state.satisfiedRows,
                        satisfiedCols: state.satisfiedCols,
                        cellSize: cellSize,
                        filledColor: context.color.primary,
                        markedMarkerColor: markedMarkerColor,
                        markerColor: context.color.error,
                      ),
                    ),
                  ),
                  // Layer 2: Grid Lines (Foreground)
                  IgnorePointer(
                    child: RepaintBoundary(
                      child: CustomPaint(
                        size: Size(gridWidth, gridHeight),
                        painter: NonogramGridPainter(
                          rows: puzzle.rows,
                          cols: puzzle.cols,
                          cellSize: cellSize,
                          themeColor: context.color.primary,
                          lineColor: context.color.outlineVariant,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

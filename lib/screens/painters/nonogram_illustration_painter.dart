import 'package:flutter/material.dart';
import 'package:nonogram/models/nonogram_cell_state.dart';

class NonogramIllustrationPainter extends CustomPainter {
  final List<int> clues;
  final List<NonogramIllustrationRow> rows;
  final Color filledColor;
  final Color markerColor;
  final Color lineColor;
  final Color textColor;
  final Color clueBackgroundColor;
  final double cellSize;
  final double rowGap;

  NonogramIllustrationPainter({
    required this.clues,
    required this.rows,
    required this.filledColor,
    required this.markerColor,
    required this.lineColor,
    required this.textColor,
    required this.clueBackgroundColor,
    this.cellSize = 30,
    this.rowGap = 4,
  }) : assert(rows.isNotEmpty, 'rows must not be empty');

  Size get layoutSize {
    final clueColumns = clues.isEmpty ? 1 : clues.length;
    final cols = rows
        .map((row) => row.cells.length)
        .reduce((value, element) => value > element ? value : element);
    final width = (clueColumns + cols) * cellSize;
    final height = rows.length * cellSize + (rows.length - 1) * rowGap;
    return Size(width, height);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final borderPaint =
        Paint()
          ..color = lineColor.withValues(alpha: 0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5;
    final clueBackgroundPaint =
        Paint()
          ..color = clueBackgroundColor
          ..style = PaintingStyle.fill;

    final clueColumns = clues.isEmpty ? 1 : clues.length;
    final gridStartX = clueColumns * cellSize;

    for (int rowIndex = 0; rowIndex < rows.length; rowIndex++) {
      final row = rows[rowIndex];
      final y = rowIndex * (cellSize + rowGap);

      for (int c = 0; c < clueColumns; c++) {
        final rect = Rect.fromLTWH(c * cellSize, y, cellSize, cellSize);
        canvas.drawRect(rect, clueBackgroundPaint);
        canvas.drawRect(rect, borderPaint);
      }

      for (int i = 0; i < clues.length; i++) {
        final clueValue = clues[clues.length - 1 - i];
        final targetX = clueColumns - i - 1;
        final rect = Rect.fromLTWH(targetX * cellSize, y, cellSize, cellSize);
        _drawCenteredText(
          canvas,
          text: '$clueValue',
          rect: rect,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: cellSize * 0.38,
          ),
        );
      }

      for (int c = 0; c < row.cells.length; c++) {
        final rect = Rect.fromLTWH(
          gridStartX + c * cellSize,
          y,
          cellSize,
          cellSize,
        );
        canvas.drawRect(rect, borderPaint);

        final state = row.cells[c];
        final opacity =
            c < row.cellOpacities.length ? row.cellOpacities[c] : 1.0;
        if (state == NonogramCellState.filled) {
          canvas.drawRect(
            rect.deflate(0.5),
            Paint()
              ..color = filledColor.withValues(alpha: opacity)
              ..style = PaintingStyle.fill,
          );
        } else if (state == NonogramCellState.marked) {
          _drawMarkerX(
            canvas,
            rect: rect,
            color: markerColor.withValues(alpha: opacity),
          );
        }
      }
    }
  }

  void _drawMarkerX(Canvas canvas, {required Rect rect, required Color color}) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..strokeCap = StrokeCap.round;
    final inset = cellSize * 0.4;
    canvas.drawLine(
      Offset(rect.left + inset, rect.top + inset),
      Offset(rect.right - inset, rect.bottom - inset),
      paint,
    );
    canvas.drawLine(
      Offset(rect.right - inset, rect.top + inset),
      Offset(rect.left + inset, rect.bottom - inset),
      paint,
    );
  }

  void _drawCenteredText(
    Canvas canvas, {
    required String text,
    required Rect rect,
    required TextStyle style,
  }) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();

    painter.paint(
      canvas,
      Offset(
        rect.left + (rect.width - painter.width) / 2,
        rect.top + (rect.height - painter.height) / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant NonogramIllustrationPainter oldDelegate) {
    return oldDelegate.clues != clues ||
        oldDelegate.rows != rows ||
        oldDelegate.filledColor != filledColor ||
        oldDelegate.markerColor != markerColor ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.textColor != textColor ||
        oldDelegate.clueBackgroundColor != clueBackgroundColor ||
        oldDelegate.cellSize != cellSize ||
        oldDelegate.rowGap != rowGap;
  }
}

class NonogramIllustrationRow {
  final List<NonogramCellState> cells;
  final List<double> cellOpacities;

  const NonogramIllustrationRow({
    required this.cells,
    this.cellOpacities = const [],
  });

  factory NonogramIllustrationRow.fromIndices({
    required int length,
    List<int> filled = const [],
    List<int> marked = const [],
    Map<int, double> cellOpacities = const {},
  }) {
    final cells = List<NonogramCellState>.filled(
      length,
      NonogramCellState.empty,
    );
    for (final index in filled) {
      if (index >= 0 && index < length) {
        cells[index] = NonogramCellState.filled;
      }
    }
    for (final index in marked) {
      if (index >= 0 && index < length) {
        cells[index] = NonogramCellState.marked;
      }
    }

    final opacities = List<double>.filled(length, 1.0);
    cellOpacities.forEach((index, opacity) {
      if (index >= 0 && index < length) {
        opacities[index] = opacity;
      }
    });

    return NonogramIllustrationRow(cells: cells, cellOpacities: opacities);
  }
}

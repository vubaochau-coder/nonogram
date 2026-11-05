import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/screens/painters/nonogram_illustration_painter.dart';
import 'package:flutter/material.dart';

class GuideNonogramIllustration extends StatelessWidget {
  const GuideNonogramIllustration({
    required this.clues,
    required this.rows,
    this.result,
    required this.filledColor,
    required this.markerColor,
    required this.lineColor,
    required this.textColor,
    required this.clueBackgroundColor,
    super.key,
  });

  final List<int> clues;
  final List<NonogramIllustrationRow> rows;
  final NonogramIllustrationRow? result;
  final Color filledColor;
  final Color markerColor;
  final Color lineColor;
  final Color textColor;
  final Color clueBackgroundColor;

  static const _rowGap = 16.0;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    final painter = NonogramIllustrationPainter(
      clues: clues,
      rows: rows,
      filledColor: filledColor,
      markerColor: markerColor,
      lineColor: lineColor,
      textColor: textColor,
      clueBackgroundColor: clueBackgroundColor,
      rowGap: _rowGap,
    );
    final size = painter.layoutSize;

    children.add(CustomPaint(size: size, painter: painter));

    if (result != null) {
      final resultPainter = NonogramIllustrationPainter(
        clues: clues,
        rows: [result!],
        filledColor: filledColor,
        markerColor: markerColor,
        lineColor: lineColor,
        textColor: textColor,
        clueBackgroundColor: clueBackgroundColor,
        rowGap: _rowGap,
      );
      final resultSize = resultPainter.layoutSize;
      children.add(
        Center(
          child: Icon(
            Icons.keyboard_double_arrow_down_outlined,
            color: context.color.primary,
          ),
        ),
      );
      children.add(CustomPaint(size: resultSize, painter: resultPainter));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(spacing: 16, children: children),
    );
  }
}

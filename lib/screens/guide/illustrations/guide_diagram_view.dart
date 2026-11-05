import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/screens/guide/models/guide_diagram.dart';

/// Vẽ một [GuideDiagram] theo màu của theme; tự thu nhỏ cho vừa bề ngang.
class GuideDiagramView extends StatelessWidget {
  const GuideDiagramView({required this.diagram, super.key});

  final GuideDiagram diagram;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final painter = GuideDiagramPainter(
      diagram: diagram,
      filledColor: colors.onSurface,
      trialColor: colors.primary,
      crossColor: colors.onSurfaceVariant,
      gridBackground: colors.surfaceContainerLow,
      lineColor: colors.outlineVariant,
      borderColor: colors.outline,
      clueBackground: context.gameColors.clueBackground,
      clueTextColor: colors.onSurface,
      linkColor: colors.primary,
    );

    return Align(
      alignment: Alignment.centerLeft,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: CustomPaint(size: painter.layoutSize, painter: painter),
      ),
    );
  }
}

class GuideDiagramPainter extends CustomPainter {
  GuideDiagramPainter({
    required this.diagram,
    required this.filledColor,
    required this.trialColor,
    required this.crossColor,
    required this.gridBackground,
    required this.lineColor,
    required this.borderColor,
    required this.clueBackground,
    required this.clueTextColor,
    required this.linkColor,
    this.cellSize = 28,
  });

  final GuideDiagram diagram;
  final Color filledColor;
  final Color trialColor;
  final Color crossColor;
  final Color gridBackground;
  final Color lineColor;
  final Color borderColor;
  final Color clueBackground;
  final Color clueTextColor;
  final Color linkColor;
  final double cellSize;

  double get _arrowGap => cellSize * 1.3;
  double get _bracketGap => cellSize * 2.1;

  double _linkHeight(int index) =>
      diagram.links[index].isEmpty ? _arrowGap : _bracketGap;

  Size get layoutSize {
    final width = (diagram.clueColumns + diagram.cellColumns) * cellSize;
    var height = 0.0;
    for (var i = 0; i < diagram.groups.length; i++) {
      height += diagram.groups[i].length * cellSize;
      if (i < diagram.links.length) height += _linkHeight(i);
    }
    // +1 để nét viền ngoài không bị cắt.
    return Size(width + 1, height + 1);
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(0.5, 0.5);
    var y = 0.0;
    for (var i = 0; i < diagram.groups.length; i++) {
      final group = diagram.groups[i];
      _paintGroup(canvas, group, y);
      y += group.length * cellSize;
      if (i < diagram.links.length) {
        final h = _linkHeight(i);
        _paintLink(canvas, diagram.links[i], y, h);
        y += h;
      }
    }
  }

  void _paintGroup(Canvas canvas, List<GuideDiagramRow> rows, double top) {
    final clueCols = diagram.clueColumns;
    final cellCols = diagram.cellColumns;
    final gridLeft = clueCols * cellSize;
    final height = rows.length * cellSize;

    final clueRect = Rect.fromLTWH(0, top, gridLeft, height);
    final gridRect = Rect.fromLTWH(gridLeft, top, cellCols * cellSize, height);
    canvas.drawRect(clueRect, Paint()..color = clueBackground);
    canvas.drawRect(gridRect, Paint()..color = gridBackground);

    final thin =
        Paint()
          ..color = lineColor
          ..strokeWidth = 1;
    for (var c = 1; c < clueCols + cellCols; c++) {
      if (c == clueCols) continue;
      final x = c * cellSize;
      canvas.drawLine(Offset(x, top), Offset(x, top + height), thin);
    }
    for (var r = 1; r < rows.length; r++) {
      final yy = top + r * cellSize;
      canvas.drawLine(Offset(0, yy), Offset(gridRect.right, yy), thin);
    }

    for (var r = 0; r < rows.length; r++) {
      final row = rows[r];
      final y = top + r * cellSize;
      // Số chỉ dẫn căn phải sát lưới.
      final offset = clueCols - row.clues.length;
      for (var i = 0; i < row.clues.length; i++) {
        final rect = Rect.fromLTWH(
          (offset + i) * cellSize,
          y,
          cellSize,
          cellSize,
        );
        _paintClue(canvas, rect, row.clues[i], row.crossedClues.contains(i));
      }
      for (var c = 0; c < row.cells.length; c++) {
        final rect = Rect.fromLTWH(
          gridLeft + c * cellSize,
          y,
          cellSize,
          cellSize,
        );
        _paintCell(canvas, rect, row.cells[c]);
      }
    }

    final border =
        Paint()
          ..color = borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;
    canvas.drawRect(clueRect, border);
    canvas.drawRect(gridRect, border);
  }

  void _paintClue(Canvas canvas, Rect rect, int value, bool crossed) {
    final color = crossed ? clueTextColor.withValues(alpha: 0.4) : clueTextColor;
    final tp = TextPainter(
      text: TextSpan(
        text: '$value',
        style: TextStyle(
          color: color,
          fontSize: cellSize * 0.5,
          fontWeight: FontWeight.w800,
          height: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(
      canvas,
      rect.center - Offset(tp.width / 2, tp.height / 2),
    );
    if (crossed) {
      _paintX(canvas, rect.deflate(cellSize * 0.2), crossColor, 1.4);
    }
  }

  void _paintCell(Canvas canvas, Rect rect, GuideCell cell) {
    switch (cell) {
      case GuideCell.empty:
        return;
      case GuideCell.filled:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            rect.deflate(2),
            Radius.circular(cellSize * 0.14),
          ),
          Paint()..color = filledColor,
        );
      case GuideCell.trialFill:
        canvas.drawCircle(
          rect.center,
          cellSize * 0.32,
          Paint()..color = trialColor,
        );
      case GuideCell.cross:
        _paintX(canvas, rect.deflate(cellSize * 0.22), crossColor, 1.8);
      case GuideCell.trialCross:
        _paintX(
          canvas,
          Rect.fromCenter(
            center: rect.center,
            width: cellSize * 0.32,
            height: cellSize * 0.32,
          ),
          trialColor,
          1.6,
        );
    }
  }

  void _paintX(Canvas canvas, Rect rect, Color color, double width) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = width
          ..strokeCap = StrokeCap.round;
    canvas.drawLine(rect.topLeft, rect.bottomRight, paint);
    canvas.drawLine(rect.topRight, rect.bottomLeft, paint);
  }

  void _paintLink(
    Canvas canvas,
    List<GuideDiagramLink> links,
    double top,
    double height,
  ) {
    final stroke =
        Paint()
          ..color = linkColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;
    final fill = Paint()..color = linkColor;
    final gridLeft = diagram.clueColumns * cellSize;
    final pad = cellSize * 0.18;
    final bracketDepth = cellSize * 0.28;

    if (links.isEmpty) {
      final x = gridLeft + diagram.cellColumns * cellSize / 2;
      _paintArrow(
        canvas,
        x,
        top + pad,
        top + height - pad,
        stroke,
        fill,
      );
      return;
    }

    for (final link in links) {
      final fromL = gridLeft + link.fromStart * cellSize + pad;
      final fromR = gridLeft + (link.fromEnd + 1) * cellSize - pad;
      final toL = gridLeft + link.toStart * cellSize + pad;
      final toR = gridLeft + (link.toEnd + 1) * cellSize - pad;

      // Ngoặc mở lên, ôm vùng ô của nhóm trên.
      final topY = top + pad;
      canvas.drawPath(
        Path()
          ..moveTo(fromL, topY)
          ..lineTo(fromL, topY + bracketDepth)
          ..lineTo(fromR, topY + bracketDepth)
          ..lineTo(fromR, topY),
        stroke,
      );
      // Ngoặc mở xuống, ôm vùng ô kết quả ở nhóm dưới.
      final bottomY = top + height - pad;
      canvas.drawPath(
        Path()
          ..moveTo(toL, bottomY)
          ..lineTo(toL, bottomY - bracketDepth)
          ..lineTo(toR, bottomY - bracketDepth)
          ..lineTo(toR, bottomY),
        stroke,
      );

      final x = (toL + toR) / 2;
      final fromX = ((fromL + fromR) / 2 - x).abs() < 1 ? x : (fromL + fromR) / 2;
      final startY = topY + bracketDepth;
      final endY = bottomY - bracketDepth;
      if (fromX != x) {
        // Hai ngoặc lệch tâm: nối bằng đường gấp khúc rồi mới chỉ xuống.
        final midY = (startY + endY) / 2 - cellSize * 0.15;
        canvas.drawPath(
          Path()
            ..moveTo(fromX, startY)
            ..lineTo(fromX, midY)
            ..lineTo(x, midY),
          stroke,
        );
        _paintArrow(canvas, x, midY, endY - 2, stroke, fill);
      } else {
        _paintArrow(canvas, x, startY + 2, endY - 2, stroke, fill);
      }
    }
  }

  void _paintArrow(
    Canvas canvas,
    double x,
    double y0,
    double y1,
    Paint stroke,
    Paint fill,
  ) {
    final head = math.min(cellSize * 0.3, (y1 - y0) * 0.6);
    canvas.drawLine(Offset(x, y0), Offset(x, y1 - head * 0.6), stroke);
    canvas.drawPath(
      Path()
        ..moveTo(x - head * 0.75, y1 - head)
        ..lineTo(x + head * 0.75, y1 - head)
        ..lineTo(x, y1)
        ..close(),
      fill,
    );
  }

  @override
  bool shouldRepaint(GuideDiagramPainter old) =>
      old.diagram != diagram ||
      old.filledColor != filledColor ||
      old.trialColor != trialColor ||
      old.crossColor != crossColor ||
      old.gridBackground != gridBackground ||
      old.lineColor != lineColor ||
      old.borderColor != borderColor ||
      old.clueBackground != clueBackground ||
      old.clueTextColor != clueTextColor ||
      old.linkColor != linkColor ||
      old.cellSize != cellSize;
}

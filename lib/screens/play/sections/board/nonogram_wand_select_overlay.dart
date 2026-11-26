import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/context_ext.dart';

import '../../layout/nonogram_board_layout.dart';
import '../../views/wand_action.dart';

/// Lớp phủ khi đang chọn hàng / cột cho gậy phép: lưới mờ đi để mắt dồn vào
/// hai dải số, và mọi dãy số cùng nhấp nháy vàng theo nhịp của nút gậy
/// phép.
class NonogramWandSelectOverlay extends StatefulWidget {
  const NonogramWandSelectOverlay({
    super.key,
    required this.rows,
    required this.cols,
    required this.cell,
    required this.grid,
    required this.area,
    required this.leftStrip,
    required this.topStrip,
  });

  /// The overlay for the board of [layout] with the grid at [offset].
  factory NonogramWandSelectOverlay.forBoard({
    Key? key,
    required NonogramBoardLayout layout,
    required Offset offset,
  }) {
    final gridW = layout.gridWidth;
    final gridH = layout.gridHeight;
    final leftW = layout.leftStripWidth;
    final topH = layout.topStripHeight;
    final stickyLeft = layout.stickyLeft(offset);
    final stickyTop = layout.stickyTop(offset);
    final area = layout.gridArea(offset);
    return NonogramWandSelectOverlay(
      key: key,
      rows: layout.rows,
      cols: layout.cols,
      cell: layout.cellSize,
      grid: Rect.fromLTWH(offset.dx, offset.dy, gridW, gridH),
      area: area,
      leftStrip: Rect.fromLTRB(
        stickyLeft,
        max(offset.dy, stickyTop + topH),
        stickyLeft + leftW,
        min(offset.dy + gridH, area.bottom),
      ),
      topStrip: Rect.fromLTRB(
        max(offset.dx, stickyLeft + leftW),
        stickyTop,
        min(offset.dx + gridW, area.right),
        stickyTop + topH,
      ),
    );
  }

  final int rows;
  final int cols;
  final double cell;

  /// Toàn bộ lưới (có thể trôi ra ngoài vùng nhìn thấy).
  final Rect grid;

  /// Phần lưới đang nhìn thấy (dưới / phải hai dải số).
  final Rect area;

  /// Phần nhìn thấy của dải số trái / trên.
  final Rect leftStrip;
  final Rect topStrip;

  @override
  State<NonogramWandSelectOverlay> createState() => _WandSelectOverlayState();
}

class _WandSelectOverlayState extends State<NonogramWandSelectOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _wave = AnimationController(
    vsync: this,
    duration: wandPulsePeriod,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _wave
        ..stop()
        ..value = 0;
    } else if (!_wave.isAnimating) {
      _wave.repeat();
    }
  }

  @override
  void dispose() {
    _wave.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _WandSelectPainter(
        wave: _wave,
        animate: !MediaQuery.disableAnimationsOf(context),
        rows: widget.rows,
        cols: widget.cols,
        cell: widget.cell,
        grid: widget.grid,
        area: widget.area,
        leftStrip: widget.leftStrip,
        topStrip: widget.topStrip,
        accent: context.gameColors.reward,
        scrim: context.color.surface,
      ),
    );
  }
}

class _WandSelectPainter extends CustomPainter {
  _WandSelectPainter({
    required this.wave,
    required this.animate,
    required this.rows,
    required this.cols,
    required this.cell,
    required this.grid,
    required this.area,
    required this.leftStrip,
    required this.topStrip,
    required this.accent,
    required this.scrim,
  }) : super(repaint: wave);

  final Animation<double> wave;
  final bool animate;
  final int rows;
  final int cols;
  final double cell;
  final Rect grid;
  final Rect area;
  final Rect leftStrip;
  final Rect topStrip;
  final Color accent;
  final Color scrim;

  /// Độ sáng hiện tại, chung cho mọi dãy số: sáng lên rồi tắt dần trong một
  /// chu kỳ, cùng nhịp với nút gậy phép.
  double get _intensity {
    if (!animate) return 0.5;
    return 0.5 - 0.5 * cos(2 * pi * wave.value);
  }

  void _line(Canvas canvas, Rect rect, double t) {
    final r = RRect.fromRectAndRadius(
      rect.deflate(1),
      const Radius.circular(4),
    );
    canvas.drawRRect(
      r,
      Paint()..color = accent.withValues(alpha: 0.07 + 0.3 * t),
    );
    canvas.drawRRect(
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1 + t
        ..color = accent.withValues(alpha: 0.35 + 0.6 * t),
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final dim = grid.intersect(area);
    if (dim.width > 0 && dim.height > 0) {
      canvas.drawRect(dim, Paint()..color = scrim.withValues(alpha: 0.55));
    }
    if (topStrip.width > 0 && topStrip.height > 0) {
      canvas.save();
      canvas.clipRect(topStrip);
      for (var c = 0; c < cols; c++) {
        final rect = Rect.fromLTWH(
          grid.left + c * cell,
          topStrip.top,
          cell,
          topStrip.height,
        );
        if (rect.overlaps(topStrip)) _line(canvas, rect, _intensity);
      }
      canvas.restore();
    }
    if (leftStrip.width > 0 && leftStrip.height > 0) {
      canvas.save();
      canvas.clipRect(leftStrip);
      for (var r = 0; r < rows; r++) {
        final rect = Rect.fromLTWH(
          leftStrip.left,
          grid.top + r * cell,
          leftStrip.width,
          cell,
        );
        if (rect.overlaps(leftStrip)) _line(canvas, rect, _intensity);
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_WandSelectPainter old) =>
      old.animate != animate ||
      old.rows != rows ||
      old.cols != cols ||
      old.cell != cell ||
      old.grid != grid ||
      old.area != area ||
      old.leftStrip != leftStrip ||
      old.topStrip != topStrip ||
      old.accent != accent ||
      old.scrim != scrim;
}

import 'package:flutter/material.dart';

import '../nonogram_tutorial_controller.dart';

/// Nháy nền xanh lần lượt từng cách đặt khối hợp lệ trên [line]: sáng lên,
/// tắt đi rồi chuyển sang cách tiếp theo, lặp mãi. Ô sáng ở mọi cách là ô
/// chắc chắn được tô; ô không sáng ở cách nào là ô chắc chắn trống.
/// Khi giảm chuyển động: vẽ đứng yên mọi cách chồng lên nhau.
class TutorialGhostBlink extends StatefulWidget {
  const TutorialGhostBlink({
    super.key,
    required this.line,
    required this.placements,
    required this.cellSize,
    required this.color,
  });

  final TutorialLine line;
  final List<Set<int>> placements;
  final double cellSize;
  final Color color;

  /// Thời gian cho mỗi cách đặt: sáng lên, giữ, tắt, nghỉ.
  static const _perPlacement = Duration(milliseconds: 1800);

  @override
  State<TutorialGhostBlink> createState() => _GhostBlinkState();
}

class _GhostBlinkState extends State<TutorialGhostBlink>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animation = AnimationController(
    vsync: this,
    duration: TutorialGhostBlink._perPlacement * widget.placements.length,
  );
  bool _still = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _still = MediaQuery.disableAnimationsOf(context);
    if (_still) {
      _animation.stop();
    } else if (!_animation.isAnimating) {
      _animation.repeat();
    }
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final placements = widget.placements;
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        final List<(Set<int>, double)> shown;
        if (_still) {
          shown = [for (final p in placements) (p, 1 / placements.length)];
        } else {
          final t = _animation.value * placements.length;
          final index = t.floor().clamp(0, placements.length - 1);
          final f = t - index;
          // 0–20%: sáng lên, 20–65%: giữ, 65–85%: tắt, 85–100%: nghỉ.
          final opacity = f < 0.2
              ? f / 0.2
              : f < 0.65
              ? 1.0
              : f < 0.85
              ? (0.85 - f) / 0.2
              : 0.0;
          shown = [(placements[index], opacity)];
        }
        return CustomPaint(
          painter: _GhostPainter(
            line: widget.line,
            shown: shown,
            cellSize: widget.cellSize,
            color: widget.color,
          ),
        );
      },
    );
  }
}

class _GhostPainter extends CustomPainter {
  _GhostPainter({
    required this.line,
    required this.shown,
    required this.cellSize,
    required this.color,
  });

  final TutorialLine line;

  /// Các cách đặt đang hiện, kèm độ đậm (0–1).
  final List<(Set<int>, double)> shown;
  final double cellSize;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    for (final (cells, opacity) in shown) {
      if (opacity <= 0) continue;
      final paint = Paint()..color = color.withValues(alpha: 0.45 * opacity);
      for (final i in cells) {
        final rect =
            (line.isRow
                    ? Rect.fromLTWH(
                        i * cellSize,
                        line.index * cellSize,
                        cellSize,
                        cellSize,
                      )
                    : Rect.fromLTWH(
                        line.index * cellSize,
                        i * cellSize,
                        cellSize,
                        cellSize,
                      ))
                .deflate(cellSize * 0.08);
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(cellSize * 0.12)),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _GhostPainter oldDelegate) => true;
}

/// Viền sáng quanh từng đoạn ô liền nhau cần làm trong mỗi hàng.
class TutorialHighlightPainter extends CustomPainter {
  TutorialHighlightPainter({
    required this.cells,
    required this.cellSize,
    required this.color,
  });

  final Set<TutorialCell> cells;
  final double cellSize;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (cells.isEmpty) return;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Cả một cột (ô vừa hiện đáp án): một khung dọc.
    final sameCol = cells.map((c) => c.col).toSet();
    if (cells.length > 1 && sameCol.length == 1) {
      final rows = cells.map((c) => c.row).toList()..sort();
      if (rows.last - rows.first == rows.length - 1) {
        final col = sameCol.first;
        final rect = Rect.fromLTRB(
          col * cellSize,
          rows.first * cellSize,
          (col + 1) * cellSize,
          (rows.last + 1) * cellSize,
        ).deflate(2.5);
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(cellSize * 0.1)),
          paint,
        );
        return;
      }
    }

    final byRow = <int, List<int>>{};
    for (final cell in cells) {
      byRow.putIfAbsent(cell.row, () => []).add(cell.col);
    }
    for (final entry in byRow.entries) {
      final cols = entry.value..sort();
      var start = cols.first;
      for (var i = 1; i <= cols.length; i++) {
        if (i < cols.length && cols[i] == cols[i - 1] + 1) continue;
        final end = cols[i - 1];
        final rect = Rect.fromLTRB(
          start * cellSize,
          entry.key * cellSize,
          (end + 1) * cellSize,
          (entry.key + 1) * cellSize,
        ).deflate(2.5);
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(cellSize * 0.1)),
          paint,
        );
        if (i < cols.length) start = cols[i];
      }
    }
  }

  @override
  bool shouldRepaint(covariant TutorialHighlightPainter oldDelegate) {
    return !_sameCells(oldDelegate.cells, cells) ||
        oldDelegate.cellSize != cellSize ||
        oldDelegate.color != color;
  }

  static bool _sameCells(Set<TutorialCell> a, Set<TutorialCell> b) {
    return a.length == b.length && a.containsAll(b);
  }
}

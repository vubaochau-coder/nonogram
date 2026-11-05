import 'dart:math';

import 'package:flutter/material.dart';

/// Vẽ một lưới ô (true = tô) thành hình pixel-art, tự co giãn vừa khung và
/// căn giữa. Dùng cho ảnh thu nhỏ của màn đã giải và xem trước ván dở.
class NonogramPixelArt extends StatelessWidget {
  const NonogramPixelArt({
    super.key,
    required this.cells,
    required this.color,
    this.emptyColor,
  });

  /// Từ ma trận solution (1 = tô).
  NonogramPixelArt.fromSolution({
    super.key,
    required List<List<int>> solution,
    required this.color,
    this.emptyColor,
  }) : cells = [
         for (final row in solution) [for (final cell in row) cell == 1],
       ];

  final List<List<bool>> cells;
  final Color color;

  /// Màu ô trống; null thì không vẽ ô trống.
  final Color? emptyColor;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PixelArtPainter(
        cells: cells,
        color: color,
        emptyColor: emptyColor,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _PixelArtPainter extends CustomPainter {
  _PixelArtPainter({
    required this.cells,
    required this.color,
    required this.emptyColor,
  });

  final List<List<bool>> cells;
  final Color color;
  final Color? emptyColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (cells.isEmpty || cells.first.isEmpty) return;
    final rows = cells.length;
    final cols = cells.first.length;
    final cell = min(size.width / cols, size.height / rows);
    final left = (size.width - cell * cols) / 2;
    final top = (size.height - cell * rows) / 2;

    // Ô đủ to thì chừa khe và bo góc cho giống ô nonogram; ô nhỏ vẽ liền để
    // hình không bị lưới làm nhoè.
    final gap = cell >= 6 ? cell * 0.1 : 0.0;
    final radius = Radius.circular(cell >= 6 ? cell * 0.2 : 0);
    final filled = Paint()..color = color;
    final empty = emptyColor == null ? null : (Paint()..color = emptyColor!);

    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        final paint = cells[r][c] ? filled : empty;
        if (paint == null) continue;
        final rect = Rect.fromLTWH(
          left + c * cell + gap / 2,
          top + r * cell + gap / 2,
          // +0.5 khi không có khe để tránh vệt hở giữa các ô do làm tròn.
          cell - gap + (gap == 0 ? 0.5 : 0),
          cell - gap + (gap == 0 ? 0.5 : 0),
        );
        canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_PixelArtPainter old) =>
      old.cells != cells || old.color != color || old.emptyColor != emptyColor;
}

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

  /// Bức tranh hoàn chỉnh, dùng đúng màu của bàn chơi (ô tô = màu ô tô
  /// trên lưới, ô trống = nền lưới) ở cả chế độ sáng và tối, để tranh kết quả
  /// trông giống hệt lúc giải. Vẽ cả ô trống, vì có màn mà hình chủ đề chính
  /// là phần ô trống.
  static Widget picture(BuildContext context, List<List<int>> solution) {
    final colors = Theme.of(context).colorScheme;
    return NonogramPixelArt.fromSolution(
      solution: solution,
      color: colors.onSurface,
      emptyColor: colors.surfaceContainerLow,
    );
  }

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

/// Bức tranh vẽ đúng kiểu bàn chơi (nền lưới, đường kẻ, ô tô bo góc), tự co
/// giãn vừa khung và căn giữa. Dùng ở màn kết quả, để tranh bay từ bàn chơi
/// vào vẫn giữ nguyên dáng.
class NonogramBoardPicture extends StatelessWidget {
  const NonogramBoardPicture({super.key, required this.solution});

  final List<List<int>> solution;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return CustomPaint(
      painter: _BoardPicturePainter(
        solution: solution,
        background: colors.surfaceContainerLow,
        filled: colors.onSurface,
        line: colors.outlineVariant,
        majorLine: colors.outline,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _BoardPicturePainter extends CustomPainter {
  _BoardPicturePainter({
    required this.solution,
    required this.background,
    required this.filled,
    required this.line,
    required this.majorLine,
  });

  final List<List<int>> solution;
  final Color background;
  final Color filled;
  final Color line;
  final Color majorLine;

  @override
  void paint(Canvas canvas, Size size) {
    if (solution.isEmpty || solution.first.isEmpty) return;
    final rows = solution.length;
    final cols = solution.first.length;
    final cell = min(size.width / cols, size.height / rows);
    final left = (size.width - cell * cols) / 2;
    final top = (size.height - cell * rows) / 2;
    final grid = Rect.fromLTWH(left, top, cell * cols, cell * rows);

    canvas.drawRect(grid, Paint()..color = background);
    final fill = Paint()..color = filled;
    final inset = cell >= 16 ? 1.5 : (cell >= 6 ? 0.5 : 0.0);
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        if (solution[r][c] != 1) continue;
        final rect = Rect.fromLTWH(left + c * cell, top + r * cell, cell, cell);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            // Ô nhỏ vẽ liền (+0.5) để không hở vệt giữa các ô.
            inset == 0 ? rect.inflate(0.25) : rect.deflate(inset),
            Radius.circular(cell * 0.12),
          ),
          fill,
        );
      }
    }

    // Ô quá nhỏ thì chỉ kẻ các đường chia nhóm 5 để hình không bị nhoè.
    final thin = Paint()..color = line;
    final major = Paint()..color = majorLine;
    final showThin = cell >= 6;
    for (var i = 0; i <= cols; i++) {
      final isMajor = i % 5 == 0 || i == cols;
      if (!isMajor && !showThin) continue;
      final x = left + i * cell;
      canvas.drawLine(
        Offset(x, grid.top),
        Offset(x, grid.bottom),
        (isMajor ? major : thin)..strokeWidth = isMajor ? 1 : 0.6,
      );
    }
    for (var i = 0; i <= rows; i++) {
      final isMajor = i % 5 == 0 || i == rows;
      if (!isMajor && !showThin) continue;
      final y = top + i * cell;
      canvas.drawLine(
        Offset(grid.left, y),
        Offset(grid.right, y),
        (isMajor ? major : thin)..strokeWidth = isMajor ? 1 : 0.6,
      );
    }
  }

  @override
  bool shouldRepaint(_BoardPicturePainter old) =>
      old.solution != solution ||
      old.background != background ||
      old.filled != filled ||
      old.line != line ||
      old.majorLine != majorLine;
}

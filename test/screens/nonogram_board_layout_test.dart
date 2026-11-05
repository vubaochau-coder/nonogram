import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/screens/play/engine/nonogram_board_layout.dart';

NonogramBoardLayout _layout({
  int rows = 45,
  int cols = 45,
  int left = 10,
  int top = 10,
  double cell = 24,
  Size viewport = const Size(390, 700),
}) {
  return NonogramBoardLayout(
    viewport: viewport,
    rows: rows,
    cols: cols,
    maxLeftClues: left,
    maxTopClues: top,
    cellSize: cell,
  );
}

void main() {
  group('small board', () {
    final layout = _layout(rows: 5, cols: 5, left: 2, top: 2, cell: 40);

    test('is centered and cannot be dragged', () {
      final x = layout.xRange;
      final y = layout.yRange;
      expect(x.min, x.max);
      expect(y.min, y.max);
      expect(layout.clamp(const Offset(-500, 900)), layout.startOffset);
    });

    test('clue strips sit right next to the grid', () {
      final t = layout.startOffset;
      expect(layout.stickyLeft(t), t.dx - layout.leftStripWidth);
      expect(layout.stickyTop(t), t.dy - layout.topStripHeight);
    });
  });

  group('large board', () {
    final layout = _layout();

    test('opens with the grid corner next to both clue strips', () {
      final t = layout.startOffset;
      expect(t.dx, NonogramBoardLayout.edgeInset + layout.leftStripWidth);
      expect(t.dy, NonogramBoardLayout.toolbarReserve + layout.topStripHeight);
    });

    test('clue strips stick to the edges when the grid scrolls away', () {
      final scrolled = layout.clamp(const Offset(-400, -500));
      expect(layout.stickyLeft(scrolled), NonogramBoardLayout.edgeInset);
      expect(layout.stickyTop(scrolled), NonogramBoardLayout.toolbarReserve);
    });

    test('cannot scroll the grid end past the right/bottom margin', () {
      final t = layout.clamp(const Offset(-99999, -99999));
      expect(
        t.dx + layout.gridWidth,
        layout.viewport.width - NonogramBoardLayout.endMargin,
      );
      expect(
        t.dy + layout.gridHeight,
        layout.viewport.height - NonogramBoardLayout.endMargin,
      );
    });

    test('clue strip depth is limited so strips do not fill the screen', () {
      // Tối đa ~34% chiều rộng, trừ khi độ dày tối thiểu buộc phải rộng hơn.
      final limit = [
        390 * 0.34,
        layout.maxLeftClues * NonogramBoardLayout.minClueDepth,
      ].reduce((a, b) => a > b ? a : b);
      expect(layout.leftStripWidth, lessThanOrEqualTo(limit + 0.01));
      expect(
        layout.leftClueDepth,
        greaterThanOrEqualTo(NonogramBoardLayout.minClueDepth),
      );
    });

    test('cellAt maps points to cells and ignores the clue strips', () {
      final t = layout.clamp(const Offset(-200, -300));
      final inside = t + const Offset(24 * 20 + 5, 24 * 30 + 5);
      expect(layout.cellAt(inside, t), (row: 30, col: 20));

      // Một điểm trên dải trái (đang dính mép) không chạm vào ô bên dưới.
      final onLeftStrip = Offset(NonogramBoardLayout.edgeInset + 5, inside.dy);
      expect(layout.cellAt(onLeftStrip, t), isNull);
    });

    test('zoom can go small enough to see the whole grid', () {
      expect(layout.minZoom, lessThanOrEqualTo(12));
      expect(
        layout.minZoom,
        greaterThanOrEqualTo(NonogramBoardLayout.minZoomCellSize),
      );
    });
  });

  test('zoomAround keeps the point under the focal point fixed', () {
    const t = Offset(100, 200);
    const focal = Offset(250, 400);
    final moved = NonogramBoardLayout.zoomAround(
      t: t,
      focal: focal,
      from: 20,
      to: 40,
    );
    // Điểm lưới dưới tâm: (focal - t) / cell phải giữ nguyên.
    expect((focal - t) / 20, (focal - moved) / 40);
  });
}

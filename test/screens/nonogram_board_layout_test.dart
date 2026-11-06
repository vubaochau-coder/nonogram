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
      // Phía dưới được kéo quá thêm một đoạn để nút "giữ để kéo" không che ô.
      expect(
        t.dy + layout.gridHeight,
        layout.viewport.height -
            NonogramBoardLayout.endMargin -
            NonogramBoardLayout.bottomOverscroll,
      );
    });

    test('clue strips never exceed their cap', () {
      final many = _layout(left: 35, top: 29);
      expect(
        many.leftStripWidth,
        lessThanOrEqualTo(
          (390 - NonogramBoardLayout.edgeInset) *
                  NonogramBoardLayout.stripCapFraction +
              0.01,
        ),
      );
      expect(many.topStripHeight, lessThanOrEqualTo(many.topStripCap + 0.01));
      expect(
        many.leftClueDepth,
        greaterThanOrEqualTo(NonogramBoardLayout.minClueDepth),
      );
      // Phần bị cắt cuộn được để xem.
      expect(many.leftClueOverflow, greaterThan(0));
      expect(
        many.leftStripWidth + many.leftClueOverflow,
        closeTo(many.leftStripContent, 0.01),
      );
    });

    test('clue depth follows the cell size when there is room', () {
      final small = _layout(left: 3, top: 3, cell: 20);
      final big = _layout(left: 3, top: 3, cell: 36);
      expect(small.leftClueDepth, closeTo(20 * 0.65, 0.01));
      expect(big.leftClueDepth, closeTo(36 * 0.65, 0.01));
      expect(
        _layout(left: 3, top: 3, cell: 80).leftClueDepth,
        NonogramBoardLayout.maxClueDepth,
      );
    });

    test('zooming in does not grow the strips past their cap', () {
      final zoomed = _layout(left: 16, top: 16, cell: 60);
      expect(zoomed.leftStripWidth, lessThanOrEqualTo(zoomed.leftStripCap));
      expect(zoomed.topStripHeight, lessThanOrEqualTo(zoomed.topStripCap));
      expect(
        zoomed.leftStripWidth,
        greaterThan(zoomed.leftStripCap - zoomed.leftClueDepth),
      );
    });

    test('a clipped strip shows whole clue columns only', () {
      final many = _layout(left: 35, top: 29);
      final columns = many.leftStripWidth / many.leftClueDepth;
      expect(columns, closeTo(columns.roundToDouble(), 1e-9));
      expect(
        many.leftClueOverflow / many.leftClueDepth,
        closeTo((35 - columns).roundToDouble(), 1e-9),
      );
    });

    test('compact clues leave more room for the grid', () {
      final full = _layout(left: 16, top: 16);
      final compact = NonogramBoardLayout(
        viewport: full.viewport,
        rows: full.rows,
        cols: full.cols,
        maxLeftClues: 16,
        maxTopClues: 16,
        cellSize: full.cellSize,
        compactClues: true,
      );
      expect(compact.leftStripWidth, lessThan(full.leftStripWidth));
      expect(compact.topStripHeight, lessThan(full.topStripHeight));
    });

    test('regionAt tells grid, strips and empty space apart', () {
      final t = layout.startOffset;
      expect(
        layout.regionAt(t + const Offset(5, 5), t),
        NonogramBoardRegion.grid,
      );
      expect(
        layout.regionAt(Offset(t.dx - 5, t.dy + 30), t),
        NonogramBoardRegion.leftStrip,
      );
      expect(
        layout.regionAt(Offset(t.dx + 30, t.dy - 5), t),
        NonogramBoardRegion.topStrip,
      );
      // Ô góc giữa hai dải.
      expect(
        layout.regionAt(Offset(t.dx - 5, t.dy - 5), t),
        NonogramBoardRegion.empty,
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

  group('landscape', () {
    final layout = _layout(viewport: const Size(900, 380));

    test('no toolbar row on top, a rail on the right instead', () {
      expect(layout.isLandscape, isTrue);
      expect(layout.topReserve, 0);
      expect(layout.rightReserve, NonogramBoardLayout.railReserve);
      expect(layout.startOffset.dy, layout.topStripHeight);
    });

    test('grid end stops before the rail', () {
      final t = layout.clamp(const Offset(-99999, -99999));
      expect(
        t.dx + layout.gridWidth,
        900 - NonogramBoardLayout.railReserve - NonogramBoardLayout.endMargin,
      );
    });

    test('top strip is capped by the short height', () {
      final many = _layout(viewport: const Size(900, 380), top: 16);
      expect(many.topStripHeight, lessThanOrEqualTo(380 * 0.30 + 0.01));
    });
  });
}

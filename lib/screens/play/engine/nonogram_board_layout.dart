import 'dart:math';
import 'dart:ui';

import 'package:nonogram/models/nonogram_puzzle.dart';

/// Hình học của bàn chơi trong khung nhìn: lưới có thể kéo/zoom, còn hai dải
/// gợi ý "dính" — nằm sát lưới, nhưng không bao giờ trôi ra khỏi mép trái /
/// mép trên (ngay dưới hàng nút công cụ).
///
/// Vị trí lưới được mô tả bằng [Offset] `t` = toạ độ góc trên-trái của lưới
/// trong khung nhìn. Zoom thực hiện bằng cách đổi [cellSize], không phóng to
/// hình, nên nét vẽ luôn sắc và dải gợi ý luôn thẳng hàng với lưới.
class NonogramBoardLayout {
  NonogramBoardLayout({
    required this.viewport,
    required this.rows,
    required this.cols,
    required this.maxLeftClues,
    required this.maxTopClues,
    required this.cellSize,
  });

  factory NonogramBoardLayout.forPuzzle({
    required NonogramPuzzle puzzle,
    required double cellSize,
    required Size viewport,
  }) {
    int maxCount(List<List<int>> clues) =>
        clues.fold(0, (m, c) => max(m, c.length));
    return NonogramBoardLayout(
      viewport: viewport,
      rows: puzzle.rows,
      cols: puzzle.cols,
      maxLeftClues: maxCount(puzzle.leftClues),
      maxTopClues: maxCount(puzzle.topClues),
      cellSize: cellSize,
    );
  }

  /// Chừa phía trên cho hàng nút công cụ nổi.
  static const double toolbarReserve = 64;

  /// Khoảng cách tối thiểu từ mép trái và mép phải/dưới.
  static const double edgeInset = 8;
  static const double endMargin = 16;

  /// Cỡ ô nhỏ nhất khi tự co cho vừa màn hình (còn chạm trúng được).
  static const double minAutoCellSize = 24;

  /// Giới hạn zoom.
  static const double maxZoomCellSize = 80;
  static const double minZoomCellSize = 6;

  /// Mỗi ô số trong dải gợi ý dày từ 14 đến 26px, sao cho cả dải chiếm tối
  /// đa khoảng 1/3 chiều rộng (trái) hoặc 28% chiều cao (trên).
  static const double minClueDepth = 14;
  static const double maxClueDepth = 26;

  final Size viewport;
  final int rows;
  final int cols;
  final int maxLeftClues;
  final int maxTopClues;
  final double cellSize;

  static double _depth(int count, double room) {
    if (count == 0) return 0;
    return (room / count).clamp(minClueDepth, maxClueDepth);
  }

  /// Độ dày mỗi cột số của dải trái / mỗi hàng số của dải trên. Chỉ phụ
  /// thuộc khung nhìn, nên không đổi khi zoom.
  double get leftClueDepth => _depth(maxLeftClues, viewport.width * 0.34);
  double get topClueDepth =>
      _depth(maxTopClues, (viewport.height - toolbarReserve) * 0.28);

  double get leftStripWidth => maxLeftClues * leftClueDepth;
  double get topStripHeight => maxTopClues * topClueDepth;
  double get gridWidth => cols * cellSize;
  double get gridHeight => rows * cellSize;

  double get _startX => edgeInset;
  double get _startY => toolbarReserve;

  /// Khoảng hợp lệ cho một trục: nếu cả dải + lưới vừa thì cố định ở giữa,
  /// nếu không thì kéo được từ "mép lưới sát dải gợi ý" tới "mép cuối lưới
  /// cách mép khung [endMargin]".
  static ({double min, double max}) _range({
    required double view,
    required double start,
    required double strip,
    required double grid,
  }) {
    final room = view - start - endMargin;
    if (strip + grid <= room) {
      final t = start + strip + (room - strip - grid) / 2;
      return (min: t, max: t);
    }
    return (min: view - endMargin - grid, max: start + strip);
  }

  ({double min, double max}) get xRange => _range(
    view: viewport.width,
    start: _startX,
    strip: leftStripWidth,
    grid: gridWidth,
  );

  ({double min, double max}) get yRange => _range(
    view: viewport.height,
    start: _startY,
    strip: topStripHeight,
    grid: gridHeight,
  );

  /// Vị trí mở màn: góc trên-trái của lưới nằm sát hai dải gợi ý.
  Offset get startOffset => Offset(xRange.max, yRange.max);

  Offset clamp(Offset t) {
    final x = xRange;
    final y = yRange;
    return Offset(t.dx.clamp(x.min, x.max), t.dy.clamp(y.min, y.max));
  }

  /// Vị trí của dải trái / dải trên: sát lưới, nhưng dính lại ở mép khi
  /// lưới bị kéo đi.
  double stickyLeft(Offset t) => max(_startX, t.dx - leftStripWidth);
  double stickyTop(Offset t) => max(_startY, t.dy - topStripHeight);

  /// Ô dưới điểm [p] (toạ độ khung nhìn), hoặc null nếu điểm nằm ngoài lưới
  /// hoặc trên dải gợi ý (dải che lên lưới khi dính mép).
  ({int row, int col})? cellAt(Offset p, Offset t) {
    if (p.dx < stickyLeft(t) + leftStripWidth) return null;
    if (p.dy < stickyTop(t) + topStripHeight) return null;
    final col = ((p.dx - t.dx) / cellSize).floor();
    final row = ((p.dy - t.dy) / cellSize).floor();
    if (row < 0 || row >= rows || col < 0 || col >= cols) return null;
    return (row: row, col: col);
  }

  /// Cỡ ô để cả lưới vừa phần khung nhìn còn lại sau hai dải gợi ý.
  double get _rawFitCellSize {
    if (rows == 0 || cols == 0) return maxZoomCellSize;
    final w = viewport.width - _startX - leftStripWidth - endMargin;
    final h = viewport.height - _startY - topStripHeight - endMargin;
    return min(w / cols, h / rows);
  }

  /// Cỡ ô cho màn mới: không lớn hơn [preferred], không nhỏ hơn
  /// [minAutoCellSize] (trừ khi chính [preferred] nhỏ hơn).
  double fitCellSize(double preferred) {
    final fit = _rawFitCellSize.floorToDouble();
    if (fit >= preferred) return preferred;
    final floor = min(preferred, minAutoCellSize);
    return max(fit, floor);
  }

  /// Zoom nhỏ nhất: đủ để nhìn toàn bộ lưới (nhưng không dưới
  /// [minZoomCellSize]), và không lớn hơn 12 để màn nhỏ vẫn thu được.
  double get minZoom =>
      _rawFitCellSize.floorToDouble().clamp(minZoomCellSize, 12.0);

  /// Vị trí mới sau khi zoom từ [cellSize] lên [newCellSize] mà giữ nguyên
  /// điểm lưới đang nằm dưới [focal].
  static Offset zoomAround({
    required Offset t,
    required Offset focal,
    required double from,
    required double to,
  }) {
    final ratio = to / from;
    return focal - (focal - t) * ratio;
  }
}

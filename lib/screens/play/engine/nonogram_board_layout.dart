import 'dart:math';
import 'dart:ui';

import 'package:nonogram/models/nonogram_puzzle.dart';

/// Vùng của bàn chơi dưới một điểm chạm.
enum NonogramBoardRegion { grid, leftStrip, topStrip, empty }

/// Hình học của bàn chơi trong khung nhìn: lưới kéo được, còn hai dải
/// gợi ý "dính" — nằm sát lưới, nhưng không bao giờ trôi ra khỏi mép trái /
/// mép trên.
///
/// Vị trí lưới được mô tả bằng [Offset] `t` = toạ độ góc trên-trái của lưới
/// trong khung nhìn.
///
/// Dải gợi ý:
/// - Độ dày mỗi ô số tỉ lệ với [cellSize].
/// - Mỗi dải có trần cứng theo tỉ lệ khung nhìn ([leftStripCap],
///   [topStripCap]); nhiều số hơn trần thì dải chỉ hiện các số gần lưới
///   nhất, phần còn lại cuộn được ([leftClueOverflow], [topClueOverflow]).
///
/// Cỡ ô không zoom được: luôn là cỡ lớn nhất vừa khung nhìn trong khoảng
/// [minCellSize]..[maxCellSize] ([fitCellSize]); lưới lớn hơn khung nhìn
/// thì kéo để xem.
///
/// Màn hình ngang ([isLandscape]): hàng nút công cụ chuyển thành cột dọc ở
/// mép phải, nên không chừa phía trên mà chừa [rightReserve] bên phải.
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

  /// Khung nhìn ngang hay dọc. Bàn chơi, bloc (tự co cỡ ô) và hàng nút đều
  /// dùng chung quy tắc này để khớp nhau.
  static bool isLandscapeViewport(Size viewport) =>
      viewport.width > viewport.height;

  /// Màn dọc: chừa phía trên cho hàng nút công cụ nổi.
  static const double toolbarReserve = 64;

  /// Màn ngang: chừa bên phải cho cột nút công cụ.
  static const double railReserve = 60;

  /// Khoảng cách tối thiểu từ mép trái và mép phải/dưới.
  static const double edgeInset = 8;
  static const double endMargin = 16;

  /// Khoảng cỡ ô (dp): bàn chơi dùng cỡ lớn nhất vừa khung nhìn trong
  /// khoảng này.
  static const double minCellSize = 28;
  static const double maxCellSize = 44;

  static double clampCellSize(double size) =>
      size.clamp(minCellSize, maxCellSize).toDouble();

  /// Độ dày mỗi ô số trong dải gợi ý: tỉ lệ [clueDepthRatio] với cỡ ô, trong
  /// khoảng [minClueDepth]..[maxClueDepth]. Nếu dải vượt trần thì ép dần về
  /// [minClueDepth] trước khi phải cuộn.
  static const double minClueDepth = 18;
  static const double maxClueDepth = 26;
  static const double clueDepthRatio = 0.65;

  /// Trần của mỗi dải theo tỉ lệ chiều tương ứng của khung nhìn.
  static const double stripCapFraction = 0.30;

  final Size viewport;
  final int rows;
  final int cols;
  final int maxLeftClues;
  final int maxTopClues;
  final double cellSize;

  bool get isLandscape => isLandscapeViewport(viewport);

  double get topReserve => isLandscape ? 0 : toolbarReserve;
  double get rightReserve => isLandscape ? railReserve : 0;

  /// Chiều rộng / cao dành cho dải + lưới.
  double get _roomWidth => viewport.width - _startX - rightReserve;
  double get _roomHeight => viewport.height - _startY;

  double get _naturalDepth =>
      (cellSize * clueDepthRatio).clamp(minClueDepth, maxClueDepth);

  /// Trần chiều rộng dải trái / chiều cao dải trên.
  double get leftStripCap => _roomWidth * stripCapFraction;
  double get topStripCap => _roomHeight * stripCapFraction;

  static double _depth(int count, double natural, double cap) {
    if (count == 0) return 0;
    return max(minClueDepth, min(natural, cap / count));
  }

  /// Độ dày mỗi cột số của dải trái / mỗi hàng số của dải trên.
  double get leftClueDepth => _depth(maxLeftClues, _naturalDepth, leftStripCap);
  double get topClueDepth => _depth(maxTopClues, _naturalDepth, topStripCap);

  /// Kích thước đầy đủ của dải (nếu hiện hết các số).
  double get leftStripContent => maxLeftClues * leftClueDepth;
  double get topStripContent => maxTopClues * topClueDepth;

  /// Kích thước dải thực sự hiện trên màn hình. Khi bị cắt thì cắt tròn
  /// theo từng cột/hàng số, để không có số nào bị che một nửa.
  double get leftStripWidth =>
      _visible(leftStripContent, leftStripCap, leftClueDepth);
  double get topStripHeight =>
      _visible(topStripContent, topStripCap, topClueDepth);

  static double _visible(double content, double cap, double depth) {
    if (content <= cap) return content;
    return max(depth, (cap / depth).floorToDouble() * depth);
  }

  /// Phần dải bị cắt (cuộn được để xem).
  double get leftClueOverflow => max(0, leftStripContent - leftStripWidth);
  double get topClueOverflow => max(0, topStripContent - topStripHeight);

  double get gridWidth => cols * cellSize;
  double get gridHeight => rows * cellSize;

  double get _startX => edgeInset;
  double get _startY => topReserve;

  /// Khoảng hợp lệ cho một trục: nếu cả dải + lưới vừa thì cố định ở giữa,
  /// nếu không thì kéo được từ "mép lưới sát dải gợi ý" tới "mép cuối lưới
  /// cách mép khung [endMargin]".
  static ({double min, double max}) _range({
    required double end,
    required double start,
    required double strip,
    required double grid,
  }) {
    final room = end - start - endMargin;
    if (strip + grid <= room) {
      final t = start + strip + (room - strip - grid) / 2;
      return (min: t, max: t);
    }
    return (min: end - endMargin - grid, max: start + strip);
  }

  ({double min, double max}) get xRange => _range(
    end: viewport.width - rightReserve,
    start: _startX,
    strip: leftStripWidth,
    grid: gridWidth,
  );

  ({double min, double max}) get yRange => _range(
    end: viewport.height,
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

  /// Phần khung nhìn mà lưới có thể hiện ra (sau hai dải và phần chừa cho
  /// nút công cụ).
  Rect gridArea(Offset t) => Rect.fromLTRB(
    stickyLeft(t) + leftStripWidth,
    stickyTop(t) + topStripHeight,
    viewport.width - rightReserve,
    viewport.height,
  );

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

  /// Vùng dưới điểm [p]: ô lưới, dải trái, dải trên, hoặc chỗ trống.
  NonogramBoardRegion regionAt(Offset p, Offset t) {
    if (cellAt(p, t) != null) return NonogramBoardRegion.grid;
    final left = stickyLeft(t);
    final top = stickyTop(t);
    final inLeftX = p.dx >= left && p.dx < left + leftStripWidth;
    final inTopY = p.dy >= top && p.dy < top + topStripHeight;
    final inRowsY =
        p.dy >= max(t.dy, top + topStripHeight) && p.dy < t.dy + gridHeight;
    final inColsX =
        p.dx >= max(t.dx, left + leftStripWidth) && p.dx < t.dx + gridWidth;
    if (inLeftX && inRowsY) return NonogramBoardRegion.leftStrip;
    if (inTopY && inColsX) return NonogramBoardRegion.topStrip;
    return NonogramBoardRegion.empty;
  }

  NonogramBoardLayout withCellSize(double size) => NonogramBoardLayout(
    viewport: viewport,
    rows: rows,
    cols: cols,
    maxLeftClues: maxLeftClues,
    maxTopClues: maxTopClues,
    cellSize: size,
  );

  /// Cỡ ô lớn nhất để cả lưới vừa phần khung nhìn còn lại sau hai dải gợi
  /// ý. Độ dày dải phụ thuộc cỡ ô nên tìm bằng chia đôi.
  double get _rawFitCellSize {
    if (rows == 0 || cols == 0) return maxCellSize;
    bool fits(double c) {
      final l = withCellSize(c);
      final w = _roomWidth - l.leftStripWidth - endMargin;
      final h = _roomHeight - l.topStripHeight - endMargin;
      return c * cols <= w && c * rows <= h;
    }

    var lo = 0.0;
    var hi = maxCellSize;
    if (fits(hi)) return hi;
    for (var i = 0; i < 30; i++) {
      final mid = (lo + hi) / 2;
      if (fits(mid)) {
        lo = mid;
      } else {
        hi = mid;
      }
    }
    return lo;
  }

  /// Cỡ ô: lớn nhất để cả lưới vừa khung nhìn, trong khoảng
  /// [minCellSize]..[maxCellSize].
  double fitCellSize() => clampCellSize(_rawFitCellSize.floorToDouble());
}

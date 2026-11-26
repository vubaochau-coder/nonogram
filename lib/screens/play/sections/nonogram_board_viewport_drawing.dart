part of 'nonogram_board_viewport.dart';

/// Drawing by dragging over the grid (with auto-scroll near the edges) and
/// scrolling the clue strips.
mixin _BoardDrawing on _BoardViewportBase {
  void _dragTo(Offset position) {
    final layout = _layout;
    if (layout == null) return;
    final cell = layout.cellAt(position, _offset);
    final last = _lastDragCell;
    if (cell == null || last == null || cell == last) return;

    // Tô cả các ô nằm giữa nếu ngón tay lướt nhanh qua nhiều ô.
    for (final step in _cellsBetween(last, cell)) {
      _bloc.add(DragUpdated(step.row, step.col));
      _drawCells++;
    }
    _lastDragCell = cell;
  }

  void _endDraw() {
    // Đã kéo qua nhiều ô: người chơi biết kéo, không cần mẹo nữa.
    if (_drawCells > 0) DragTip.maybeOf(context)?.dragged();
    _drawCells = 0;
    _autoScroll.stop();
    _drawStartPoint = null;
    _lastDrawPoint = null;
    _lastDragCell = null;
    final o = _offset;
    _bloc.add(DragEnded(offsetX: o.dx, offsetY: o.dy));
  }

  /// Một ngón kéo trên dải gợi ý: theo chiều dọc lưới thì kéo bàn, theo
  /// chiều vuông góc thì cuộn các số bị cắt.
  void _dragStrip(Offset delta) {
    final layout = _layout;
    if (layout == null) return;
    final scroll = _clueScroll.value;
    if (_gesture == _GestureKind.leftStrip) {
      _clueScroll.value = Offset(
        (scroll.dx + delta.dx).clamp(0, layout.leftClueOverflow),
        scroll.dy,
      );
      _setOffset(layout.clamp(_offset + Offset(0, delta.dy)));
    } else {
      _clueScroll.value = Offset(
        scroll.dx,
        (scroll.dy + delta.dy).clamp(0, layout.topClueOverflow),
      );
      _setOffset(layout.clamp(_offset + Offset(delta.dx, 0)));
    }
  }

  void _endStripDrag() {
    // Dừng ở ranh giới cột/hàng số để không có số nào bị che một nửa.
    final layout = _layout;
    if (layout != null) {
      double snap(double v, double depth, double max) =>
          depth <= 0 ? v : ((v / depth).round() * depth).clamp(0, max);
      final scroll = _clueScroll.value;
      _clueScroll.value = Offset(
        snap(scroll.dx, layout.leftClueDepth, layout.leftClueOverflow),
        snap(scroll.dy, layout.topClueDepth, layout.topClueOverflow),
      );
    }
    final o = _offset;
    _bloc.add(ViewportChanged(o.dx, o.dy));
  }

  // --- Tự cuộn khi tô sát mép ---

  static const double _edgeZone = 40;

  /// Hệ số -1..1 cho một trục: dương = bàn trôi về phía tăng toạ độ (lộ các
  /// ô phía trước), âm = ngược lại. Chỉ bật cạnh mà ngón tay đã đi về phía
  /// đó, để bắt đầu tô ngay sát dải gợi ý không làm bàn trôi.
  static double _edgeFactor(double p, double start, double lo, double hi) {
    const armed = 12.0;
    if (p < lo + _edgeZone && p < start - armed) {
      return ((lo + _edgeZone - p) / _edgeZone).clamp(0.0, 1.0);
    }
    if (p > hi - _edgeZone && p > start + armed) {
      return -((p - (hi - _edgeZone)) / _edgeZone).clamp(0.0, 1.0);
    }
    return 0;
  }

  @override
  void _onAutoScrollTick(Duration elapsed) {
    final dt = (elapsed - _autoScrollLast).inMicroseconds / 1e6;
    _autoScrollLast = elapsed;
    final layout = _layout;
    final point = _lastDrawPoint;
    final start = _drawStartPoint;
    if (layout == null || point == null || start == null || dt <= 0) return;
    if (_gesture != _GestureKind.draw) return;

    final o = _offset;
    final area = layout.gridArea(o);
    final fx = _edgeFactor(point.dx, start.dx, area.left, area.right);
    final fy = _edgeFactor(point.dy, start.dy, area.top, area.bottom);
    if (fx == 0 && fy == 0) return;

    final speed = (layout.cellSize * 14).clamp(320.0, 1100.0);
    final next = layout.clamp(o + Offset(fx, fy) * speed * dt);
    if (next == o) return;
    _setOffset(next);
    _dragTo(point);
  }
}

/// Các ô nằm trên đoạn thẳng từ [a] tới [b] (không gồm [a]).
List<({int row, int col})> _cellsBetween(
  ({int row, int col}) a,
  ({int row, int col}) b,
) {
  final dr = b.row - a.row;
  final dc = b.col - a.col;
  final steps = max(dr.abs(), dc.abs());
  return [
    for (var i = 1; i <= steps; i++)
      (
        row: a.row + (dr * i / steps).round(),
        col: a.col + (dc * i / steps).round(),
      ),
  ];
}

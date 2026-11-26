part of 'nonogram_board_viewport.dart';

/// Tap, long press, one / two finger drags and mouse wheel on the board.
mixin _BoardGestures on _BoardViewportBase, _BoardDrawing {
  // --- Chạm / nhấn giữ ---

  void _onTapUp(TapUpDetails details) {
    final layout = _layout;
    if (layout == null) return;
    if (_wandActive) {
      final line = layout.clueLineAt(details.localPosition, _offset);
      if (line == null) return;
      final o = _offset;
      HapticFeedback.lightImpact();
      _bloc.add(
        WandLineSelected(
          isRow: line.isRow,
          index: line.index,
          offsetX: o.dx,
          offsetY: o.dy,
        ),
      );
      return;
    }
    final cell = layout.cellAt(details.localPosition, _offset);
    if (cell == null) return;
    if (_rejectLocked(cell)) return;
    final o = _offset;
    _bloc.add(CellTapped(cell.row, cell.col, offsetX: o.dx, offsetY: o.dy));
    DragTip.maybeOf(context)?.cellTapped();
  }

  void _onLongPressStart(LongPressStartDetails details) {
    final layout = _layout;
    if (layout == null || _wandActive) return;
    final cell = layout.cellAt(details.localPosition, _offset);
    if (cell == null) return;
    if (_rejectLocked(cell)) return;
    // Rung ngay lúc nhấn giữ được nhận, để người chơi biết đã có thể nhấc
    // tay (khó đoán phải giữ bao lâu).
    AppHaptics.longPress();
    final o = _offset;
    _bloc.add(
      CellLongPressed(
        row: cell.row,
        col: cell.col,
        offsetX: o.dx,
        offsetY: o.dy,
      ),
    );
  }

  /// Chạm / nhấn giữ vào ô khoá: không đổi gì, chỉ rung nhẹ và nháy ô đó
  /// để báo ô đã khoá.
  bool _rejectLocked(({int row, int col}) cell) {
    if (!_bloc.state.isLocked(cell.row, cell.col)) return false;
    HapticFeedback.lightImpact();
    _showHint(cells: [cell]);
    return true;
  }

  // --- Kéo để tô / kéo bàn / cuộn dải gợi ý ---

  void _onScaleStart(ScaleStartDetails details) {
    final layout = _layout;
    if (layout == null) return;

    if (details.pointerCount > 1) {
      _startNavigate(details.localFocalPoint);
      return;
    }

    // Xét chỗ ngón tay chạm xuống, không phải chỗ đã trượt qua ngưỡng nhận
    // cử chỉ.
    final start = _pointerDownPosition ?? details.localFocalPoint;
    switch (layout.regionAt(start, _offset)) {
      case NonogramBoardRegion.grid when !_wandActive:
        final cell = layout.cellAt(start, _offset)!;
        _gesture = _GestureKind.draw;
        _lastDragCell = cell;
        _drawStartPoint = start;
        _lastDrawPoint = details.localFocalPoint;
        _bloc.add(DragStarted(cell.row, cell.col));
        _dragTo(details.localFocalPoint);
        _autoScrollLast = Duration.zero;
        if (!_autoScroll.isActive) _autoScroll.start();
      case NonogramBoardRegion.leftStrip when layout.leftClueOverflow > 0:
        _gesture = _GestureKind.leftStrip;
      case NonogramBoardRegion.topStrip when layout.topClueOverflow > 0:
        _gesture = _GestureKind.topStrip;
      default:
        // Chỗ trống hoặc dải không bị cắt: kéo bàn.
        _startNavigate(details.localFocalPoint);
    }
  }

  void _startNavigate(Offset focal) {
    _gesture = _GestureKind.navigate;
    _navStartOffset = _offset;
    _navStartFocal = focal;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    switch (_gesture) {
      case _GestureKind.draw:
        if (details.pointerCount > 1) {
          // Thêm ngón thứ hai giữa chừng: dừng tô, chuyển sang kéo bàn.
          _endDraw();
          _startNavigate(details.localFocalPoint);
          return;
        }
        _lastDrawPoint = details.localFocalPoint;
        _dragTo(details.localFocalPoint);
      case _GestureKind.navigate:
        _navigate(details.localFocalPoint);
      case _GestureKind.leftStrip || _GestureKind.topStrip:
        if (details.pointerCount > 1) {
          _endStripDrag();
          _startNavigate(details.localFocalPoint);
          return;
        }
        _dragStrip(details.focalPointDelta);
      case _GestureKind.none:
        break;
    }
  }

  void _onScaleEnd(ScaleEndDetails details) {
    switch (_gesture) {
      case _GestureKind.draw:
        _endDraw();
      case _GestureKind.navigate:
        _endNavigate();
      case _GestureKind.leftStrip || _GestureKind.topStrip:
        _endStripDrag();
      case _GestureKind.none:
        break;
    }
    _gesture = _GestureKind.none;
  }

  // --- Kéo bàn ---

  void _navigate(Offset focal) {
    final layout = _layout;
    if (layout == null) return;
    _setOffset(layout.clamp(_navStartOffset + (focal - _navStartFocal)));
  }

  void _endNavigate() {
    final o = _offset;
    _bloc.add(ViewportChanged(o.dx, o.dy));
  }

  // --- Chuột / trackpad: lăn để kéo ---

  void _onPointerSignal(PointerSignalEvent event) {
    final layout = _layout;
    if (layout == null || event is! PointerScrollEvent) return;
    _setOffset(layout.clamp(_offset - event.scrollDelta));
    _scheduleViewportSave();
  }

  bool _saveScheduled = false;
  void _scheduleViewportSave() {
    if (_saveScheduled) return;
    _saveScheduled = true;
    Future.delayed(const Duration(milliseconds: 400), () {
      _saveScheduled = false;
      if (!mounted) return;
      final o = _offset;
      _bloc.add(ViewportChanged(o.dx, o.dy));
    });
  }
}

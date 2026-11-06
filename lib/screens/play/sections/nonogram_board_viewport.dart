import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/models/nonogram_grid_equality.dart';

import '../../painters/nonogram_cells_painter.dart';
import '../../painters/nonogram_grid_painter.dart';
import '../../painters/nonogram_left_clues_painter.dart';
import '../../painters/nonogram_top_clues_painter.dart';
import '../bloc/nonogram_play_bloc.dart';
import '../bloc/nonogram_play_event.dart';
import '../bloc/nonogram_play_state.dart';
import '../engine/nonogram_board_layout.dart';
import '../nonogram_transformation_controller_provider.dart';

/// Bàn chơi: lưới kéo/zoom được, hai dải gợi ý dính mép.
///
/// Vị trí lưới (góc trên-trái, toạ độ khung nhìn) nằm trong
/// [TransformationController] dùng chung, để các nút và việc lưu ván đọc
/// được. Zoom đổi `cellSize` trong bloc chứ không phóng to hình.
///
/// Cử chỉ (chạm tô hay đánh X tuỳ chế độ Tô / X trong bloc):
/// - Chạm = tô / đánh X một ô, nhấn giữ = việc ngược lại, kéo một ngón bắt
///   đầu trên lưới = tô / đánh X liên tiếp (tới sát mép thì bàn tự trôi).
/// - Kéo một ngón bắt đầu ngoài lưới: trên dải trái thì cuộn dọc (và cuộn
///   ngang các số bị cắt), trên dải trên thì cuộn ngang (và cuộn dọc các số
///   bị cắt), chỗ trống thì kéo bàn.
/// - Hai ngón = kéo bàn và chụm để zoom.
/// - Chuột/trackpad: lăn để kéo, Ctrl/⌘ + lăn hoặc chụm trackpad để zoom.
class NonogramBoardViewport extends StatefulWidget {
  const NonogramBoardViewport({super.key});

  @override
  State<NonogramBoardViewport> createState() => _NonogramBoardViewportState();
}

enum _GestureKind { none, draw, navigate, leftStrip, topStrip }

class _NonogramBoardViewportState extends State<NonogramBoardViewport>
    with TickerProviderStateMixin {
  late final AnimationController _hintPulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );
  Axis? _hintAxis;
  int? _hintIndex;

  // Trạng thái cử chỉ hiện tại.
  _GestureKind _gesture = _GestureKind.none;
  Offset? _pointerDownPosition;
  ({int row, int col})? _lastDragCell;
  double _zoomStartCell = 0;
  Offset _zoomStartOffset = Offset.zero;
  Offset _zoomStartFocal = Offset.zero;
  double? _liveCellSize;

  /// Phần dải gợi ý đang cuộn để xem các số bị cắt: dx cho dải trái, dy
  /// cho dải trên (0 = đang hiện các số gần lưới nhất).
  final ValueNotifier<Offset> _clueScroll = ValueNotifier(Offset.zero);

  // Tự cuộn khi tô sát mép.
  late final Ticker _autoScroll = createTicker(_onAutoScrollTick);
  Duration _autoScrollLast = Duration.zero;
  Offset? _drawStartPoint;
  Offset? _lastDrawPoint;

  NonogramBoardLayout? _layout;

  /// Ván nào đã được đặt vị trí ban đầu (puzzle + thời điểm bắt đầu).
  Object? _placedFor;

  /// Lần đầu thấy một ván (màn mới, chơi lại, hoặc khôi phục ván dở): đặt
  /// lưới ở vị trí đã lưu, hoặc ở vị trí mở màn (sát hai dải gợi ý).
  void _placeIfNewGame(NonogramPlayState state, NonogramBoardLayout layout) {
    final key = (state.puzzle?.id, state.startTime);
    if (key == _placedFor) return;
    _placedFor = key;
    final saved = _bloc.takePendingViewport();
    final target = layout.clamp(saved ?? layout.startOffset);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _setOffset(target);
      _clueScroll.value = Offset.zero;
    });
  }

  @override
  void dispose() {
    _autoScroll.dispose();
    _hintPulse.dispose();
    _clueScroll.dispose();
    super.dispose();
  }

  TransformationController get _controller =>
      NonogramTransformationControllerProvider.of(context);

  Offset get _offset {
    final t = _controller.value.getTranslation();
    return Offset(t.x, t.y);
  }

  void _setOffset(Offset value) {
    _controller.value = Matrix4.translationValues(value.dx, value.dy, 0);
  }

  NonogramPlayBloc get _bloc => context.read<NonogramPlayBloc>();

  // --- Chạm / nhấn giữ ---

  void _onTapUp(TapUpDetails details) {
    final layout = _layout;
    if (layout == null) return;
    final cell = layout.cellAt(details.localPosition, _offset);
    if (cell == null) return;
    final o = _offset;
    _bloc.add(CellTapped(cell.row, cell.col, offsetX: o.dx, offsetY: o.dy));
  }

  void _onLongPressStart(LongPressStartDetails details) {
    final layout = _layout;
    if (layout == null) return;
    final cell = layout.cellAt(details.localPosition, _offset);
    if (cell == null) return;
    final o = _offset;
    _bloc.add(
      CellLongPressed(
        row: cell.row,
        col: cell.col,
        offsetX: o.dx,
        offsetY: o.dy,
      ),
    );
    HapticFeedback.selectionClick();
  }

  // --- Kéo để tô / kéo-zoom / cuộn dải gợi ý ---

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
      case NonogramBoardRegion.grid:
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
    _zoomStartCell = _bloc.state.cellSize;
    _zoomStartOffset = _offset;
    _zoomStartFocal = focal;
    _liveCellSize = null;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    switch (_gesture) {
      case _GestureKind.draw:
        if (details.pointerCount > 1) {
          // Thêm ngón thứ hai giữa chừng: dừng tô, chuyển sang kéo/zoom.
          _endDraw();
          _startNavigate(details.localFocalPoint);
          return;
        }
        _lastDrawPoint = details.localFocalPoint;
        _dragTo(details.localFocalPoint);
      case _GestureKind.navigate:
        _navigate(details.localFocalPoint, details.scale);
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

  void _dragTo(Offset position) {
    final layout = _layout;
    if (layout == null) return;
    final cell = layout.cellAt(position, _offset);
    final last = _lastDragCell;
    if (cell == null || last == null || cell == last) return;

    // Tô cả các ô nằm giữa nếu ngón tay lướt nhanh qua nhiều ô.
    for (final step in _cellsBetween(last, cell)) {
      _bloc.add(DragUpdated(step.row, step.col));
    }
    _lastDragCell = cell;
  }

  void _endDraw() {
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

  // --- Kéo / zoom ---

  void _navigate(Offset focal, double scale) {
    final layout = _layout;
    if (layout == null) return;
    final newCell = NonogramBoardLayout.clampCellSize(_zoomStartCell * scale);
    // Giữ điểm lưới dưới tâm chụm ban đầu nằm dưới tâm chụm hiện tại (vừa
    // kéo vừa zoom).
    final moved = NonogramBoardLayout.zoomAround(
      t: _zoomStartOffset + (focal - _zoomStartFocal),
      focal: focal,
      from: _zoomStartCell,
      to: newCell,
    );
    if ((newCell - _bloc.state.cellSize).abs() > 0.01) {
      _liveCellSize = newCell;
      _bloc.add(CellSizePreviewed(newCell));
    }
    _setOffset(layout.withCellSize(newCell).clamp(moved));
  }

  void _endNavigate() {
    final o = _offset;
    final zoomed = _liveCellSize;
    _liveCellSize = null;
    if (zoomed != null) {
      _bloc.add(
        CellSizeChanged(cellSize: zoomed, offsetX: o.dx, offsetY: o.dy),
      );
    } else {
      _bloc.add(ViewportChanged(o.dx, o.dy));
    }
  }

  // --- Chuột / trackpad ---

  void _onPointerSignal(PointerSignalEvent event) {
    final layout = _layout;
    if (layout == null) return;
    if (event is PointerScrollEvent) {
      final keys = HardwareKeyboard.instance;
      if (keys.isControlPressed || keys.isMetaPressed) {
        _zoomBy(exp(-event.scrollDelta.dy / 300), event.localPosition);
      } else {
        _setOffset(layout.clamp(_offset - event.scrollDelta));
        _scheduleViewportSave();
      }
    } else if (event is PointerScaleEvent) {
      _zoomBy(event.scale, event.localPosition);
    }
  }

  void _zoomBy(double factor, Offset focal) {
    final layout = _layout;
    if (layout == null) return;
    final from = _bloc.state.cellSize;
    final to = NonogramBoardLayout.clampCellSize(from * factor);
    if ((to - from).abs() < 0.01) return;
    final moved = NonogramBoardLayout.zoomAround(
      t: _offset,
      focal: focal,
      from: from,
      to: to,
    );
    final clamped = layout.withCellSize(to).clamp(moved);
    _setOffset(clamped);
    _bloc.add(
      CellSizeChanged(cellSize: to, offsetX: clamped.dx, offsetY: clamped.dy),
    );
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

  // --- Gợi ý (hint) ---

  void _showHint(Axis axis, int index) {
    setState(() {
      _hintAxis = axis;
      _hintIndex = index;
    });
    _hintPulse.forward(from: 0).then((_) {
      if (mounted) {
        setState(() {
          _hintAxis = null;
          _hintIndex = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NonogramPlayBloc, NonogramPlayState>(
      listenWhen: (p, c) => c is NonogramPlayHintAppliedState,
      listener: (context, state) {
        if (state is NonogramPlayHintAppliedState) {
          _showHint(state.axis, state.lineIndex);
        }
      },
      child: BlocBuilder<NonogramPlayBloc, NonogramPlayState>(
        buildWhen:
            (p, c) =>
                p.puzzle != c.puzzle ||
                p.cellSize != c.cellSize ||
                p.satisfiedRows != c.satisfiedRows ||
                p.satisfiedCols != c.satisfiedCols ||
                p.isLoading != c.isLoading ||
                p.startTime != c.startTime ||
                !NonogramGridEquality.equals(p.gridData, c.gridData),
        builder: (context, state) {
          final puzzle = state.puzzle;
          if (puzzle == null) return const SizedBox.shrink();

          return LayoutBuilder(
            builder: (context, constraints) {
              final layout = NonogramBoardLayout.forPuzzle(
                puzzle: puzzle,
                cellSize: state.cellSize,
                viewport: constraints.biggest,
              );
              _layout = layout;
              _placeIfNewGame(state, layout);

              return Listener(
                onPointerDown: (e) => _pointerDownPosition = e.localPosition,
                onPointerSignal: _onPointerSignal,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapUp: state.isLoading ? null : _onTapUp,
                  onLongPressStart: state.isLoading ? null : _onLongPressStart,
                  onScaleStart: _onScaleStart,
                  onScaleUpdate: _onScaleUpdate,
                  onScaleEnd: _onScaleEnd,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.precise,
                    child: AnimatedBuilder(
                      animation: Listenable.merge([_controller, _clueScroll]),
                      builder: (context, _) {
                        final raw = _offset;
                        final offset = layout.clamp(raw);
                        if (offset != raw) {
                          // Kích thước/cỡ ô đổi làm vị trí cũ ra ngoài giới
                          // hạn: kéo về trong khung ở khung hình sau.
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) _setOffset(layout.clamp(_offset));
                          });
                        }
                        final scroll = _clueScroll.value;
                        return _BoardPaint(
                          state: state,
                          layout: layout,
                          offset: offset,
                          leftClueScroll: scroll.dx.clamp(
                            0,
                            layout.leftClueOverflow,
                          ),
                          topClueScroll: scroll.dy.clamp(
                            0,
                            layout.topClueOverflow,
                          ),
                          hintAxis: _hintAxis,
                          hintIndex: _hintIndex,
                          hintPulse: _hintPulse,
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
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

class _BoardPaint extends StatelessWidget {
  const _BoardPaint({
    required this.state,
    required this.layout,
    required this.offset,
    required this.leftClueScroll,
    required this.topClueScroll,
    required this.hintAxis,
    required this.hintIndex,
    required this.hintPulse,
  });

  final NonogramPlayState state;
  final NonogramBoardLayout layout;
  final Offset offset;
  final double leftClueScroll;
  final double topClueScroll;
  final Axis? hintAxis;
  final int? hintIndex;
  final Animation<double> hintPulse;

  @override
  Widget build(BuildContext context) {
    final puzzle = state.puzzle!;
    final game = context.gameColors;
    final colors = context.color;
    final cell = layout.cellSize;
    final gridW = layout.gridWidth;
    final gridH = layout.gridHeight;
    final leftW = layout.leftStripWidth;
    final topH = layout.topStripHeight;
    final leftContent = layout.leftStripContent;
    final topContent = layout.topStripContent;
    final stickyLeft = layout.stickyLeft(offset);
    final stickyTop = layout.stickyTop(offset);
    final rightReserve = layout.rightReserve;

    // Hai dải dùng chung một cỡ chữ, theo dải có ô số mỏng hơn.
    double fontFor(double depth) => depth == 0 ? double.infinity : depth * 0.6;
    final clueFont = min(
      cell * 0.5,
      min(fontFor(layout.leftClueDepth), fontFor(layout.topClueDepth)),
    ).clamp(7.0, 16.0);
    final clueStyle = context.labelSmall.copyWith(
      fontSize: clueFont,
      fontWeight: FontWeight.w800,
      color: colors.onSurface,
      height: 1,
    );
    final solvedStyle = clueStyle.copyWith(
      color: game.success.withValues(alpha: 0.75),
    );

    // Số cột/hàng số còn bị che ở phía xa lưới.
    int hidden(double content, double visible, double scroll, double depth) =>
        depth == 0 ? 0 : ((content - visible - scroll) / depth - 0.01).ceil();
    final hiddenLeft = hidden(
      leftContent,
      leftW,
      leftClueScroll,
      layout.leftClueDepth,
    );
    final hiddenTop = hidden(
      topContent,
      topH,
      topClueScroll,
      layout.topClueDepth,
    );

    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        // 1. Lưới.
        Positioned(
          left: offset.dx,
          top: offset.dy,
          width: gridW,
          height: gridH,
          child: RepaintBoundary(
            child: CustomPaint(
              painter: NonogramCellsPainter(
                rows: puzzle.rows,
                cols: puzzle.cols,
                gridData: state.gridData,
                satisfiedRows: state.satisfiedRows,
                satisfiedCols: state.satisfiedCols,
                cellSize: cell,
                backgroundColor: colors.surfaceContainerLow,
                filledColor: colors.onSurface,
                markedMarkerColor: colors.primary,
                markerColor: colors.onSurfaceVariant.withValues(alpha: 0.7),
              ),
              foregroundPainter: NonogramGridPainter(
                rows: puzzle.rows,
                cols: puzzle.cols,
                cellSize: cell,
                themeColor: colors.primary,
                lineColor: colors.outlineVariant,
                majorLineColor: colors.outline,
              ),
            ),
          ),
        ),

        // 2. Dải gợi ý trái (dính mép trái, cuộn ngang khi bị cắt).
        if (leftW > 0)
          Positioned(
            left: stickyLeft,
            top: offset.dy,
            width: leftW,
            height: gridH,
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned(
                  left: leftW - leftContent + leftClueScroll,
                  top: 0,
                  width: leftContent,
                  height: gridH,
                  child: CustomPaint(
                    painter: NonogramLeftCluesPainter(
                      clues: puzzle.leftClues,
                      satisfiedRows: state.satisfiedRows,
                      cellSize: cell,
                      clueDepth: layout.leftClueDepth,
                      lineColor: colors.surface,
                      majorLineColor: colors.outline,
                      backgroundColor: game.clueBackground,
                      bandColor: game.clueBand,
                      textStyle: clueStyle,
                      satisfiedTextStyle: solvedStyle,
                    ),
                  ),
                ),
                if (hiddenLeft > 0)
                  _StripFade(
                    axis: Axis.horizontal,
                    atStart: true,
                    color: game.clueBackground,
                  ),
                if (leftClueScroll > 0.5)
                  _StripFade(
                    axis: Axis.horizontal,
                    atStart: false,
                    color: game.clueBackground,
                  ),
              ],
            ),
          ),

        // 3. Dải gợi ý trên (dính ngay dưới hàng nút công cụ, cuộn dọc khi
        // bị cắt).
        if (topH > 0)
          Positioned(
            left: offset.dx,
            top: stickyTop,
            width: gridW,
            height: topH,
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned(
                  left: 0,
                  top: topH - topContent + topClueScroll,
                  width: gridW,
                  height: topContent,
                  child: CustomPaint(
                    painter: NonogramTopCluesPainter(
                      clues: puzzle.topClues,
                      satisfiedColumns: state.satisfiedCols,
                      cellSize: cell,
                      clueDepth: layout.topClueDepth,
                      lineColor: colors.surface,
                      majorLineColor: colors.outline,
                      backgroundColor: game.clueBackground,
                      bandColor: game.clueBand,
                      textStyle: clueStyle,
                      satisfiedTextStyle: solvedStyle,
                    ),
                  ),
                ),
                if (hiddenTop > 0)
                  _StripFade(
                    axis: Axis.vertical,
                    atStart: true,
                    color: game.clueBackground,
                  ),
                if (topClueScroll > 0.5)
                  _StripFade(
                    axis: Axis.vertical,
                    atStart: false,
                    color: game.clueBackground,
                  ),
              ],
            ),
          ),

        // 4. Che mọi thứ trôi ra ngoài vùng bàn chơi: phía trên, bên trái
        // (vẽ sau cả hai dải để dải trên không lòi sang trái ô góc), và
        // dưới cột nút công cụ khi màn ngang.
        Positioned(
          left: 0,
          top: 0,
          right: 0,
          height: stickyTop,
          child: ColoredBox(color: colors.surface),
        ),
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          width: stickyLeft,
          child: ColoredBox(color: colors.surface),
        ),
        if (rightReserve > 0)
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: rightReserve,
            child: ColoredBox(color: colors.surface),
          ),

        // 5. Ô góc: che chỗ hai dải giao nhau, kèm số lượng số đang bị cắt.
        Positioned(
          left: stickyLeft,
          top: stickyTop,
          width: leftW,
          height: topH,
          child: ColoredBox(
            color: colors.surface,
            child: _HiddenCluesBadges(
              hiddenLeft: hiddenLeft,
              hiddenTop: hiddenTop,
            ),
          ),
        ),

        // 6. Dải sáng khi dùng gợi ý (cả lưới lẫn dải số của hàng/cột đó).
        if (hintAxis != null && hintIndex != null)
          _HintBand(
            rect:
                hintAxis == Axis.vertical
                    ? Rect.fromLTWH(
                      offset.dx + hintIndex! * cell,
                      stickyTop,
                      cell,
                      offset.dy + gridH - stickyTop,
                    )
                    : Rect.fromLTWH(
                      stickyLeft,
                      offset.dy + hintIndex! * cell,
                      offset.dx + gridW - stickyLeft,
                      cell,
                    ),
            pulse: hintPulse,
          ),
      ],
    );
  }
}

/// Viền mờ ở mép dải gợi ý, báo còn số bị cắt ở phía đó.
class _StripFade extends StatelessWidget {
  const _StripFade({
    required this.axis,
    required this.atStart,
    required this.color,
  });

  final Axis axis;

  /// Mép đầu (trái / trên) hay mép cuối (phải / dưới).
  final bool atStart;
  final Color color;

  @override
  Widget build(BuildContext context) {
    const size = 10.0;
    final horizontal = axis == Axis.horizontal;
    final begin =
        horizontal
            ? (atStart ? Alignment.centerLeft : Alignment.centerRight)
            : (atStart ? Alignment.topCenter : Alignment.bottomCenter);
    final end =
        horizontal
            ? (atStart ? Alignment.centerRight : Alignment.centerLeft)
            : (atStart ? Alignment.bottomCenter : Alignment.topCenter);
    return Positioned(
      left: horizontal ? (atStart ? 0 : null) : 0,
      right: horizontal ? (atStart ? null : 0) : 0,
      top: horizontal ? 0 : (atStart ? 0 : null),
      bottom: horizontal ? 0 : (atStart ? null : 0),
      width: horizontal ? size : null,
      height: horizontal ? null : size,
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: begin,
              end: end,
              colors: [color, color.withValues(alpha: 0)],
            ),
          ),
        ),
      ),
    );
  }
}

/// Trong ô góc: "← +N" (dải trái còn N cột số bị cắt) và "↑ +M" (dải trên).
class _HiddenCluesBadges extends StatelessWidget {
  const _HiddenCluesBadges({required this.hiddenLeft, required this.hiddenTop});

  final int hiddenLeft;
  final int hiddenTop;

  @override
  Widget build(BuildContext context) {
    if (hiddenLeft <= 0 && hiddenTop <= 0) return const SizedBox.shrink();
    final style = context.labelSmall.copyWith(
      fontSize: 10,
      fontWeight: FontWeight.w800,
      color: context.color.primary,
    );
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Stack(
        children: [
          if (hiddenTop > 0)
            Align(
              alignment: Alignment.topRight,
              child: FittedBox(child: Text('↑ +$hiddenTop', style: style)),
            ),
          if (hiddenLeft > 0)
            Align(
              alignment: Alignment.bottomLeft,
              child: FittedBox(child: Text('← +$hiddenLeft', style: style)),
            ),
        ],
      ),
    );
  }
}

class _HintBand extends StatelessWidget {
  const _HintBand({required this.rect, required this.pulse});

  final Rect rect;
  final Animation<double> pulse;

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: rect,
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: pulse,
          builder: (context, _) {
            final opacity = (1 - pulse.value).clamp(0.0, 1.0);
            return DecoratedBox(
              decoration: BoxDecoration(
                color: context.color.primary.withValues(alpha: 0.28 * opacity),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          },
        ),
      ),
    );
  }
}

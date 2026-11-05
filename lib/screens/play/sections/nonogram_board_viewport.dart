import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/models/nonogram_grid_equality.dart';
import 'package:nonogram/models/nonogram_interaction_mode.dart';

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
/// Cử chỉ:
/// - Chế độ tô: chạm = tô/xoá một ô, nhấn giữ = đánh dấu X, kéo một ngón =
///   tô liên tiếp, hai ngón = kéo bàn và chụm để zoom.
/// - Chế độ bàn tay: một hoặc hai ngón đều để kéo/zoom.
/// - Chuột/trackpad: lăn để kéo, Ctrl/⌘ + lăn hoặc chụm trackpad để zoom.
class NonogramBoardViewport extends StatefulWidget {
  const NonogramBoardViewport({super.key});

  @override
  State<NonogramBoardViewport> createState() => _NonogramBoardViewportState();
}

enum _GestureKind { none, draw, navigate }

class _NonogramBoardViewportState extends State<NonogramBoardViewport>
    with SingleTickerProviderStateMixin {
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
      if (mounted) _setOffset(target);
    });
  }

  @override
  void dispose() {
    _hintPulse.dispose();
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

  bool get _isDrawMode =>
      _bloc.state.interactionMode == NonogramInteractionMode.draw;

  // --- Chạm / nhấn giữ ---

  void _onTapUp(TapUpDetails details) {
    final layout = _layout;
    if (layout == null || !_isDrawMode) return;
    final cell = layout.cellAt(details.localPosition, _offset);
    if (cell == null) return;
    final o = _offset;
    _bloc.add(CellTapped(cell.row, cell.col, offsetX: o.dx, offsetY: o.dy));
  }

  void _onLongPressStart(LongPressStartDetails details) {
    final layout = _layout;
    if (layout == null || !_isDrawMode) return;
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

  // --- Kéo để tô / kéo-zoom ---

  void _onScaleStart(ScaleStartDetails details) {
    final layout = _layout;
    if (layout == null) return;

    if (details.pointerCount == 1 && _isDrawMode) {
      // Bắt đầu tô từ chỗ ngón tay chạm xuống, không phải chỗ đã trượt qua
      // ngưỡng nhận cử chỉ.
      final start = _pointerDownPosition ?? details.localFocalPoint;
      final cell = layout.cellAt(start, _offset);
      if (cell == null) {
        _gesture = _GestureKind.none;
        return;
      }
      _gesture = _GestureKind.draw;
      _lastDragCell = cell;
      _bloc.add(DragStarted(cell.row, cell.col));
      _dragTo(details.localFocalPoint);
    } else {
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
        _dragTo(details.localFocalPoint);
      case _GestureKind.navigate:
        _navigate(details.localFocalPoint, details.scale);
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
    _lastDragCell = null;
    final o = _offset;
    _bloc.add(DragEnded(offsetX: o.dx, offsetY: o.dy));
  }

  void _navigate(Offset focal, double scale) {
    final layout = _layout;
    if (layout == null) return;
    final newCell = (_zoomStartCell * scale).clamp(
      layout.minZoom,
      NonogramBoardLayout.maxZoomCellSize,
    );
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
    _setOffset(_layoutFor(newCell).clamp(moved));
  }

  void _endNavigate() {
    final o = _offset;
    final zoomed = _liveCellSize;
    _liveCellSize = null;
    if (zoomed != null) {
      _bloc.add(
        CellSizeChanged(
          cellSize: zoomed,
          offsetX: o.dx,
          offsetY: o.dy,
          isZoom: true,
        ),
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
    final to = (from * factor).clamp(
      layout.minZoom,
      NonogramBoardLayout.maxZoomCellSize,
    );
    if ((to - from).abs() < 0.01) return;
    final moved = NonogramBoardLayout.zoomAround(
      t: _offset,
      focal: focal,
      from: from,
      to: to,
    );
    final clamped = _layoutFor(to).clamp(moved);
    _setOffset(clamped);
    _bloc.add(
      CellSizeChanged(
        cellSize: to,
        offsetX: clamped.dx,
        offsetY: clamped.dy,
        isZoom: true,
      ),
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

  NonogramBoardLayout _layoutFor(double cellSize) {
    final layout = _layout!;
    return NonogramBoardLayout(
      viewport: layout.viewport,
      rows: layout.rows,
      cols: layout.cols,
      maxLeftClues: layout.maxLeftClues,
      maxTopClues: layout.maxTopClues,
      cellSize: cellSize,
    );
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
                p.interactionMode != c.interactionMode ||
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

              final isNavMode =
                  state.interactionMode == NonogramInteractionMode.explore;

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
                    cursor:
                        isNavMode
                            ? SystemMouseCursors.grab
                            : SystemMouseCursors.precise,
                    child: AnimatedBuilder(
                      animation: _controller,
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
                        return _BoardPaint(
                          state: state,
                          layout: layout,
                          offset: offset,
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
    required this.hintAxis,
    required this.hintIndex,
    required this.hintPulse,
  });

  final NonogramPlayState state;
  final NonogramBoardLayout layout;
  final Offset offset;
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
    final stickyLeft = layout.stickyLeft(offset);
    final stickyTop = layout.stickyTop(offset);

    final leftFont = min(
      cell * 0.55,
      layout.leftClueDepth * 0.6,
    ).clamp(7.0, 16.0);
    final topFont = min(
      cell * 0.5,
      layout.topClueDepth * 0.62,
    ).clamp(7.0, 16.0);
    // Thu nhỏ quá mức (chế độ xem tổng thể): số không còn đọc được và sẽ
    // chồng lên nhau, nên ẩn đi, chỉ giữ nền dải gợi ý.
    final showNumbers = cell >= 10;
    TextStyle clueStyle(double size) => context.labelSmall.copyWith(
      fontSize: size,
      fontWeight: FontWeight.w800,
      color: showNumbers ? colors.onSurface : Colors.transparent,
      height: 1,
    );
    TextStyle solvedStyle(double size) => clueStyle(size).copyWith(
      color:
          showNumbers
              ? game.success.withValues(alpha: 0.75)
              : Colors.transparent,
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

        // 3. Dải gợi ý trái (dính mép trái).
        Positioned(
          left: stickyLeft,
          top: offset.dy,
          width: leftW,
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
              textStyle: clueStyle(leftFont),
              satisfiedTextStyle: solvedStyle(leftFont),
            ),
          ),
        ),

        // 4. Che phần lưới / dải trái trôi ra ngoài vùng bàn chơi.
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

        // 5. Dải gợi ý trên (dính ngay dưới hàng nút công cụ).
        Positioned(
          left: offset.dx,
          top: stickyTop,
          width: gridW,
          height: topH,
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
              textStyle: clueStyle(topFont),
              satisfiedTextStyle: solvedStyle(topFont),
            ),
          ),
        ),

        // 6. Ô góc: che chỗ hai dải giao nhau.
        Positioned(
          left: stickyLeft,
          top: stickyTop,
          width: leftW,
          height: topH,
          child: ColoredBox(color: colors.surface),
        ),

        // 7. Dải sáng khi dùng gợi ý (cả lưới lẫn dải số của hàng/cột đó).
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

import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nonogram/core/app_haptics.dart';
import 'package:nonogram/engine/model/nonogram_grid_equality.dart';

import '../bloc/nonogram_play_bloc.dart';
import '../bloc/nonogram_play_event.dart';
import '../bloc/nonogram_play_state.dart';
import '../layout/nonogram_board_layout.dart';
import '../nonogram_transformation_controller_provider.dart';
import '../views/drag_tip.dart';
import 'board/nonogram_board_paint.dart';

part 'nonogram_board_viewport_drawing.dart';
part 'nonogram_board_viewport_gestures.dart';

/// Bàn chơi: lưới kéo được, hai dải gợi ý dính mép.
///
/// Vị trí lưới (góc trên-trái, toạ độ khung nhìn) nằm trong
/// [TransformationController] dùng chung, để các nút và việc lưu ván đọc
/// được. Cỡ ô cố định (vừa khung nhìn, do bloc tính), không zoom.
///
/// Cử chỉ (chạm tô hay đánh X tuỳ chế độ Tô / X trong bloc):
/// - Chạm = tô / đánh X một ô, nhấn giữ = việc ngược lại, kéo một ngón bắt
///   đầu trên lưới = tô / đánh X liên tiếp (tới sát mép thì bàn tự trôi).
/// - Kéo một ngón bắt đầu ngoài lưới: trên dải trái thì cuộn dọc (và cuộn
///   ngang các số bị cắt), trên dải trên thì cuộn ngang (và cuộn dọc các số
///   bị cắt), chỗ trống thì kéo bàn.
/// - Hai ngón = kéo bàn.
/// - Chuột/trackpad: lăn để kéo.
class NonogramBoardViewport extends StatefulWidget {
  const NonogramBoardViewport({super.key});

  @override
  State<NonogramBoardViewport> createState() => _NonogramBoardViewportState();
}

enum _GestureKind { none, draw, navigate, leftStrip, topStrip }

/// State shared by the viewport and its gesture mixins
/// ([_BoardGestures], [_BoardDrawing]).
abstract class _BoardViewportBase extends State<NonogramBoardViewport>
    with TickerProviderStateMixin {
  late final AnimationController _hintPulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );
  Axis? _hintAxis;
  int? _hintIndex;

  /// Ô vừa được gợi ý tô giúp (nháy sáng).
  List<({int row, int col})> _hintCells = const [];

  // Trạng thái cử chỉ hiện tại.
  _GestureKind _gesture = _GestureKind.none;
  Offset? _pointerDownPosition;
  ({int row, int col})? _lastDragCell;

  /// Số ô đã đi qua thêm (ngoài ô đầu) trong lần kéo đang diễn ra.
  int _drawCells = 0;
  Offset _navStartOffset = Offset.zero;
  Offset _navStartFocal = Offset.zero;

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

  /// Đang chọn hàng / cột cho gậy phép: chạm, nhấn giữ hay kéo trên lưới
  /// đều không tô (kéo thì chuyển sang kéo bàn để tìm hàng cần chọn).
  bool get _wandActive => _bloc.state.isWandActive;

  void _onAutoScrollTick(Duration elapsed);

  // --- Gợi ý (hint) ---

  void _showHint({
    Axis? axis,
    int? index,
    List<({int row, int col})> cells = const [],
  }) {
    setState(() {
      _hintAxis = axis;
      _hintIndex = index;
      _hintCells = cells;
    });
    _hintPulse.forward(from: 0).then((_) {
      if (mounted) {
        setState(() {
          _hintAxis = null;
          _hintIndex = null;
          _hintCells = const [];
        });
      }
    });
  }
}

class _NonogramBoardViewportState extends _BoardViewportBase
    with _BoardDrawing, _BoardGestures {
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<NonogramPlayBloc, NonogramPlayState>(
      listenWhen: (p, c) =>
          c is NonogramPlayHintAppliedState ||
          c is NonogramPlayHintCellsAppliedState,
      listener: (context, state) {
        if (state is NonogramPlayHintAppliedState) {
          _showHint(axis: state.axis, index: state.lineIndex);
        } else if (state is NonogramPlayHintCellsAppliedState) {
          _showHint(cells: state.cells);
        }
      },
      child: BlocBuilder<NonogramPlayBloc, NonogramPlayState>(
        buildWhen: (p, c) =>
            p.puzzle != c.puzzle ||
            p.cellSize != c.cellSize ||
            p.satisfiedRows != c.satisfiedRows ||
            p.satisfiedCols != c.satisfiedCols ||
            p.isLoading != c.isLoading ||
            p.startTime != c.startTime ||
            p.isWandActive != c.isWandActive ||
            p.lockedCells != c.lockedCells ||
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
                        return NonogramBoardPaint(
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
                          hintCells: _hintCells,
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

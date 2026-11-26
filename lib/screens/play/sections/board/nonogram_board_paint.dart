import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/context_ext.dart';

import '../../../painters/nonogram_cells_painter.dart';
import '../../../painters/nonogram_grid_painter.dart';
import '../../bloc/nonogram_play_state.dart';
import '../../celebration/solve_celebration.dart';
import '../../layout/nonogram_board_layout.dart';
import 'nonogram_clue_strip.dart';
import 'nonogram_hint_band.dart';
import 'nonogram_solve_stage.dart';
import 'nonogram_wand_select_overlay.dart';

/// The board at one grid position: grid, sticky clue strips, masks, wand and
/// hint highlights, and the solve animation, stacked in paint order.
class NonogramBoardPaint extends StatelessWidget {
  const NonogramBoardPaint({
    super.key,
    required this.state,
    required this.layout,
    required this.offset,
    required this.leftClueScroll,
    required this.topClueScroll,
    required this.hintAxis,
    required this.hintIndex,
    required this.hintCells,
    required this.hintPulse,
  });

  final NonogramPlayState state;
  final NonogramBoardLayout layout;
  final Offset offset;
  final double leftClueScroll;
  final double topClueScroll;
  final Axis? hintAxis;
  final int? hintIndex;
  final List<({int row, int col})> hintCells;
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
    final rightReserve = layout.rightReserve;

    // Vùng được vẽ lưới. Khi lưới nằm sát dải (chưa trôi vào dưới dải) thì
    // chừa thêm 2px cho nét viền ngoài.
    final area = layout.gridArea(offset);
    final clipLeft = offset.dx >= area.left - 0.5 ? offset.dx - 2 : area.left;
    final clipTop = offset.dy >= area.top - 0.5 ? offset.dy - 2 : area.top;

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

    final chipTextStyle = clueStyle.copyWith(color: const Color(0xFF2B1A00));
    final celebration = SolveCelebration.maybeOf(context);
    final waving = celebration != null && celebration.holdsBoard;
    // Tranh đang bay sang màn kết quả: lưới trên bàn (đang mờ dần) để trống.
    final flying = celebration != null && celebration.isFlying;
    final revealing = waving || flying;
    final cellsPaint = _cells(context);

    // Lúc giải xong hai dải số mờ đi để lộ trọn tranh.
    Widget strip(Widget child) => revealing
        ? FadeTransition(opacity: celebration.cluesOpacity, child: child)
        : child;

    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        // 1. Lưới, chỉ vẽ trong phần nằm phải / dưới hai dải gợi ý: phần trôi
        // xuống dưới dải không được lộ ra ở góc bo tròn hay mép dải (nét viền
        // ngoài của lưới dày hơn mép lưới một chút).
        Positioned(
          left: clipLeft,
          top: clipTop,
          right: 0,
          bottom: 0,
          child: ClipRect(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Đang có hiệu ứng giải xong: lưới chuyển sang lớp sân khấu
                // (8) để lùi lại cho thấy trọn tranh.
                if (!revealing)
                  Positioned(
                    left: offset.dx - clipLeft,
                    top: offset.dy - clipTop,
                    width: gridW,
                    height: gridH,
                    child: RepaintBoundary(
                      key: celebration?.gridKey,
                      child: cellsPaint,
                    ),
                  ),
                // Ô vừa được gợi ý tô giúp: nháy sáng (nằm trong vùng cắt
                // nên không đè lên dải số).
                for (final c in hintCells)
                  NonogramHintBand(
                    rect: Rect.fromLTWH(
                      offset.dx - clipLeft + c.col * cell,
                      offset.dy - clipTop + c.row * cell,
                      cell,
                      cell,
                    ).inflate(1),
                    pulse: hintPulse,
                    strong: true,
                  ),
              ],
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
            child: strip(
              NonogramClueStrip(
                isLeft: true,
                state: state,
                layout: layout,
                scroll: leftClueScroll,
                textStyle: clueStyle,
                satisfiedTextStyle: solvedStyle,
                chipTextStyle: chipTextStyle,
              ),
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
            child: strip(
              NonogramClueStrip(
                isLeft: false,
                state: state,
                layout: layout,
                scroll: topClueScroll,
                textStyle: clueStyle,
                satisfiedTextStyle: solvedStyle,
                chipTextStyle: chipTextStyle,
              ),
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

        // 5. Ô góc: che chỗ hai dải giao nhau.
        // Lấn thêm 1px lên trên / sang trái để không lộ khe mép dải (khử
        // răng cưa) giữa ô góc và lớp che.
        Positioned(
          left: stickyLeft - 1,
          top: stickyTop - 1,
          width: leftW + 1,
          height: topH + 1,
          child: ColoredBox(color: colors.surface),
        ),

        // 6. Đang chọn hàng / cột cho gậy phép: lưới mờ đi, các dãy số cùng
        // nhấp nháy vàng để người chơi biết chạm vào đâu.
        if (state.isWandActive)
          Positioned.fill(
            child: IgnorePointer(
              child: NonogramWandSelectOverlay.forBoard(
                layout: layout,
                offset: offset,
              ),
            ),
          ),

        // 7. Dải sáng khi dùng gợi ý (cả lưới lẫn dải số của hàng/cột đó).
        if (hintAxis != null && hintIndex != null)
          NonogramHintBand(
            rect: hintAxis == Axis.vertical
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

        // 8. Vừa giải xong: lưới lùi lại cho trọn tranh nằm giữa khung (vùng
        // cắt nới dần ra cả khung nhìn trong lúc dải số mờ đi), rồi sóng
        // lan trên tranh. Lúc tranh bay sang màn kết quả thì để trống.
        if (revealing)
          NonogramSolveLayer(
            celebration: celebration,
            layout: layout,
            offset: offset,
            clip: Offset(clipLeft, clipTop),
            solution: puzzle.solution,
            cells: cellsPaint,
          ),
      ],
    );
  }

  /// The cells and grid lines at their real size.
  Widget _cells(BuildContext context) {
    final puzzle = state.puzzle!;
    final game = context.gameColors;
    final colors = context.color;
    final cell = layout.cellSize;
    return CustomPaint(
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
        lockedCells: state.lockedCells,
        lockedStarColor: game.lockedStar,
        lockedMarkStarColor: game.lockedMarkStar,
        pinnedCells: puzzle.pinnedCells,
        pinColor: colors.surfaceContainerLow,
      ),
      foregroundPainter: NonogramGridPainter(
        rows: puzzle.rows,
        cols: puzzle.cols,
        cellSize: cell,
        themeColor: colors.primary,
        lineColor: colors.outlineVariant,
        majorLineColor: colors.outline,
      ),
    );
  }
}

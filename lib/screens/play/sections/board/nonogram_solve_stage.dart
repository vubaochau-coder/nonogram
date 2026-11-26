import 'package:flutter/material.dart';
import 'package:nonogram/core/context_ext.dart';

import '../../celebration/solve_celebration.dart';
import '../../layout/nonogram_board_layout.dart';

/// Lớp sân khấu lúc giải xong: lưới đi từ [gridFrom] (chỗ đang chơi) tới
/// [gridTo] (trọn tranh giữa khung), vùng cắt nới từ [clipFrom] (phần lưới
/// đang lộ ra) tới [clipTo], theo [fit].
class NonogramSolveStage extends StatelessWidget {
  const NonogramSolveStage({
    super.key,
    required this.fit,
    required this.clipFrom,
    required this.clipTo,
    required this.gridFrom,
    required this.gridTo,
    required this.child,
  });

  final Animation<double> fit;
  final Rect clipFrom;
  final Rect clipTo;
  final Rect gridFrom;
  final Rect gridTo;

  /// Lưới ở cỡ thật; được thu phóng cho khớp khung đang đi.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: fit,
      child: child,
      builder: (context, child) {
        final t = fit.value;
        final clip = Rect.lerp(clipFrom, clipTo, t)!;
        final grid = Rect.lerp(gridFrom, gridTo, t)!;
        return Stack(
          children: [
            Positioned.fromRect(
              rect: clip,
              child: ClipRect(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fromRect(
                      rect: grid.shift(-clip.topLeft),
                      child: FittedBox(fit: BoxFit.fill, child: child),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Board layer shown right after solving: the grid moves back so the whole
/// picture sits in the middle of the viewport (the clip widens to the whole
/// viewport while the clue strips fade out), then the wave runs over the
/// picture. While the picture flies to the result screen it stays empty.
class NonogramSolveLayer extends StatelessWidget {
  const NonogramSolveLayer({
    super.key,
    required this.celebration,
    required this.layout,
    required this.offset,
    required this.clip,
    required this.solution,
    required this.cells,
  });

  final SolveCelebration celebration;
  final NonogramBoardLayout layout;
  final Offset offset;

  /// Top-left corner of the visible part of the grid.
  final Offset clip;
  final List<List<int>> solution;

  /// The painted grid at its real size.
  final Widget cells;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final gridW = layout.gridWidth;
    final gridH = layout.gridHeight;
    final viewport = layout.viewport;
    return Positioned.fill(
      child: IgnorePointer(
        child: Opacity(
          opacity: celebration.isFlying ? 0 : 1,
          child: NonogramSolveStage(
            fit: celebration.fit,
            clipFrom: Rect.fromLTRB(
              clip.dx,
              clip.dy,
              viewport.width,
              viewport.height,
            ),
            clipTo: Rect.fromLTRB(
              0,
              layout.topReserve,
              viewport.width - layout.rightReserve,
              viewport.height,
            ),
            gridFrom: Rect.fromLTWH(offset.dx, offset.dy, gridW, gridH),
            gridTo: SolveCelebration.fitRect(
              grid: Size(gridW, gridH),
              area: layout.celebrationArea,
            ),
            child: SizedBox(
              width: gridW,
              height: gridH,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: RepaintBoundary(
                      key: celebration.gridKey,
                      child: cells,
                    ),
                  ),
                  // Sóng lan từ góc trái dưới lên góc phải trên, từng ô tô nổi
                  // lên rồi hạ xuống, dấu X mờ dần.
                  if (celebration.holdsBoard)
                    Positioned.fill(
                      child: CustomPaint(
                        key: const ValueKey('solve-wave'),
                        painter: SolveWavePainter(
                          progress: celebration.wave,
                          solution: solution,
                          cellSize: layout.cellSize,
                          filledColor: colors.onSurface,
                          backgroundColor: colors.surfaceContainerLow,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

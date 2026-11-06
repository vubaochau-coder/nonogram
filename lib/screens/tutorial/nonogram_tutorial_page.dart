import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/l10n/app_localizations.dart';
import 'package:nonogram/models/nonogram_interaction_mode.dart';
import 'package:nonogram/screens/painters/nonogram_cells_painter.dart';
import 'package:nonogram/screens/painters/nonogram_grid_painter.dart';

import 'nonogram_tutorial_controller.dart';

/// Luồng "Cách chơi": một câu đố 5×5 hiện dần từng hàng, mỗi bước có lời dẫn,
/// viền sáng chỗ cần làm và bàn tay chỉ vào chỗ cần chạm.
///
/// Đóng trang trả về `true` nếu người chơi bấm "Xem các kỹ thuật giải".
class NonogramTutorialPage extends StatefulWidget {
  const NonogramTutorialPage({super.key});

  @override
  State<NonogramTutorialPage> createState() => _NonogramTutorialPageState();
}

class _NonogramTutorialPageState extends State<NonogramTutorialPage> {
  final _controller = NonogramTutorialController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _close({bool showTechniques = false}) {
    Navigator.of(context).pop(showTechniques);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final step = _controller.step;
        final task = step.task;

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.nonogramTutorialTitle),
            actions: [
              if (task != TutorialTask.done)
                TextButton(
                  key: const ValueKey('nonogram-tutorial-skip'),
                  onPressed: _close,
                  child: Text(l10n.nonogramTutorialSkip),
                ),
              const SizedBox(width: 8),
            ],
          ),
          body: SafeArea(
            top: false,
            child: Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: _MessageCard(
                        text:
                            task == TutorialTask.intro
                                ? ''
                                : tutorialMessageText(l10n, step.message),
                        mistakes: _controller.mistakes,
                      ),
                    ),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return _BoardArea(
                            controller: _controller,
                            constraints: constraints,
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                      child: _TutorialModeToggle(controller: _controller),
                    ),
                  ],
                ),
                if (task == TutorialTask.intro)
                  _Overlay(
                    alignment: Alignment.center,
                    child: _OverlayCard(
                      title: l10n.nonogramTutorialWelcomeTitle,
                      body: l10n.nonogramTutorialWelcome,
                      actions: [
                        FilledButton(
                          key: const ValueKey('nonogram-tutorial-start'),
                          onPressed: _controller.start,
                          child: Text(l10n.nonogramTutorialStart),
                        ),
                      ],
                    ),
                  ),
                if (task == TutorialTask.done)
                  _Overlay(
                    alignment: Alignment.bottomCenter,
                    child: _OverlayCard(
                      title: l10n.nonogramTutorialDoneTitle,
                      body: l10n.nonogramTutorialDone,
                      actions: [
                        FilledButton(
                          key: const ValueKey('nonogram-tutorial-techniques'),
                          onPressed: () => _close(showTechniques: true),
                          child: Text(l10n.nonogramTutorialShowTechniques),
                        ),
                        TextButton(
                          key: const ValueKey('nonogram-tutorial-play'),
                          onPressed: _close,
                          child: Text(l10n.nonogramTutorialPlay),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

String tutorialMessageText(AppLocalizations l10n, TutorialMessage message) {
  return switch (message) {
    TutorialMessage.welcome => l10n.nonogramTutorialWelcome,
    TutorialMessage.switchToFill => l10n.nonogramTutorialSwitchToFill,
    TutorialMessage.clueIsCount => l10n.nonogramTutorialClueIsCount,
    TutorialMessage.edgeCell => l10n.nonogramTutorialEdgeCell,
    TutorialMessage.multipleClues => l10n.nonogramTutorialMultipleClues,
    TutorialMessage.clueOrder => l10n.nonogramTutorialClueOrder,
    TutorialMessage.columns => l10n.nonogramTutorialColumns,
    TutorialMessage.markEmpty => l10n.nonogramTutorialMarkEmpty,
    TutorialMessage.oneCellLeft => l10n.nonogramTutorialOneCellLeft,
    TutorialMessage.finish => l10n.nonogramTutorialFinish,
    TutorialMessage.done => l10n.nonogramTutorialDone,
  };
}

/// Lời dẫn của bước hiện tại. Rung nhẹ mỗi khi người chơi làm sai.
class _MessageCard extends StatelessWidget {
  const _MessageCard({required this.text, required this.mistakes});

  final String text;
  final int mistakes;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;

    return TweenAnimationBuilder<double>(
      key: ValueKey(mistakes),
      tween: Tween(begin: mistakes == 0 ? 0.0 : 1.0, end: 0.0),
      duration: const Duration(milliseconds: 420),
      builder: (context, t, child) {
        final dx = math.sin(t * math.pi * 6) * 10 * t;
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 104),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: context.gameColors.cardBorder),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: Text(
            text,
            key: ValueKey(text),
            textAlign: TextAlign.center,
            style: context.bodyLarge.copyWith(height: 1.4),
          ),
        ),
      ),
    );
  }
}

/// Tính cỡ ô theo chỗ trống và giữ bàn đứng yên khi các hàng hiện dần.
class _BoardArea extends StatelessWidget {
  const _BoardArea({required this.controller, required this.constraints});

  final NonogramTutorialController controller;
  final BoxConstraints constraints;

  /// Bề rộng / cao vùng số gợi ý, tính theo số ô.
  static const double clueExtent = 1.4;
  static const double clueGap = 4;

  @override
  Widget build(BuildContext context) {
    final rows = controller.rows;
    final cols = controller.cols;
    final byWidth = (constraints.maxWidth - 32 - clueGap) / (cols + clueExtent);
    final byHeight = (constraints.maxHeight - clueGap) / (rows + clueExtent);
    final cellSize = math.min(64.0, math.min(byWidth, byHeight));
    if (cellSize <= 8) return const SizedBox.shrink();

    final clueSize = cellSize * clueExtent;
    final width = clueSize + clueGap + cellSize * cols;
    final height = clueSize + clueGap + cellSize * rows;

    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: width,
        height: height,
        child: Align(
          alignment: Alignment.topLeft,
          child: _TutorialBoard(
            controller: controller,
            cellSize: cellSize,
            clueSize: clueSize,
            clueGap: clueGap,
          ),
        ),
      ),
    );
  }
}

class _TutorialBoard extends StatelessWidget {
  const _TutorialBoard({
    required this.controller,
    required this.cellSize,
    required this.clueSize,
    required this.clueGap,
  });

  final NonogramTutorialController controller;
  final double cellSize;
  final double clueSize;
  final double clueGap;

  @override
  Widget build(BuildContext context) {
    final step = controller.step;
    final activeRows = {for (final cell in step.highlightedCells) cell.row};

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedOpacity(
          opacity: step.showColumnClues ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Padding(
            padding: EdgeInsets.only(left: clueSize + clueGap, bottom: clueGap),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var c = 0; c < controller.cols; c++)
                  _ClueTile(
                    width: cellSize,
                    height: clueSize,
                    clues: controller.colClues[c],
                    vertical: true,
                    complete: controller.isColComplete(c),
                    active: false,
                  ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var r = 0; r < step.visibleRows; r++)
                  _ClueTile(
                    width: clueSize,
                    height: cellSize,
                    clues: controller.rowClues[r],
                    vertical: false,
                    complete: controller.isRowComplete(r),
                    active: activeRows.contains(r),
                  ),
              ],
            ),
            SizedBox(width: clueGap),
            _TutorialGrid(controller: controller, cellSize: cellSize),
          ],
        ),
      ],
    );
  }
}

/// Ô số gợi ý của một hàng / cột. Đủ ô thì mờ đi và hiện dấu ✓.
class _ClueTile extends StatelessWidget {
  const _ClueTile({
    required this.width,
    required this.height,
    required this.clues,
    required this.vertical,
    required this.complete,
    required this.active,
  });

  final double width;
  final double height;
  final List<int> clues;
  final bool vertical;
  final bool complete;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final game = context.gameColors;
    final shortSide = vertical ? width : height;
    final style = context.titleMedium.copyWith(
      fontSize: shortSide * 0.36,
      height: 1.15,
      fontWeight: active ? FontWeight.w800 : FontWeight.w600,
      color: complete ? colors.onSurfaceVariant : colors.onSurface,
    );
    final numbers = [for (final clue in clues) Text('$clue', style: style)];

    return SizedBox(
      width: width,
      height: height,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: complete ? colors.surface : game.clueBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: active ? game.reward : game.cardBorder,
              width: active ? 2 : 1,
            ),
          ),
          child: Stack(
            children: [
              if (complete)
                Align(
                  alignment:
                      vertical ? Alignment.topCenter : Alignment.centerLeft,
                  child: Icon(
                    Icons.check_rounded,
                    size: shortSide * 0.3,
                    color: game.success,
                  ),
                ),
              Align(
                alignment:
                    vertical ? Alignment.bottomCenter : Alignment.centerRight,
                child:
                    vertical
                        ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: numbers,
                        )
                        : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (var i = 0; i < numbers.length; i++) ...[
                              if (i > 0) SizedBox(width: shortSide * 0.12),
                              numbers[i],
                            ],
                          ],
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Lưới ô: chạm hoặc kéo qua các ô để tô / đánh X.
class _TutorialGrid extends StatefulWidget {
  const _TutorialGrid({required this.controller, required this.cellSize});

  final NonogramTutorialController controller;
  final double cellSize;

  @override
  State<_TutorialGrid> createState() => _TutorialGridState();
}

class _TutorialGridState extends State<_TutorialGrid> {
  TutorialCell? _lastDragCell;

  TutorialCell? _cellAt(Offset position) {
    final controller = widget.controller;
    final row = (position.dy / widget.cellSize).floor();
    final col = (position.dx / widget.cellSize).floor();
    if (row < 0 || row >= controller.step.visibleRows) return null;
    if (col < 0 || col >= controller.cols) return null;
    return (row: row, col: col);
  }

  void _apply(TutorialCell? cell, {required bool countMiss}) {
    if (cell == null) return;
    final changed = widget.controller.tapCell(
      cell.row,
      cell.col,
      countMiss: countMiss,
    );
    if (changed) HapticFeedback.selectionClick();
  }

  void _onDrag(Offset position) {
    final cell = _cellAt(position);
    if (cell == null || cell == _lastDragCell) return;
    _lastDragCell = cell;
    _apply(cell, countMiss: false);
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final step = controller.step;
    final cellSize = widget.cellSize;
    final rows = step.visibleRows;
    final cols = controller.cols;
    final colors = context.color;
    final game = context.gameColors;

    final pending = controller.pendingTargets;
    // Bàn tay chỉ hiện khi bước vừa bắt đầu, để không che bàn khi đang tô.
    final pointAt =
        pending.isNotEmpty && pending.length == step.targets.length
            ? pending.first
            : null;
    final handSize = cellSize * 0.9;

    return GestureDetector(
      key: const ValueKey('nonogram-tutorial-grid'),
      behavior: HitTestBehavior.opaque,
      onTapUp: (details) {
        _apply(_cellAt(details.localPosition), countMiss: true);
      },
      onPanStart: (details) {
        _lastDragCell = null;
        _onDrag(details.localPosition);
      },
      onPanUpdate: (details) => _onDrag(details.localPosition),
      onPanEnd: (_) => _lastDragCell = null,
      child: SizedBox(
        width: cellSize * cols,
        height: cellSize * rows,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: NonogramCellsPainter(
                  rows: rows,
                  cols: cols,
                  gridData: controller.grid.sublist(0, rows),
                  satisfiedRows: [
                    for (var r = 0; r < rows; r++) controller.isRowComplete(r),
                  ],
                  satisfiedCols: [
                    for (var c = 0; c < cols; c++)
                      step.showColumnClues && controller.isColComplete(c),
                  ],
                  cellSize: cellSize,
                  backgroundColor: colors.surfaceContainerLow,
                  filledColor: colors.onSurface,
                  markedMarkerColor: colors.primary,
                  markerColor: colors.onSurfaceVariant.withValues(alpha: 0.7),
                ),
                foregroundPainter: NonogramGridPainter(
                  rows: rows,
                  cols: cols,
                  cellSize: cellSize,
                  themeColor: colors.primary,
                  lineColor: colors.outlineVariant,
                  majorLineColor: colors.outline,
                ),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _HighlightPainter(
                    cells: {
                      for (final cell in step.highlightedCells)
                        if (cell.row < rows) cell,
                    },
                    cellSize: cellSize,
                    color: game.reward,
                  ),
                ),
              ),
            ),
            if (pointAt != null)
              Positioned(
                left: (pointAt.col + 0.5) * cellSize - handSize * 0.42,
                top: (pointAt.row + 0.5) * cellSize - handSize * 0.08,
                child: IgnorePointer(child: _TapHint(size: handSize)),
              ),
          ],
        ),
      ),
    );
  }
}

/// Viền sáng quanh từng đoạn ô liền nhau cần làm trong mỗi hàng.
class _HighlightPainter extends CustomPainter {
  _HighlightPainter({
    required this.cells,
    required this.cellSize,
    required this.color,
  });

  final Set<TutorialCell> cells;
  final double cellSize;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (cells.isEmpty) return;
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;

    final byRow = <int, List<int>>{};
    for (final cell in cells) {
      byRow.putIfAbsent(cell.row, () => []).add(cell.col);
    }
    for (final entry in byRow.entries) {
      final cols = entry.value..sort();
      var start = cols.first;
      for (var i = 1; i <= cols.length; i++) {
        if (i < cols.length && cols[i] == cols[i - 1] + 1) continue;
        final end = cols[i - 1];
        final rect = Rect.fromLTRB(
          start * cellSize,
          entry.key * cellSize,
          (end + 1) * cellSize,
          (entry.key + 1) * cellSize,
        ).deflate(2.5);
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(cellSize * 0.1)),
          paint,
        );
        if (i < cols.length) start = cols[i];
      }
    }
  }

  @override
  bool shouldRepaint(covariant _HighlightPainter oldDelegate) {
    return !_sameCells(oldDelegate.cells, cells) ||
        oldDelegate.cellSize != cellSize ||
        oldDelegate.color != color;
  }

  static bool _sameCells(Set<TutorialCell> a, Set<TutorialCell> b) {
    return a.length == b.length && a.containsAll(b);
  }
}

/// Nút gạt Tô / X giống trong màn chơi, kèm bàn tay chỉ vào lựa chọn cần bấm.
class _TutorialModeToggle extends StatelessWidget {
  const _TutorialModeToggle({required this.controller});

  final NonogramTutorialController controller;

  static const double _segment = 56;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.color;
    final step = controller.step;
    final pointAt = step.task == TutorialTask.switchMode ? step.mode : null;

    void toggle() {
      controller.selectMode(
        controller.mode == NonogramInteractionMode.fill
            ? NonogramInteractionMode.mark
            : NonogramInteractionMode.fill,
      );
    }

    Widget segment(
      NonogramInteractionMode mode,
      String label,
      Widget Function(Color color) icon,
    ) {
      final selected = controller.mode == mode;
      final foreground = selected ? colors.onPrimary : colors.onSurface;
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Semantics(
            button: true,
            selected: selected,
            label: label,
            child: InkWell(
              key: ValueKey('nonogram-tutorial-mode-${mode.name}'),
              onTap: toggle,
              borderRadius: BorderRadius.circular(15),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: _segment,
                height: _segment,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? colors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: icon(foreground),
              ),
            ),
          ),
          if (pointAt == mode)
            const Positioned(
              left: _segment * 0.5 - 20,
              top: _segment * 0.45,
              child: IgnorePointer(child: _TapHint(size: 48)),
            ),
        ],
      );
    }

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: context.gameColors.cardBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            segment(
              NonogramInteractionMode.fill,
              l10n.nonogramPlayModeFill,
              (color) => Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            segment(
              NonogramInteractionMode.mark,
              l10n.nonogramPlayModeMark,
              (color) => Icon(LucideIcons.x, size: 26, color: color),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bàn tay nhấp nhô, đầu ngón tay ở khoảng (42%, 8%) của ô vuông [size].
class _TapHint extends StatefulWidget {
  const _TapHint({required this.size});

  final double size;

  @override
  State<_TapHint> createState() => _TapHintState();
}

class _TapHintState extends State<_TapHint>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animation = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.color;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final t = Curves.easeInOut.transform(_animation.value);
        return Transform.translate(
          offset: Offset(0, widget.size * 0.14 * t),
          child: child,
        );
      },
      child: Icon(
        Icons.touch_app,
        size: widget.size,
        color: colors.onSurface,
        shadows: [
          Shadow(color: colors.surface, blurRadius: 6),
          Shadow(color: colors.surface, blurRadius: 2),
        ],
      ),
    );
  }
}

/// Lớp phủ mờ cho thẻ chào mừng / hoàn thành.
class _Overlay extends StatelessWidget {
  const _Overlay({required this.alignment, required this.child});

  final Alignment alignment;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: Colors.black.withValues(alpha: 0.4),
        child: Align(
          alignment: alignment,
          child: Padding(padding: const EdgeInsets.all(16), child: child),
        ),
      ),
    );
  }
}

class _OverlayCard extends StatelessWidget {
  const _OverlayCard({
    required this.title,
    required this.body,
    required this.actions,
  });

  final String title;
  final String body;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Material(
        color: colors.surface,
        borderRadius: BorderRadius.circular(24),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: context.titleLarge.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              Text(
                body,
                textAlign: TextAlign.center,
                style: context.bodyLarge.copyWith(
                  color: colors.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              for (final action in actions) ...[
                action,
                const SizedBox(height: 4),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

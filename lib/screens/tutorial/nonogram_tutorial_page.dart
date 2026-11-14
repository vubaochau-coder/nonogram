import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/app_haptics.dart';
import 'package:nonogram/core/app_sounds.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/core/onboarding_preferences.dart';
import 'package:nonogram/l10n/app_localizations.dart';
import 'package:nonogram/models/nonogram_cell_state.dart';
import 'package:nonogram/models/nonogram_interaction_mode.dart';
import 'package:nonogram/screens/painters/nonogram_cells_painter.dart';
import 'package:nonogram/screens/painters/nonogram_grid_painter.dart';

import '../play/nonogram_play_sounds.dart';
import 'nonogram_tutorial_controller.dart';

/// Luồng "Cách chơi": một câu đố 5×5 hiện dần từng hàng, mỗi bước có lời dẫn,
/// viền sáng chỗ cần làm và bàn tay chỉ vào chỗ cần chạm.
///
/// Phần 2 (sau luật chơi) thực hành thao tác trên một câu đố khác: kéo để tô
/// liền, nhấn giữ để đánh X, nút gợi ý, gậy phép. Làm xong phần này thì
/// không tự hiện hướng dẫn thao tác trong màn chơi nữa.
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
  void initState() {
    super.initState();
    _controller.addListener(_onProgress);
    _lastTally = _tally();
  }

  @override
  void dispose() {
    _controller.removeListener(_onProgress);
    _controller.dispose();
    super.dispose();
  }

  /// Bàn hướng dẫn lần trước, để biết vừa tô / đánh X / khớp hàng nào.
  PlayTally? _lastTally;
  bool _wasFinished = false;

  PlayTally _tally() {
    final c = _controller;
    var filled = 0;
    var marked = 0;
    for (final row in c.grid) {
      for (final cell in row) {
        if (cell == NonogramCellState.filled) filled++;
        if (cell == NonogramCellState.marked) marked++;
      }
    }
    var lines = 0;
    for (var r = 0; r < c.rows; r++) {
      if (c.isRowComplete(r)) lines++;
    }
    for (var col = 0; col < c.cols; col++) {
      if (c.isColComplete(col)) lines++;
    }
    return (
      // Mỗi lần nạp bài mới là một danh sách solution mới.
      game: identityHashCode(c.solution),
      filled: filled,
      marked: marked,
      lines: lines,
      totalLines: c.rows + c.cols,
    );
  }

  /// Tiếng giống màn chơi: tô ô, đánh X, khớp xong hàng / cột; giải xong bài
  /// thì hợp âm mừng.
  void _playSounds() {
    final tally = _tally();
    final prev = _lastTally;
    _lastTally = tally;
    final sounds = AppSoundController.maybeOf(context);
    if (sounds == null) return;
    final finished = _controller.isFinished;
    if (finished && !_wasFinished) {
      _wasFinished = true;
      sounds.play(GameSound.fanfare);
      return;
    }
    if (prev == null || prev.game != tally.game) return;
    final sound = soundFor(prev, tally);
    if (sound != null) sounds.play(sound);
  }

  void _onProgress() {
    _playSounds();
    if (!_controller.isFinished) return;
    try {
      context.read<OnboardingPreferences>().markPlayCoachSeen();
    } on ProviderNotFoundException {
      // Không có tuỳ chọn (test): bỏ qua.
    }
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
                            task == TutorialTask.intro ||
                                    task == TutorialTask.rulesDone
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (step.showTools) ...[
                            _TutorialToolButton(
                              key: const ValueKey('nonogram-tutorial-hint'),
                              icon: LucideIcons.lightbulb,
                              label: l10n.nonogramCoachHintTitle,
                              count: _controller.remainingHints,
                              active: false,
                              pointed: task == TutorialTask.useHint,
                              onPressed: _controller.useHint,
                            ),
                            const SizedBox(width: 12),
                            _TutorialToolButton(
                              key: const ValueKey('nonogram-tutorial-wand'),
                              icon: LucideIcons.wand2,
                              label: l10n.nonogramPlayWandLabel,
                              count: _controller.remainingWands,
                              active: _controller.isWandActive,
                              pointed: task == TutorialTask.activateWand,
                              onPressed: _controller.activateWand,
                            ),
                            const SizedBox(width: 20),
                          ],
                          _TutorialModeToggle(controller: _controller),
                        ],
                      ),
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
                if (task == TutorialTask.rulesDone)
                  _Overlay(
                    alignment: Alignment.bottomCenter,
                    child: _OverlayCard(
                      title: l10n.nonogramTutorialRulesDoneTitle,
                      body: l10n.nonogramTutorialRulesDone,
                      actions: [
                        FilledButton(
                          key: const ValueKey('nonogram-tutorial-continue'),
                          onPressed: _controller.continueToTools,
                          child: Text(l10n.nonogramTutorialContinue),
                        ),
                        TextButton(
                          key: const ValueKey('nonogram-tutorial-later'),
                          onPressed: _close,
                          child: Text(l10n.nonogramTutorialLater),
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
    TutorialMessage.rulesDone => l10n.nonogramTutorialRulesDone,
    TutorialMessage.dragRow => l10n.nonogramTutorialDragRow,
    TutorialMessage.longPressMark => l10n.nonogramTutorialLongPressMark,
    TutorialMessage.useHint => l10n.nonogramTutorialUseHint,
    TutorialMessage.activateWand => l10n.nonogramTutorialActivateWand,
    TutorialMessage.pickWandLine => l10n.nonogramTutorialPickWandLine,
    TutorialMessage.finishTools => l10n.nonogramTutorialFinishTools,
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
        // Đủ cho 4 dòng, để lời dẫn dài / ngắn không làm bàn nhảy lên xuống.
        constraints: const BoxConstraints(minHeight: 128),
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
    final activeRows = {
      for (final cell in controller.highlightedCells) cell.row,
    };
    final wandLine = step.wandLine;
    final picking = step.task == TutorialTask.pickWandLine;
    bool isWandTarget(bool isRow, int index) =>
        picking && wandLine == (isRow: isRow, index: index);
    VoidCallback? pick(bool isRow, int index) =>
        picking
            ? () => controller.pickClueLine((isRow: isRow, index: index))
            : null;

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
                    active: isWandTarget(false, c),
                    pointed: isWandTarget(false, c),
                    onTap: pick(false, c),
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
                    active: activeRows.contains(r) || isWandTarget(true, r),
                    pointed: isWandTarget(true, r),
                    onTap: pick(true, r),
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
    this.pointed = false,
    this.onTap,
  });

  final double width;
  final double height;
  final List<int> clues;
  final bool vertical;
  final bool complete;
  final bool active;

  /// Bàn tay chỉ vào ô số này (chọn hàng / cột cho gậy phép).
  final bool pointed;

  /// Chạm vào dãy số (khi đang chọn hàng / cột cho gậy phép).
  final VoidCallback? onTap;

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
    final handSize = shortSide * 0.9;

    final tile = SizedBox(
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
          // Dấu ✓ và các số chia chỗ với nhau (không đè lên nhau khi có
          // nhiều số); 3 số trở lên ("1 1 1") thì thu nhỏ cho vừa ô.
          child: Flex(
            direction: vertical ? Axis.vertical : Axis.horizontal,
            children: [
              if (complete)
                Icon(
                  Icons.check_rounded,
                  size: shortSide * 0.3,
                  color: game.success,
                ),
              Expanded(
                child: Align(
                  alignment:
                      vertical ? Alignment.bottomCenter : Alignment.centerRight,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (onTap == null && !pointed) return tile;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          tile,
          if (pointed)
            Positioned(
              left: width / 2 - handSize * 0.42,
              top: height / 2 - handSize * 0.08,
              child: IgnorePointer(child: _TapHint(size: handSize)),
            ),
        ],
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

  void _onLongPress(Offset position) {
    final cell = _cellAt(position);
    if (cell == null) return;
    // Như màn chơi: rung ngay lúc nhấn giữ được nhận (kể cả khi bước này
    // không nhận nhấn giữ), để người chơi biết đã có thể nhấc tay.
    AppHaptics.longPress();
    widget.controller.longPressCell(cell.row, cell.col);
  }

  void _onDrag(Offset position) {
    final cell = _cellAt(position);
    if (cell == null || cell == _lastDragCell) return;
    final last = _lastDragCell;
    _lastDragCell = cell;
    if (last == null) {
      _apply(cell, countMiss: false);
      return;
    }
    // Lướt nhanh có thể nhảy qua vài ô giữa hai sự kiện: tô cả các ô đó.
    final dr = cell.row - last.row;
    final dc = cell.col - last.col;
    final steps = math.max(dr.abs(), dc.abs());
    for (var i = 1; i <= steps; i++) {
      _apply((
        row: last.row + (dr * i / steps).round(),
        col: last.col + (dc * i / steps).round(),
      ), countMiss: false);
    }
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
    // Bước tập kéo: bàn tay lướt dọc theo các ô cần tô.
    final swipe = step.message == TutorialMessage.dragRow && pointAt != null;

    return GestureDetector(
      key: const ValueKey('nonogram-tutorial-grid'),
      behavior: HitTestBehavior.opaque,
      onTapUp: (details) {
        _apply(_cellAt(details.localPosition), countMiss: true);
      },
      // Bắt đầu tính từ chỗ ngón tay chạm xuống, không phải chỗ đã trượt
      // qua ngưỡng nhận kéo (không bỏ sót ô đầu tiên).
      dragStartBehavior: DragStartBehavior.down,
      onPanStart: (details) {
        _lastDragCell = null;
        _onDrag(details.localPosition);
      },
      onPanUpdate: (details) => _onDrag(details.localPosition),
      onPanEnd: (_) => _lastDragCell = null,
      onLongPressStart: (details) => _onLongPress(details.localPosition),
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
                  lockedCells: controller.lockedCells,
                  lockedStarColor: game.lockedStar,
                  lockedMarkStarColor: game.lockedMarkStar,
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
                      for (final cell in controller.highlightedCells)
                        if (cell.row < rows) cell,
                    },
                    cellSize: cellSize,
                    color: game.reward,
                  ),
                ),
              ),
            ),
            if (controller.revealedCells.isNotEmpty)
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _HighlightPainter(
                      cells: controller.revealedCells,
                      cellSize: cellSize,
                      color: colors.primary,
                    ),
                  ),
                ),
              ),
            if (pointAt != null && swipe)
              Positioned.fill(
                child: IgnorePointer(
                  child: _SwipeHint(
                    from: Offset(
                      (pending.first.col + 0.5) * cellSize - handSize * 0.42,
                      (pending.first.row + 0.5) * cellSize - handSize * 0.08,
                    ),
                    to: Offset(
                      (pending.last.col + 0.5) * cellSize - handSize * 0.42,
                      (pending.last.row + 0.5) * cellSize - handSize * 0.08,
                    ),
                    size: handSize,
                  ),
                ),
              )
            else if (pointAt != null)
              Positioned(
                left: (pointAt.col + 0.5) * cellSize - handSize * 0.42,
                top: (pointAt.row + 0.5) * cellSize - handSize * 0.08,
                child: IgnorePointer(
                  child:
                      step.task == TutorialTask.longPressMark
                          ? _HoldHint(size: handSize)
                          : _TapHint(size: handSize),
                ),
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

    // Cả một cột (ô vừa hiện đáp án): một khung dọc.
    final sameCol = cells.map((c) => c.col).toSet();
    if (cells.length > 1 && sameCol.length == 1) {
      final rows = cells.map((c) => c.row).toList()..sort();
      if (rows.last - rows.first == rows.length - 1) {
        final col = sameCol.first;
        final rect = Rect.fromLTRB(
          col * cellSize,
          rows.first * cellSize,
          (col + 1) * cellSize,
          (rows.last + 1) * cellSize,
        ).deflate(2.5);
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(cellSize * 0.1)),
          paint,
        );
        return;
      }
    }

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

/// Bàn tay lướt từ [from] tới [to] (vị trí góc trên-trái của icon), lặp lại.
class _SwipeHint extends StatefulWidget {
  const _SwipeHint({required this.from, required this.to, required this.size});

  final Offset from;
  final Offset to;
  final double size;

  @override
  State<_SwipeHint> createState() => _SwipeHintState();
}

class _SwipeHintState extends State<_SwipeHint>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animation = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat();

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
      builder: (context, _) {
        // 0–15%: hiện ra, 15–80%: lướt, 80–100%: mờ đi.
        final v = _animation.value;
        final move = Curves.easeInOut.transform(
          ((v - 0.15) / 0.65).clamp(0.0, 1.0),
        );
        final opacity = v < 0.15 ? v / 0.15 : (v > 0.8 ? (1 - v) / 0.2 : 1.0);
        final p = Offset.lerp(widget.from, widget.to, move)!;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: p.dx,
              top: p.dy,
              child: Opacity(
                opacity: opacity.clamp(0.0, 1.0),
                child: Icon(
                  Icons.touch_app,
                  size: widget.size,
                  color: colors.onSurface,
                  shadows: [
                    Shadow(color: colors.surface, blurRadius: 6),
                    Shadow(color: colors.surface, blurRadius: 2),
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

/// Bàn tay nhấn xuống và giữ, kèm vòng tròn chạy quanh đầu ngón tay cho tới
/// lúc "rung".
class _HoldHint extends StatefulWidget {
  const _HoldHint({required this.size});

  final double size;

  @override
  State<_HoldHint> createState() => _HoldHintState();
}

class _HoldHintState extends State<_HoldHint>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animation = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..repeat();

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final size = widget.size;
    final ring = size * 0.62;
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final v = _animation.value;
        // 0–20%: ấn xuống, 20–70%: giữ (vòng chạy), 70–100%: nhả.
        final press = v < 0.2 ? v / 0.2 : (v > 0.7 ? (1 - v) / 0.3 : 1.0);
        final progress = ((v - 0.2) / 0.5).clamp(0.0, 1.0);
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              if (v >= 0.2 && v <= 0.85)
                Positioned(
                  left: size * 0.42 - ring / 2,
                  top: size * 0.08 - ring / 2,
                  width: ring,
                  height: ring,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 3,
                    color: colors.primary,
                    backgroundColor: colors.primary.withValues(alpha: 0.2),
                  ),
                ),
              Transform.translate(
                offset: Offset(0, size * 0.12 * press),
                child: child,
              ),
            ],
          ),
        );
      },
      child: Icon(
        Icons.touch_app,
        size: size,
        color: colors.onSurface,
        shadows: [
          Shadow(color: colors.surface, blurRadius: 6),
          Shadow(color: colors.surface, blurRadius: 2),
        ],
      ),
    );
  }
}

/// Nút gợi ý / gậy phép trong bài hướng dẫn, kèm số lượt và bàn tay chỉ.
class _TutorialToolButton extends StatelessWidget {
  const _TutorialToolButton({
    super.key,
    required this.icon,
    required this.label,
    required this.count,
    required this.active,
    required this.pointed,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final int count;
  final bool active;
  final bool pointed;
  final VoidCallback onPressed;

  static const double _size = 60;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final game = context.gameColors;
    final foreground = active ? colors.primary : colors.onSurface;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Semantics(
          button: true,
          label: label,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(17),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: _size,
                height: _size,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color:
                      active
                          ? colors.primary.withValues(alpha: 0.12)
                          : colors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(
                    color:
                        pointed
                            ? game.reward
                            : (active
                                ? colors.primary.withValues(alpha: 0.4)
                                : game.cardBorder),
                    width: pointed ? 2 : 1,
                  ),
                ),
                child: Icon(icon, size: 26, color: foreground),
              ),
            ),
          ),
        ),
        Positioned(
          right: -5,
          top: -5,
          child: IgnorePointer(
            child: Container(
              constraints: const BoxConstraints(minWidth: 20),
              height: 20,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: count > 0 ? colors.primary : colors.outline,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: context.labelSmall.copyWith(
                  fontSize: 11,
                  height: 1,
                  fontWeight: FontWeight.w800,
                  color: colors.onPrimary,
                ),
              ),
            ),
          ),
        ),
        if (pointed)
          const Positioned(
            left: _size * 0.5 - 20,
            top: _size * 0.45,
            child: IgnorePointer(child: _TapHint(size: 48)),
          ),
      ],
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

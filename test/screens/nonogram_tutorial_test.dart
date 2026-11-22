import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/core/app_sounds.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/l10n/app_localizations.dart';
import 'package:nonogram/models/nonogram_cell_state.dart';
import 'package:nonogram/models/nonogram_interaction_mode.dart';
import 'package:nonogram/models/nonogram_puzzle.dart';
import 'package:nonogram/screens/tutorial/nonogram_tutorial_controller.dart';
import 'package:nonogram/screens/tutorial/nonogram_tutorial_page.dart';
import 'package:provider/provider.dart';

/// Làm đúng mọi bước của kịch bản.
void solveAll(NonogramTutorialController controller) {
  while (!controller.isFinished) {
    _doStep(controller);
  }
}

/// Làm đúng bước hiện tại.
void _doStep(NonogramTutorialController controller) {
  final step = controller.step;
  switch (step.task) {
    case TutorialTask.intro:
      controller.start();
    case TutorialTask.switchMode:
      controller.selectMode(step.mode!);
    case TutorialTask.fill:
    case TutorialTask.mark:
      for (final cell in controller.pendingTargets) {
        controller.tapCell(cell.row, cell.col);
      }
    case TutorialTask.rulesDone:
    case TutorialTask.toolsDone:
      controller.continueChapter();
    case TutorialTask.longPressMark:
      for (final cell in controller.pendingTargets) {
        controller.longPressCell(cell.row, cell.col);
      }
    case TutorialTask.useHint:
      controller.useHint();
    case TutorialTask.activateWand:
      controller.activateWand();
    case TutorialTask.pickWandLine:
      controller.pickClueLine(step.wandLine!);
    case TutorialTask.done:
      break;
  }
}

void main() {
  group('NonogramTutorialScript', () {
    final allSteps = NonogramTutorialScript.steps;
    final toolsStart = allSteps.indexWhere((s) => s.newPuzzle != null);
    // Phần luật chơi: các bước tới hết bước "xong luật chơi".
    const solution = NonogramTutorialScript.solution;
    final steps = allSteps.sublist(0, toolsStart);
    final steps0 = allSteps;

    test('starts with the intro and ends with done', () {
      expect(steps0.first.task, TutorialTask.intro);
      expect(steps0.last.task, TutorialTask.done);
      expect(steps.last.task, TutorialTask.rulesDone);
      expect(
        allSteps[toolsStart].newPuzzle,
        NonogramTutorialScript.toolsSolution,
      );
    });

    test('tools part targets agree with its solution', () {
      const tools = NonogramTutorialScript.toolsSolution;
      final toolsEnd = allSteps.indexWhere(
        (s) => s.task == TutorialTask.toolsDone,
      );
      for (final step in allSteps.sublist(toolsStart, toolsEnd + 1)) {
        expect(step.showTools, isTrue);
        for (final cell in step.targets) {
          expect(
            tools[cell.row][cell.col],
            step.task == TutorialTask.longPressMark ? 0 : 1,
          );
        }
      }
    });

    test('targets agree with the solution', () {
      for (final step in steps) {
        for (final cell in step.targets) {
          expect(cell.row, lessThan(step.visibleRows));
          final value = solution[cell.row][cell.col];
          expect(value, step.task == TutorialTask.mark ? 0 : 1);
        }
        for (final cell in step.prefilled) {
          expect(solution[cell.row][cell.col], 1);
        }
        if (step.task == TutorialTask.switchMode) {
          expect(step.mode, isNotNull);
        }
        if (step.task == TutorialTask.fill || step.task == TutorialTask.mark) {
          expect(step.targets, isNotEmpty);
        }
      }
    });

    test('every filled cell of the solution is filled by some step', () {
      final filled = {
        for (final step in steps)
          if (step.task == TutorialTask.fill) ...step.targets,
        for (final step in steps) ...step.prefilled,
      };
      for (var r = 0; r < solution.length; r++) {
        for (var c = 0; c < solution[r].length; c++) {
          expect(filled.contains((row: r, col: c)), solution[r][c] == 1);
        }
      }
    });
  });

  group('NonogramTutorialController', () {
    test('walks through every step to a solved board', () {
      final controller = NonogramTutorialController();
      solveAll(controller);

      expect(controller.isFinished, isTrue);
      expect(controller.solution, NonogramTutorialScript.techniquesSolution);
      expect(controller.mistakes, 0);
      for (var r = 0; r < controller.rows; r++) {
        expect(controller.isRowComplete(r), isTrue);
      }
      for (var c = 0; c < controller.cols; c++) {
        expect(controller.isColComplete(c), isTrue);
      }
    });

    test('starts in X mode and must be switched to fill mode', () {
      final controller = NonogramTutorialController()..start();

      expect(controller.mode, NonogramInteractionMode.mark);
      expect(controller.step.task, TutorialTask.switchMode);

      controller.tapCell(0, 0);
      expect(controller.cellAt(0, 0), NonogramCellState.empty);
      expect(controller.mistakes, 1);

      controller.selectMode(NonogramInteractionMode.fill);
      expect(controller.mode, NonogramInteractionMode.fill);
      expect(controller.step.task, TutorialTask.fill);
    });

    test('ignores cells outside the step targets', () {
      final controller = NonogramTutorialController()..start();
      controller.selectMode(NonogramInteractionMode.fill);
      // Bước tô hàng đầu: hàng thứ hai chưa hiện.
      expect(controller.tapCell(1, 1), isFalse);
      expect(controller.mistakes, 1);

      // Kéo lướt qua ô sai không bị tính là lỗi.
      expect(controller.tapCell(1, 1, countMiss: false), isFalse);
      expect(controller.mistakes, 1);

      expect(controller.tapCell(0, 2), isTrue);
      expect(controller.cellAt(0, 2), NonogramCellState.filled);
      // Chạm lại ô đã tô không xoá ô.
      expect(controller.tapCell(0, 2), isFalse);
      expect(controller.cellAt(0, 2), NonogramCellState.filled);
    });

    test('prefills the edge cell when the second row appears', () {
      final controller = NonogramTutorialController()..start();
      controller.selectMode(NonogramInteractionMode.fill);
      for (var c = 0; c < 5; c++) {
        controller.tapCell(0, c);
      }

      expect(controller.step.message, TutorialMessage.edgeCell);
      expect(controller.cellAt(1, 4), NonogramCellState.filled);
      expect(controller.pendingTargets.length, 3);
    });
  });

  group('NonogramTutorialController tools part', () {
    NonogramTutorialController atTools() {
      final controller = NonogramTutorialController();
      while (controller.step.newPuzzle == null) {
        final step = controller.step;
        switch (step.task) {
          case TutorialTask.intro:
            controller.start();
          case TutorialTask.switchMode:
            controller.selectMode(step.mode!);
          case TutorialTask.rulesDone:
            controller.continueChapter();
          default:
            for (final cell in controller.pendingTargets) {
              controller.tapCell(cell.row, cell.col);
            }
        }
      }
      return controller;
    }

    test('starts a fresh board in fill mode', () {
      final controller = atTools();
      expect(controller.mode, NonogramInteractionMode.fill);
      expect(
        controller.grid
            .expand((r) => r)
            .every((c) => c == NonogramCellState.empty),
        isTrue,
      );
      expect(controller.rowClues.first, [5]);
    });

    test('tapping instead of holding does not mark', () {
      final controller = atTools();
      for (var c = 0; c < 5; c++) {
        controller.tapCell(0, c, countMiss: false);
      }
      expect(controller.step.task, TutorialTask.longPressMark);
      expect(controller.tapCell(2, 1), isFalse);
      expect(controller.cellAt(2, 1), NonogramCellState.empty);
      expect(controller.mistakes, 1);

      expect(controller.longPressCell(2, 1), isTrue);
      expect(controller.cellAt(2, 1), NonogramCellState.marked);
      // Nhấn giữ ô không phải mục tiêu là sai.
      expect(controller.longPressCell(0, 0), isFalse);
      expect(controller.mistakes, 2);
    });

    test('hint fills 5 random cells, wand reveals the chosen line', () {
      final controller = atTools();
      for (var c = 0; c < 5; c++) {
        controller.tapCell(0, c);
      }
      controller.longPressCell(2, 1);
      controller.longPressCell(2, 3);
      expect(controller.step.task, TutorialTask.useHint);

      controller.useHint();
      expect(controller.remainingHints, 2);
      // Tô giúp 5 ô đúng, chưa tô từ trước.
      expect(controller.revealedCells.length, 5);
      for (final c in controller.revealedCells) {
        expect(NonogramTutorialScript.toolsSolution[c.row][c.col], 1);
        expect(c.row == 0, isFalse);
        expect(controller.cellAt(c.row, c.col), NonogramCellState.filled);
      }

      // Chưa cầm gậy phép thì chạm dãy số là sai.
      controller.pickClueLine((isRow: true, index: 4));
      expect(controller.step.task, TutorialTask.activateWand);
      controller.activateWand();
      expect(controller.isWandActive, isTrue);

      // Chọn sai dòng: không đổi gì.
      controller.pickClueLine((isRow: false, index: 0));
      expect(controller.remainingWands, 1);

      controller.pickClueLine((isRow: true, index: 4));
      expect(controller.remainingWands, 0);
      expect(controller.isWandActive, isFalse);
      expect(
        controller.grid[4].every((c) => c == NonogramCellState.filled),
        isTrue,
      );
      expect(controller.step.message, TutorialMessage.finishTools);
    });
  });

  group('NonogramTutorialScript techniques part', () {
    final allSteps = NonogramTutorialScript.steps;
    final start = allSteps.indexWhere(
      (s) => s.newPuzzle == NonogramTutorialScript.techniquesSolution,
    );
    final steps = allSteps.sublist(start);
    const solution = NonogramTutorialScript.techniquesSolution;

    test('comes after the tools part and ends the tutorial', () {
      expect(start, greaterThan(0));
      expect(allSteps[start - 1].task, TutorialTask.toolsDone);
      expect(steps.last.task, TutorialTask.done);
      expect(steps.last.visibleRows, solution.length);
      for (final step in steps) {
        expect(step.showTools, isFalse);
        expect(step.visibleRows, solution.length);
      }
    });

    test('every target can be deduced from its row or column alone', () {
      // Bàn mà người chơi thấy: null = chưa biết, 1 = tô, 0 = X.
      final known = [
        for (final row in solution) List<int?>.filled(row.length, null),
      ];
      List<int> rowClue(int r) => NonogramPuzzle.deriveClues(solution[r]);
      List<int> colClue(int c) =>
          NonogramPuzzle.deriveClues([for (final row in solution) row[c]]);

      for (final step in steps) {
        if (step.task != TutorialTask.fill && step.task != TutorialTask.mark) {
          continue;
        }
        final value = step.task == TutorialTask.fill ? 1 : 0;
        // Bước tự giải: mỗi lần tô một ô suy ra được, như người chơi.
        final pending = {...step.targets};
        while (pending.isNotEmpty) {
          final cell = pending.firstWhere((cell) {
            final byRow = _forcedLine(rowClue(cell.row), known[cell.row]);
            final byCol = _forcedLine(colClue(cell.col), [
              for (final row in known) row[cell.col],
            ]);
            return byRow[cell.col] == value || byCol[cell.row] == value;
          }, orElse: () => throw StateError('${step.message}: no deduction'));
          expect(solution[cell.row][cell.col], value);
          known[cell.row][cell.col] = value;
          pending.remove(cell);
          // Bước tự giải: người chơi cũng suy ra được các ô X dọc đường.
          if (step.freePlay) _deduceMarks(known, rowClue, colClue);
        }
      }
      for (var r = 0; r < solution.length; r++) {
        for (var c = 0; c < solution[r].length; c++) {
          if (solution[r][c] == 1) expect(known[r][c], 1);
        }
      }
    });

    test('blinking placements agree exactly with the cells to do', () {
      final controller = NonogramTutorialController();
      final counts = <TutorialMessage, int>{};
      while (!controller.isFinished) {
        final step = controller.step;
        final line = step.ghostLine;
        if (line != null) {
          final placements = controller.ghostPlacements;
          counts[step.message] = placements.length;
          expect(controller.showGhost, isTrue);
          TutorialCell cellAt(int i) =>
              line.isRow
                  ? (row: line.index, col: i)
                  : (row: i, col: line.index);
          final onLine = {
            for (final cell in step.targets)
              if (line.isRow ? cell.row == line.index : cell.col == line.index)
                cell,
          };
          if (step.task == TutorialTask.fill) {
            // Ô sáng ở mọi cách đặt = đúng các ô cần tô.
            final always = placements.reduce((a, b) => a.intersection(b));
            expect({for (final i in always) cellAt(i)}, onLine);
          } else {
            // Ô không sáng ở cách nào = đúng các ô cần đánh X (còn trống).
            final reach = placements.reduce((a, b) => a.union(b));
            final length = line.isRow ? controller.cols : controller.rows;
            expect({
              for (var i = 0; i < length; i++)
                if (!reach.contains(i) &&
                    controller.cellAt(cellAt(i).row, cellAt(i).col) ==
                        NonogramCellState.empty)
                  cellAt(i),
            }, onLine);
          }
          // Làm ô đầu tiên thì hoạt ảnh dừng.
          final first = controller.pendingTargets.first;
          controller.tapCell(first.row, first.col);
          expect(controller.showGhost, isFalse);
        }
        _doStep(controller);
      }
      expect(counts, {
        TutorialMessage.overlapSingle: 3,
        TutorialMessage.overlapMulti: 3,
        TutorialMessage.outOfReach: 2,
      });
    });

    test('free play hides the highlight', () {
      final step = steps.firstWhere((s) => s.freePlay);
      expect(step.highlightedCells, isEmpty);
      expect(step.targets, isNotEmpty);
    });
  });

  group('NonogramTutorialPage', () {
    Widget buildPage(GlobalKey<NavigatorState> navigatorKey) {
      return MaterialApp(
        navigatorKey: navigatorKey,
        theme: AppTheme.lightTheme,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: SizedBox()),
      );
    }

    Future<void> tapCell(WidgetTester tester, int row, int col) async {
      final grid = find.byKey(const ValueKey('nonogram-tutorial-grid'));
      final rect = tester.getRect(grid);
      final cellSize = rect.width / NonogramTutorialScript.solution[0].length;
      await tester.tapAt(
        rect.topLeft + Offset((col + 0.5) * cellSize, (row + 0.5) * cellSize),
      );
      await tester.pump();
    }

    Future<void> tapMode(WidgetTester tester) async {
      await tester.tap(
        find.byKey(const ValueKey('nonogram-tutorial-mode-fill')),
      );
      await tester.pump(const Duration(milliseconds: 300));
    }

    testWidgets('can be completed by tapping and returns the choice', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      final navigatorKey = GlobalKey<NavigatorState>();
      await tester.pumpWidget(buildPage(navigatorKey));

      final result = navigatorKey.currentState!.push<bool>(
        MaterialPageRoute(builder: (_) => const NonogramTutorialPage()),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      await tester.tap(find.byKey(const ValueKey('nonogram-tutorial-start')));
      await tester.pump(const Duration(milliseconds: 300));

      await tapMode(tester);
      for (var c = 0; c < 5; c++) {
        await tapCell(tester, 0, c);
      }
      for (final c in [1, 2, 3]) {
        await tapCell(tester, 1, c);
      }
      for (final c in [0, 1, 3, 4]) {
        await tapCell(tester, 2, c);
      }
      for (final c in [0, 1, 2, 4]) {
        await tapCell(tester, 3, c);
      }
      await tapMode(tester);
      for (final cell in [(1, 0), (4, 0), (4, 1), (2, 2), (4, 2), (4, 4)]) {
        await tapCell(tester, cell.$1, cell.$2);
      }
      await tapMode(tester);
      await tapCell(tester, 4, 3);
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('You know the rules!'), findsOneWidget);
      await tester.tap(
        find.byKey(const ValueKey('nonogram-tutorial-continue')),
      );
      await tester.pump(const Duration(milliseconds: 300));

      // Phần thao tác. Lời dẫn đổi độ cao làm bàn dịch chỗ, nên đo lại lưới
      // trước mỗi thao tác.
      Rect gridRect() =>
          tester.getRect(find.byKey(const ValueKey('nonogram-tutorial-grid')));

      // Kéo qua hàng đầu.
      var rect = gridRect();
      var cell = rect.width / 5;
      await tester.dragFrom(
        rect.topLeft + Offset(cell * 0.5, cell * 0.5),
        Offset(cell * 4, 0),
      );
      await tester.pump(const Duration(milliseconds: 300));

      // Nhấn giữ để đánh X.
      for (final c in [1, 3]) {
        rect = gridRect();
        cell = rect.width / 5;
        await tester.longPressAt(
          rect.topLeft + Offset((c + 0.5) * cell, 2.5 * cell),
        );
        await tester.pump(const Duration(milliseconds: 300));
      }

      await tester.tap(find.byKey(const ValueKey('nonogram-tutorial-hint')));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(find.byKey(const ValueKey('nonogram-tutorial-wand')));
      await tester.pump(const Duration(milliseconds: 300));
      // Dãy số của hàng cuối nằm ngay bên trái lưới.
      rect = gridRect();
      cell = rect.width / 5;
      await tester.tapAt(rect.topLeft + Offset(-cell * 0.5, 4.5 * cell));
      await tester.pump(const Duration(milliseconds: 300));

      for (final c in [
        (1, 0),
        (2, 0),
        (3, 0),
        (2, 2),
        (1, 4),
        (2, 4),
        (3, 4),
      ]) {
        await tapCell(tester, c.$1, c.$2);
      }
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Controls mastered!'), findsOneWidget);
      await tester.tap(
        find.byKey(const ValueKey('nonogram-tutorial-continue-techniques')),
      );
      await tester.pump(const Duration(milliseconds: 300));

      // Phần kỹ thuật giải: bàn 8×8.
      Future<void> tap8(int row, int col) async {
        final rect = gridRect();
        final size = rect.width / 8;
        await tester.tapAt(
          rect.topLeft + Offset((col + 0.5) * size, (row + 0.5) * size),
        );
        await tester.pump(const Duration(milliseconds: 50));
      }

      Future<void> tapModeKey(String mode) async {
        await tester.tap(find.byKey(ValueKey('nonogram-tutorial-mode-$mode')));
        await tester.pump(const Duration(milliseconds: 300));
      }

      for (final c in [2, 3, 4, 5]) {
        await tap8(1, c);
      }
      for (final c in [1, 2, 5, 6]) {
        await tap8(2, c);
      }
      for (var c = 0; c < 8; c++) {
        await tap8(3, c);
      }
      await tapModeKey('mark');
      for (var c = 0; c < 8; c++) {
        await tap8(7, c);
      }
      for (final col in [1, 6]) {
        for (final r in [0, 5, 6]) {
          await tap8(r, col);
        }
      }
      await tapModeKey('fill');
      for (final col in [2, 5]) {
        for (final r in [0, 4, 5, 6]) {
          await tap8(r, col);
        }
      }
      for (final c in [(0, 3), (0, 4), (1, 1), (1, 6), (2, 0), (2, 7)]) {
        await tap8(c.$1, c.$2);
      }
      await tap8(6, 3);
      await tap8(6, 4);
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Well done!'), findsOneWidget);

      await tester.tap(
        find.byKey(const ValueKey('nonogram-tutorial-techniques')),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(await result, isTrue);
    });

    testWidgets('plays game sounds and buzzes on every long press', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      final haptics = <String>[];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'HapticFeedback.vibrate') {
            haptics.add('${call.arguments}');
          }
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );
      final engine = _RecordingEngine();
      final navigatorKey = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: AppSoundController.inMemory(engine: engine),
          child: buildPage(navigatorKey),
        ),
      );
      navigatorKey.currentState!.push<bool>(
        MaterialPageRoute(builder: (_) => const NonogramTutorialPage()),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.tap(find.byKey(const ValueKey('nonogram-tutorial-start')));
      await tester.pump(const Duration(milliseconds: 300));

      // Bước này chưa dạy nhấn giữ: không đổi ô nhưng vẫn rung như màn chơi.
      final grid = find.byKey(const ValueKey('nonogram-tutorial-grid'));
      await tester.longPressAt(
        tester.getRect(grid).topLeft + const Offset(5, 5),
      );
      await tester.pump(const Duration(milliseconds: 300));
      expect(haptics, isNotEmpty);

      await tapMode(tester);
      for (var c = 0; c < 5; c++) {
        await tapCell(tester, 0, c);
      }
      expect(engine.played.first, GameSound.fill);
      // Tô đủ hàng đầu: tiếng khớp hàng.
      expect(engine.played.last, GameSound.line);
    });

    testWidgets('skip closes the tutorial without the techniques', (
      tester,
    ) async {
      final navigatorKey = GlobalKey<NavigatorState>();
      await tester.pumpWidget(buildPage(navigatorKey));

      final result = navigatorKey.currentState!.push<bool>(
        MaterialPageRoute(builder: (_) => const NonogramTutorialPage()),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      await tester.tap(find.byKey(const ValueKey('nonogram-tutorial-skip')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(await result, isFalse);
    });
  });
}

/// Trạng thái chắc chắn của từng ô trong một dòng (null = chưa biết), xét
/// mọi cách đặt khối hợp với [clue] và các ô đã biết.
List<int?> _forcedLine(List<int> clue, List<int?> known) {
  final length = known.length;
  final blocks = clue.where((c) => c > 0).toList();
  List<int?>? result;
  void place(int index, int from, List<int> line) {
    if (index == blocks.length) {
      for (var i = 0; i < length; i++) {
        if (known[i] != null && known[i] != line[i]) return;
      }
      result =
          result == null
              ? List<int?>.of(line)
              : [
                for (var i = 0; i < length; i++)
                  result![i] == line[i] ? line[i] : null,
              ];
      return;
    }
    final rest = blocks.skip(index + 1).fold(0, (sum, b) => sum + b + 1);
    for (var s = from; s + blocks[index] + rest <= length; s++) {
      final next = List<int>.of(line);
      for (var i = s; i < s + blocks[index]; i++) {
        next[i] = 1;
      }
      place(index + 1, s + blocks[index] + 1, next);
    }
  }

  place(0, 0, List.filled(length, 0));
  return result ?? List<int?>.filled(length, null);
}

/// Đánh X mọi ô suy ra được là trống, cho tới khi không còn gì mới.
void _deduceMarks(
  List<List<int?>> known,
  List<int> Function(int) rowClue,
  List<int> Function(int) colClue,
) {
  var changed = true;
  while (changed) {
    changed = false;
    for (var r = 0; r < known.length; r++) {
      for (var c = 0; c < known[r].length; c++) {
        if (known[r][c] != null) continue;
        final byRow = _forcedLine(rowClue(r), known[r]);
        final byCol = _forcedLine(colClue(c), [
          for (final row in known) row[c],
        ]);
        if (byRow[c] == 0 || byCol[r] == 0) {
          known[r][c] = 0;
          changed = true;
        }
      }
    }
  }
}

class _RecordingEngine implements GameSoundEngine {
  final played = <GameSound>[];

  @override
  void play(GameSound sound) => played.add(sound);

  @override
  void dispose() {}
}

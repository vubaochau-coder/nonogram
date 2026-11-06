import 'package:flutter/foundation.dart';
import 'package:nonogram/models/nonogram_cell_state.dart';
import 'package:nonogram/models/nonogram_interaction_mode.dart';
import 'package:nonogram/models/nonogram_puzzle.dart';

typedef TutorialCell = ({int row, int col});

/// Việc người chơi phải làm ở một bước của bài hướng dẫn.
enum TutorialTask {
  /// Thẻ chào mừng, chờ bấm "Bắt đầu".
  intro,

  /// Chuyển nút Tô / X sang [TutorialStep.mode].
  switchMode,

  /// Tô đủ các ô [TutorialStep.targets].
  fill,

  /// Đánh X đủ các ô [TutorialStep.targets].
  mark,

  /// Đã giải xong.
  done,
}

/// Lời dẫn của từng bước; trang hướng dẫn đổi sang chuỗi dịch.
enum TutorialMessage {
  welcome,
  switchToFill,
  clueIsCount,
  edgeCell,
  multipleClues,
  clueOrder,
  columns,
  markEmpty,
  oneCellLeft,
  finish,
  done,
}

class TutorialStep {
  const TutorialStep({
    required this.task,
    required this.message,
    required this.visibleRows,
    this.showColumnClues = false,
    this.mode,
    this.targets = const {},
    this.highlight,
    this.prefilled = const {},
  });

  final TutorialTask task;
  final TutorialMessage message;

  /// Số hàng (từ trên xuống) đang hiện trên bàn.
  final int visibleRows;
  final bool showColumnClues;

  /// Chế độ cần chuyển sang, với [TutorialTask.switchMode].
  final NonogramInteractionMode? mode;

  /// Các ô cần tô / đánh X để qua bước.
  final Set<TutorialCell> targets;

  /// Vùng viền sáng; mặc định là [targets].
  final Set<TutorialCell>? highlight;

  /// Ô được tô sẵn khi vào bước.
  final Set<TutorialCell> prefilled;

  Set<TutorialCell> get highlightedCells => highlight ?? targets;
}

/// Bài 5×5 và kịch bản từng bước của luồng "Cách chơi".
abstract final class NonogramTutorialScript {
  /// Bàn đã giải:
  /// ```
  /// ■ ■ ■ ■ ■   5
  /// · ■ ■ ■ ■   4
  /// ■ ■ · ■ ■   2 2
  /// ■ ■ ■ · ■   3 1
  /// · · · ■ ·   1
  /// ```
  static const List<List<int>> solution = [
    [1, 1, 1, 1, 1],
    [0, 1, 1, 1, 1],
    [1, 1, 0, 1, 1],
    [1, 1, 1, 0, 1],
    [0, 0, 0, 1, 0],
  ];

  static TutorialCell _cell(int row, int col) => (row: row, col: col);

  static Set<TutorialCell> _row(int row, List<int> cols) {
    return {for (final c in cols) _cell(row, c)};
  }

  static final List<TutorialStep> steps = [
    const TutorialStep(
      task: TutorialTask.intro,
      message: TutorialMessage.welcome,
      visibleRows: 1,
    ),
    const TutorialStep(
      task: TutorialTask.switchMode,
      message: TutorialMessage.switchToFill,
      visibleRows: 1,
      mode: NonogramInteractionMode.fill,
    ),
    TutorialStep(
      task: TutorialTask.fill,
      message: TutorialMessage.clueIsCount,
      visibleRows: 1,
      targets: _row(0, [0, 1, 2, 3, 4]),
    ),
    // Ô cuối đã tô sẵn: khối 4 phải chạm nó nên chỉ có một cách đặt.
    TutorialStep(
      task: TutorialTask.fill,
      message: TutorialMessage.edgeCell,
      visibleRows: 2,
      prefilled: {_cell(1, 4)},
      targets: _row(1, [1, 2, 3]),
      highlight: _row(1, [1, 2, 3, 4]),
    ),
    TutorialStep(
      task: TutorialTask.fill,
      message: TutorialMessage.multipleClues,
      visibleRows: 3,
      targets: _row(2, [0, 1, 3, 4]),
    ),
    TutorialStep(
      task: TutorialTask.fill,
      message: TutorialMessage.clueOrder,
      visibleRows: 4,
      targets: _row(3, [0, 1, 2, 4]),
    ),
    const TutorialStep(
      task: TutorialTask.switchMode,
      message: TutorialMessage.columns,
      visibleRows: 5,
      showColumnClues: true,
      mode: NonogramInteractionMode.mark,
    ),
    // Cột 1, 2, 3, 5 đã đủ ô: các ô còn trống của chúng chắc chắn bỏ trống.
    TutorialStep(
      task: TutorialTask.mark,
      message: TutorialMessage.markEmpty,
      visibleRows: 5,
      showColumnClues: true,
      targets: {
        _cell(1, 0),
        _cell(4, 0),
        _cell(4, 1),
        _cell(2, 2),
        _cell(4, 2),
        _cell(4, 4),
      },
    ),
    TutorialStep(
      task: TutorialTask.switchMode,
      message: TutorialMessage.oneCellLeft,
      visibleRows: 5,
      showColumnClues: true,
      mode: NonogramInteractionMode.fill,
      highlight: {_cell(4, 3)},
    ),
    TutorialStep(
      task: TutorialTask.fill,
      message: TutorialMessage.finish,
      visibleRows: 5,
      showColumnClues: true,
      targets: {_cell(4, 3)},
    ),
    const TutorialStep(
      task: TutorialTask.done,
      message: TutorialMessage.done,
      visibleRows: 5,
      showColumnClues: true,
    ),
  ];
}

/// Trạng thái bài hướng dẫn. Chỉ nhận đúng thao tác của bước hiện tại, sai
/// thì tăng [mistakes] để giao diện rung lời dẫn.
class NonogramTutorialController extends ChangeNotifier {
  NonogramTutorialController({
    List<List<int>> solution = NonogramTutorialScript.solution,
    List<TutorialStep>? steps,
  }) : solution = [for (final row in solution) List<int>.of(row)],
       steps = steps ?? NonogramTutorialScript.steps,
       rowClues = _rowClues(solution),
       colClues = _colClues(solution),
       _grid = _emptyGrid(solution) {
    _enterStep(0);
  }

  static List<List<int>> _rowClues(List<List<int>> solution) {
    return [for (final row in solution) NonogramPuzzle.deriveClues(row)];
  }

  static List<List<int>> _colClues(List<List<int>> solution) {
    return [
      for (var c = 0; c < solution.first.length; c++)
        NonogramPuzzle.deriveClues([for (final row in solution) row[c]]),
    ];
  }

  static List<List<NonogramCellState>> _emptyGrid(List<List<int>> solution) {
    return [
      for (final row in solution)
        List.filled(row.length, NonogramCellState.empty),
    ];
  }

  final List<List<int>> solution;
  final List<TutorialStep> steps;
  final List<List<int>> rowClues;
  final List<List<int>> colClues;

  List<List<NonogramCellState>> _grid;
  int _stepIndex = 0;
  int _mistakes = 0;

  /// Mở đầu ở chế độ X để bước đầu tiên dạy cách chuyển sang chế độ tô.
  NonogramInteractionMode _mode = NonogramInteractionMode.mark;

  int get rows => solution.length;
  int get cols => solution.first.length;
  int get stepIndex => _stepIndex;
  TutorialStep get step => steps[_stepIndex];
  NonogramInteractionMode get mode => _mode;
  int get mistakes => _mistakes;
  bool get isFinished => step.task == TutorialTask.done;

  /// Bản sao mới mỗi lần đổi, để painter so sánh bằng `!=`.
  List<List<NonogramCellState>> get grid => _grid;

  NonogramCellState cellAt(int row, int col) => _grid[row][col];

  /// Ô mục tiêu chưa làm, theo thứ tự đọc (trên xuống, trái sang).
  List<TutorialCell> get pendingTargets {
    final desired = _desiredState;
    if (desired == null) return const [];
    final pending = [
      for (final cell in step.targets)
        if (_grid[cell.row][cell.col] != desired) cell,
    ];
    pending.sort((a, b) => a.row != b.row ? a.row - b.row : a.col - b.col);
    return pending;
  }

  bool isRowComplete(int row) {
    return _lineComplete([for (var c = 0; c < cols; c++) (row: row, col: c)]);
  }

  bool isColComplete(int col) {
    return _lineComplete([for (var r = 0; r < rows; r++) (row: r, col: col)]);
  }

  bool _lineComplete(List<TutorialCell> cells) {
    for (final cell in cells) {
      final filled = _grid[cell.row][cell.col] == NonogramCellState.filled;
      if (filled != (solution[cell.row][cell.col] == 1)) return false;
    }
    return true;
  }

  NonogramCellState? get _desiredState {
    switch (step.task) {
      case TutorialTask.fill:
        return NonogramCellState.filled;
      case TutorialTask.mark:
        return NonogramCellState.marked;
      default:
        return null;
    }
  }

  /// Bấm "Bắt đầu" ở thẻ chào mừng.
  void start() {
    if (step.task != TutorialTask.intro) return;
    _advance();
  }

  /// Chạm vào nút Tô / X. Chỉ đổi được ở bước yêu cầu chuyển chế độ.
  void selectMode(NonogramInteractionMode mode) {
    if (step.task != TutorialTask.switchMode || mode != step.mode) {
      _miss();
      return;
    }
    _mode = mode;
    _advance();
  }

  /// Chạm / kéo qua một ô. Trả về `true` nếu ô được đổi.
  ///
  /// Khi kéo, [countMiss] = false để lướt qua ô không liên quan không bị tính
  /// là sai.
  bool tapCell(int row, int col, {bool countMiss = true}) {
    final desired = _desiredState;
    final cell = (row: row, col: col);
    if (desired == null ||
        row >= step.visibleRows ||
        !step.targets.contains(cell)) {
      if (countMiss) _miss();
      return false;
    }
    if (_grid[row][col] == desired) return false;

    _grid = [for (final r in _grid) List.of(r)];
    _grid[row][col] = desired;
    if (pendingTargets.isEmpty) {
      _advance();
    } else {
      notifyListeners();
    }
    return true;
  }

  void _miss() {
    _mistakes++;
    notifyListeners();
  }

  void _advance() {
    if (_stepIndex < steps.length - 1) _enterStep(_stepIndex + 1);
    notifyListeners();
  }

  void _enterStep(int index) {
    _stepIndex = index;
    final prefilled = steps[index].prefilled;
    if (prefilled.isEmpty) return;
    _grid = [for (final r in _grid) List.of(r)];
    for (final cell in prefilled) {
      _grid[cell.row][cell.col] = NonogramCellState.filled;
    }
  }
}

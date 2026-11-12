/// Một màn nonogram đọc từ assets.
///
/// Chỉ `solution` là dữ liệu gốc; `topClues`/`leftClues` luôn được tính lại
/// từ solution nên không bao giờ lệch nhau.
class NonogramPuzzle {
  /// ID ổn định của màn (lưu vào snapshot/tiến độ), ví dụ `"L0001"`.
  final String id;
  final String title;
  final String author;
  final String difficulty;
  final double difficultyScore;
  final int level;
  final int rows;
  final int cols;

  /// `solution[row][col]` = 1 nếu ô được tô, 0 nếu để trống.
  final List<List<int>> solution;
  final List<List<int>> topClues;
  final List<List<int>> leftClues;

  /// Ô ghim sẵn: hiện đúng theo đáp án ngay từ đầu màn và không đổi được.
  /// Dùng cho màn có nhiều cách tô khớp gợi ý, để chỉ còn một nghiệm duy nhất
  /// mà không phải sửa hình (xem `docs/level_format.md`).
  final Set<({int row, int col})> pinnedCells;

  NonogramPuzzle({
    required this.id,
    required this.title,
    required this.author,
    required this.difficulty,
    required this.difficultyScore,
    required this.level,
    required this.solution,
    this.pinnedCells = const {},
  }) : rows = solution.length,
       cols = solution.isEmpty ? 0 : solution.first.length,
       leftClues = [for (final row in solution) deriveClues(row)],
       topClues = [
         for (
           var c = 0;
           c < (solution.isEmpty ? 0 : solution.first.length);
           c++
         )
           deriveClues([for (final row in solution) row[c]]),
       ];

  /// Giá trị đáp án của các ô ghim (1 = tô, 0 = trống), cho bộ giải.
  Map<({int row, int col}), int> get pinnedValues => {
    for (final cell in pinnedCells) cell: solution[cell.row][cell.col],
  };

  /// Các đoạn liên tiếp ô được tô trong một hàng/cột. Hàng trống → `[]`.
  static List<int> deriveClues(List<int> line) {
    final clues = <int>[];
    var run = 0;
    for (final cell in line) {
      if (cell > 0) {
        run++;
      } else if (run > 0) {
        clues.add(run);
        run = 0;
      }
    }
    if (run > 0) clues.add(run);
    return clues;
  }

  /// Đọc một màn từ JSON trong file gói (xem `docs/level_format.md`).
  ///
  /// Ném [FormatException] nếu dữ liệu sai, để test kiểm tra assets bắt được.
  factory NonogramPuzzle.fromAssetJson(Map<String, dynamic> json) {
    final level = json['level'];
    final id = json['id'];
    final rawSolution = json['solution'];
    if (level is! int || level <= 0) {
      throw FormatException('Invalid level: $level');
    }
    if (id is! String || id.isEmpty) {
      throw FormatException('Level $level: missing id');
    }
    if (rawSolution is! List || rawSolution.isEmpty) {
      throw FormatException('Level $level: missing solution');
    }

    final solution = <List<int>>[];
    for (final row in rawSolution) {
      if (row is! String || row.isEmpty || !RegExp(r'^[01]+$').hasMatch(row)) {
        throw FormatException('Level $level: invalid solution row "$row"');
      }
      solution.add([for (final ch in row.codeUnits) ch == 0x31 ? 1 : 0]);
    }

    final cols = solution.first.length;
    if (solution.any((row) => row.length != cols)) {
      throw FormatException('Level $level: solution rows differ in length');
    }
    if (!solution.any((row) => row.contains(1))) {
      throw FormatException('Level $level: solution is empty');
    }

    final rows = json['rows'];
    if (rows != null && rows != solution.length) {
      throw FormatException(
        'Level $level: rows=$rows but solution has '
        '${solution.length}',
      );
    }
    final declaredCols = json['cols'];
    if (declaredCols != null && declaredCols != cols) {
      throw FormatException(
        'Level $level: cols=$declaredCols but solution '
        'has $cols',
      );
    }

    final pinnedCells = <({int row, int col})>{};
    final rawPinned = json['pinned'];
    if (rawPinned != null) {
      if (rawPinned is! List) {
        throw FormatException('Level $level: pinned must be a list');
      }
      for (final cell in rawPinned) {
        if (cell is! List ||
            cell.length != 2 ||
            cell[0] is! int ||
            cell[1] is! int) {
          throw FormatException('Level $level: invalid pinned cell $cell');
        }
        final r = cell[0] as int;
        final c = cell[1] as int;
        if (r < 0 || r >= solution.length || c < 0 || c >= cols) {
          throw FormatException('Level $level: pinned cell $cell is outside');
        }
        if (!pinnedCells.add((row: r, col: c))) {
          throw FormatException('Level $level: duplicate pinned cell $cell');
        }
      }
    }

    return NonogramPuzzle(
      id: id,
      level: level,
      title:
          (json['title'] as String?)?.trim().isNotEmpty == true
              ? (json['title'] as String).trim()
              : 'Level $level',
      author: (json['author'] as String?) ?? '',
      difficulty: (json['difficulty'] as String?) ?? '',
      difficultyScore: (json['difficultyScore'] as num?)?.toDouble() ?? 0,
      solution: solution,
      pinnedCells: pinnedCells,
    );
  }
}

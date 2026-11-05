/// Bộ giải nonogram thuần Dart (không phụ thuộc Flutter).
///
/// Dùng để kiểm tra dữ liệu màn chơi: mỗi màn phải có **đúng một** nghiệm,
/// nếu không người chơi có thể tô ra hình khác đáp án mà vẫn khớp mọi gợi ý.
///
/// Cách làm: suy luận từng hàng/cột (tìm các ô chắc chắn tô / chắc chắn trống
/// trong mọi cách xếp hợp lệ), lặp tới khi không suy được thêm; nếu vẫn còn ô
/// chưa biết thì thử đoán và quay lui, dừng khi đã thấy 2 nghiệm.
final class NonogramSolver {
  const NonogramSolver();

  static const int _unknown = -1;
  static const int _empty = 0;
  static const int _filled = 1;

  /// Đếm số nghiệm, tối đa [limit] (mặc định 2 là đủ để biết có duy nhất không).
  int countSolutions({
    required List<List<int>> rowClues,
    required List<List<int>> colClues,
    int limit = 2,
  }) {
    final rows = rowClues.length;
    final cols = colClues.length;
    final grid = List.generate(rows, (_) => List.filled(cols, _unknown));
    return _search(grid, rowClues, colClues, limit);
  }

  bool hasUniqueSolution({
    required List<List<int>> rowClues,
    required List<List<int>> colClues,
  }) {
    return countSolutions(rowClues: rowClues, colClues: colClues) == 1;
  }

  int _search(
    List<List<int>> grid,
    List<List<int>> rowClues,
    List<List<int>> colClues,
    int limit,
  ) {
    if (!_propagate(grid, rowClues, colClues)) return 0;

    // Chọn ô chưa biết đầu tiên để đoán.
    for (var r = 0; r < grid.length; r++) {
      for (var c = 0; c < grid[r].length; c++) {
        if (grid[r][c] != _unknown) continue;

        var found = 0;
        for (final guess in const [_filled, _empty]) {
          final copy = [for (final row in grid) List<int>.of(row)];
          copy[r][c] = guess;
          found += _search(copy, rowClues, colClues, limit - found);
          if (found >= limit) return found;
        }
        return found;
      }
    }
    return 1; // Không còn ô chưa biết: đây là một nghiệm.
  }

  /// Suy luận tới điểm dừng. Trả về false nếu gặp mâu thuẫn.
  bool _propagate(
    List<List<int>> grid,
    List<List<int>> rowClues,
    List<List<int>> colClues,
  ) {
    final rows = grid.length;
    final cols = rows == 0 ? 0 : grid.first.length;
    var dirtyRows = List.filled(rows, true);
    var dirtyCols = List.filled(cols, true);

    var changed = true;
    while (changed) {
      changed = false;

      for (var r = 0; r < rows; r++) {
        if (!dirtyRows[r]) continue;
        dirtyRows[r] = false;
        final solved = solveLine(grid[r], rowClues[r]);
        if (solved == null) return false;
        for (var c = 0; c < cols; c++) {
          if (solved[c] != grid[r][c]) {
            grid[r][c] = solved[c];
            dirtyCols[c] = true;
            changed = true;
          }
        }
      }

      for (var c = 0; c < cols; c++) {
        if (!dirtyCols[c]) continue;
        dirtyCols[c] = false;
        final line = [for (var r = 0; r < rows; r++) grid[r][c]];
        final solved = solveLine(line, colClues[c]);
        if (solved == null) return false;
        for (var r = 0; r < rows; r++) {
          if (solved[r] != grid[r][c]) {
            grid[r][c] = solved[r];
            dirtyRows[r] = true;
            changed = true;
          }
        }
      }
    }
    return true;
  }

  /// Suy luận một hàng: trả về hàng với các ô suy ra được (-1 = chưa biết,
  /// 0 = trống, 1 = tô), hoặc `null` nếu không có cách xếp nào hợp lệ.
  ///
  /// Mô hình: thêm một ô trống ảo ở đầu hàng; mỗi khối gợi ý là
  /// "1 ô trống + c ô tô", giữa các khối có thể chen thêm ô trống tự do.
  /// `fwd[i][j]`: i ô đầu khớp với j khối đầu; `bwd[i][j]`: phần từ ô i trở
  /// đi khớp với các khối từ j.
  List<int>? solveLine(List<int> line, List<int> clues) {
    final n = line.length + 1;
    final cells = [_empty, ...line];
    final k = clues.length;

    bool canEmpty(int i) => cells[i] != _filled;

    // filledPrefix[i]: số ô "không thể tô" trong cells[0..i) — để kiểm tra
    // nhanh một đoạn có tô được hết không.
    final blockedPrefix = List.filled(n + 1, 0);
    for (var i = 0; i < n; i++) {
      blockedPrefix[i + 1] = blockedPrefix[i] + (cells[i] == _empty ? 1 : 0);
    }
    bool canFill(int from, int length) {
      final to = from + length;
      if (to > n) return false;
      return blockedPrefix[to] - blockedPrefix[from] == 0;
    }

    final fwd = List.generate(n + 1, (_) => List.filled(k + 1, false));
    fwd[0][0] = true;
    for (var i = 0; i < n; i++) {
      for (var j = 0; j <= k; j++) {
        if (!fwd[i][j] || !canEmpty(i)) continue;
        fwd[i + 1][j] = true;
        if (j < k && canFill(i + 1, clues[j])) {
          fwd[i + 1 + clues[j]][j + 1] = true;
        }
      }
    }
    if (!fwd[n][k]) return null;

    final bwd = List.generate(n + 2, (_) => List.filled(k + 1, false));
    bwd[n][k] = true;
    for (var i = n - 1; i >= 0; i--) {
      for (var j = k; j >= 0; j--) {
        if (!canEmpty(i)) continue;
        var ok = bwd[i + 1][j];
        if (!ok && j < k) {
          final end = i + 1 + clues[j];
          ok = end <= n && canFill(i + 1, clues[j]) && bwd[end][j + 1];
        }
        bwd[i][j] = ok;
      }
    }

    final mayBeEmpty = List.filled(n, false);
    final fillDiff = List.filled(n + 1, 0);
    for (var i = 0; i < n; i++) {
      if (!canEmpty(i)) continue;
      for (var j = 0; j <= k; j++) {
        if (!fwd[i][j]) continue;
        // Ô i là ô trống tự do.
        if (bwd[i + 1][j]) mayBeEmpty[i] = true;
        // Ô i là ô trống mở đầu khối j, khối chiếm (i, i + c].
        if (j < k) {
          final end = i + 1 + clues[j];
          if (end <= n && canFill(i + 1, clues[j]) && bwd[end][j + 1]) {
            mayBeEmpty[i] = true;
            fillDiff[i + 1]++;
            fillDiff[end]--;
          }
        }
      }
    }

    final result = List<int>.filled(line.length, _unknown);
    var running = 0;
    for (var i = 0; i < n; i++) {
      running += fillDiff[i];
      if (i == 0) continue;
      final mayBeFilled = running > 0;
      if (mayBeFilled && !mayBeEmpty[i]) {
        result[i - 1] = _filled;
      } else if (!mayBeFilled && mayBeEmpty[i]) {
        result[i - 1] = _empty;
      } else if (!mayBeFilled && !mayBeEmpty[i]) {
        return null;
      }
    }
    return result;
  }
}

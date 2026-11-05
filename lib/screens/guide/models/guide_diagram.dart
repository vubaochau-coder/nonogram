/// Một hình minh hoạ kỹ thuật giải: các nhóm hàng xếp dọc, nối với nhau bằng
/// mũi tên (có thể kèm ngoặc chỉ vùng ô được suy ra).
class GuideDiagram {
  GuideDiagram({required this.groups, List<List<GuideDiagramLink>>? links})
    : links = links ?? List.generate(groups.length - 1, (_) => const []),
      assert(groups.isNotEmpty);

  /// Mỗi nhóm là các hàng dính liền nhau (ví dụ hai phương án thử).
  final List<List<GuideDiagramRow>> groups;

  /// `links[i]` nối nhóm `i` với nhóm `i + 1`. Danh sách rỗng = chỉ một mũi
  /// tên ở giữa.
  final List<List<GuideDiagramLink>> links;

  int get clueColumns => groups
      .expand((g) => g)
      .map((r) => r.clues.length)
      .fold(1, (a, b) => a > b ? a : b);

  int get cellColumns => groups
      .expand((g) => g)
      .map((r) => r.cells.length)
      .fold(1, (a, b) => a > b ? a : b);
}

enum GuideCell {
  empty,

  /// Ô đã tô (đã biết chắc).
  filled,

  /// Ô đã đánh dấu X (đã biết chắc).
  cross,

  /// Ô tô giả định khi thử đặt khối.
  trialFill,

  /// Ô trống giả định (bắt buộc giữa/bên cạnh khối) khi thử đặt khối.
  trialCross,
}

class GuideDiagramRow {
  const GuideDiagramRow({
    required this.clues,
    required this.cells,
    this.crossedClues = const {},
  });

  /// Viết gọn: `clues` là chuỗi số cách nhau bởi dấu cách, số có tiền tố `~`
  /// là số đã dùng xong (gạch chéo). `cells`: `.` trống, `#` tô, `X` dấu X,
  /// `o` tô giả định, `x` X giả định.
  factory GuideDiagramRow.parse(String clues, String cells) {
    final parts = clues.trim().split(RegExp(r'\s+'));
    final crossed = <int>{};
    final values = <int>[];
    for (var i = 0; i < parts.length; i++) {
      var p = parts[i];
      if (p.startsWith('~')) {
        crossed.add(i);
        p = p.substring(1);
      }
      values.add(int.parse(p));
    }
    return GuideDiagramRow(
      clues: values,
      crossedClues: crossed,
      cells: [
        for (final ch in cells.split(''))
          switch (ch) {
            '#' => GuideCell.filled,
            'X' => GuideCell.cross,
            'o' => GuideCell.trialFill,
            'x' => GuideCell.trialCross,
            _ => GuideCell.empty,
          },
      ],
    );
  }

  final List<int> clues;
  final Set<int> crossedClues;
  final List<GuideCell> cells;
}

/// Ngoặc dưới nhóm trên (`fromStart..fromEnd`) → mũi tên → ngoặc trên nhóm
/// dưới (`toStart..toEnd`). Chỉ số cột tính trong lưới ô, gồm cả hai đầu.
class GuideDiagramLink {
  const GuideDiagramLink(this.fromStart, this.fromEnd, [int? toStart, int? toEnd])
    : toStart = toStart ?? fromStart,
      toEnd = toEnd ?? fromEnd;

  final int fromStart;
  final int fromEnd;
  final int toStart;
  final int toEnd;
}

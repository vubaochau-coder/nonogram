import 'guide_diagram.dart';

/// Các hình minh hoạ trên màn hướng dẫn, vẽ lại từ bộ ảnh cũ
/// (`assets/guide/solution_methods_p*.png`) với đúng nội dung từng ô.
///
/// Ký hiệu ô: `.` trống, `#` tô, `X` dấu X, `o` tô giả định, `x` X giả định.
/// Số chỉ dẫn có tiền tố `~` là số đã dùng xong.
abstract final class GuideDiagrams {
  static GuideDiagramRow _r(String clues, String cells) =>
      GuideDiagramRow.parse(clues, cells);

  /// Chồng lấp, một số: `5` trong hàng 10 ô có X ở hai đầu.
  static final superpositionSimple = [
    GuideDiagram(
      groups: [
        [_r('5', 'XX.......X')],
        [_r('5', 'XXooooo..X'), _r('5', 'XX..oooooX')],
        [_r('5', 'XX..###..X')],
      ],
      links: [
        [],
        [GuideDiagramLink(4, 6)],
      ],
    ),
  ];

  /// Chồng lấp, một số: `7` trong hàng 10 ô.
  static final superpositionSingleLong = [
    GuideDiagram(
      groups: [
        [_r('7', '..........')],
        [_r('7', 'ooooooo...'), _r('7', '...ooooooo')],
        [_r('7', '...####...')],
      ],
      links: [
        [],
        [GuideDiagramLink(3, 6)],
      ],
    ),
  ];

  /// Chồng lấp, nhiều số: `3 4` và `3 2 1`.
  static final superpositionMulti = [
    GuideDiagram(
      groups: [
        [_r('3 4', '..........')],
        [_r('3 4', 'ooo.oooo..'), _r('3 4', '..ooo.oooo')],
        [_r('3 4', '..#...##..')],
      ],
      links: [
        [],
        [GuideDiagramLink(2, 2), GuideDiagramLink(6, 7)],
      ],
    ),
    GuideDiagram(
      groups: [
        [_r('3 2 1', '..........')],
        [_r('3 2 1', 'ooo.oo.o..'), _r('3 2 1', '..ooo.oo.o')],
        [_r('3 2 1', '..#.......')],
      ],
      links: [
        [],
        [GuideDiagramLink(2, 2)],
      ],
    ),
  ];

  /// Đẩy từ biên.
  static final wallPushing = [
    GuideDiagram(
      groups: [
        [_r('5', '...#......')],
        [_r('5', 'ooo#o.....')],
        [_r('5', '...##.....')],
      ],
      links: [
        [],
        [GuideDiagramLink(4, 4)],
      ],
    ),
    GuideDiagram(
      groups: [
        [_r('1 4', '........#.')],
        [_r('1 4', '......oo#o')],
        [_r('1 4', '......###.')],
      ],
      links: [
        [],
        [GuideDiagramLink(6, 8)],
      ],
    ),
    GuideDiagram(
      groups: [
        [_r('~1 3 1', '#X.#......')],
        [_r('~1 3 1', '#Xo#o.....')],
        [_r('~1 3 1', '#X.##.....')],
      ],
      links: [
        [],
        [GuideDiagramLink(4, 4)],
      ],
    ),
  ];

  /// Không thể tiếp cận.
  static final inaccessibility = [
    GuideDiagram(
      groups: [
        [_r('4', '.....#....')],
        [_r('4', '..ooo#....'), _r('4', '.....#ooo.')],
        [_r('4', 'XX...#...X')],
      ],
      links: [
        [],
        [GuideDiagramLink(0, 1), GuideDiagramLink(9, 9)],
      ],
    ),
    GuideDiagram(
      groups: [
        [_r('3 1', '.....##...')],
        [_r('3 1', '....o##.o.'), _r('3 1', '.....##o.o')],
        [_r('3 1', 'XXXX.##...')],
      ],
      links: [
        [],
        [GuideDiagramLink(0, 3)],
      ],
    ),
    GuideDiagram(
      groups: [
        [_r('2 3', '..#....#..')],
        [_r('2 3', '.o#..oo#..'), _r('2 3', '..#o...#oo')],
        [_r('2 3', 'X.#.X..#..')],
      ],
      links: [
        [],
        [GuideDiagramLink(0, 0), GuideDiagramLink(4, 4)],
      ],
    ),
  ];

  /// Không vừa khoảng trống.
  static final notFit = [
    GuideDiagram(
      groups: [
        [_r('3', '...X..X...')],
        [_r('3', '...XXXX...')],
      ],
      links: [
        [GuideDiagramLink(4, 5)],
      ],
    ),
    GuideDiagram(
      groups: [
        [_r('2 2', '.X........')],
        [_r('2 2', 'XX........')],
      ],
      links: [
        [GuideDiagramLink(0, 0)],
      ],
    ),
    GuideDiagram(
      groups: [
        [_r('1 4', '.......X..')],
        [_r('1 4', '.......XXX')],
      ],
      links: [
        [GuideDiagramLink(8, 9)],
      ],
    ),
  ];

  /// Sự chia cắt.
  static final division = [
    GuideDiagram(
      groups: [
        [_r('1 2 2', '....#.#........')],
        [_r('1 2 2', '....#X#........')],
      ],
      links: [
        [GuideDiagramLink(4, 6, 5, 5)],
      ],
    ),
    GuideDiagram(
      groups: [
        [_r('1 1 3 1', '....#.##.......')],
        [_r('1 ~1 ~3 1', '...X#X###X.....')],
      ],
      links: [
        [GuideDiagramLink(4, 7, 3, 9)],
      ],
    ),
  ];

  /// Định vị kép.
  static final doublePositioning = [
    GuideDiagram(
      groups: [
        [_r('4 3', '.......###....X')],
        [
          _r('4 3', '......x###xxxxX'),
          _r('4 3', '.....xo###xoooX'),
        ],
        [_r('4 3', '.......###X...X')],
      ],
      links: [
        [],
        [GuideDiagramLink(10, 10)],
      ],
    ),
    GuideDiagram(
      groups: [
        [_r('1 1 2', '....#.X........')],
        [
          _r('1 1 2', 'oxox#oX........'),
          _r('1 1 2', '...x#xX........'),
        ],
        [_r('1 1 2', '...X#.X........')],
      ],
      links: [
        [],
        [GuideDiagramLink(3, 3)],
      ],
    ),
  ];
}

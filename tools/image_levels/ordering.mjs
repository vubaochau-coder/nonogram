// Đo độ khó và xếp thứ tự màn chơi.
//
// Độ khó của một màn giải được bằng suy luận hàng/cột phụ thuộc vào:
// - kích thước: nhiều ô thì lâu hơn;
// - điểm bắt đầu: tỉ lệ ô suy ra được ngay từ lưới trống, chỉ nhìn từng
//   hàng/cột riêng lẻ (chồng khối). Ít điểm bắt đầu thì khó vào màn;
// - độ sâu: số vòng quét cả lưới cần để suy ra hết. Nhiều vòng nghĩa là phải
//   dùng kết quả hàng này để suy tiếp cột kia nhiều lần.

import { deriveClues, solveLine } from './solver.mjs';

const clamp01 = (x) => Math.max(0, Math.min(1, x));

/** Các chỉ số độ khó của một lời giải (mảng hàng 0/1). */
export function difficultyMetrics(solution) {
  const rows = solution.length;
  const cols = solution[0].length;
  const { rowClues, colClues } = deriveClues(solution);
  const blankRow = new Array(cols).fill(-1);
  const blankCol = new Array(rows).fill(-1);

  // Điểm bắt đầu: ô suy ra được từ lưới trống bằng một hàng hoặc một cột.
  const start = solution.map(() => new Array(cols).fill(false));
  rowClues.forEach((clues, r) => solveLine(blankRow, clues).forEach((v, c) => v !== -1 && (start[r][c] = true)));
  colClues.forEach((clues, c) => solveLine(blankCol, clues).forEach((v, r) => v !== -1 && (start[r][c] = true)));
  const startRatio = start.flat().filter(Boolean).length / (rows * cols);

  // Độ sâu: số vòng quét (mỗi vòng giải lại mọi hàng rồi mọi cột) tới khi xong.
  const grid = solution.map((row) => row.map(() => -1));
  let rounds = 0;
  for (let changed = true; changed; ) {
    changed = false;
    for (let r = 0; r < rows; r++) {
      const s = solveLine(grid[r], rowClues[r]);
      for (let c = 0; c < cols; c++) if (s[c] !== grid[r][c]) ((grid[r][c] = s[c]), (changed = true));
    }
    for (let c = 0; c < cols; c++) {
      const s = solveLine(grid.map((row) => row[c]), colClues[c]);
      for (let r = 0; r < rows; r++) if (s[r] !== grid[r][c]) ((grid[r][c] = s[r]), (changed = true));
    }
    if (changed) rounds++;
  }

  const cells = rows * cols;
  const score =
    0.45 * clamp01((cells - 40) / (530 - 40)) + 0.35 * clamp01(1 - startRatio) + 0.2 * clamp01((rounds - 1) / 6);
  return { cells, startRatio, rounds, score };
}

/** Chủ đề của màn (để không xếp hai màn cùng chủ đề gần nhau). */
const subjectOf = (title) => title.trim().toLowerCase();

/**
 * Xếp màn từ dễ tới khó theo `score`, nhưng không để hai màn cùng chủ đề
 * (vd. "Skull" của hai bộ hình) cách nhau dưới [minGap] màn: tại mỗi vị trí
 * chọn màn dễ nhất trong [window] màn dễ nhất còn lại mà chưa trùng chủ đề.
 */
export function orderLevels(items, { window = 4, minGap = 12 } = {}) {
  const remaining = [...items].sort((a, b) => a.score - b.score || a.cells - b.cells);
  const ordered = [];
  while (remaining.length) {
    const recent = new Set(ordered.slice(-minGap).map((it) => subjectOf(it.title)));
    let index = remaining.slice(0, window).findIndex((it) => !recent.has(subjectOf(it.title)));
    if (index === -1) index = 0;
    ordered.push(remaining.splice(index, 1)[0]);
  }
  return ordered;
}

/**
 * Nhãn độ khó 1–10 theo thứ hạng điểm trong cả bộ màn: mỗi mức chiếm khoảng
 * một phần mười số màn, nên nhãn trải đều thay vì dồn vào giữa.
 */
export function difficultyLabels(items) {
  const n = items.length;
  const rank = new Map([...items].sort((a, b) => a.score - b.score).map((it, i) => [it, i]));
  return items.map((it) => 1 + Math.min(9, Math.floor((10 * rank.get(it)) / n)));
}

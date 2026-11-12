// Bộ giải nonogram dùng cho công cụ sinh màn — chuyển từ
// lib/screens/play/engine/nonogram_solver.dart (giữ cùng thuật toán suy luận
// hàng/cột), thêm phần đo độ khó.
//
// -1 = chưa biết, 0 = trống, 1 = tô.

export function cluesOf(line) {
  const clues = [];
  let run = 0;
  for (const v of line) {
    if (v === 1) run++;
    else if (run > 0) {
      clues.push(run);
      run = 0;
    }
  }
  if (run > 0) clues.push(run);
  return clues;
}

export function deriveClues(grid) {
  const rows = grid.length;
  const cols = grid[0].length;
  const rowClues = grid.map(cluesOf);
  const colClues = [];
  for (let c = 0; c < cols; c++) {
    colClues.push(cluesOf(Array.from({ length: rows }, (_, r) => grid[r][c])));
  }
  return { rowClues, colClues };
}

/** Suy luận một hàng; trả về hàng mới hoặc null nếu mâu thuẫn. */
export function solveLine(line, clues) {
  const n = line.length + 1;
  const cells = [0, ...line];
  const k = clues.length;
  const canEmpty = (i) => cells[i] !== 1;

  const blocked = new Int32Array(n + 1);
  for (let i = 0; i < n; i++) blocked[i + 1] = blocked[i] + (cells[i] === 0 ? 1 : 0);
  const canFill = (from, len) => {
    const to = from + len;
    return to <= n && blocked[to] - blocked[from] === 0;
  };

  const fwd = Array.from({ length: n + 1 }, () => new Uint8Array(k + 1));
  fwd[0][0] = 1;
  for (let i = 0; i < n; i++) {
    if (!canEmpty(i)) continue;
    for (let j = 0; j <= k; j++) {
      if (!fwd[i][j]) continue;
      fwd[i + 1][j] = 1;
      if (j < k && canFill(i + 1, clues[j])) fwd[i + 1 + clues[j]][j + 1] = 1;
    }
  }
  if (!fwd[n][k]) return null;

  const bwd = Array.from({ length: n + 2 }, () => new Uint8Array(k + 1));
  bwd[n][k] = 1;
  for (let i = n - 1; i >= 0; i--) {
    if (!canEmpty(i)) continue;
    for (let j = k; j >= 0; j--) {
      let ok = bwd[i + 1][j];
      if (!ok && j < k) {
        const end = i + 1 + clues[j];
        ok = end <= n && canFill(i + 1, clues[j]) && bwd[end][j + 1];
      }
      bwd[i][j] = ok ? 1 : 0;
    }
  }

  const mayBeEmpty = new Uint8Array(n);
  const fillDiff = new Int32Array(n + 1);
  for (let i = 0; i < n; i++) {
    if (!canEmpty(i)) continue;
    for (let j = 0; j <= k; j++) {
      if (!fwd[i][j]) continue;
      if (bwd[i + 1][j]) mayBeEmpty[i] = 1;
      if (j < k) {
        const end = i + 1 + clues[j];
        if (end <= n && canFill(i + 1, clues[j]) && bwd[end][j + 1]) {
          mayBeEmpty[i] = 1;
          fillDiff[i + 1]++;
          fillDiff[end]--;
        }
      }
    }
  }

  const result = new Array(line.length).fill(-1);
  let running = 0;
  for (let i = 0; i < n; i++) {
    running += fillDiff[i];
    if (i === 0) continue;
    const mayBeFilled = running > 0;
    if (mayBeFilled && !mayBeEmpty[i]) result[i - 1] = 1;
    else if (!mayBeFilled && mayBeEmpty[i]) result[i - 1] = 0;
    else if (!mayBeFilled && !mayBeEmpty[i]) return null;
  }
  return result;
}

/**
 * Suy luận hàng/cột tới điểm dừng. Trả về {ok, rounds, lineSolves}:
 * `rounds` = số vòng quét cả lưới, `lineSolves` = số lần giải một hàng/cột
 * có suy ra được ô mới — dùng làm thước đo độ khó.
 */
export function propagate(grid, rowClues, colClues) {
  const rows = grid.length;
  const cols = grid[0].length;
  const dirtyRows = new Array(rows).fill(true);
  const dirtyCols = new Array(cols).fill(true);
  let rounds = 0;
  let lineSolves = 0;
  let changed = true;
  while (changed) {
    changed = false;
    rounds++;
    for (let r = 0; r < rows; r++) {
      if (!dirtyRows[r]) continue;
      dirtyRows[r] = false;
      const solved = solveLine(grid[r], rowClues[r]);
      if (!solved) return { ok: false, rounds, lineSolves };
      let progress = false;
      for (let c = 0; c < cols; c++) {
        if (solved[c] !== grid[r][c]) {
          grid[r][c] = solved[c];
          dirtyCols[c] = true;
          changed = progress = true;
        }
      }
      if (progress) lineSolves++;
    }
    for (let c = 0; c < cols; c++) {
      if (!dirtyCols[c]) continue;
      dirtyCols[c] = false;
      const line = Array.from({ length: rows }, (_, r) => grid[r][c]);
      const solved = solveLine(line, colClues[c]);
      if (!solved) return { ok: false, rounds, lineSolves };
      let progress = false;
      for (let r = 0; r < rows; r++) {
        if (solved[r] !== grid[r][c]) {
          grid[r][c] = solved[r];
          dirtyRows[r] = true;
          changed = progress = true;
        }
      }
      if (progress) lineSolves++;
    }
  }
  return { ok: true, rounds, lineSolves };
}

/**
 * Kiểm tra màn giải được chỉ bằng suy luận hàng/cột (không cần đoán).
 * Điều kiện này mạnh hơn "nghiệm duy nhất" và cho trải nghiệm chơi tốt hơn.
 */
export function analyze(solution, pins = []) {
  const { rowClues, colClues } = deriveClues(solution);
  const grid = solution.map((row) => row.map(() => -1));
  // Ô ghim sẵn ([hàng, cột]) đã biết từ đầu, theo đáp án.
  for (const [r, c] of pins) grid[r][c] = solution[r][c];
  const res = propagate(grid, rowClues, colClues);
  const solved = res.ok && grid.every((row) => row.every((v) => v !== -1));
  return { lineSolvable: solved, rounds: res.rounds, lineSolves: res.lineSolves, partial: grid };
}

const known = (partial) => partial.reduce((n, row) => n + row.filter((v) => v !== -1).length, 0);

/**
 * Sửa màn không giải được bằng suy luận: lặp lại việc lật một ô ở vùng còn
 * mơ hồ (ưu tiên ô sát mép hình để ít ảnh hưởng tới hình) sao cho suy luận đi
 * được xa nhất, tối đa [maxFlips] ô. Trả về {grid, flips} hoặc null.
 */
export function repair(solution, maxFlips) {
  let grid = solution.map((row) => [...row]);
  const flips = [];
  const rows = grid.length;
  const cols = grid[0].length;
  let a = analyze(grid);
  while (!a.lineSolvable) {
    if (flips.length >= maxFlips) return null;
    const base = known(a.partial);
    const at = (r, c) => (r >= 0 && r < rows && c >= 0 && c < cols ? grid[r][c] : 0);
    let best = null;
    for (let r = 0; r < rows; r++) {
      for (let c = 0; c < cols; c++) {
        if (a.partial[r][c] !== -1) continue;
        const v = grid[r][c];
        const n = at(r - 1, c) + at(r + 1, c) + at(r, c - 1) + at(r, c + 1);
        // Chỉ lật ô nằm trên mép hình: ô trống cạnh ô tô, hoặc ô tô cạnh ô trống.
        if (v === 0 ? n === 0 : n === 4) continue;
        grid[r][c] = 1 - v;
        const b = analyze(grid);
        grid[r][c] = v;
        const gain = b.lineSolvable ? Infinity : known(b.partial) - base;
        if (gain > 0 && (!best || gain > best.gain)) best = { r, c, gain };
        if (gain === Infinity) break;
      }
      if (best?.gain === Infinity) break;
    }
    if (!best) return null;
    grid[best.r][best.c] = 1 - grid[best.r][best.c];
    flips.push([best.r, best.c]);
    a = analyze(grid);
  }
  return { grid, flips };
}

/**
 * Tìm ô ghim (theo đáp án) để màn giải được bằng suy luận: mỗi bước ghim ô giúp
 * suy luận đi được xa nhất, tới khi giải xong. Trả về danh sách [hàng, cột]
 * (rỗng nếu không cần ghim), hoặc null nếu cần nhiều hơn [maxPins] ô.
 * [filledOnly]: chỉ ghim ô tô.
 */
export function findPins(solution, { maxPins = Infinity, filledOnly = true } = {}) {
  const rows = solution.length;
  const cols = solution[0].length;
  const pins = [];
  let a = analyze(solution, pins);
  while (!a.lineSolvable) {
    if (pins.length >= maxPins) return null;
    let best = null;
    for (let r = 0; r < rows; r++)
      for (let c = 0; c < cols; c++) {
        if (a.partial[r][c] !== -1 || (filledOnly && !solution[r][c])) continue;
        pins.push([r, c]);
        const b = analyze(solution, pins);
        pins.pop();
        const k = known(b.partial);
        if (!best || k > best.k) best = { r, c, k };
      }
    if (!best) return null;
    pins.push([best.r, best.c]);
    a = analyze(solution, pins);
  }
  return pins;
}

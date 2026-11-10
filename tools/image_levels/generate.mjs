#!/usr/bin/env node
// Sinh màn nonogram từ các bộ icon có giấy phép mở (Iconify trên npm).
//
// Cách dùng (chạy từ thư mục gốc repo):
//   npm install --prefix tools/image_levels     # lần đầu: cài Playwright
//   node tools/image_levels/generate.mjs [--selection=tools/image_levels/selection.json]
//                                         [--out=tools/image_levels/out]
//
// Kết quả trong thư mục --out:
//   levels.json   đầu vào cho tools/build_levels.dart (mảng JSON)
//   sources.json  nguồn + giấy phép của từng màn (để ghi công / chứng minh nguồn gốc)
//   preview.html  trang xem trước: hình gốc cạnh lưới nonogram, để duyệt bằng mắt
//
// Các bộ icon được tải bằng `npm pack` vào tools/image_levels/.cache/ (không commit).

import { execFileSync } from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { createRequire } from 'node:module';

import { analyze, repair } from './solver.mjs';

const here = path.dirname(fileURLToPath(import.meta.url));
const args = Object.fromEntries(
  process.argv
    .slice(2)
    .filter((a) => a.startsWith('--'))
    .map((a) => {
      const [k, ...v] = a.slice(2).split('=');
      return [k, v.join('=') || true];
    }),
);
const selectionPath = args.selection ?? path.join(here, 'selection.json');
const outDir = args.out ?? path.join(here, 'out');
const cacheDir = path.join(here, '.cache');

// Giới hạn chất lượng cho một màn.
const MIN_DENSITY = 0.25;
const MAX_DENSITY = 0.75;
// Tỉ lệ ô tối đa được lật khi sửa màn cho giải được bằng suy luận.
const MAX_FLIP_RATIO = 0.03;

// ---------------------------------------------------------------------------
// Tải bộ icon

function loadIconSet(set) {
  const dir = path.join(cacheDir, set);
  const iconsFile = path.join(dir, 'package', 'icons.json');
  if (!fs.existsSync(iconsFile)) {
    fs.mkdirSync(dir, { recursive: true });
    const tgz = execFileSync('npm', ['pack', `@iconify-json/${set}`, '--silent', '--pack-destination', dir], {
      encoding: 'utf8',
    })
      .trim()
      .split('\n')
      .pop();
    execFileSync('tar', ['xzf', path.join(dir, tgz), '-C', dir]);
  }
  const pkg = JSON.parse(fs.readFileSync(path.join(dir, 'package', 'package.json'), 'utf8'));
  return {
    data: JSON.parse(fs.readFileSync(iconsFile, 'utf8')),
    info: JSON.parse(fs.readFileSync(path.join(dir, 'package', 'info.json'), 'utf8')),
    version: pkg.version,
  };
}

function iconSvg(iconSet, name) {
  let icon = iconSet.icons[name];
  let alias = iconSet.aliases?.[name];
  while (!icon && alias) {
    icon = iconSet.icons[alias.parent];
    alias = iconSet.aliases?.[alias.parent];
  }
  if (!icon) return null;
  const left = icon.left ?? iconSet.left ?? 0;
  const top = icon.top ?? iconSet.top ?? 0;
  const w = icon.width ?? iconSet.width ?? 16;
  const h = icon.height ?? iconSet.height ?? 16;
  const body = icon.body.replaceAll('currentColor', '#000');
  return {
    svg: `<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="${left} ${top} ${w} ${h}" width="${w}" height="${h}">${body}</svg>`,
    width: w,
    height: h,
  };
}

// ---------------------------------------------------------------------------
// Vẽ SVG thành lưới (chạy trong Chromium qua Playwright)

/** Chạy trong trang: trả về dữ liệu điểm ảnh theo ô cho từng yêu cầu. */
async function pageRender(jobs) {
  const SS = 8; // số điểm ảnh con mỗi cạnh ô
  const load = (svg) =>
    new Promise((resolve, reject) => {
      const img = new Image();
      img.onload = () => resolve(img);
      img.onerror = reject;
      img.src = 'data:image/svg+xml;charset=utf-8,' + encodeURIComponent(svg);
    });
  const canvas = (w, h) => {
    const c = document.createElement('canvas');
    c.width = w;
    c.height = h;
    return [c, c.getContext('2d', { willReadFrequently: true })];
  };

  const out = [];
  for (const job of jobs) {
    const img = await load(job.svg);
    const result = { key: job.key };

    // Hình xem trước.
    {
      const [c, ctx] = canvas(96, 96);
      ctx.drawImage(img, 0, 0, 96, 96);
      result.thumb = c.toDataURL('image/png');
    }

    if (job.mode === 'pixel') {
      // Icon pixel art: 1 đơn vị viewBox = 1 điểm ảnh.
      const [c, ctx] = canvas(job.width, job.height);
      ctx.drawImage(img, 0, 0, job.width, job.height);
      const px = ctx.getImageData(0, 0, job.width, job.height).data;
      const grid = [];
      for (let y = 0; y < job.height; y++) {
        const row = [];
        for (let x = 0; x < job.width; x++) row.push(px[(y * job.width + x) * 4 + 3] >= 128 ? 1 : 0);
        grid.push(row);
      }
      result.pixel = grid;
      out.push(result);
      continue;
    }

    // Emoji màu: tìm khung bao phần có nội dung rồi lấy mẫu theo từng cỡ lưới.
    const R = 512;
    const [big, bctx] = canvas(R, R);
    bctx.drawImage(img, 0, 0, R, R);
    const bp = bctx.getImageData(0, 0, R, R).data;
    let x0 = R, y0 = R, x1 = -1, y1 = -1;
    for (let y = 0; y < R; y++) {
      for (let x = 0; x < R; x++) {
        if (bp[(y * R + x) * 4 + 3] > 24) {
          if (x < x0) x0 = x;
          if (x > x1) x1 = x;
          if (y < y0) y0 = y;
          if (y > y1) y1 = y;
        }
      }
    }
    const bw = x1 - x0 + 1;
    const bh = y1 - y0 + 1;
    result.sizes = [];
    for (const n of job.sizes) {
      const cols = bw >= bh ? n : Math.max(3, Math.round((n * bw) / bh));
      const rows = bh >= bw ? n : Math.max(3, Math.round((n * bh) / bw));
      const [c, ctx] = canvas(cols * SS, rows * SS);
      ctx.drawImage(big, x0, y0, bw, bh, 0, 0, cols * SS, rows * SS);
      const px = ctx.getImageData(0, 0, cols * SS, rows * SS).data;
      const alpha = [];
      const lum = [];
      for (let r = 0; r < rows; r++) {
        const ar = [];
        const lr = [];
        for (let cc = 0; cc < cols; cc++) {
          let a = 0;
          let l = 0;
          for (let sy = 0; sy < SS; sy++) {
            for (let sx = 0; sx < SS; sx++) {
              const i = ((r * SS + sy) * cols * SS + cc * SS + sx) * 4;
              const al = px[i + 3] / 255;
              const y = (0.2126 * px[i] + 0.7152 * px[i + 1] + 0.0722 * px[i + 2]) / 255;
              a += al;
              l += al * y + (1 - al); // phủ lên nền trắng
            }
          }
          ar.push(a / (SS * SS));
          lr.push(l / (SS * SS));
        }
        alpha.push(ar);
        lum.push(lr);
      }
      result.sizes.push({ n, rows, cols, alpha, lum });
    }
    out.push(result);
  }
  return out;
}

// ---------------------------------------------------------------------------
// Chuyển dữ liệu điểm ảnh thành lưới 0/1

function cropToContent(grid) {
  const rows = grid.length;
  const cols = grid[0].length;
  let r0 = rows, r1 = -1, c0 = cols, c1 = -1;
  for (let r = 0; r < rows; r++)
    for (let c = 0; c < cols; c++)
      if (grid[r][c]) {
        r0 = Math.min(r0, r);
        r1 = Math.max(r1, r);
        c0 = Math.min(c0, c);
        c1 = Math.max(c1, c);
      }
  if (r1 < 0) return grid;
  return grid.slice(r0, r1 + 1).map((row) => row.slice(c0, c1 + 1));
}

/** Pixelarticons vẽ mỗi "điểm ảnh" bằng khối 2×2 đơn vị: thu về 1×1 nếu đúng vậy. */
function halveIfBlocky(grid) {
  const rows = grid.length;
  const cols = grid[0].length;
  if (rows % 2 || cols % 2) return grid;
  for (let r = 0; r < rows; r += 2)
    for (let c = 0; c < cols; c += 2) {
      const v = grid[r][c];
      if (grid[r + 1][c] !== v || grid[r][c + 1] !== v || grid[r + 1][c + 1] !== v) return grid;
    }
  return Array.from({ length: rows / 2 }, (_, r) => Array.from({ length: cols / 2 }, (_, c) => grid[r * 2][c * 2]));
}

/** Ngưỡng Otsu trên các giá trị trong [0, 1]. */
function otsu(values) {
  const bins = 64;
  const hist = new Array(bins).fill(0);
  for (const v of values) hist[Math.min(bins - 1, Math.floor(v * bins))]++;
  const total = values.length;
  let sum = 0;
  for (let i = 0; i < bins; i++) sum += i * hist[i];
  let sumB = 0, wB = 0, best = 0, bestT = 0.5;
  for (let i = 0; i < bins; i++) {
    wB += hist[i];
    if (!wB) continue;
    const wF = total - wB;
    if (!wF) break;
    sumB += i * hist[i];
    const mB = sumB / wB;
    const mF = (sum - sumB) / wF;
    const between = wB * wF * (mB - mF) ** 2;
    if (between > best) {
      best = between;
      bestT = (i + 1) / bins;
    }
  }
  return bestT;
}

/** Bỏ ô tô lẻ loi và lấp lỗ trống lẻ loi (nhiễu khi thu nhỏ). */
function cleanup(grid) {
  const rows = grid.length;
  const cols = grid[0].length;
  const at = (r, c) => (r >= 0 && r < rows && c >= 0 && c < cols ? grid[r][c] : 0);
  return grid.map((row, r) =>
    row.map((v, c) => {
      const n = at(r - 1, c) + at(r + 1, c) + at(r, c - 1) + at(r, c + 1);
      if (v === 1 && n === 0) return 0;
      if (v === 0 && n === 4) return 1;
      return v;
    }),
  );
}

/**
 * Các cách chuyển emoji màu sang đen trắng:
 * - silhouette: cả hình bóng (mọi ô có nội dung);
 * - ink:        ô tối hơn ngưỡng Otsu (như in đen trắng);
 * - cutout:     hình bóng, đục lỗ ở các chi tiết tối (mắt, miệng, viền...).
 */
function emojiVariants({ alpha, lum }) {
  const opaque = alpha.map((row) => row.map((a) => (a >= 0.5 ? 1 : 0)));
  const all = lum.flat();
  const tInk = otsu(all);
  const ink = lum.map((row) => row.map((l) => (l < tInk ? 1 : 0)));
  const inside = [];
  lum.forEach((row, r) => row.forEach((l, c) => opaque[r][c] && inside.push(l)));
  const tIn = inside.length ? otsu(inside) : 0.5;
  const dark = inside.filter((l) => l < tIn).length / Math.max(1, inside.length);
  const cutout =
    dark < 0.4 ? opaque.map((row, r) => row.map((v, c) => (v && lum[r][c] >= tIn ? 1 : 0))) : null;
  const variants = { silhouette: opaque, ink };
  if (cutout) variants.cutout = cutout;
  return variants;
}

/** Lấp các vùng trống bị bao kín (biến hình nét viền thành hình đặc). */
function fillHoles(grid) {
  const rows = grid.length;
  const cols = grid[0].length;
  const outside = grid.map((row) => row.map(() => false));
  const stack = [];
  for (let r = 0; r < rows; r++) stack.push([r, 0], [r, cols - 1]);
  for (let c = 0; c < cols; c++) stack.push([0, c], [rows - 1, c]);
  while (stack.length) {
    const [r, c] = stack.pop();
    if (r < 0 || r >= rows || c < 0 || c >= cols || outside[r][c] || grid[r][c]) continue;
    outside[r][c] = true;
    stack.push([r + 1, c], [r - 1, c], [r, c + 1], [r, c - 1]);
  }
  return grid.map((row, r) => row.map((v, c) => (v || !outside[r][c] ? 1 : 0)));
}

/** Số mảng vụn (≤ 2 ô) của cả phần tô lẫn phần trống: càng nhiều càng nhiễu. */
function specks(grid) {
  const rows = grid.length;
  const cols = grid[0].length;
  const seen = grid.map((row) => row.map(() => false));
  let count = 0;
  for (let r = 0; r < rows; r++)
    for (let c = 0; c < cols; c++) {
      if (seen[r][c]) continue;
      const v = grid[r][c];
      let size = 0;
      const stack = [[r, c]];
      while (stack.length) {
        const [y, x] = stack.pop();
        if (y < 0 || y >= rows || x < 0 || x >= cols || seen[y][x] || grid[y][x] !== v) continue;
        seen[y][x] = true;
        size++;
        stack.push([y + 1, x], [y - 1, x], [y, x + 1], [y, x - 1]);
      }
      if (size <= 2) count++;
    }
  return count;
}

function evaluate(grid) {
  let g = cropToContent(grid);
  const rows = g.length;
  const cols = g[0].length;
  let flips = [];
  let a = analyze(g);
  if (!a.lineSolvable) {
    const fixed = repair(g, Math.max(1, Math.round(MAX_FLIP_RATIO * rows * cols)));
    if (fixed) {
      g = fixed.grid;
      flips = fixed.flips;
      a = analyze(g);
    }
  }
  const filled = g.flat().reduce((x, y) => x + y, 0);
  const density = filled / (rows * cols);
  const { partial, ...stats } = a;
  return { grid: g, rows, cols, density, flips, specks: specks(g), ...stats };
}

/** Điểm độ khó 0..1 từ kích thước và lượng suy luận. */
function difficultyScore(rows, cols, lineSolves, rounds) {
  const size = Math.min(1, (rows * cols) / 900); // 30×30 = 1
  const work = Math.min(1, lineSolves / (2.5 * (rows + cols)));
  const depth = Math.min(1, (rounds - 1) / 10);
  return Math.round(Math.min(1, 0.55 * size + 0.25 * work + 0.2 * depth) * 100) / 100;
}

const titleOf = (name) =>
  name
    .split('-')
    .map((w) => w[0].toUpperCase() + w.slice(1))
    .join(' ');

// ---------------------------------------------------------------------------

async function main() {
  const selection = JSON.parse(fs.readFileSync(selectionPath, 'utf8'));
  const sets = {};
  for (const set of Object.keys(selection.sets)) sets[set] = loadIconSet(set);

  const jobs = [];
  const missing = [];
  for (const item of selection.icons) {
    const meta = selection.sets[item.set];
    const svg = iconSvg(sets[item.set].data, item.icon);
    if (!svg) {
      missing.push(`${item.set}:${item.icon}`);
      continue;
    }
    jobs.push({
      key: `${item.set}:${item.icon}`,
      mode: meta.mode,
      sizes: item.sizes ?? meta.sizes ?? [15],
      ...svg,
    });
  }
  if (missing.length) console.warn(`Không tìm thấy icon: ${missing.join(', ')}`);

  const require = createRequire(path.join(here, 'package.json'));
  let chromium;
  try {
    ({ chromium } = require('playwright'));
  } catch {
    ({ chromium } = createRequire(import.meta.url)('playwright'));
  }
  const browser = await chromium.launch();
  const page = await browser.newPage();
  await page.setContent('<!doctype html><body></body>');
  const rendered = await page.evaluate(pageRender, jobs);
  await browser.close();

  const levels = [];
  const sources = [];
  const preview = [];
  const byKey = Object.fromEntries(rendered.map((r) => [r.key, r]));

  for (const item of selection.icons) {
    const key = `${item.set}:${item.icon}`;
    const r = byKey[key];
    if (!r) continue;
    const meta = selection.sets[item.set];
    const candidates = [];
    if (r.pixel) {
      const base = halveIfBlocky(cropToContent(r.pixel));
      candidates.push({ variant: 'pixel', ...evaluate(base) });
      const solid = fillHoles(base);
      if (solid.flat().join('') !== base.flat().join('')) candidates.push({ variant: 'solid', ...evaluate(solid) });
    } else {
      for (const s of r.sizes) {
        for (const [variant, grid] of Object.entries(emojiVariants(s))) {
          candidates.push({ variant, n: s.n, ...evaluate(cleanup(grid)) });
        }
      }
    }
    for (const c of candidates) {
      c.reasons = [];
      if (!c.lineSolvable) c.reasons.push('cần đoán / nhiều nghiệm, sửa không được');
      if (c.density < MIN_DENSITY) c.reasons.push('quá thưa');
      if (c.density > MAX_DENSITY) c.reasons.push('quá đặc');
      if (c.rows < 4 || c.cols < 4) c.reasons.push('quá nhỏ');
      c.ok = c.reasons.length === 0;
    }

    // Chấm điểm (thấp = tốt): ưu tiên hình có chi tiết (đục lỗ) ở cỡ 20,
    // phạt mảng vụn và ô phải lật khi sửa. Ghi đè bằng variant/size trong selection.
    const variantCost = { pixel: 0, solid: 1.5, cutout: 0, ink: 1, silhouette: 2 };
    const sizeCost = { 20: 0, 15: 0.5, 25: 1 };
    const cost = (c) =>
      variantCost[c.variant] + (sizeCost[c.n] ?? 0) + 0.4 * c.specks + (0.6 * c.flips.length) / Math.sqrt(c.rows * c.cols / 100);
    const pick = item.variant
      ? candidates.find((c) => c.ok && c.variant === item.variant && (!item.size || c.n === item.size))
      : candidates.filter((c) => c.ok).sort((a, b) => cost(a) - cost(b))[0];

    const title = item.title ?? titleOf(item.icon);
    preview.push({ key, title, thumb: r.thumb, candidates, pick });
    if (!pick) continue;

    const score = difficultyScore(pick.rows, pick.cols, pick.lineSolves, pick.rounds);
    const id = `${item.set}-${item.icon}`;
    levels.push({
      source_puzzle_id: id,
      title,
      author: meta.author,
      difficulty_score: score,
      difficulty: `${Math.max(1, Math.round(score * 10))}/10`,
      rows: pick.rows,
      cols: pick.cols,
      solution: pick.grid.map((row) => row.join('')),
    });
    const info = sets[item.set].info;
    sources.push({
      id,
      title,
      set: item.set,
      setVersion: sets[item.set].version,
      icon: item.icon,
      variant: pick.variant,
      size: pick.n,
      flippedCells: pick.flips.length,
      author: info.author?.name,
      authorUrl: info.author?.url,
      license: info.license?.spdx,
      licenseUrl: info.license?.url,
    });
  }

  // Xếp theo độ khó để màn đầu dễ nhất.
  const order = levels
    .map((l, i) => [l, sources[i]])
    .sort((a, b) => a[0].difficulty_score - b[0].difficulty_score || a[0].rows * a[0].cols - b[0].rows * b[0].cols);
  order.forEach(([l], i) => (l.level = i + 1));

  fs.mkdirSync(outDir, { recursive: true });
  fs.writeFileSync(path.join(outDir, 'levels.json'), JSON.stringify(order.map(([l]) => l), null, 1) + '\n');
  fs.writeFileSync(path.join(outDir, 'sources.json'), JSON.stringify(order.map(([, s]) => s), null, 1) + '\n');
  fs.writeFileSync(path.join(outDir, 'preview.html'), previewHtml(preview, order));
  console.log(`${order.length}/${selection.icons.length} hình thành màn. Kết quả: ${outDir}`);
}

function gridSvg(grid, cell = 6, flips = []) {
  const rows = grid.length;
  const cols = grid[0].length;
  let rects = '';
  grid.forEach((row, r) =>
    row.forEach((v, c) => {
      if (v) rects += `<rect x="${c * cell}" y="${r * cell}" width="${cell}" height="${cell}"/>`;
    }),
  );
  for (const [r, c] of flips) rects += `<rect class="f" x="${c * cell}" y="${r * cell}" width="${cell}" height="${cell}"/>`;
  return `<svg viewBox="0 0 ${cols * cell} ${rows * cell}" width="${cols * cell}" height="${rows * cell}" class="g"><rect class="bg" width="100%" height="100%"/>${rects}</svg>`;
}

function previewHtml(preview, order) {
  const levelOf = Object.fromEntries(order.map(([l]) => [l.source_puzzle_id, l]));
  const cards = preview
    .map((p) => {
      const id = p.key.replace(':', '-');
      const lvl = levelOf[id];
      const head = lvl
        ? `<b>#${lvl.level} ${p.title}</b> <span>${lvl.cols}×${lvl.rows} · ${lvl.difficulty}</span>`
        : `<b>${p.title}</b> <span class="bad">bị loại</span>`;
      const variants = p.candidates
        .map(
          (c) =>
            `<figure class="${c === p.pick ? 'pick' : c.ok ? '' : 'no'}">${gridSvg(c.grid, c.rows > 20 ? 4 : 6, c.flips)}<figcaption>${c.variant}${c.n ? ' ' + c.n : ''}${c.flips.length ? ` · sửa ${c.flips.length} ô` : ''}${c.ok ? '' : ' · ' + c.reasons.join(', ')}</figcaption></figure>`,
        )
        .join('');
      return `<section><header><img src="${p.thumb}" width="64" height="64" alt="">${head}<small>${p.key}</small></header><div class="v">${variants}</div></section>`;
    })
    .join('\n');
  return `<!doctype html><html lang="vi"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Xem trước màn chơi</title>
<style>
:root{--bg:#f6f6f4;--card:#fff;--ink:#1d1d1f;--muted:#6b6b70;--line:#e3e3e0;--accent:#2f6fde;--bad:#c4372c}
@media (prefers-color-scheme:dark){:root{--bg:#141416;--card:#1e1e21;--ink:#ececef;--muted:#9a9aa0;--line:#2e2e33;--accent:#6a9cff;--bad:#ff7a6e}}
body{margin:0;padding:16px;background:var(--bg);color:var(--ink);font:14px/1.4 system-ui,sans-serif}
h1{font-size:20px;margin:0 0 4px}p{color:var(--muted);margin:0 0 16px}
section{background:var(--card);border:1px solid var(--line);border-radius:10px;padding:12px;margin-bottom:12px}
header{display:flex;align-items:center;gap:10px;flex-wrap:wrap;margin-bottom:8px}header span{color:var(--muted)}header small{color:var(--muted);margin-left:auto}
.bad{color:var(--bad)!important}
.v{display:flex;gap:12px;flex-wrap:wrap;align-items:flex-end}
figure{margin:0;padding:6px;border:2px solid transparent;border-radius:8px;max-width:100%}figure.pick{border-color:var(--accent)}figure.no{opacity:.45}
figcaption{font-size:11px;color:var(--muted);margin-top:4px;max-width:160px}
.g{display:block;max-width:100%;height:auto}.g rect{fill:var(--ink)}.g .bg{fill:var(--card)}.g .f{fill:var(--bad);opacity:.75}
</style></head><body><h1>Xem trước màn chơi</h1><p>${order.length}/${preview.length} hình thành màn. Khung xanh = bản được chọn; mờ = bị loại (lý do ở dưới); ô đỏ = ô đã lật để màn giải được bằng suy luận.</p>
${cards}</body></html>`;
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});

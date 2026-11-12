#!/usr/bin/env node
// Nạp một bộ icon pixel art dạng PNG (mỗi icon một file) vào trang chọn màn.
//
// Cách dùng (chạy từ thư mục gốc repo, sau generate.mjs):
//   node tools/image_levels/import_png_icons.mjs <thư mục PNG> --set=<id bộ> \
//     --author="<ghi công>" --license=<SPDX> [--exclude=Prefix1,Prefix2] \
//     [--exclude-words=word1,word2] [--include=Ten_file1,Ten_file2]
//     [--titles=Ten_file:Tiêu đề,...] [--only] [--auto-accept] [--max-pins=2]
//     [--out=tools/image_levels/out/picker_icons.json]
//
// Mỗi điểm ảnh màu đen (gần đen) thành một ô tô; nền trong suốt và phần ruột
// màu trắng thành ô trống. Trên trang chọn màn, "Lấp kín" sẽ lấp phần ruột để
// ra hình bóng. Các icon của bộ này được thay thế (hoặc thêm) trong file picker
// mà không đụng tới các bộ khác.

import fs from 'node:fs';
import path from 'node:path';
import { createRequire } from 'node:module';
import { fileURLToPath } from 'node:url';

import { analyze, findPins, repair } from './solver.mjs';

const here = path.dirname(fileURLToPath(import.meta.url));
const args = Object.fromEntries(
  process.argv
    .slice(2)
    .filter((a) => a.startsWith('--'))
    .map((a) => {
      const [k, ...v] = a.slice(2).split('=');
      return [k, v.join('=')];
    }),
);
const dir = process.argv.slice(2).find((a) => !a.startsWith('--'));
if (!dir || !args.set || !args.author || !args.license) {
  console.error(
    'Usage: node tools/image_levels/import_png_icons.mjs <dir> --set=<id> --author="..." --license=<SPDX> [--exclude=A,B] [--exclude-words=a,b]',
  );
  process.exit(64);
}
const outFile = args.out ?? path.join(here, 'out', 'picker_icons.json');
const excludePrefixes = (args.exclude ?? '').split(',').filter(Boolean);
const excludeWords = (args['exclude-words'] ?? '').split(',').filter(Boolean).map((w) => w.toLowerCase());
// Tên file (không có .png) được giữ dù thuộc nhóm bị loại, vd. Tux trong nhóm Platforms.
const include = new Set((args.include ?? '').split(',').filter(Boolean));
// Đặt lại tên màn: --titles=Tên_file:Tiêu đề,...
const titles = Object.fromEntries(
  (args.titles ?? '')
    .split(',')
    .filter(Boolean)
    .map((pair) => pair.split(':')),
);

const files = fs
  .readdirSync(dir)
  .filter((f) => f.toLowerCase().endsWith('.png'))
  .filter(
    (f) =>
      include.has(f.replace(/\.png$/i, '')) ||
      (!excludePrefixes.some((p) => f.startsWith(p + '_')) && !excludeWords.some((w) => f.toLowerCase().includes(w))),
  )
  .sort();

const require = createRequire(import.meta.url);
const { chromium } = require('playwright');
const browser = await chromium.launch();
const page = await browser.newPage();
await page.setContent('<!doctype html><body></body>');
const decoded = await page.evaluate(
  async (images) => {
    const out = [];
    for (const { name, data } of images) {
      const img = new Image();
      img.src = 'data:image/png;base64,' + data;
      await img.decode();
      const c = document.createElement('canvas');
      c.width = img.width;
      c.height = img.height;
      const ctx = c.getContext('2d');
      ctx.drawImage(img, 0, 0);
      const px = ctx.getImageData(0, 0, c.width, c.height).data;
      const ink = [];
      const shape = [];
      for (let y = 0; y < c.height; y++) {
        const a = [];
        const b = [];
        for (let x = 0; x < c.width; x++) {
          const i = (y * c.width + x) * 4;
          const opaque = px[i + 3] >= 128;
          const dark = opaque && px[i] + px[i + 1] + px[i + 2] < 3 * 96;
          a.push(dark ? 1 : 0);
          b.push(opaque ? 1 : 0);
        }
        ink.push(a);
        shape.push(b);
      }
      out.push({ name, width: c.width, height: c.height, ink, shape });
    }
    return out;
  },
  files.map((f) => ({ name: f, data: fs.readFileSync(path.join(dir, f)).toString('base64') })),
);
await browser.close();

const crop = (g) => {
  let r0 = g.length, r1 = -1, c0 = g[0].length, c1 = -1;
  g.forEach((row, r) => row.forEach((v, c) => {
    if (v) ((r0 = Math.min(r0, r)), (r1 = Math.max(r1, r)), (c0 = Math.min(c0, c)), (c1 = Math.max(c1, c)));
  }));
  return r1 < 0 ? g : g.slice(r0, r1 + 1).map((row) => row.slice(c0, c1 + 1));
};
// Giải được bằng suy luận, hoặc sửa được bằng cách lật ít ô (như trang chọn
// màn tự làm khi mở ảnh).
const solvable = (g) => {
  const c = crop(g);
  if (c.length < 4 || c[0].length < 4) return false;
  return analyze(c).lineSolvable || repair(c, Math.max(1, Math.round(0.03 * c.length * c[0].length))) !== null;
};
const density = (g) => {
  const c = crop(g);
  return c.flat().reduce((a, b) => a + b, 0) / (c.length * c[0].length);
};
/** Như trang chọn màn: chọn cách chia khối 2×2 khớp nhất rồi gộp theo số đông. */
function halfDown(g) {
  const H = g.length;
  const W = g[0].length;
  const at = (y, x) => (y >= 0 && y < H && x >= 0 && x < W ? g[y][x] : 0);
  let best = null;
  for (const oy of [0, 1])
    for (const ox of [0, 1]) {
      let bad = 0;
      let blocks = 0;
      const out = [];
      for (let y = -oy; y < H; y += 2) {
        const row = [];
        for (let x = -ox; x < W; x += 2) {
          const s = at(y, x) + at(y + 1, x) + at(y, x + 1) + at(y + 1, x + 1);
          if (s) blocks++;
          if (s && s !== 4) bad++;
          row.push(s >= 2 ? 1 : 0);
        }
        out.push(row);
      }
      const mismatch = blocks ? bad / blocks : 1;
      if (!best || mismatch < best.mismatch) best = { mismatch, grid: out };
    }
  best.grid = crop(best.grid);
  return best;
}

/** Cùng công thức với trang chọn màn (thứ tự thật tính lại ở ordering.mjs). */
function pickerDifficulty(rows, cols, lineSolves, rounds) {
  const size = Math.min(1, (rows * cols) / 900);
  const work = Math.min(1, lineSolves / (2.5 * (rows + cols)));
  const depth = Math.min(1, (rounds - 1) / 10);
  return Math.round(Math.min(1, 0.55 * size + 0.25 * work + 0.2 * depth) * 100) / 100;
}

/**
 * --auto-accept: icon tự được chọn khi nét viền giải được bằng suy luận mà
 * không cần sửa ô nào; dùng bản thu nhỏ ½ nếu thu nhỏ được trọn vẹn (mọi khối
 * 2×2 đồng nhất), không thì giữ nguyên kích thước. Nếu chưa giải được, cho phép
 * ghim sẵn tối đa --max-pins ô tô (mặc định 2, không quá 5% số ô).
 */
const maxPins = args['max-pins'] === undefined ? 2 : Number(args['max-pins']);
function autoAccept(ink) {
  const full = crop(ink);
  const half = halfDown(full);
  const useHalf = half.mismatch === 0;
  const sol = useHalf ? half.grid : full;
  if (sol.length < 4 || sol[0].length < 4) return null;
  const limit = Math.min(maxPins, Math.floor(0.05 * sol.length * sol[0].length));
  const pins = findPins(sol, { maxPins: limit, filledOnly: true });
  if (!pins) return null;
  const a = analyze(sol, pins);
  const filled = sol.flat().reduce((x, y) => x + y, 0);
  return {
    rows: sol.length,
    cols: sol[0].length,
    solution: sol.map((r) => r.join('')),
    density: Math.round((filled / (sol.length * sol[0].length)) * 1000) / 1000,
    difficultyScore: pickerDifficulty(sol.length, sol[0].length, a.lineSolves, a.rounds),
    params: { mode: 'pixel', solid: false, cleanup: false, half: useHalf, negative: false, pad: 0 },
    ...(pins.length ? { pins } : {}),
  };
}

const titleOf = (name) => {
  const parts = name.replace(/\.png$/i, '').split('_');
  const skip = parts[0] === 'Map' && parts[1] === 'Markers' ? 2 : 1;
  return parts
    .slice(skip)
    .filter((p) => !/^\d+$/.test(p))
    .join(' ');
};

const icons = decoded.map((d) => {
  let rects = '';
  d.ink.forEach((row, y) => row.forEach((v, x) => v && (rects += `M${x} ${y}h1v1h-1z`)));
  // Phần ruột trắng vẽ mờ để ảnh gốc trên trang vẫn giống icon thật; trang chỉ
  // lấy ô có độ đục >= 50% nên phần này không thành ô tô.
  let fill = '';
  d.shape.forEach((row, y) => row.forEach((v, x) => v && !d.ink[y][x] && (fill += `M${x} ${y}h1v1h-1z`)));
  const svg =
    `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${d.width} ${d.height}" width="${d.width}" height="${d.height}" shape-rendering="crispEdges">` +
    (fill ? `<path fill="#000" fill-opacity="0.12" d="${fill}"/>` : '') +
    `<path fill="#000" d="${rects}"/></svg>`;
  // Ưu tiên giữ nét viền (nhiều chi tiết); chỉ gợi ý hình bóng khi nét viền
  // không giải được và hình bóng không quá đặc.
  const variant = !solvable(d.ink) && density(d.shape) <= 0.75 && solvable(d.shape) ? 'solid' : 'pixel';
  const icon = d.name.replace(/\.png$/i, '');
  const auto = 'auto-accept' in args ? autoAccept(d.ink) : null;
  return {
    ...(auto ? { auto } : {}),
    key: `${args.set}:${icon}`,
    set: args.set,
    icon,
    title: titles[icon] ?? titleOf(d.name),
    author: args.author,
    license: args.license,
    mode: 'pixel',
    width: d.width,
    height: d.height,
    svg,
    suggest: { variant, size: null },
  };
});

const data = fs.existsSync(outFile) ? JSON.parse(fs.readFileSync(outFile, 'utf8')) : { version: 1, icons: [] };
// --only: trang chọn màn chỉ còn bộ này (bỏ các bộ khác khỏi file picker; kết
// quả đã chọn trước đó vẫn nằm trong cơ sở dữ liệu của trang và data/picks.json).
const keep = 'only' in args ? [] : data.icons.filter((i) => i.set !== args.set);
data.icons = [...keep, ...icons];
data.generatedAt = new Date().toISOString();
fs.writeFileSync(outFile, JSON.stringify(data));
const counts = icons.reduce((m, i) => ((m[i.suggest.variant] = (m[i.suggest.variant] ?? 0) + 1), m), {});
console.log(`${icons.length} icon (${JSON.stringify(counts)}, tự chấp nhận ${icons.filter((i) => i.auto).length}) → ${outFile}`);

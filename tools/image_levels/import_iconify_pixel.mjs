#!/usr/bin/env node
// Đưa các màn đã chọn từ bộ pixel art Iconify (Pixelarticons, Streamline Pixel)
// về bản gốc rồi nạp lại vào trang chọn màn.
//
// Cách dùng (sau generate.mjs, để có bộ icon trong .cache/):
//   node tools/image_levels/import_iconify_pixel.mjs [--picks=tools/image_levels/data/picks.json]
//
// Với mỗi màn đã chọn của hai bộ này:
// - lấy hình gốc của icon (bỏ mọi chỉnh sửa trước đó: sửa tay, âm bản, lấp kín,
//   lề, thu nhỏ...);
// - nếu mọi khối 2×2 đều đồng nhất thì thu nhỏ ½; nếu bản đó giải được bằng suy
//   luận thì tự chấp nhận (trường `auto`);
// - các màn còn lại vào nhóm chờ duyệt trên trang chọn màn.
// Quyết định cũ của các màn này bị bỏ qua nhờ trường `resetBefore` (thời điểm
// chạy script): trang và picks_to_levels.mjs không dùng quyết định lưu trước đó.

import fs from 'node:fs';
import path from 'node:path';
import { createRequire } from 'node:module';
import { fileURLToPath } from 'node:url';

import { analyze } from './solver.mjs';

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
const picksFile = args.picks ?? path.join(here, 'data', 'picks.json');
const outFile = path.join(here, 'out', 'picker_icons.json');

// Số ô thật trên mỗi cạnh khung của từng bộ (xem selection.json).
const sets = {
  pixelarticons: { grid: null, author: 'Pixelarticons (Gerrit Halfmann)', license: 'MIT' },
  'streamline-pixel': { grid: 42, author: 'Streamline Pixel (Streamline)', license: 'CC-BY-4.0' },
};

const picks = JSON.parse(fs.readFileSync(picksFile, 'utf8')).filter((p) => p.status === 'picked' && sets[p.set]);

function iconSvg(iconSet, name) {
  let icon = iconSet.icons[name];
  let alias = iconSet.aliases?.[name];
  while (!icon && alias) {
    icon = iconSet.icons[alias.parent];
    alias = iconSet.aliases?.[alias.parent];
  }
  const w = icon.width ?? iconSet.width ?? 16;
  const h = icon.height ?? iconSet.height ?? 16;
  const body = icon.body.replaceAll('currentColor', '#000');
  return { svg: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${w} ${h}" width="${w}" height="${h}">${body}</svg>`, w, h };
}

const iconSets = {};
for (const set of Object.keys(sets)) {
  iconSets[set] = JSON.parse(fs.readFileSync(path.join(here, '.cache', set, 'package', 'icons.json'), 'utf8'));
}
const jobs = picks.map((p) => {
  const { svg, w, h } = iconSvg(iconSets[p.set], p.icon);
  const grid = sets[p.set].grid;
  return { key: p.key, svg, width: grid ?? w, height: grid ?? h };
});

const require = createRequire(import.meta.url);
const { chromium } = require('playwright');
const browser = await chromium.launch();
const page = await browser.newPage();
await page.setContent('<!doctype html><body></body>');
const grids = await page.evaluate(async (jobs) => {
  const out = {};
  for (const job of jobs) {
    const img = new Image();
    img.src = 'data:image/svg+xml;charset=utf-8,' + encodeURIComponent(job.svg);
    await img.decode();
    const c = document.createElement('canvas');
    c.width = job.width;
    c.height = job.height;
    const ctx = c.getContext('2d');
    ctx.drawImage(img, 0, 0, job.width, job.height);
    const px = ctx.getImageData(0, 0, job.width, job.height).data;
    out[job.key] = Array.from({ length: job.height }, (_, y) =>
      Array.from({ length: job.width }, (_, x) => (px[(y * job.width + x) * 4 + 3] >= 128 ? 1 : 0)),
    );
  }
  return out;
}, jobs);
await browser.close();

const crop = (g) => {
  let r0 = g.length, r1 = -1, c0 = g[0].length, c1 = -1;
  g.forEach((row, r) => row.forEach((v, c) => {
    if (v) ((r0 = Math.min(r0, r)), (r1 = Math.max(r1, r)), (c0 = Math.min(c0, c)), (c1 = Math.max(c1, c)));
  }));
  return r1 < 0 ? g : g.slice(r0, r1 + 1).map((row) => row.slice(c0, c1 + 1));
};
// Giống trang chọn màn: chọn cách chia khối 2×2 khớp nhất rồi gộp theo số đông.
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
function pickerDifficulty(rows, cols, lineSolves, rounds) {
  const size = Math.min(1, (rows * cols) / 900);
  const work = Math.min(1, lineSolves / (2.5 * (rows + cols)));
  const depth = Math.min(1, (rounds - 1) / 10);
  return Math.round(Math.min(1, 0.55 * size + 0.25 * work + 0.2 * depth) * 100) / 100;
}

const resetBefore = new Date().toISOString();
const report = { accepted: [], notSolvable: [], notUniform: [] };
const icons = picks.map((p) => {
  const job = jobs.find((j) => j.key === p.key);
  const full = crop(grids[p.key]);
  const half = halfDown(full);
  let auto = null;
  if (half.mismatch === 0) {
    const sol = half.grid;
    const a = analyze(sol);
    if (sol.length >= 4 && sol[0].length >= 4 && a.lineSolvable) {
      const filled = sol.flat().reduce((x, y) => x + y, 0);
      auto = {
        rows: sol.length,
        cols: sol[0].length,
        solution: sol.map((r) => r.join('')),
        density: Math.round((filled / (sol.length * sol[0].length)) * 1000) / 1000,
        difficultyScore: pickerDifficulty(sol.length, sol[0].length, a.lineSolves, a.rounds),
        params: { mode: 'pixel', solid: false, cleanup: false, half: true, negative: false, pad: 0 },
      };
      report.accepted.push(p.title);
    } else report.notSolvable.push(p.title);
  } else report.notUniform.push(`${p.title} (${Math.round(half.mismatch * 100)}%)`);
  return {
    ...(auto ? { auto } : {}),
    key: p.key,
    set: p.set,
    icon: p.icon,
    title: p.title,
    author: sets[p.set].author,
    license: sets[p.set].license,
    mode: 'pixel',
    width: job.width,
    height: job.height,
    svg: job.svg,
    suggest: { variant: 'pixel', size: null },
    resetBefore,
  };
});

const data = JSON.parse(fs.readFileSync(outFile, 'utf8'));
data.icons = [...data.icons.filter((i) => !sets[i.set]), ...icons];
data.generatedAt = new Date().toISOString();
fs.writeFileSync(outFile, JSON.stringify(data));
console.log(
  `${icons.length} màn cũ: tự chấp nhận ${report.accepted.length}, thu nhỏ được nhưng không giải được ${report.notSolvable.length}, không thu nhỏ trọn vẹn được ${report.notUniform.length}`,
);
console.log('Không giải được:', report.notSolvable.join(', '));
console.log('Không thu nhỏ được:', report.notUniform.join(', '));

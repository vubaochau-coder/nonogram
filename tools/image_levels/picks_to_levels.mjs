#!/usr/bin/env node
// Chuyển kết quả chọn trên trang picker (mỗi màn một file JSON, xuất từ cơ sở
// dữ liệu của trang) thành đầu vào cho tools/build_levels.dart.
//
// Cách dùng:
//   node tools/image_levels/picks_to_levels.mjs <thư mục chứa picks/*.json> [--out=tools/image_levels/out]
//
// Ghi ra levels.json (xếp theo độ khó) và sources.json (nguồn + giấy phép).
// Mỗi màn được kiểm tra lại: phải giải được hoàn toàn bằng suy luận.

import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

import { analyze } from './solver.mjs';

const here = path.dirname(fileURLToPath(import.meta.url));
const positional = process.argv.slice(2).filter((a) => !a.startsWith('--'));
const outArg = process.argv.find((a) => a.startsWith('--out='));
const outDir = outArg ? outArg.slice(6) : path.join(here, 'out');
if (positional.length !== 1) {
  console.error('Usage: node tools/image_levels/picks_to_levels.mjs <picks-dir> [--out=dir]');
  process.exit(64);
}

const files = fs.readdirSync(positional[0], { recursive: true }).filter((f) => String(f).endsWith('.json'));
const picks = files
  .map((f) => JSON.parse(fs.readFileSync(path.join(positional[0], String(f)), 'utf8')))
  .map((doc) => doc.data ?? doc)
  .filter((p) => p.status === 'picked');

const levels = [];
const sources = [];
const problems = [];
for (const p of picks) {
  const grid = p.solution.map((row) => [...row].map(Number));
  if (!analyze(grid).lineSolvable) {
    problems.push(p.key);
    continue;
  }
  const id = p.key.replace(':', '-');
  levels.push({
    source_puzzle_id: id,
    title: p.title,
    author: p.author,
    difficulty_score: p.difficultyScore,
    difficulty: `${Math.max(1, Math.round(p.difficultyScore * 10))}/10`,
    rows: p.rows,
    cols: p.cols,
    solution: p.solution,
  });
  sources.push({ id, title: p.title, set: p.set, icon: p.icon, author: p.author, license: p.license, params: p.params, editedCells: p.edits?.length ?? 0 });
}
if (problems.length) console.warn(`Bỏ ${problems.length} màn không giải được bằng suy luận: ${problems.join(', ')}`);

const order = levels
  .map((l, i) => [l, sources[i]])
  .sort((a, b) => a[0].difficulty_score - b[0].difficulty_score || a[0].rows * a[0].cols - b[0].rows * b[0].cols);
order.forEach(([l], i) => (l.level = i + 1));

fs.mkdirSync(outDir, { recursive: true });
fs.writeFileSync(path.join(outDir, 'levels.json'), JSON.stringify(order.map(([l]) => l), null, 1) + '\n');
fs.writeFileSync(path.join(outDir, 'sources.json'), JSON.stringify(order.map(([, s]) => s), null, 1) + '\n');
console.log(`${order.length} màn → ${outDir}`);

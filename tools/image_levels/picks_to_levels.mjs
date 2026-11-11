#!/usr/bin/env node
// Chuyển kết quả chọn trên trang picker (mỗi màn một file JSON, xuất từ cơ sở
// dữ liệu của trang) thành đầu vào cho tools/build_levels.dart.
//
// Cách dùng:
//   node tools/image_levels/picks_to_levels.mjs <picks.json | thư mục chứa picks/*.json> [--out=tools/image_levels/out]
//
// Bản chụp kết quả duyệt đang dùng cho app: tools/image_levels/data/picks.json.
//
// Ghi ra levels.json và sources.json (nguồn + giấy phép). Thứ tự và nhãn độ
// khó tính lại từ lời giải (xem ordering.mjs), không dùng điểm của trang chọn màn.
// Mỗi màn được kiểm tra lại: phải giải được hoàn toàn bằng suy luận.

import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

import { difficultyLabels, difficultyMetrics, orderLevels } from './ordering.mjs';
import { analyze } from './solver.mjs';

const here = path.dirname(fileURLToPath(import.meta.url));
const positional = process.argv.slice(2).filter((a) => !a.startsWith('--'));
const outArg = process.argv.find((a) => a.startsWith('--out='));
const outDir = outArg ? outArg.slice(6) : path.join(here, 'out');
if (positional.length !== 1) {
  console.error('Usage: node tools/image_levels/picks_to_levels.mjs <picks.json|picks-dir> [--out=dir]');
  process.exit(64);
}

const input = positional[0];
const docs = fs.statSync(input).isDirectory()
  ? fs
      .readdirSync(input, { recursive: true })
      .filter((f) => String(f).endsWith('.json'))
      .map((f) => JSON.parse(fs.readFileSync(path.join(input, String(f)), 'utf8')))
  : JSON.parse(fs.readFileSync(input, 'utf8'));
const picks = docs
  .map((doc) => doc.data ?? doc)
  .filter((p) => p.status === 'picked');

const levels = [];
const problems = [];
for (const p of picks) {
  const grid = p.solution.map((row) => [...row].map(Number));
  if (!analyze(grid).lineSolvable) {
    problems.push(p.key);
    continue;
  }
  const id = p.key.replace(':', '-');
  const metrics = difficultyMetrics(grid);
  levels.push({
    id,
    title: p.title,
    score: metrics.score,
    cells: metrics.cells,
    level: {
      source_puzzle_id: id,
      title: p.title,
      author: p.author,
      difficulty_score: Math.round(metrics.score * 100) / 100,
      rows: p.rows,
      cols: p.cols,
      solution: p.solution,
    },
    source: { id, title: p.title, set: p.set, icon: p.icon, author: p.author, license: p.license, params: p.params, editedCells: p.edits?.length ?? 0, metrics },
  });
}
// Màn lấy nguyên từ các bộ nonogram có giấy phép mở (không phải chuyển từ
// icon), xem data/nonogram_db.json và docs/credits.md.
const authorFields = {
  'Jan Wolter': 'Jan Wolter (webpbn.com)',
  'Michael Terry': 'Michael Terry (nonogram-db)',
  'Frederico Vera': 'Frederico Vera (gnonograms)',
};
for (const p of JSON.parse(fs.readFileSync(path.join(here, 'data', 'nonogram_db.json'), 'utf8'))) {
  const grid = p.solution.map((row) => [...row].map(Number));
  if (!analyze(grid).lineSolvable) {
    problems.push(p.id);
    continue;
  }
  const author = authorFields[p.by];
  if (!author) throw new Error(`Chưa có ghi công cho tác giả "${p.by}" (${p.id})`);
  const metrics = difficultyMetrics(grid);
  levels.push({
    id: p.id,
    title: p.title,
    score: metrics.score,
    cells: metrics.cells,
    level: {
      source_puzzle_id: p.id,
      title: p.title,
      author,
      difficulty_score: Math.round(metrics.score * 100) / 100,
      rows: grid.length,
      cols: grid[0].length,
      solution: p.solution,
    },
    source: { id: p.id, title: p.title, set: 'nonogram-db', author: p.by, copyright: p.copyright, license: p.license, url: p.source, catalogue: p.catalogue, metrics },
  });
}
if (problems.length) console.warn(`Bỏ ${problems.length} màn không giải được bằng suy luận: ${problems.join(', ')}`);

// Màn mở đầu chọn tay (danh sách id), xem tools/image_levels/README.md.
const pinnedFile = path.join(here, 'data', 'pinned_first.json');
const pinnedFirst = fs.existsSync(pinnedFile) ? JSON.parse(fs.readFileSync(pinnedFile, 'utf8')) : [];
const ordered = orderLevels(levels, { pinnedFirst });
const labels = difficultyLabels(ordered);
const order = ordered.map((it, i) => {
  it.level.level = i + 1;
  it.level.difficulty = `${labels[i]}/10`;
  return [it.level, it.source];
});

fs.mkdirSync(outDir, { recursive: true });
fs.writeFileSync(path.join(outDir, 'levels.json'), JSON.stringify(order.map(([l]) => l), null, 1) + '\n');
fs.writeFileSync(path.join(outDir, 'sources.json'), JSON.stringify(order.map(([, s]) => s), null, 1) + '\n');
console.log(`${order.length} màn → ${outDir}`);

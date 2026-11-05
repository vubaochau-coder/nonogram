// Chuyển dữ liệu màn chơi (dump bảng `puzzles` từ Supabase, hoặc file mẫu)
// thành các file gói trong assets/levels/.
//
// Cách dùng:
//   dart run tools/build_levels.dart <input.json> [tuỳ chọn]
//
// Tuỳ chọn:
//   --out=assets/levels     Thư mục ghi kết quả (mặc định assets/levels)
//   --pack-size=100         Số màn mỗi gói (mặc định 100)
//   --status=published      Chỉ lấy các màn có status này (mặc định: lấy hết)
//   --renumber              Đánh số lại level liên tục từ 1 theo thứ tự level cũ
//                           (dùng khi lọc bớt màn làm level bị hổng)
//   --skip-unique-check     Bỏ kiểm tra nghiệm duy nhất (nhanh hơn)
//   --drop-invalid          Bỏ qua màn lỗi/không duy nhất thay vì dừng lại
//
// Đầu vào là một mảng JSON (hoặc {"data": [...]}, như file của
// tools/crawl_json.js). Mỗi phần tử cần `level` và `solution`; `solution` là
// ma trận số (như cột jsonb trên Supabase) hoặc mảng chuỗi "0101...".
// Các trường khác được giữ nếu có: source_puzzle_id, title, author,
// difficulty, difficulty_score, rows, cols, status.

import 'dart:convert';
import 'dart:io';

import 'package:nonogram/models/nonogram_puzzle.dart';
import 'package:nonogram/screens/play/engine/nonogram_solver.dart';

void main(List<String> args) {
  final positional = args.where((a) => !a.startsWith('--')).toList();
  if (positional.length != 1 || args.contains('--help')) {
    stderr.writeln(
      'Usage: dart run tools/build_levels.dart <input.json> '
      '[--out=assets/levels] [--pack-size=100] [--status=published] '
      '[--renumber] [--skip-unique-check] [--drop-invalid]',
    );
    exit(64);
  }

  String? option(String name) {
    final prefix = '--$name=';
    for (final a in args) {
      if (a.startsWith(prefix)) return a.substring(prefix.length);
    }
    return null;
  }

  final outDir = Directory(option('out') ?? 'assets/levels');
  final packSize = int.parse(option('pack-size') ?? '100');
  final status = option('status');
  final renumber = args.contains('--renumber');
  final checkUnique = !args.contains('--skip-unique-check');
  final dropInvalid = args.contains('--drop-invalid');

  dynamic decoded = jsonDecode(File(positional.single).readAsStringSync());
  if (decoded is Map && decoded['data'] is List) decoded = decoded['data'];
  if (decoded is! List) {
    stderr.writeln('Input must be a JSON array of puzzles.');
    exit(65);
  }

  var rows = decoded.cast<Map>().map(Map<String, dynamic>.from).toList();
  if (status != null) {
    rows = rows.where((r) => r['status'] == status).toList();
  }
  rows.sort((a, b) => (a['level'] as num).compareTo(b['level'] as num));

  const solver = NonogramSolver();
  final errors = <String>[];
  final entries = <Map<String, dynamic>>[];
  final seenLevels = <int>{};
  final seenIds = <String>{};

  for (final row in rows) {
    final originalLevel = (row['level'] as num).toInt();
    final level = renumber ? entries.length + 1 : originalLevel;
    final sourceId = row['source_puzzle_id']?.toString() ?? '';
    final id =
        sourceId.isNotEmpty
            ? 'src-$sourceId'
            : 'L${originalLevel.toString().padLeft(4, '0')}';

    final entry = <String, dynamic>{
      'id': id,
      'level': level,
      'title': (row['title'] as String?)?.trim() ?? '',
      'author': row['author'] ?? '',
      'difficulty': row['difficulty'] ?? '',
      'difficultyScore':
          (row['difficulty_score'] ?? row['difficultyScore'] ?? 0) as num,
      if (row['rows'] != null) 'rows': row['rows'],
      if (row['cols'] != null) 'cols': row['cols'],
      'solution': _solutionRows(row['solution']),
    };

    String? problem;
    try {
      if (!seenLevels.add(level)) throw FormatException('duplicate level');
      if (!seenIds.add(id)) throw FormatException('duplicate id $id');
      final puzzle = NonogramPuzzle.fromAssetJson(entry);
      if (checkUnique) {
        final count = solver.countSolutions(
          rowClues: puzzle.leftClues,
          colClues: puzzle.topClues,
        );
        if (count != 1) {
          throw FormatException('has $count+ solutions (not unique)');
        }
      }
    } on Object catch (e) {
      problem = 'level $originalLevel ($id): $e';
    }

    if (problem != null) {
      errors.add(problem);
      if (renumber && dropInvalid) seenLevels.remove(level);
      if (dropInvalid) continue;
    }
    entries.add(entry);
  }

  if (errors.isNotEmpty) {
    stderr.writeln('${errors.length} problem(s):');
    for (final e in errors) {
      stderr.writeln('  - $e');
    }
    if (!dropInvalid) {
      stderr.writeln('Nothing written. Fix the data or pass --drop-invalid.');
      exit(1);
    }
  }

  if (entries.isEmpty) {
    stderr.writeln('No puzzles to write.');
    exit(1);
  }

  for (var i = 0; i < entries.length; i++) {
    if (entries[i]['level'] != i + 1) {
      stderr.writeln(
        'Levels must be contiguous from 1, but position ${i + 1} is level '
        '${entries[i]['level']}. Pass --renumber to renumber them.',
      );
      exit(1);
    }
  }

  outDir.createSync(recursive: true);
  for (final f in outDir.listSync().whereType<File>()) {
    if (RegExp(r'(pack_\d+|index)\.json$').hasMatch(f.path)) f.deleteSync();
  }

  final packs = <Map<String, dynamic>>[];
  const encoder = JsonEncoder.withIndent(null);
  for (var start = 0; start < entries.length; start += packSize) {
    final chunk = entries.sublist(
      start,
      (start + packSize).clamp(0, entries.length),
    );
    final file = 'pack_${(packs.length + 1).toString().padLeft(3, '0')}.json';
    // Mỗi màn một dòng để diff trên git dễ đọc.
    final body = StringBuffer('{"version":1,"puzzles":[\n');
    for (var i = 0; i < chunk.length; i++) {
      body.write(encoder.convert(chunk[i]));
      body.write(i == chunk.length - 1 ? '\n' : ',\n');
    }
    body.write(']}\n');
    File('${outDir.path}/$file').writeAsStringSync(body.toString());
    packs.add({
      'file': file,
      'firstLevel': chunk.first['level'],
      'lastLevel': chunk.last['level'],
    });
  }

  final index = {'version': 1, 'totalLevels': entries.length, 'packs': packs};
  File(
    '${outDir.path}/index.json',
  ).writeAsStringSync('${const JsonEncoder.withIndent('  ').convert(index)}\n');

  stdout.writeln(
    'Wrote ${entries.length} levels in ${packs.length} pack(s) to '
    '${outDir.path}${errors.isEmpty ? '' : ' (dropped ${errors.length})'}.',
  );
}

/// Chuẩn hoá solution về mảng chuỗi "0101..." (ô > 0 coi là tô).
List<String> _solutionRows(dynamic solution) {
  if (solution is String) solution = jsonDecode(solution);
  if (solution is! List) return const [];
  return [
    for (final row in solution)
      if (row is String)
        row
      else if (row is List)
        row.map((cell) => (cell as num) > 0 ? '1' : '0').join()
      else
        '',
  ];
}

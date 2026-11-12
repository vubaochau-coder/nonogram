// Chuyển dữ liệu màn chơi (tools/image_levels/out/levels.json, hoặc file mẫu)
// thành các file gói trong assets/levels/.
//
// Cách dùng:
//   dart run tools/build_levels.dart <input.json|input.csv> [tuỳ chọn]
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
// Đầu vào là một mảng JSON (hoặc {"data": [...]}), hoặc file CSV (dòng đầu là
// tên cột, cột kiểu JSON là chuỗi JSON). Mỗi phần tử cần `level` và `solution`;
// `solution` là ma trận số hoặc mảng chuỗi "0101...".
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

  final inputPath = positional.single;
  final inputText = File(inputPath).readAsStringSync();
  dynamic decoded =
      inputPath.toLowerCase().endsWith('.csv')
          ? _parseCsvRecords(inputText)
          : jsonDecode(inputText);
  if (decoded is Map && decoded['data'] is List) decoded = decoded['data'];
  if (decoded is! List) {
    stderr.writeln('Input must be a JSON array of puzzles.');
    exit(65);
  }

  var rows = decoded.cast<Map>().map(Map<String, dynamic>.from).toList();
  if (status != null) {
    rows = rows.where((r) => r['status'] == status).toList();
  }
  rows.sort((a, b) => _asInt(a['level']).compareTo(_asInt(b['level'])));

  const solver = NonogramSolver();
  final errors = <String>[];
  final entries = <Map<String, dynamic>>[];
  final seenLevels = <int>{};
  final seenIds = <String>{};

  for (final row in rows) {
    final originalLevel = _asInt(row['level']);
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
      'difficultyScore': _asNum(
        row['difficulty_score'] ?? row['difficultyScore'],
      ),
      if (row['rows'] != null && '${row['rows']}'.isNotEmpty)
        'rows': _asInt(row['rows']),
      if (row['cols'] != null && '${row['cols']}'.isNotEmpty)
        'cols': _asInt(row['cols']),
      'solution': _solutionRows(row['solution']),
      // Ô ghim sẵn: danh sách [hàng, cột], xem docs/level_format.md.
      if (row['pinned'] is List && (row['pinned'] as List).isNotEmpty)
        'pinned': row['pinned'],
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
          fixedCells: puzzle.pinnedValues,
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

int _asInt(dynamic value) =>
    value is num ? value.toInt() : int.parse('$value'.trim());

num _asNum(dynamic value) {
  if (value is num) return value;
  return num.tryParse('${value ?? ''}'.trim()) ?? 0;
}

/// Đọc CSV (RFC 4180: trường có thể nằm trong "...", "" là dấu nháy) thành
/// danh sách map theo tên cột ở dòng đầu.
List<Map<String, dynamic>> _parseCsvRecords(String text) {
  final records = <List<String>>[];
  var record = <String>[];
  final field = StringBuffer();
  var inQuotes = false;

  for (var i = 0; i < text.length; i++) {
    final ch = text[i];
    if (inQuotes) {
      if (ch == '"') {
        if (i + 1 < text.length && text[i + 1] == '"') {
          field.write('"');
          i++;
        } else {
          inQuotes = false;
        }
      } else {
        field.write(ch);
      }
    } else if (ch == '"') {
      inQuotes = true;
    } else if (ch == ',') {
      record.add(field.toString());
      field.clear();
    } else if (ch == '\n' || ch == '\r') {
      if (ch == '\r' && i + 1 < text.length && text[i + 1] == '\n') i++;
      record.add(field.toString());
      field.clear();
      if (record.any((f) => f.isNotEmpty)) records.add(record);
      record = <String>[];
    } else {
      field.write(ch);
    }
  }
  if (field.isNotEmpty || record.isNotEmpty) {
    record.add(field.toString());
    if (record.any((f) => f.isNotEmpty)) records.add(record);
  }
  if (records.isEmpty) return const [];

  final header = records.first;
  return [
    for (final values in records.skip(1))
      {
        for (var c = 0; c < header.length; c++)
          header[c]: c < values.length ? values[c] : '',
      },
  ];
}

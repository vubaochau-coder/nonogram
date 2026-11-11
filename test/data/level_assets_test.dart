import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/core/play_mode.dart';
import 'package:nonogram/data/nonogram_puzzle_source.dart';
import 'package:nonogram/screens/play/engine/nonogram_solver.dart';

/// Kiểm tra toàn bộ dữ liệu màn chơi đóng gói trong app: bộ màn có bản quyền
/// (assets/levels/, chế độ người dùng) và bộ màn của chế độ nhà phát triển
/// (assets/levels_dev/, chỉ có ở flavor dev).
/// Dữ liệu nằm trong app nên lỗi ở đây chỉ sửa được bằng bản phát hành mới.
void main() {
  for (final mode in PlayMode.values) {
    group(mode.levelsPath, () => _checkLevels(Directory(mode.levelsPath)));
  }
}

void _checkLevels(Directory dir) {
  final index = NonogramLevelIndex.fromJson(
    jsonDecode(File('${dir.path}/index.json').readAsStringSync()),
  );

  test('index covers levels 1..totalLevels', () {
    expect(index.totalLevels, greaterThan(0));
    expect(index.packs.first.firstLevel, 1);
    expect(index.packs.last.lastLevel, index.totalLevels);
  });

  test('no stray pack files', () {
    final listed = index.packs.map((p) => p.file).toSet();
    final onDisk =
        dir
            .listSync()
            .whereType<File>()
            .map((f) => f.uri.pathSegments.last)
            .where((name) => name.startsWith('pack_'))
            .toSet();
    expect(onDisk, listed);
  });

  for (final pack in index.packs) {
    test(
      '${pack.file}: valid, matches index, unique ids, unique solutions',
      () {
        final puzzles = AssetNonogramPuzzleSource.parsePack(
          jsonDecode(File('${dir.path}/${pack.file}').readAsStringSync()),
        );

        expect(puzzles.keys.toList()..sort(), [
          for (var l = pack.firstLevel; l <= pack.lastLevel; l++) l,
        ]);

        const solver = NonogramSolver();
        for (final puzzle in puzzles.values) {
          expect(
            solver.countSolutions(
              rowClues: puzzle.leftClues,
              colClues: puzzle.topClues,
            ),
            1,
            reason:
                'level ${puzzle.level} (${puzzle.id}) must have exactly one '
                'solution',
          );
        }
      },
    );
  }

  test('puzzle ids are unique across packs', () {
    final ids = <String>{};
    for (final pack in index.packs) {
      final raw = jsonDecode(
        File('${dir.path}/${pack.file}').readAsStringSync(),
      );
      for (final p in raw['puzzles'] as List) {
        expect(ids.add(p['id'] as String), isTrue, reason: 'dup ${p['id']}');
      }
    }
  });
}

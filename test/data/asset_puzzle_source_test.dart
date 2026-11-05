import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/data/nonogram_puzzle_source.dart';
import 'package:nonogram/models/nonogram_puzzle.dart';

class _MapBundle extends CachingAssetBundle {
  _MapBundle(this.files);

  final Map<String, String> files;
  final loads = <String>[];

  @override
  Future<ByteData> load(String key) async {
    loads.add(key);
    final value = files[key];
    if (value == null) throw FlutterError('missing $key');
    return ByteData.sublistView(utf8.encode(value));
  }
}

String _pack(List<int> levels) => jsonEncode({
  'puzzles': [
    for (final l in levels)
      {
        'id': 'L$l',
        'level': l,
        'title': 'T$l',
        'solution': ['10', '01'],
      },
  ],
});

void main() {
  late _MapBundle bundle;
  late AssetNonogramPuzzleSource source;

  setUp(() {
    bundle = _MapBundle({
      'assets/levels/index.json': jsonEncode({
        'totalLevels': 3,
        'packs': [
          {'file': 'pack_001.json', 'firstLevel': 1, 'lastLevel': 2},
          {'file': 'pack_002.json', 'firstLevel': 3, 'lastLevel': 3},
        ],
      }),
      'assets/levels/pack_001.json': _pack([1, 2]),
      'assets/levels/pack_002.json': _pack([3]),
    });
    source = AssetNonogramPuzzleSource(bundle: bundle);
  });

  test('loads a level from the right pack and derives clues', () async {
    final puzzle = await source.puzzleByLevel(3);
    expect(puzzle!.id, 'L3');
    expect(puzzle.rows, 2);
    expect(puzzle.cols, 2);
    expect(puzzle.leftClues, [
      [1],
      [1],
    ]);
    expect(puzzle.topClues, [
      [1],
      [1],
    ]);
    expect(bundle.loads, isNot(contains('assets/levels/pack_001.json')));
  });

  test('returns null outside the range', () async {
    expect(await source.totalLevels(), 3);
    expect(await source.puzzleByLevel(0), isNull);
    expect(await source.puzzleByLevel(4), isNull);
  });

  test('parses each pack only once', () async {
    await source.puzzleByLevel(1);
    await source.puzzleByLevel(2);
    expect(bundle.loads.where((k) => k.endsWith('pack_001.json')).length, 1);
  });

  group('validation', () {
    test('rejects packs that do not cover levels contiguously', () {
      expect(
        () => NonogramLevelIndex.fromJson({
          'totalLevels': 3,
          'packs': [
            {'file': 'a', 'firstLevel': 1, 'lastLevel': 1},
            {'file': 'b', 'firstLevel': 3, 'lastLevel': 3},
          ],
        }),
        throwsFormatException,
      );
    });

    test('rejects ragged or non-binary solutions', () {
      expect(
        () => NonogramPuzzle.fromAssetJson({
          'id': 'x',
          'level': 1,
          'solution': ['10', '011'],
        }),
        throwsFormatException,
      );
      expect(
        () => NonogramPuzzle.fromAssetJson({
          'id': 'x',
          'level': 1,
          'solution': ['12'],
        }),
        throwsFormatException,
      );
    });

    test('rejects declared size that does not match the solution', () {
      expect(
        () => NonogramPuzzle.fromAssetJson({
          'id': 'x',
          'level': 1,
          'rows': 3,
          'solution': ['10', '01'],
        }),
        throwsFormatException,
      );
    });
  });
}

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:nonogram/models/nonogram_puzzle.dart';

/// Nguồn dữ liệu màn chơi.
abstract class NonogramPuzzleSource {
  /// Tổng số màn có trong game.
  Future<int> totalLevels();

  /// Màn theo số thứ tự (bắt đầu từ 1), `null` nếu không tồn tại.
  Future<NonogramPuzzle?> puzzleByLevel(int level);
}

/// Đọc màn chơi đóng gói sẵn trong `assets/levels/`.
///
/// `index.json` liệt kê các gói; mỗi gói chỉ được đọc và parse khi cần tới,
/// sau đó giữ trong bộ nhớ.
class AssetNonogramPuzzleSource implements NonogramPuzzleSource {
  AssetNonogramPuzzleSource({
    AssetBundle? bundle,
    this.basePath = 'assets/levels',
  }) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;
  final String basePath;

  Future<NonogramLevelIndex>? _index;
  final Map<String, Future<Map<int, NonogramPuzzle>>> _packs = {};

  Future<NonogramLevelIndex> index() {
    return _index ??= _bundle
        .loadString('$basePath/index.json')
        .then((raw) => NonogramLevelIndex.fromJson(jsonDecode(raw)));
  }

  @override
  Future<int> totalLevels() async => (await index()).totalLevels;

  @override
  Future<NonogramPuzzle?> puzzleByLevel(int level) async {
    final pack = (await index()).packForLevel(level);
    if (pack == null) return null;
    final puzzles = await loadPack(pack.file);
    return puzzles[level];
  }

  /// Đọc toàn bộ một gói, key là level.
  Future<Map<int, NonogramPuzzle>> loadPack(String file) {
    return _packs[file] ??= _bundle
        .loadString('$basePath/$file')
        .then((raw) => parsePack(jsonDecode(raw)));
  }

  static Map<int, NonogramPuzzle> parsePack(dynamic json) {
    if (json is! Map || json['puzzles'] is! List) {
      throw const FormatException('Pack must be {"puzzles": [...]}');
    }
    final result = <int, NonogramPuzzle>{};
    for (final raw in json['puzzles'] as List) {
      final puzzle = NonogramPuzzle.fromAssetJson(
        Map<String, dynamic>.from(raw as Map),
      );
      if (result.containsKey(puzzle.level)) {
        throw FormatException('Duplicate level ${puzzle.level}');
      }
      result[puzzle.level] = puzzle;
    }
    return result;
  }
}

class NonogramLevelPack {
  const NonogramLevelPack({
    required this.file,
    required this.firstLevel,
    required this.lastLevel,
  });

  final String file;
  final int firstLevel;
  final int lastLevel;

  bool contains(int level) => level >= firstLevel && level <= lastLevel;
}

class NonogramLevelIndex {
  const NonogramLevelIndex({required this.totalLevels, required this.packs});

  final int totalLevels;
  final List<NonogramLevelPack> packs;

  NonogramLevelPack? packForLevel(int level) {
    for (final pack in packs) {
      if (pack.contains(level)) return pack;
    }
    return null;
  }

  factory NonogramLevelIndex.fromJson(dynamic json) {
    if (json is! Map || json['packs'] is! List) {
      throw const FormatException('index.json must contain "packs"');
    }
    final packs = [
      for (final raw in json['packs'] as List)
        NonogramLevelPack(
          file: raw['file'] as String,
          firstLevel: raw['firstLevel'] as int,
          lastLevel: raw['lastLevel'] as int,
        ),
    ]..sort((a, b) => a.firstLevel.compareTo(b.firstLevel));

    final total = json['totalLevels'] as int;
    var expected = 1;
    for (final pack in packs) {
      if (pack.firstLevel != expected || pack.lastLevel < pack.firstLevel) {
        throw FormatException(
          'Packs must cover levels contiguously from 1; '
          '${pack.file} starts at ${pack.firstLevel}, expected $expected',
        );
      }
      expected = pack.lastLevel + 1;
    }
    if (expected - 1 != total) {
      throw FormatException(
        'totalLevels=$total but packs cover ${expected - 1} levels',
      );
    }
    return NonogramLevelIndex(totalLevels: total, packs: packs);
  }
}

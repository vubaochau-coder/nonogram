import 'package:flutter_test/flutter_test.dart';

import '../../tools/check_conventions.dart';

void main() {
  group('lineCount', () {
    test('ignores trailing blank lines', () {
      expect(lineCount(''), 0);
      expect(lineCount('a\nb\n\n\n'), 2);
    });
  });

  group('file length', () {
    test('300 lines is fine, 301 is not', () {
      expect(checkLength('lib/a.dart', 300, {}), isNull);
      expect(checkLength('lib/a.dart', 301, {}), isNotNull);
    });

    test('generated files are exempt', () {
      for (final path in [
        'lib/l10n/app_localizations.dart',
        'lib/l10n/app_localizations_vi.dart',
        'lib/models/board.g.dart',
      ]) {
        expect(checkLength(path, 5000, {}), isNull, reason: path);
      }
    });
  });

  group('baseline', () {
    const baseline = {'lib/big.dart': 900};

    test('a listed file may stay or shrink, not grow', () {
      expect(checkLength('lib/big.dart', 900, baseline), isNull);
      expect(checkLength('lib/big.dart', 500, baseline), isNull);
      expect(checkLength('lib/big.dart', 901, baseline), isNotNull);
    });

    test('a listed file that fits the limit must leave the list', () {
      expect(checkLength('lib/big.dart', 300, baseline), isNotNull);
    });

    test('a listed file that does not exist is reported, not an error', () {
      final files = {'lib/other.dart': 10};
      expect(checkLengths(files, baseline), isEmpty);
      expect(missingBaselineFiles(files, baseline), ['lib/big.dart']);
    });

    test('parses paths, limits and comments', () {
      final parsed = parseBaseline('''
# header
lib/a.dart 400
test/b_test.dart   950  # trailing comment

''');
      expect(parsed, {'lib/a.dart': 400, 'test/b_test.dart': 950});
    });

    test('rejects malformed lines', () {
      expect(() => parseBaseline('lib/a.dart'), throwsFormatException);
      expect(() => parseBaseline('lib/a.dart many'), throwsFormatException);
    });
  });

  group('lib/engine/ is pure Dart', () {
    List<Violation> check(String import) =>
        checkImports('lib/engine/nonogram_engine.dart', "import '$import';\n");

    test('rejects Flutter and dart:ui', () {
      expect(check('package:flutter/painting.dart'), hasLength(1));
      expect(check('package:flutter_bloc/flutter_bloc.dart'), hasLength(1));
      expect(check('dart:ui'), hasLength(1));
    });

    test('rejects app code outside lib/engine/', () {
      expect(check('package:nonogram/core/app_theme.dart'), hasLength(1));
      expect(check('../core/app_theme.dart'), hasLength(1));
    });

    test('allows Dart SDK, pure packages and engine code', () {
      expect(check('dart:math'), isEmpty);
      expect(check('package:collection/collection.dart'), isEmpty);
      expect(
        check('package:nonogram/engine/model/nonogram_puzzle.dart'),
        isEmpty,
      );
      expect(check('model/nonogram_puzzle.dart'), isEmpty);
    });
  });

  test('tools/ may only use lib/engine/ from the app', () {
    List<Violation> check(String import) =>
        checkImports('tools/build_levels.dart', "import '$import';\n");

    expect(check('package:nonogram/engine/nonogram_solver.dart'), isEmpty);
    expect(
      check('package:nonogram/data/nonogram_repository.dart'),
      hasLength(1),
    );
    expect(check('package:flutter/material.dart'), isEmpty);
  });

  test('other folders may import anything', () {
    final source = "import 'package:flutter/material.dart';\n";
    expect(checkImports('lib/screens/play/a.dart', source), isEmpty);
  });
}

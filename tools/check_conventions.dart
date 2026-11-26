// Checks the repo conventions from docs/conventions.md that a machine can
// verify:
//   * every Dart file in lib/, test/ and tools/ has at most 300 lines
//     (generated files excluded);
//   * files written before the rule are listed in
//     tools/conventions_baseline.txt with their current length: they may
//     shrink but not grow, and must leave the list once they fit the limit.
//     A listed file that does not exist only warns (see
//     missingBaselineFiles);
//   * lib/engine/ is pure Dart: no Flutter, no dart:ui, nothing from lib/
//     outside lib/engine/;
//   * tools/ only uses lib/engine/ from the app;
//   * screens are named *_screen.dart, never *_page.dart.
//
// Run from the repo root: dart run tools/check_conventions.dart
import 'dart:io';

const maxFileLines = 300;
const scannedRoots = ['lib', 'test', 'tools'];
const baselinePath = 'tools/conventions_baseline.txt';

/// A broken convention in one file.
class Violation {
  const Violation(this.path, this.message);

  final String path;
  final String message;

  @override
  String toString() => '$path: $message';
}

/// Generated code is exempt from the length limit.
bool isGenerated(String path) =>
    path.endsWith('.g.dart') ||
    path.endsWith('.freezed.dart') ||
    RegExp(r'^lib/l10n/app_localizations(_\w+)?\.dart$').hasMatch(path);

/// Number of lines in [source], ignoring trailing blank lines.
int lineCount(String source) =>
    source.trim().isEmpty ? 0 : source.trimRight().split('\n').length;

/// Parses the baseline: one `<path> <max lines>` per line, `#` comments.
Map<String, int> parseBaseline(String text) {
  final baseline = <String, int>{};
  for (final raw in text.split('\n')) {
    final line = raw.split('#').first.trim();
    if (line.isEmpty) continue;
    final parts = line.split(RegExp(r'\s+'));
    final limit = parts.length == 2 ? int.tryParse(parts[1]) : null;
    if (limit == null) {
      throw FormatException('Bad baseline line: "$raw"');
    }
    baseline[parts[0]] = limit;
  }
  return baseline;
}

/// Checks the length of one file. [path] is repo-relative and uses `/`.
Violation? checkLength(String path, int lines, Map<String, int> baseline) {
  if (isGenerated(path)) return null;
  final allowed = baseline[path];
  if (allowed == null) {
    if (lines <= maxFileLines) return null;
    return Violation(
      path,
      '$lines lines, max is $maxFileLines: split the file',
    );
  }
  if (lines <= maxFileLines) {
    return Violation(
      path,
      '$lines lines now fits the limit: remove it from $baselinePath',
    );
  }
  if (lines > allowed) {
    return Violation(
      path,
      '$lines lines, baseline allows $allowed: split the file instead of '
      'growing it',
    );
  }
  return null;
}

final _directive = RegExp(
  r'''^\s*(?:import|export)\s+['"]([^'"]+)['"]''',
  multiLine: true,
);

/// URIs of all `import` / `export` directives in [source].
List<String> directivesOf(String source) =>
    _directive.allMatches(source).map((m) => m.group(1)!).toList();

/// Resolves [uri] imported from the file at [path] to a repo-relative path,
/// or returns `null` for `dart:` and third-party packages.
String? resolveToRepoPath(String path, String uri) {
  const self = 'package:nonogram/';
  if (uri.startsWith(self)) return 'lib/${uri.substring(self.length)}';
  if (uri.contains(':')) return null;
  final resolved = Uri.parse(path).resolve(uri).path;
  return resolved.startsWith('/') ? resolved.substring(1) : resolved;
}

/// Checks the imports of one file. [path] is repo-relative and uses `/`.
List<Violation> checkImports(String path, String source) => [
  for (final uri in directivesOf(source))
    if (_importProblem(path, uri) case final problem?) Violation(path, problem),
];

String? _importProblem(String path, String uri) {
  final inEngine = path.startsWith('lib/engine/');
  final inTools = path.startsWith('tools/');
  if (!inEngine && !inTools) return null;

  if (inEngine && (uri.startsWith('package:flutter') || uri == 'dart:ui')) {
    return "imports '$uri': lib/engine/ must be pure Dart";
  }
  final target = resolveToRepoPath(path, uri);
  if (target == null) return null;
  if (target.startsWith('lib/') && !target.startsWith('lib/engine/')) {
    final who = inEngine ? 'lib/engine/' : 'tools/';
    return "imports '$uri': $who may only use lib/engine/ from the app";
  }
  return null;
}

/// Screens are `*_screen.dart`; the old `*_page.dart` naming is rejected.
Violation? checkFileName(String path) =>
    RegExp(r'_page(_test)?\.dart$').hasMatch(path)
    ? Violation(path, 'name screens *_screen.dart, not *_page.dart')
    : null;

/// Checks [files] (repo-relative path -> line count) against [baseline].
List<Violation> checkLengths(
  Map<String, int> files,
  Map<String, int> baseline,
) => [
  for (final entry in files.entries)
    ?checkLength(entry.key, entry.value, baseline),
];

/// Baseline entries whose file does not exist. Only a warning: a file can be
/// deleted or renamed in the same change that forgets to update the list.
List<String> missingBaselineFiles(
  Map<String, int> files,
  Map<String, int> baseline,
) => [
  for (final path in baseline.keys)
    if (!files.containsKey(path)) path,
];

/// Sources of every Dart file under [scannedRoots] in [repoRoot], keyed by
/// repo-relative path.
Map<String, String> scanRepo(Directory repoRoot) {
  final files = <String, String>{};
  for (final root in scannedRoots) {
    final dir = Directory('${repoRoot.path}/$root');
    if (!dir.existsSync()) continue;
    final dartFiles = dir
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'));
    for (final file in dartFiles) {
      final path = file.path
          .substring(repoRoot.path.length + 1)
          .replaceAll(r'\', '/');
      files[path] = file.readAsStringSync();
    }
  }
  return files;
}

void main() {
  final root = Directory.current;
  final baselineFile = File('${root.path}/$baselinePath');
  final baseline = baselineFile.existsSync()
      ? parseBaseline(baselineFile.readAsStringSync())
      : <String, int>{};
  final sources = scanRepo(root);
  final lengths = sources.map((path, src) => MapEntry(path, lineCount(src)));
  for (final path in missingBaselineFiles(lengths, baseline)) {
    stdout.writeln('warning: $path is in $baselinePath but does not exist');
  }
  final violations = [
    ...checkLengths(lengths, baseline),
    for (final MapEntry(key: path, value: src) in sources.entries) ...[
      ...checkImports(path, src),
      ?checkFileName(path),
    ],
  ];
  if (violations.isEmpty) {
    stdout.writeln('Conventions OK (${baseline.length} file(s) in baseline).');
    return;
  }
  violations.forEach(stderr.writeln);
  stderr.writeln('${violations.length} convention violation(s).');
  exitCode = 1;
}

// Checks the repo conventions from docs/conventions.md that a machine can
// verify:
//   * every Dart file in lib/, test/ and tools/ has at most 300 lines
//     (generated files excluded);
//   * files written before the rule are listed in
//     tools/conventions_baseline.txt with their current length: they may
//     shrink but not grow, and must leave the list once they fit the limit.
//     A listed file that does not exist only warns (see
//     missingBaselineFiles).
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

/// Checks [files] (repo-relative path -> line count) against [baseline].
List<Violation> checkLengths(
  Map<String, int> files,
  Map<String, int> baseline,
) => [
  for (final entry in files.entries)
    ?checkLength(entry.key, entry.value, baseline),
];

/// Baseline entries whose file does not exist. Only a warning: `main` has
/// no tester code, so it shares the baseline with `develop` but lacks some
/// of its files.
List<String> missingBaselineFiles(
  Map<String, int> files,
  Map<String, int> baseline,
) => [
  for (final path in baseline.keys)
    if (!files.containsKey(path)) path,
];

/// Line counts of every Dart file under [scannedRoots] in [repoRoot].
Map<String, int> scanRepo(Directory repoRoot) {
  final files = <String, int>{};
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
      files[path] = lineCount(file.readAsStringSync());
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
  final files = scanRepo(root);
  for (final path in missingBaselineFiles(files, baseline)) {
    stdout.writeln('warning: $path is in $baselinePath but does not exist');
  }
  final violations = checkLengths(files, baseline);
  if (violations.isEmpty) {
    stdout.writeln('Conventions OK (${baseline.length} file(s) in baseline).');
    return;
  }
  violations.forEach(stderr.writeln);
  stderr.writeln('${violations.length} convention violation(s).');
  exitCode = 1;
}

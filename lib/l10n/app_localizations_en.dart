// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Nonopix';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonSave => 'Save';

  @override
  String nonogramDashboardContinueLevel(int level) {
    return 'Level $level';
  }

  @override
  String get nonogramDashboardProgressSectionTitle => 'Your Progress';

  @override
  String get nonogramDashboardStatCompleted => 'Completed';

  @override
  String get nonogramGuideIntro =>
      'Nonograms are logic puzzles with simple rules and challenging solutions. The goal is to reveal hidden pictures by filling cells based on numbers on the side of the grid.';

  @override
  String get nonogramGuideMethodDivisionDesc =>
      'If joining two existing blocks would create a figure larger than any available clue, the gap between them must be an X.';

  @override
  String get nonogramGuideMethodDivisionTitle => '5. Division';

  @override
  String get nonogramGuideMethodDoublePositioningDesc =>
      'If a painted cell can only belong to a few specific block variants, any cells that are never filled in any of those variants must be marked with X.';

  @override
  String get nonogramGuideMethodDoublePositioningTitle =>
      '6. Double positioning';

  @override
  String get nonogramGuideMethodInaccessibilityDesc =>
      'Mark cells that cannot possibly belong to any remaining figure with a cross (X).';

  @override
  String get nonogramGuideMethodInaccessibilityTitle => '3. Inaccessibility';

  @override
  String get nonogramGuideMethodNotFitDesc =>
      'If an empty space between crosses is smaller than any available clue for that line, it must be marked with X.';

  @override
  String get nonogramGuideMethodNotFitTitle => '4. Doesn\'t fit in';

  @override
  String get nonogramGuideMethodSuperpositionMultiDesc =>
      'When there are several numbers, superpose the extreme left and right positions of the entire group, accounting for the mandatory minimum one-square gap between same-color blocks. Squares where a group overlaps with its own range in both variants are painted.';

  @override
  String get nonogramGuideMethodSuperpositionMultiTitle =>
      'Superposition (Multiple Clues)';

  @override
  String get nonogramGuideMethodSuperpositionSimpleDesc =>
      'If a number makes more than half of the length, some squares in the middle will definitely be painted. Superpose the extreme left and extreme right positions; where they overlap, the squares are painted.';

  @override
  String get nonogramGuideMethodSuperpositionSimpleTitle =>
      'Superposition (Single Clue)';

  @override
  String get nonogramGuideMethodWallPushingDesc =>
      'If a known painted cell is closer to a border than the size of the first clue, the figure it belongs to must extend away from that border.';

  @override
  String get nonogramGuideMethodWallPushingTitle =>
      '2. Pushing off from the walls';

  @override
  String get nonogramGuideRuleDesc =>
      'Each number represents one continuous block of filled cells in that row or column. If there are multiple numbers, they represent separate blocks, and each block must be separated from the next by at least one empty cell. For example, `3 1` means a block of 3 filled cells, then at least 1 empty cell, then a block of 1 filled cell.';

  @override
  String get nonogramGuideRuleTitle => 'Core rule: what the numbers mean';

  @override
  String get nonogramGuideTitle => 'How to Solve';

  @override
  String nonogramHistoryCompletedOn(String date) {
    return 'Completed on $date';
  }

  @override
  String get nonogramHistoryDetailNotFound => 'Level details not found.';

  @override
  String get nonogramHistoryEmpty => 'No completed levels yet.';

  @override
  String nonogramHistoryLevel(int n) {
    return 'Level $n';
  }

  @override
  String get nonogramHistoryTitle => 'Results';

  @override
  String get nonogramPlayActionNextLevelFixed => 'Next Level';

  @override
  String get nonogramPlayActionShowClues => 'Show clues';

  @override
  String nonogramPlayCompletionMessage(int level) {
    return 'Congratulations! You have completed Level $level.';
  }

  @override
  String get nonogramPlayCompletionTitle => 'Puzzle Solved!';

  @override
  String nonogramPlayDurationFormat(int minutes, int seconds) {
    return '${minutes}m ${seconds}s';
  }

  @override
  String nonogramPlayHintLabel(int count) {
    return 'Hint $count/3';
  }

  @override
  String get nonogramPlayNoNextLevelToast => 'No next level available yet.';

  @override
  String get nonogramPlayPageTitle => 'Nonogram';

  @override
  String get nonogramSettingsCellSize => 'Cell size';

  @override
  String get nonogramSettingsCellSizeCustom => 'Custom size';

  @override
  String get nonogramSettingsCellSizeDefault => '(default)';

  @override
  String get nonogramSettingsCellSizeError => 'Size must be between 12 and 80';

  @override
  String get nonogramSettingsTitle => 'Settings';

  @override
  String get nonogramDashboardContinueNext => 'Next challenge';

  @override
  String get nonogramDashboardPlay => 'Play';

  @override
  String get nonogramDashboardResumeAction => 'Continue';

  @override
  String get nonogramDashboardInProgressBadge => 'In progress';

  @override
  String nonogramDashboardDifficulty(String value) {
    return 'Difficulty $value';
  }

  @override
  String nonogramDashboardSolvedOfTotal(int completed, int total) {
    return '$completed of $total puzzles solved';
  }

  @override
  String get nonogramDashboardStatFastest => 'Fastest';

  @override
  String get nonogramDashboardStatTotalTime => 'Total time';

  @override
  String get nonogramDashboardRecentTitle => 'Recently solved';

  @override
  String get nonogramDashboardSeeAll => 'See all';

  @override
  String get nonogramDashboardRecentEmpty =>
      'Solve your first puzzle to start your picture collection.';

  @override
  String get nonogramDashboardAllDoneTitle => 'All puzzles solved!';

  @override
  String nonogramDashboardAllDoneDesc(int total) {
    return 'You have completed all $total puzzles. Revisit your collection anytime.';
  }

  @override
  String nonogramDurationHoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String nonogramHistoryBestTime(String time) {
    return 'Best $time';
  }

  @override
  String get nonogramPlayActionDashboard => 'Home';

  @override
  String get appThemeTitle => 'Appearance';

  @override
  String get appThemeSystem => 'System';

  @override
  String get appThemeLight => 'Light';

  @override
  String get appThemeDark => 'Dark';
}

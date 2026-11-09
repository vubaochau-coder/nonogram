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
  String get appThemeLight => 'Light';

  @override
  String get appThemeDark => 'Dark';

  @override
  String get nonogramPlayModeFill => 'Fill mode';

  @override
  String get nonogramPlayModeMark => 'Mark X mode';

  @override
  String get nonogramSettingsRestart => 'Restart this level';

  @override
  String get nonogramSettingsRestartConfirmTitle => 'Restart this level?';

  @override
  String get nonogramSettingsRestartConfirmMessage =>
      'All cells you have filled or marked will be cleared.';

  @override
  String get commonClose => 'Close';

  @override
  String get nonogramSettingsRestartConfirm => 'Restart';

  @override
  String get nonogramTutorialTitle => 'How to play';

  @override
  String get nonogramTutorialSkip => 'Skip';

  @override
  String get nonogramTutorialWelcomeTitle => 'Welcome to Nonopix!';

  @override
  String get nonogramTutorialWelcome =>
      'Let\'s learn the basic rules with a small 5×5 puzzle.';

  @override
  String get nonogramTutorialStart => 'Start';

  @override
  String get nonogramTutorialSwitchToFill =>
      'Puzzles are solved by filling in squares. Tap the button below to switch to fill mode.';

  @override
  String get nonogramTutorialClueIsCount =>
      'The number tells you how many squares in the row are filled. This row has 5, so fill them all!';

  @override
  String get nonogramTutorialEdgeCell =>
      'The last square is already filled. The block of 4 must include it, so there is only one way to place it: fill the 3 squares to its left.';

  @override
  String get nonogramTutorialMultipleClues =>
      'More than one number means more than one block, with at least one empty square between them. 2 2 fits these 5 squares in only one way.';

  @override
  String get nonogramTutorialClueOrder =>
      'Order matters too: 3 1 means the block of 3 comes first, then the block of 1.';

  @override
  String get nonogramTutorialColumns =>
      'Columns have numbers too, read from top to bottom. Switch to X mode to mark squares that must stay empty.';

  @override
  String get nonogramTutorialMarkEmpty =>
      'Columns with a ✓ already have all their squares. Mark their remaining empty squares with an X.';

  @override
  String get nonogramTutorialOneCellLeft =>
      'The 1 in the last row now has only one place left. Switch back to fill mode.';

  @override
  String get nonogramTutorialFinish =>
      'Fill the last square to finish the puzzle!';

  @override
  String get nonogramTutorialDoneTitle => 'Well done!';

  @override
  String get nonogramTutorialDone =>
      'You\'re all set! On big puzzles, drag with two fingers (or from the empty space outside the grid) to move the board; the app will remind you on your first big puzzle.';

  @override
  String get nonogramTutorialShowTechniques => 'See solving techniques';

  @override
  String get nonogramTutorialPlay => 'Start playing';

  @override
  String get nonogramGuideTutorialCardTitle => 'Learn by playing';

  @override
  String get nonogramGuideTutorialCardDesc =>
      'Learn the rules and controls step by step on a small 5×5 puzzle.';

  @override
  String get nonogramPlayInfoHide => 'Hide level info';

  @override
  String get nonogramPlayWandLabel => 'Magic wand';

  @override
  String get nonogramPlayWandSelectPrompt =>
      'Tap the clues of the row or column to reveal';

  @override
  String get nonogramPlayWandRowSolved =>
      'This row is already correct. Pick another row or column.';

  @override
  String get nonogramPlayWandColSolved =>
      'This column is already correct. Pick another row or column.';

  @override
  String get nonogramSettingsControlsGuide => 'Controls guide';

  @override
  String get nonogramCoachSkip => 'Skip';

  @override
  String get nonogramCoachNext => 'Next';

  @override
  String get nonogramCoachDone => 'Got it';

  @override
  String nonogramCoachStep(int current, int total) {
    return '$current/$total';
  }

  @override
  String get nonogramCoachHintTitle => 'Hint';

  @override
  String get nonogramCoachHintBody =>
      'The app picks a row or column and reveals its answer. You get 3 per puzzle.';

  @override
  String get nonogramCoachWandTitle => 'Magic wand';

  @override
  String get nonogramCoachWandBody =>
      'Tap the wand, then tap the clues of any row or column: the answer for exactly that line is revealed. You get 1 per puzzle.';

  @override
  String get nonogramCoachModeTitle => 'Fill or X';

  @override
  String get nonogramCoachModeBody =>
      'Choose what a tap does: fill the square, or mark it with an X to remember it is empty. Tap the button to switch. Drag across the grid to fill or mark many squares at once.';

  @override
  String get nonogramCoachLongPressTitle => 'Press and hold for the opposite';

  @override
  String get nonogramCoachLongPressBody =>
      'Press and hold a square to do the opposite of the current mode: X while filling, fill while marking. A short vibration means it\'s done and you can let go.';

  @override
  String get nonogramCoachScrollTitle => 'Moving around big puzzles';

  @override
  String get nonogramCoachScrollBody =>
      'Big puzzles don\'t fit on screen: drag with two fingers, or drag from the empty space outside the grid to move the board. Drag on the clues to see hidden numbers (the \"+N\" in the corner shows how many).';

  @override
  String get nonogramTutorialRulesDoneTitle => 'You know the rules!';

  @override
  String get nonogramTutorialRulesDone =>
      'Next, let\'s practice the controls and helpers on another puzzle: drag to fill quickly, press and hold to mark, hints and the magic wand.';

  @override
  String get nonogramTutorialContinue => 'Continue';

  @override
  String get nonogramTutorialLater => 'Later, just play';

  @override
  String get nonogramTutorialDragRow =>
      'Tip: drag your finger across squares to fill them in one go. The top row has 5, so drag across the whole row!';

  @override
  String get nonogramTutorialLongPressMark =>
      '1 1 1 fits these 5 squares exactly, so the 2nd and 4th squares must be empty. No need to switch modes: press and hold each one to mark it with an X. A short vibration means it\'s done.';

  @override
  String get nonogramTutorialUseHint =>
      'Stuck? Tap the Hint button and the app picks a row or column and reveals its answer. You get 3 per puzzle.';

  @override
  String get nonogramTutorialActivateWand =>
      'The hint revealed the highlighted column. To choose the line yourself, use the magic wand: tap the wand button.';

  @override
  String get nonogramTutorialPickWandLine =>
      'Now tap the clues of the bottom row to reveal that row. You get 1 wand per puzzle.';

  @override
  String get nonogramTutorialFinishTools =>
      'Fill the remaining squares to finish. Drag down a column to fill faster.';
}

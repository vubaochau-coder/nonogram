// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Pixel Nonogram';

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
      'If joining two filled pieces would make a block bigger than the largest number, the square between them must be empty. Mark it with X to keep them apart.';

  @override
  String get nonogramGuideMethodDivisionTitle => '5. Division';

  @override
  String get nonogramGuideMethodDoublePositioningDesc =>
      'Sometimes a filled square can belong to only one or two of the numbers. Try each possibility: squares that stay empty in every one of them get an X.';

  @override
  String get nonogramGuideMethodDoublePositioningTitle =>
      '6. Double positioning';

  @override
  String get nonogramGuideMethodInaccessibilityDesc =>
      'Squares that no block can reach are empty. Try each block at its furthest positions around the filled squares; anything outside that range gets an X.';

  @override
  String get nonogramGuideMethodInaccessibilityTitle => '3. Inaccessibility';

  @override
  String get nonogramGuideMethodNotFitDesc =>
      'A gap between X\'s (or between an X and the edge) that is shorter than every number that could go there can\'t hold a block: mark it with X.';

  @override
  String get nonogramGuideMethodNotFitTitle => '4. Doesn\'t fit in';

  @override
  String get nonogramGuideMethodSuperpositionMultiDesc =>
      'With several numbers, push the whole group left (keeping one empty square between blocks), then right. Where the same block covers a square in both positions, that square is filled. Quick check: add up the numbers and the gaps; what\'s left over is how far each block can move.';

  @override
  String get nonogramGuideMethodSuperpositionMultiTitle =>
      'Superposition (Multiple Clues)';

  @override
  String get nonogramGuideMethodSuperpositionSimpleDesc =>
      'If a number is more than half its line, part of it is always filled. Imagine the block pushed all the way left, then all the way right: the squares it covers both times are filled for sure. Example: 7 in 10 squares always fills the middle 4.';

  @override
  String get nonogramGuideMethodSuperpositionSimpleTitle =>
      'Superposition (Single Clue)';

  @override
  String get nonogramGuideMethodWallPushingDesc =>
      'A filled square near the edge limits where its block can be. The block can\'t go past the edge, so it must extend away from it. Example: 5 with the 4th square filled: even pushed against the left edge, the block still covers the 5th square.';

  @override
  String get nonogramGuideMethodWallPushingTitle =>
      '2. Pushing off from the walls';

  @override
  String get nonogramGuideRuleDesc =>
      'Each number represents one continuous block of filled cells in that row or column. If there are multiple numbers, they represent separate blocks, and each block must be separated from the next by at least one empty cell. For example, 3 1 means a block of 3 filled cells, then at least 1 empty cell, then a block of 1 filled cell.';

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
    return 'Hint ($count)';
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
      'All cells you have filled or marked will be cleared. Cells with a star (opened by hints or the wand) are kept.';

  @override
  String get commonClose => 'Close';

  @override
  String get nonogramSettingsRestartConfirm => 'Restart';

  @override
  String get nonogramTutorialTitle => 'How to play';

  @override
  String get nonogramTutorialSkip => 'Skip';

  @override
  String get nonogramTutorialWelcomeTitle => 'Welcome to Pixel Nonogram!';

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
      'Learn the rules, the controls and the main solving techniques step by step, by playing.';

  @override
  String get nonogramGuideRoutineTitle => 'Where to start';

  @override
  String get nonogramGuideRoutineTip1 =>
      'Start with the big numbers. If a number is more than half its line, part of it is already certain (see technique 1 below).';

  @override
  String get nonogramGuideRoutineTip2 =>
      'Solve the easy lines first: 0 means the whole line is empty, and if the numbers plus one gap between each add up to the line\'s length, it fits only one way.';

  @override
  String get nonogramGuideRoutineTip3 =>
      'Mark squares you know are empty with X. An X is as useful as a filled square.';

  @override
  String get nonogramGuideRoutineTip4 =>
      'Go back and forth between rows and columns. Every square you solve is a new clue for the line that crosses it.';

  @override
  String get nonogramGuideRoutineTip5 =>
      'Never guess. When you\'re stuck, look for the line with the fewest unknown squares, or use a hint.';

  @override
  String nonogramGuideExample(int number) {
    return 'Example $number';
  }

  @override
  String get nonogramGuideExampleSingle => 'Example';

  @override
  String get nonogramGuideLegendTitle => 'How to read the pictures';

  @override
  String get nonogramGuideLegendFilled => 'Filled square';

  @override
  String get nonogramGuideLegendTrial => 'Trying a block position';

  @override
  String get nonogramGuideLegendCross => 'Empty square (X)';

  @override
  String get nonogramGuideLegendResult => 'What you can deduce';

  @override
  String get nonogramGuideMethodLineDoneTitle => 'Finished lines';

  @override
  String get nonogramGuideMethodLineDoneDesc =>
      'When all the blocks of a line are in place, every other square in it is empty: mark them with X. A line with the number 0 is empty from the start.';

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
      'Fills 5 correct squares for you (squares that should be filled but aren\'t yet), picked at random across the board. They get a star: they can\'t be changed and are kept even if you restart. You get 3 per puzzle.';

  @override
  String get nonogramCoachWandTitle => 'Magic wand';

  @override
  String get nonogramCoachWandBody =>
      'Tap the wand, then tap the clues of any row or column: the answer for that whole line is revealed and marked with a star, kept even if you restart. You get 1 per puzzle.';

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
      'Stuck? Tap the Hint button and the app fills 5 correct squares at random. You get 3 per puzzle.';

  @override
  String get nonogramTutorialActivateWand =>
      'The hint filled 5 squares marked with a star: they\'re locked and kept even if you restart. To reveal a whole row or column of your choice, use the magic wand: tap the wand button.';

  @override
  String get nonogramTutorialPickWandLine =>
      'Now tap the clues of the bottom row to reveal that row. You get 1 wand per puzzle.';

  @override
  String get nonogramTutorialFinishTools =>
      'Fill the remaining squares to finish. Drag down a column to fill faster.';

  @override
  String get nonogramTutorialToolsDoneTitle => 'Controls mastered!';

  @override
  String get nonogramTutorialToolsDone =>
      'Real puzzles are bigger, and most lines can\'t be solved at a glance. Next, learn the solving techniques on an 8×8 puzzle.';

  @override
  String get nonogramTutorialOverlapSingle =>
      'Look for big numbers first. The 6 fits these 8 squares in 3 ways, and each one blinks in turn. Squares lit in every way are filled for sure: fill the 4 in the yellow frame.';

  @override
  String get nonogramTutorialOverlapMulti =>
      'Same with several numbers: 3 3 needs at least 7 squares (3 + gap + 3), so it fits in only 3 ways. Fill the squares lit in all 3.';

  @override
  String get nonogramTutorialFullRow =>
      '8 in 8 squares: the whole row is filled. Drag across it.';

  @override
  String get nonogramTutorialZeroRow =>
      '0 means the row has no filled squares at all. Switch to X mode.';

  @override
  String get nonogramTutorialMarkZeroRow =>
      'Mark the whole bottom row with X. X\'s matter: they show the columns where blocks can\'t go.';

  @override
  String get nonogramTutorialOutOfReach =>
      'Now the columns. Column 2 is one block of 3 that must cover its 2 filled squares, so it fits in only 2 ways. Squares never lit can\'t be reached: mark them with X, and the same in column 7.';

  @override
  String get nonogramTutorialBackToFill =>
      'Look at column 3: it needs 7. Switch back to fill mode.';

  @override
  String get nonogramTutorialExactSpace =>
      'The X at the bottom leaves exactly 7 squares for the 7, so fill them all. Column 6 works the same way.';

  @override
  String get nonogramTutorialFinishTechniques =>
      'That\'s the routine: solve what you can in the rows, then in the columns, and repeat. Finish the mushroom on your own!';

  @override
  String get nonogramPlayHintNothingToFill =>
      'Every square that should be filled already is. Check for extra filled squares.';

  @override
  String get settingsSound => 'Sound';

  @override
  String get settingsLicenses => 'Licenses';

  @override
  String get licensesTitle => 'Licenses';

  @override
  String get licensesLevelArtHeading => 'Puzzles';

  @override
  String get licensesLevelArtIntro =>
      'The puzzles come from these sources. Icon sets were scaled down, converted to black and white and edited so every puzzle can be solved; the nonogram collections are used as they are.';

  @override
  String get licensesFontHeading => 'Font';

  @override
  String get licensesSoftwareButton => 'Open-source software licenses';

  @override
  String licensesBy(String author) {
    return 'By $author';
  }

  @override
  String licensesLevelCount(int count) {
    return '$count puzzles';
  }

  @override
  String get adRewardNotReady =>
      'The ad isn\'t ready yet. Check your internet connection and try again.';

  @override
  String get settingsAdPrivacy => 'Ad privacy';

  @override
  String get ratingTitle => 'Enjoying Pixel Nonogram?';

  @override
  String get ratingMessage => 'Tap a star to rate the game.';

  @override
  String get ratingLater => 'Later';

  @override
  String get ratingSubmit => 'Submit';

  @override
  String get ratingThanks =>
      'Thanks for your feedback! We\'ll keep making the game better.';

  @override
  String ratingStarLabel(int count) {
    return '$count stars';
  }

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSystem => 'Device language';

  @override
  String get premiumTitle => 'Play without ads';

  @override
  String get premiumBenefitNoAds => 'No more ads between levels';

  @override
  String get premiumBenefitDaily =>
      '2 hints and 1 magic wand each day you check in';

  @override
  String premiumBuy(String price) {
    return 'Buy · $price';
  }

  @override
  String get premiumOneTime => 'One-time payment via Google Play';

  @override
  String get premiumActiveTitle => 'Ad-free pack active';

  @override
  String get premiumActiveDaily =>
      'Check in every day to get 2 hints and 1 magic wand for that day.';

  @override
  String get premiumPurchased => 'Thank you! Ads between levels are now off.';

  @override
  String get premiumPending =>
      'Your payment is pending. The pack turns on as soon as it goes through.';

  @override
  String get premiumFailed =>
      'The purchase didn\'t go through. Please try again.';

  @override
  String get checkInTitle => 'Daily check-in';

  @override
  String get checkInAction => 'Check in';

  @override
  String get checkInDoneToday => 'Checked in today';

  @override
  String get checkInCheckedIn => 'Checked in!';

  @override
  String checkInReceived(String rewards) {
    return 'You got $rewards.';
  }

  @override
  String rewardHints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hints',
      one: '1 hint',
    );
    return '$_temp0';
  }

  @override
  String rewardWands(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count magic wands',
      one: '1 magic wand',
    );
    return '$_temp0';
  }

  @override
  String rewardTodayOnly(String reward) {
    return '$reward (today only)';
  }

  @override
  String get navHome => 'Home';

  @override
  String get navMe => 'Me';

  @override
  String get meHelp => 'Help';

  @override
  String get meMore => 'More';

  @override
  String get checkInTodayButton => 'Check in today';

  @override
  String get checkInGiftToday => 'Gift today!';

  @override
  String get checkInGiftCollect => 'Collect';

  @override
  String get checkInGiftDouble => 'Collect x2';

  @override
  String checkInStreakTitle(int count) {
    return '$count-day streak';
  }

  @override
  String checkInStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String checkInStreakMakeUp(int missed, String days) {
    String _temp0 = intl.Intl.pluralLogic(
      missed,
      locale: localeName,
      other: '$missed missed days',
      one: '1 missed day',
    );
    return 'Make up $_temp0 to grow your streak to $days';
  }

  @override
  String get checkInStreakKeepGoing => 'Check in every day to keep your streak';

  @override
  String get checkInStreakAllDone => 'You got every streak gift this month!';

  @override
  String checkInStreakDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count more days for a gift',
      one: '1 more day for a gift',
    );
    return '$_temp0';
  }

  @override
  String get checkInLegendChecked => 'Checked in';

  @override
  String get checkInLegendMissed => 'Missed';

  @override
  String get checkInLegendFuture => 'Coming up';

  @override
  String checkInGiftStreak(int count) {
    return '$count-day streak gift';
  }

  @override
  String checkInMakeUpTitle(String date) {
    return 'Make up $date?';
  }

  @override
  String get checkInMakeUpBody =>
      'Watch a short ad to make up this day. Your streak will be joined back up.';

  @override
  String get checkInMakeUpWatch => 'Watch ad';

  @override
  String checkInMadeUp(String date) {
    return 'Made up $date';
  }

  @override
  String dashboardDailyReminder(String rewards, String time) {
    return 'You have $rewards that will expire in $time. Use them now so they don\'t go to waste.';
  }

  @override
  String get premiumViewBenefits => 'See what\'s included';

  @override
  String get premiumBenefitsTitle => 'Pack benefits';

  @override
  String get premiumBenefitsTagline =>
      'Buy once to remove ads between levels and get daily helper rewards, forever on your account.';

  @override
  String get premiumBenefitsOneTime => 'one-time';

  @override
  String get premiumWhatYouGet => 'What you get';

  @override
  String get premiumPerkNoAdsTitle => 'No ads between levels';

  @override
  String get premiumPerkNoAdsBody =>
      'No more full-screen ads between puzzles. Move from one level to the next without a break.';

  @override
  String get premiumPerkDailyTitle => 'Daily check-in rewards';

  @override
  String get premiumPerkDailyBody =>
      'Each check-in gives you 2 extra hints and 1 magic wand for that day, on top of the usual milestone rewards.';

  @override
  String get premiumItemsTitle => 'What the power-ups do';

  @override
  String get powerUpHintName => 'Hint';

  @override
  String get powerUpHintTagline => 'Reveals one correct cell you pick';

  @override
  String get powerUpHintDesc =>
      'Tap the lightbulb, then pick the spot you are unsure about. The app fills in one correct cell, filled or marked empty, to get you unstuck.';

  @override
  String get powerUpWandName => 'Magic wand';

  @override
  String get powerUpWandTagline => 'Solves a whole row or column';

  @override
  String get powerUpWandDesc =>
      'Tap the wand to turn on select mode, then tap the clue numbers of a row or column. The app reveals that whole row or column. Stronger than a single-cell hint.';

  @override
  String get powerUpStatesTitle => 'The icon shows the use type';

  @override
  String get powerUpStatesLead =>
      'The number in the corner is your total uses left. A time-limited use turns the icon gold with a small clock:';

  @override
  String get powerUpTimeLimited => 'Time-limited';

  @override
  String get powerUpTimeLimitedDesc =>
      'Gold icon with a clock. From the pack\'s daily check-in reward. Expires at the end of the day.';

  @override
  String get powerUpPermanent => 'Permanent';

  @override
  String get powerUpPermanentDesc =>
      'Normal icon with a blue badge. Milestone and starter uses. Never expire.';

  @override
  String get powerUpSpendOrderTitle => 'Which uses are spent first?';

  @override
  String get powerUpSpendOrderHeading => 'Time-limited uses are spent first';

  @override
  String get powerUpSpendOrderBody =>
      'Daily uses expire at the end of the day, so a hint or wand spends your daily uses first and only uses your permanent ones once the daily uses run out. Nothing goes to waste.';

  @override
  String get powerUpSpendDaily => 'Daily uses';

  @override
  String get powerUpSpendPermanent => 'Permanent uses';

  @override
  String get premiumBenefitsFootnote =>
      'Daily uses do not roll over to the next day. Milestone check-in rewards are permanent uses and build up as normal.';

  @override
  String dashboardDailyReminderBoth(String hints, String wands) {
    return '$hints and $wands';
  }
}

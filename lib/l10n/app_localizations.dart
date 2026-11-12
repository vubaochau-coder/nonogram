import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// App name
  ///
  /// In en, this message translates to:
  /// **'Nonopix'**
  String get appTitle;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @nonogramDashboardContinueLevel.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String nonogramDashboardContinueLevel(int level);

  /// No description provided for @nonogramDashboardProgressSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Progress'**
  String get nonogramDashboardProgressSectionTitle;

  /// No description provided for @nonogramDashboardStatCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get nonogramDashboardStatCompleted;

  /// No description provided for @nonogramGuideIntro.
  ///
  /// In en, this message translates to:
  /// **'Nonograms are logic puzzles with simple rules and challenging solutions. The goal is to reveal hidden pictures by filling cells based on numbers on the side of the grid.'**
  String get nonogramGuideIntro;

  /// No description provided for @nonogramGuideMethodDivisionDesc.
  ///
  /// In en, this message translates to:
  /// **'If joining two existing blocks would create a figure larger than any available clue, the gap between them must be an X.'**
  String get nonogramGuideMethodDivisionDesc;

  /// No description provided for @nonogramGuideMethodDivisionTitle.
  ///
  /// In en, this message translates to:
  /// **'5. Division'**
  String get nonogramGuideMethodDivisionTitle;

  /// No description provided for @nonogramGuideMethodDoublePositioningDesc.
  ///
  /// In en, this message translates to:
  /// **'If a painted cell can only belong to a few specific block variants, any cells that are never filled in any of those variants must be marked with X.'**
  String get nonogramGuideMethodDoublePositioningDesc;

  /// No description provided for @nonogramGuideMethodDoublePositioningTitle.
  ///
  /// In en, this message translates to:
  /// **'6. Double positioning'**
  String get nonogramGuideMethodDoublePositioningTitle;

  /// No description provided for @nonogramGuideMethodInaccessibilityDesc.
  ///
  /// In en, this message translates to:
  /// **'Mark cells that cannot possibly belong to any remaining figure with a cross (X).'**
  String get nonogramGuideMethodInaccessibilityDesc;

  /// No description provided for @nonogramGuideMethodInaccessibilityTitle.
  ///
  /// In en, this message translates to:
  /// **'3. Inaccessibility'**
  String get nonogramGuideMethodInaccessibilityTitle;

  /// No description provided for @nonogramGuideMethodNotFitDesc.
  ///
  /// In en, this message translates to:
  /// **'If an empty space between crosses is smaller than any available clue for that line, it must be marked with X.'**
  String get nonogramGuideMethodNotFitDesc;

  /// No description provided for @nonogramGuideMethodNotFitTitle.
  ///
  /// In en, this message translates to:
  /// **'4. Doesn\'t fit in'**
  String get nonogramGuideMethodNotFitTitle;

  /// No description provided for @nonogramGuideMethodSuperpositionMultiDesc.
  ///
  /// In en, this message translates to:
  /// **'When there are several numbers, superpose the extreme left and right positions of the entire group, accounting for the mandatory minimum one-square gap between same-color blocks. Squares where a group overlaps with its own range in both variants are painted.'**
  String get nonogramGuideMethodSuperpositionMultiDesc;

  /// No description provided for @nonogramGuideMethodSuperpositionMultiTitle.
  ///
  /// In en, this message translates to:
  /// **'Superposition (Multiple Clues)'**
  String get nonogramGuideMethodSuperpositionMultiTitle;

  /// No description provided for @nonogramGuideMethodSuperpositionSimpleDesc.
  ///
  /// In en, this message translates to:
  /// **'If a number makes more than half of the length, some squares in the middle will definitely be painted. Superpose the extreme left and extreme right positions; where they overlap, the squares are painted.'**
  String get nonogramGuideMethodSuperpositionSimpleDesc;

  /// No description provided for @nonogramGuideMethodSuperpositionSimpleTitle.
  ///
  /// In en, this message translates to:
  /// **'Superposition (Single Clue)'**
  String get nonogramGuideMethodSuperpositionSimpleTitle;

  /// No description provided for @nonogramGuideMethodWallPushingDesc.
  ///
  /// In en, this message translates to:
  /// **'If a known painted cell is closer to a border than the size of the first clue, the figure it belongs to must extend away from that border.'**
  String get nonogramGuideMethodWallPushingDesc;

  /// No description provided for @nonogramGuideMethodWallPushingTitle.
  ///
  /// In en, this message translates to:
  /// **'2. Pushing off from the walls'**
  String get nonogramGuideMethodWallPushingTitle;

  /// No description provided for @nonogramGuideRuleDesc.
  ///
  /// In en, this message translates to:
  /// **'Each number represents one continuous block of filled cells in that row or column. If there are multiple numbers, they represent separate blocks, and each block must be separated from the next by at least one empty cell. For example, `3 1` means a block of 3 filled cells, then at least 1 empty cell, then a block of 1 filled cell.'**
  String get nonogramGuideRuleDesc;

  /// No description provided for @nonogramGuideRuleTitle.
  ///
  /// In en, this message translates to:
  /// **'Core rule: what the numbers mean'**
  String get nonogramGuideRuleTitle;

  /// No description provided for @nonogramGuideTitle.
  ///
  /// In en, this message translates to:
  /// **'How to Solve'**
  String get nonogramGuideTitle;

  /// No description provided for @nonogramHistoryCompletedOn.
  ///
  /// In en, this message translates to:
  /// **'Completed on {date}'**
  String nonogramHistoryCompletedOn(String date);

  /// No description provided for @nonogramHistoryDetailNotFound.
  ///
  /// In en, this message translates to:
  /// **'Level details not found.'**
  String get nonogramHistoryDetailNotFound;

  /// No description provided for @nonogramHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No completed levels yet.'**
  String get nonogramHistoryEmpty;

  /// No description provided for @nonogramHistoryLevel.
  ///
  /// In en, this message translates to:
  /// **'Level {n}'**
  String nonogramHistoryLevel(int n);

  /// No description provided for @nonogramHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get nonogramHistoryTitle;

  /// No description provided for @nonogramPlayActionNextLevelFixed.
  ///
  /// In en, this message translates to:
  /// **'Next Level'**
  String get nonogramPlayActionNextLevelFixed;

  /// No description provided for @nonogramPlayActionShowClues.
  ///
  /// In en, this message translates to:
  /// **'Show clues'**
  String get nonogramPlayActionShowClues;

  /// No description provided for @nonogramPlayCompletionMessage.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! You have completed Level {level}.'**
  String nonogramPlayCompletionMessage(int level);

  /// No description provided for @nonogramPlayCompletionTitle.
  ///
  /// In en, this message translates to:
  /// **'Puzzle Solved!'**
  String get nonogramPlayCompletionTitle;

  /// No description provided for @nonogramPlayDurationFormat.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m {seconds}s'**
  String nonogramPlayDurationFormat(int minutes, int seconds);

  /// No description provided for @nonogramPlayHintLabel.
  ///
  /// In en, this message translates to:
  /// **'Hint ({count})'**
  String nonogramPlayHintLabel(int count);

  /// No description provided for @nonogramPlayNoNextLevelToast.
  ///
  /// In en, this message translates to:
  /// **'No next level available yet.'**
  String get nonogramPlayNoNextLevelToast;

  /// No description provided for @nonogramPlayPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Nonogram'**
  String get nonogramPlayPageTitle;

  /// No description provided for @nonogramSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get nonogramSettingsTitle;

  /// No description provided for @nonogramDashboardContinueNext.
  ///
  /// In en, this message translates to:
  /// **'Next challenge'**
  String get nonogramDashboardContinueNext;

  /// No description provided for @nonogramDashboardPlay.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get nonogramDashboardPlay;

  /// No description provided for @nonogramDashboardResumeAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get nonogramDashboardResumeAction;

  /// No description provided for @nonogramDashboardInProgressBadge.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get nonogramDashboardInProgressBadge;

  /// No description provided for @nonogramDashboardDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty {value}'**
  String nonogramDashboardDifficulty(String value);

  /// No description provided for @nonogramDashboardSolvedOfTotal.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} puzzles solved'**
  String nonogramDashboardSolvedOfTotal(int completed, int total);

  /// No description provided for @nonogramDashboardStatFastest.
  ///
  /// In en, this message translates to:
  /// **'Fastest'**
  String get nonogramDashboardStatFastest;

  /// No description provided for @nonogramDashboardStatTotalTime.
  ///
  /// In en, this message translates to:
  /// **'Total time'**
  String get nonogramDashboardStatTotalTime;

  /// No description provided for @nonogramDashboardRecentTitle.
  ///
  /// In en, this message translates to:
  /// **'Recently solved'**
  String get nonogramDashboardRecentTitle;

  /// No description provided for @nonogramDashboardSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get nonogramDashboardSeeAll;

  /// No description provided for @nonogramDashboardRecentEmpty.
  ///
  /// In en, this message translates to:
  /// **'Solve your first puzzle to start your picture collection.'**
  String get nonogramDashboardRecentEmpty;

  /// No description provided for @nonogramDashboardAllDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'All puzzles solved!'**
  String get nonogramDashboardAllDoneTitle;

  /// No description provided for @nonogramDashboardAllDoneDesc.
  ///
  /// In en, this message translates to:
  /// **'You have completed all {total} puzzles. Revisit your collection anytime.'**
  String nonogramDashboardAllDoneDesc(int total);

  /// No description provided for @nonogramDurationHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m'**
  String nonogramDurationHoursMinutes(int hours, int minutes);

  /// No description provided for @nonogramHistoryBestTime.
  ///
  /// In en, this message translates to:
  /// **'Best {time}'**
  String nonogramHistoryBestTime(String time);

  /// No description provided for @nonogramPlayActionDashboard.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get nonogramPlayActionDashboard;

  /// No description provided for @appThemeTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appThemeTitle;

  /// No description provided for @appThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get appThemeLight;

  /// No description provided for @appThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get appThemeDark;

  /// No description provided for @nonogramPlayModeFill.
  ///
  /// In en, this message translates to:
  /// **'Fill mode'**
  String get nonogramPlayModeFill;

  /// No description provided for @nonogramPlayModeMark.
  ///
  /// In en, this message translates to:
  /// **'Mark X mode'**
  String get nonogramPlayModeMark;

  /// No description provided for @nonogramSettingsRestart.
  ///
  /// In en, this message translates to:
  /// **'Restart this level'**
  String get nonogramSettingsRestart;

  /// No description provided for @nonogramSettingsRestartConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Restart this level?'**
  String get nonogramSettingsRestartConfirmTitle;

  /// No description provided for @nonogramSettingsRestartConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'All cells you have filled or marked will be cleared. Cells with a star (opened by hints or the wand) are kept.'**
  String get nonogramSettingsRestartConfirmMessage;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @nonogramSettingsRestartConfirm.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get nonogramSettingsRestartConfirm;

  /// No description provided for @nonogramTutorialTitle.
  ///
  /// In en, this message translates to:
  /// **'How to play'**
  String get nonogramTutorialTitle;

  /// No description provided for @nonogramTutorialSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get nonogramTutorialSkip;

  /// No description provided for @nonogramTutorialWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Nonopix!'**
  String get nonogramTutorialWelcomeTitle;

  /// No description provided for @nonogramTutorialWelcome.
  ///
  /// In en, this message translates to:
  /// **'Let\'s learn the basic rules with a small 5×5 puzzle.'**
  String get nonogramTutorialWelcome;

  /// No description provided for @nonogramTutorialStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get nonogramTutorialStart;

  /// No description provided for @nonogramTutorialSwitchToFill.
  ///
  /// In en, this message translates to:
  /// **'Puzzles are solved by filling in squares. Tap the button below to switch to fill mode.'**
  String get nonogramTutorialSwitchToFill;

  /// No description provided for @nonogramTutorialClueIsCount.
  ///
  /// In en, this message translates to:
  /// **'The number tells you how many squares in the row are filled. This row has 5, so fill them all!'**
  String get nonogramTutorialClueIsCount;

  /// No description provided for @nonogramTutorialEdgeCell.
  ///
  /// In en, this message translates to:
  /// **'The last square is already filled. The block of 4 must include it, so there is only one way to place it: fill the 3 squares to its left.'**
  String get nonogramTutorialEdgeCell;

  /// No description provided for @nonogramTutorialMultipleClues.
  ///
  /// In en, this message translates to:
  /// **'More than one number means more than one block, with at least one empty square between them. 2 2 fits these 5 squares in only one way.'**
  String get nonogramTutorialMultipleClues;

  /// No description provided for @nonogramTutorialClueOrder.
  ///
  /// In en, this message translates to:
  /// **'Order matters too: 3 1 means the block of 3 comes first, then the block of 1.'**
  String get nonogramTutorialClueOrder;

  /// No description provided for @nonogramTutorialColumns.
  ///
  /// In en, this message translates to:
  /// **'Columns have numbers too, read from top to bottom. Switch to X mode to mark squares that must stay empty.'**
  String get nonogramTutorialColumns;

  /// No description provided for @nonogramTutorialMarkEmpty.
  ///
  /// In en, this message translates to:
  /// **'Columns with a ✓ already have all their squares. Mark their remaining empty squares with an X.'**
  String get nonogramTutorialMarkEmpty;

  /// No description provided for @nonogramTutorialOneCellLeft.
  ///
  /// In en, this message translates to:
  /// **'The 1 in the last row now has only one place left. Switch back to fill mode.'**
  String get nonogramTutorialOneCellLeft;

  /// No description provided for @nonogramTutorialFinish.
  ///
  /// In en, this message translates to:
  /// **'Fill the last square to finish the puzzle!'**
  String get nonogramTutorialFinish;

  /// No description provided for @nonogramTutorialDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Well done!'**
  String get nonogramTutorialDoneTitle;

  /// No description provided for @nonogramTutorialDone.
  ///
  /// In en, this message translates to:
  /// **'You\'re all set! On big puzzles, drag with two fingers (or from the empty space outside the grid) to move the board; the app will remind you on your first big puzzle.'**
  String get nonogramTutorialDone;

  /// No description provided for @nonogramTutorialShowTechniques.
  ///
  /// In en, this message translates to:
  /// **'See solving techniques'**
  String get nonogramTutorialShowTechniques;

  /// No description provided for @nonogramTutorialPlay.
  ///
  /// In en, this message translates to:
  /// **'Start playing'**
  String get nonogramTutorialPlay;

  /// No description provided for @nonogramGuideTutorialCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Learn by playing'**
  String get nonogramGuideTutorialCardTitle;

  /// No description provided for @nonogramGuideTutorialCardDesc.
  ///
  /// In en, this message translates to:
  /// **'Learn the rules and controls step by step on a small 5×5 puzzle.'**
  String get nonogramGuideTutorialCardDesc;

  /// No description provided for @nonogramPlayInfoHide.
  ///
  /// In en, this message translates to:
  /// **'Hide level info'**
  String get nonogramPlayInfoHide;

  /// No description provided for @nonogramPlayWandLabel.
  ///
  /// In en, this message translates to:
  /// **'Magic wand'**
  String get nonogramPlayWandLabel;

  /// No description provided for @nonogramPlayWandSelectPrompt.
  ///
  /// In en, this message translates to:
  /// **'Tap the clues of the row or column to reveal'**
  String get nonogramPlayWandSelectPrompt;

  /// No description provided for @nonogramPlayWandRowSolved.
  ///
  /// In en, this message translates to:
  /// **'This row is already correct. Pick another row or column.'**
  String get nonogramPlayWandRowSolved;

  /// No description provided for @nonogramPlayWandColSolved.
  ///
  /// In en, this message translates to:
  /// **'This column is already correct. Pick another row or column.'**
  String get nonogramPlayWandColSolved;

  /// No description provided for @nonogramSettingsControlsGuide.
  ///
  /// In en, this message translates to:
  /// **'Controls guide'**
  String get nonogramSettingsControlsGuide;

  /// No description provided for @nonogramCoachSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get nonogramCoachSkip;

  /// No description provided for @nonogramCoachNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nonogramCoachNext;

  /// No description provided for @nonogramCoachDone.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get nonogramCoachDone;

  /// No description provided for @nonogramCoachStep.
  ///
  /// In en, this message translates to:
  /// **'{current}/{total}'**
  String nonogramCoachStep(int current, int total);

  /// No description provided for @nonogramCoachHintTitle.
  ///
  /// In en, this message translates to:
  /// **'Hint'**
  String get nonogramCoachHintTitle;

  /// No description provided for @nonogramCoachHintBody.
  ///
  /// In en, this message translates to:
  /// **'Fills 5 correct squares for you (squares that should be filled but aren\'t yet), picked at random across the board. They get a star: they can\'t be changed and are kept even if you restart. You get 3 per puzzle.'**
  String get nonogramCoachHintBody;

  /// No description provided for @nonogramCoachWandTitle.
  ///
  /// In en, this message translates to:
  /// **'Magic wand'**
  String get nonogramCoachWandTitle;

  /// No description provided for @nonogramCoachWandBody.
  ///
  /// In en, this message translates to:
  /// **'Tap the wand, then tap the clues of any row or column: the answer for that whole line is revealed and marked with a star, kept even if you restart. You get 1 per puzzle.'**
  String get nonogramCoachWandBody;

  /// No description provided for @nonogramCoachModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Fill or X'**
  String get nonogramCoachModeTitle;

  /// No description provided for @nonogramCoachModeBody.
  ///
  /// In en, this message translates to:
  /// **'Choose what a tap does: fill the square, or mark it with an X to remember it is empty. Tap the button to switch. Drag across the grid to fill or mark many squares at once.'**
  String get nonogramCoachModeBody;

  /// No description provided for @nonogramCoachLongPressTitle.
  ///
  /// In en, this message translates to:
  /// **'Press and hold for the opposite'**
  String get nonogramCoachLongPressTitle;

  /// No description provided for @nonogramCoachLongPressBody.
  ///
  /// In en, this message translates to:
  /// **'Press and hold a square to do the opposite of the current mode: X while filling, fill while marking. A short vibration means it\'s done and you can let go.'**
  String get nonogramCoachLongPressBody;

  /// No description provided for @nonogramCoachScrollTitle.
  ///
  /// In en, this message translates to:
  /// **'Moving around big puzzles'**
  String get nonogramCoachScrollTitle;

  /// No description provided for @nonogramCoachScrollBody.
  ///
  /// In en, this message translates to:
  /// **'Big puzzles don\'t fit on screen: drag with two fingers, or drag from the empty space outside the grid to move the board. Drag on the clues to see hidden numbers (the \"+N\" in the corner shows how many).'**
  String get nonogramCoachScrollBody;

  /// No description provided for @nonogramTutorialRulesDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'You know the rules!'**
  String get nonogramTutorialRulesDoneTitle;

  /// No description provided for @nonogramTutorialRulesDone.
  ///
  /// In en, this message translates to:
  /// **'Next, let\'s practice the controls and helpers on another puzzle: drag to fill quickly, press and hold to mark, hints and the magic wand.'**
  String get nonogramTutorialRulesDone;

  /// No description provided for @nonogramTutorialContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get nonogramTutorialContinue;

  /// No description provided for @nonogramTutorialLater.
  ///
  /// In en, this message translates to:
  /// **'Later, just play'**
  String get nonogramTutorialLater;

  /// No description provided for @nonogramTutorialDragRow.
  ///
  /// In en, this message translates to:
  /// **'Tip: drag your finger across squares to fill them in one go. The top row has 5, so drag across the whole row!'**
  String get nonogramTutorialDragRow;

  /// No description provided for @nonogramTutorialLongPressMark.
  ///
  /// In en, this message translates to:
  /// **'1 1 1 fits these 5 squares exactly, so the 2nd and 4th squares must be empty. No need to switch modes: press and hold each one to mark it with an X. A short vibration means it\'s done.'**
  String get nonogramTutorialLongPressMark;

  /// No description provided for @nonogramTutorialUseHint.
  ///
  /// In en, this message translates to:
  /// **'Stuck? Tap the Hint button and the app fills 5 correct squares at random. You get 3 per puzzle.'**
  String get nonogramTutorialUseHint;

  /// No description provided for @nonogramTutorialActivateWand.
  ///
  /// In en, this message translates to:
  /// **'The hint filled 5 squares marked with a star: they\'re locked and kept even if you restart. To reveal a whole row or column of your choice, use the magic wand: tap the wand button.'**
  String get nonogramTutorialActivateWand;

  /// No description provided for @nonogramTutorialPickWandLine.
  ///
  /// In en, this message translates to:
  /// **'Now tap the clues of the bottom row to reveal that row. You get 1 wand per puzzle.'**
  String get nonogramTutorialPickWandLine;

  /// No description provided for @nonogramTutorialFinishTools.
  ///
  /// In en, this message translates to:
  /// **'Fill the remaining squares to finish. Drag down a column to fill faster.'**
  String get nonogramTutorialFinishTools;

  /// No description provided for @nonogramPlayHintNothingToFill.
  ///
  /// In en, this message translates to:
  /// **'Every square that should be filled already is. Check for extra filled squares.'**
  String get nonogramPlayHintNothingToFill;

  /// No description provided for @settingsLicenses.
  ///
  /// In en, this message translates to:
  /// **'Licenses'**
  String get settingsLicenses;

  /// No description provided for @settingsSwitchPlayMode.
  ///
  /// In en, this message translates to:
  /// **'Switch play mode'**
  String get settingsSwitchPlayMode;

  /// No description provided for @licensesTitle.
  ///
  /// In en, this message translates to:
  /// **'Licenses'**
  String get licensesTitle;

  /// No description provided for @licensesLevelArtHeading.
  ///
  /// In en, this message translates to:
  /// **'Puzzles'**
  String get licensesLevelArtHeading;

  /// No description provided for @licensesLevelArtIntro.
  ///
  /// In en, this message translates to:
  /// **'The puzzles come from these sources. Icon sets were scaled down, converted to black and white and edited so every puzzle can be solved; the nonogram collections are used as they are.'**
  String get licensesLevelArtIntro;

  /// No description provided for @licensesFontHeading.
  ///
  /// In en, this message translates to:
  /// **'Font'**
  String get licensesFontHeading;

  /// No description provided for @licensesSoftwareButton.
  ///
  /// In en, this message translates to:
  /// **'Open-source software licenses'**
  String get licensesSoftwareButton;

  /// No description provided for @licensesDeveloperLevelsNote.
  ///
  /// In en, this message translates to:
  /// **'Developer mode puzzles come from nonogram.org and are for internal testing only. They are not included in the store version.'**
  String get licensesDeveloperLevelsNote;

  /// No description provided for @playModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a play mode'**
  String get playModeTitle;

  /// No description provided for @playModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Progress is saved separately for each mode.'**
  String get playModeSubtitle;

  /// No description provided for @playModeUserTitle.
  ///
  /// In en, this message translates to:
  /// **'Player mode'**
  String get playModeUserTitle;

  /// No description provided for @playModeUserBody.
  ///
  /// In en, this message translates to:
  /// **'The licensed puzzles that ship in the store version.'**
  String get playModeUserBody;

  /// No description provided for @playModeDeveloperTitle.
  ///
  /// In en, this message translates to:
  /// **'Developer mode'**
  String get playModeDeveloperTitle;

  /// No description provided for @playModeDeveloperBody.
  ///
  /// In en, this message translates to:
  /// **'The original puzzles from nonogram.org, for internal testing. Keeps your earlier progress.'**
  String get playModeDeveloperBody;

  /// No description provided for @playModeLastUsed.
  ///
  /// In en, this message translates to:
  /// **'Last used'**
  String get playModeLastUsed;

  /// No description provided for @licensesBy.
  ///
  /// In en, this message translates to:
  /// **'By {author}'**
  String licensesBy(String author);

  /// No description provided for @licensesLevelCount.
  ///
  /// In en, this message translates to:
  /// **'{count} puzzles'**
  String licensesLevelCount(int count);

  /// No description provided for @playModeProgress.
  ///
  /// In en, this message translates to:
  /// **'{solved}/{total} solved'**
  String playModeProgress(int solved, int total);

  /// No description provided for @adRewardNotReady.
  ///
  /// In en, this message translates to:
  /// **'The ad isn\'t ready yet. Check your internet connection and try again.'**
  String get adRewardNotReady;

  /// No description provided for @settingsAdPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Ad privacy'**
  String get settingsAdPrivacy;

  /// No description provided for @ratingTitle.
  ///
  /// In en, this message translates to:
  /// **'Enjoying Nonopix?'**
  String get ratingTitle;

  /// No description provided for @ratingMessage.
  ///
  /// In en, this message translates to:
  /// **'Tap a star to rate the game.'**
  String get ratingMessage;

  /// No description provided for @ratingLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get ratingLater;

  /// No description provided for @ratingSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get ratingSubmit;

  /// No description provided for @ratingThanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks for your feedback! We\'ll keep making the game better.'**
  String get ratingThanks;

  /// No description provided for @ratingStarLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} stars'**
  String ratingStarLabel(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

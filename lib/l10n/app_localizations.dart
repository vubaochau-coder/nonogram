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
  /// **'Nonogram'**
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

  /// No description provided for @nonogramDashboardHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reveal hidden pictures by filling cells based on numerical clues found on the side of the grid.'**
  String get nonogramDashboardHeroSubtitle;

  /// No description provided for @nonogramDashboardInSessionDesc.
  ///
  /// In en, this message translates to:
  /// **'You are halfway through Level {level}'**
  String nonogramDashboardInSessionDesc(int level);

  /// No description provided for @nonogramDashboardInSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Currently in progress'**
  String get nonogramDashboardInSessionTitle;

  /// No description provided for @nonogramDashboardProgressSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Progress'**
  String get nonogramDashboardProgressSectionTitle;

  /// No description provided for @nonogramDashboardReadyDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete Level {level} to unlock more challenges'**
  String nonogramDashboardReadyDesc(int level);

  /// No description provided for @nonogramDashboardReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready for next puzzle'**
  String get nonogramDashboardReadyTitle;

  /// No description provided for @nonogramDashboardStatCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get nonogramDashboardStatCompleted;

  /// No description provided for @nonogramDashboardStatNextTarget.
  ///
  /// In en, this message translates to:
  /// **'Next Target'**
  String get nonogramDashboardStatNextTarget;

  /// No description provided for @nonogramDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Nonogram'**
  String get nonogramDashboardTitle;

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

  /// No description provided for @nonogramHistoryBest.
  ///
  /// In en, this message translates to:
  /// **'Best'**
  String get nonogramHistoryBest;

  /// No description provided for @nonogramHistoryCompletedOn.
  ///
  /// In en, this message translates to:
  /// **'Completed on {date}'**
  String nonogramHistoryCompletedOn(String date);

  /// No description provided for @nonogramHistoryCompletionDate.
  ///
  /// In en, this message translates to:
  /// **'Completion Date'**
  String get nonogramHistoryCompletionDate;

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

  /// No description provided for @nonogramHistoryPlayTime.
  ///
  /// In en, this message translates to:
  /// **'Total Play Time'**
  String get nonogramHistoryPlayTime;

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
  /// **'Hint {count}/3'**
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

  /// No description provided for @nonogramPlayStatDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get nonogramPlayStatDifficulty;

  /// No description provided for @nonogramPlayStatTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get nonogramPlayStatTime;

  /// No description provided for @nonogramSettingsCellSize.
  ///
  /// In en, this message translates to:
  /// **'Cell size'**
  String get nonogramSettingsCellSize;

  /// No description provided for @nonogramSettingsCellSizeCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom size'**
  String get nonogramSettingsCellSizeCustom;

  /// No description provided for @nonogramSettingsCellSizeDefault.
  ///
  /// In en, this message translates to:
  /// **'(default)'**
  String get nonogramSettingsCellSizeDefault;

  /// No description provided for @nonogramSettingsCellSizeError.
  ///
  /// In en, this message translates to:
  /// **'Size must be between 12 and 80'**
  String get nonogramSettingsCellSizeError;

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

  /// No description provided for @nonogramDashboardContinueResume.
  ///
  /// In en, this message translates to:
  /// **'Resume playing'**
  String get nonogramDashboardContinueResume;
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

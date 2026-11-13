// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Nonopix';

  @override
  String get commonCancel => 'Abbrechen';

  @override
  String get commonRetry => 'Erneut versuchen';

  @override
  String get commonSave => 'Speichern';

  @override
  String nonogramDashboardContinueLevel(int level) {
    return 'Level $level';
  }

  @override
  String get nonogramDashboardProgressSectionTitle => 'Dein Fortschritt';

  @override
  String get nonogramDashboardStatCompleted => 'Gelöst';

  @override
  String get nonogramGuideIntro =>
      'Nonogramme sind Logikrätsel mit einfachen Regeln und kniffligen Lösungen. Ziel ist es, versteckte Bilder aufzudecken, indem du Felder anhand der Zahlen am Rand des Gitters ausfüllst.';

  @override
  String get nonogramGuideMethodDivisionDesc =>
      'Würde das Verbinden zweier vorhandener Blöcke eine Figur ergeben, die größer ist als jeder verfügbare Hinweis, muss die Lücke dazwischen ein X sein.';

  @override
  String get nonogramGuideMethodDivisionTitle => '5. Trennung';

  @override
  String get nonogramGuideMethodDoublePositioningDesc =>
      'Kann ein ausgefülltes Feld nur zu wenigen bestimmten Varianten eines Blocks gehören, müssen alle Felder, die in keiner dieser Varianten ausgefüllt sind, mit X markiert werden.';

  @override
  String get nonogramGuideMethodDoublePositioningTitle =>
      '6. Doppelte Positionierung';

  @override
  String get nonogramGuideMethodInaccessibilityDesc =>
      'Markiere Felder, die zu keiner der verbleibenden Figuren gehören können, mit einem Kreuz (X).';

  @override
  String get nonogramGuideMethodInaccessibilityTitle => '3. Unerreichbarkeit';

  @override
  String get nonogramGuideMethodNotFitDesc =>
      'Ist ein leerer Bereich zwischen Kreuzen kleiner als jeder verfügbare Hinweis dieser Zeile, muss er mit X markiert werden.';

  @override
  String get nonogramGuideMethodNotFitTitle => '4. Passt nicht hinein';

  @override
  String get nonogramGuideMethodSuperpositionMultiDesc =>
      'Bei mehreren Zahlen legst du die äußerste linke und die äußerste rechte Lage der ganzen Gruppe übereinander und berücksichtigst dabei die vorgeschriebene Lücke von mindestens einem Feld zwischen gleichfarbigen Blöcken. Felder, an denen sich ein Block in beiden Varianten mit sich selbst überschneidet, werden ausgefüllt.';

  @override
  String get nonogramGuideMethodSuperpositionMultiTitle =>
      'Überlagerung (mehrere Hinweise)';

  @override
  String get nonogramGuideMethodSuperpositionSimpleDesc =>
      'Ist eine Zahl größer als die halbe Länge, sind einige Felder in der Mitte sicher ausgefüllt. Lege die äußerste linke und die äußerste rechte Lage übereinander; wo sie sich überschneiden, werden die Felder ausgefüllt.';

  @override
  String get nonogramGuideMethodSuperpositionSimpleTitle =>
      'Überlagerung (ein Hinweis)';

  @override
  String get nonogramGuideMethodWallPushingDesc =>
      'Liegt ein bekanntes ausgefülltes Feld näher am Rand, als der erste Hinweis lang ist, muss sich die zugehörige Figur von diesem Rand weg erstrecken.';

  @override
  String get nonogramGuideMethodWallPushingTitle => '2. Vom Rand wegschieben';

  @override
  String get nonogramGuideRuleDesc =>
      'Jede Zahl steht für einen zusammenhängenden Block ausgefüllter Felder in dieser Zeile oder Spalte. Bei mehreren Zahlen sind es getrennte Blöcke, und zwischen zwei Blöcken muss mindestens ein leeres Feld liegen. Zum Beispiel bedeutet `3 1`: ein Block aus 3 ausgefüllten Feldern, dann mindestens 1 leeres Feld, dann ein Block aus 1 ausgefülltem Feld.';

  @override
  String get nonogramGuideRuleTitle => 'Grundregel: Was die Zahlen bedeuten';

  @override
  String get nonogramGuideTitle => 'Lösungstechniken';

  @override
  String nonogramHistoryCompletedOn(String date) {
    return 'Gelöst am $date';
  }

  @override
  String get nonogramHistoryDetailNotFound => 'Leveldetails nicht gefunden.';

  @override
  String get nonogramHistoryEmpty => 'Noch keine Level gelöst.';

  @override
  String nonogramHistoryLevel(int n) {
    return 'Level $n';
  }

  @override
  String get nonogramHistoryTitle => 'Ergebnisse';

  @override
  String get nonogramPlayActionNextLevelFixed => 'Nächstes Level';

  @override
  String get nonogramPlayActionShowClues => 'Hinweise anzeigen';

  @override
  String nonogramPlayCompletionMessage(int level) {
    return 'Glückwunsch! Du hast Level $level gelöst.';
  }

  @override
  String get nonogramPlayCompletionTitle => 'Rätsel gelöst!';

  @override
  String nonogramPlayDurationFormat(int minutes, int seconds) {
    return '$minutes Min. $seconds Sek.';
  }

  @override
  String nonogramPlayHintLabel(int count) {
    return 'Tipp ($count)';
  }

  @override
  String get nonogramPlayNoNextLevelToast =>
      'Noch kein nächstes Level verfügbar.';

  @override
  String get nonogramPlayPageTitle => 'Nonogramm';

  @override
  String get nonogramSettingsTitle => 'Einstellungen';

  @override
  String get nonogramDashboardContinueNext => 'Nächstes Rätsel';

  @override
  String get nonogramDashboardPlay => 'Spielen';

  @override
  String get nonogramDashboardResumeAction => 'Weiterspielen';

  @override
  String get nonogramDashboardInProgressBadge => 'Begonnen';

  @override
  String nonogramDashboardDifficulty(String value) {
    return 'Schwierigkeit $value';
  }

  @override
  String nonogramDashboardSolvedOfTotal(int completed, int total) {
    return '$completed von $total Rätseln gelöst';
  }

  @override
  String get nonogramDashboardStatFastest => 'Schnellste';

  @override
  String get nonogramDashboardStatTotalTime => 'Gesamtzeit';

  @override
  String get nonogramDashboardRecentTitle => 'Zuletzt gelöst';

  @override
  String get nonogramDashboardSeeAll => 'Alle anzeigen';

  @override
  String get nonogramDashboardRecentEmpty =>
      'Löse dein erstes Rätsel, um deine Bildersammlung zu beginnen.';

  @override
  String get nonogramDashboardAllDoneTitle => 'Alle Rätsel gelöst!';

  @override
  String nonogramDashboardAllDoneDesc(int total) {
    return 'Du hast alle $total Rätsel gelöst. Sieh dir deine Sammlung jederzeit wieder an.';
  }

  @override
  String nonogramDurationHoursMinutes(int hours, int minutes) {
    return '$hours Std. $minutes Min.';
  }

  @override
  String nonogramHistoryBestTime(String time) {
    return 'Bestzeit $time';
  }

  @override
  String get nonogramPlayActionDashboard => 'Startseite';

  @override
  String get appThemeTitle => 'Darstellung';

  @override
  String get appThemeLight => 'Hell';

  @override
  String get appThemeDark => 'Dunkel';

  @override
  String get nonogramPlayModeFill => 'Ausfüllmodus';

  @override
  String get nonogramPlayModeMark => 'X-Modus';

  @override
  String get nonogramSettingsRestart => 'Level neu starten';

  @override
  String get nonogramSettingsRestartConfirmTitle => 'Level neu starten?';

  @override
  String get nonogramSettingsRestartConfirmMessage =>
      'Alle Felder, die du ausgefüllt oder markiert hast, werden gelöscht. Felder mit Stern (durch Tipps oder den Zauberstab aufgedeckt) bleiben erhalten.';

  @override
  String get commonClose => 'Schließen';

  @override
  String get nonogramSettingsRestartConfirm => 'Neu starten';

  @override
  String get nonogramTutorialTitle => 'So wird gespielt';

  @override
  String get nonogramTutorialSkip => 'Überspringen';

  @override
  String get nonogramTutorialWelcomeTitle => 'Willkommen bei Nonopix!';

  @override
  String get nonogramTutorialWelcome =>
      'Lerne die Grundregeln an einem kleinen 5×5-Rätsel.';

  @override
  String get nonogramTutorialStart => 'Los geht\'s';

  @override
  String get nonogramTutorialSwitchToFill =>
      'Rätsel werden gelöst, indem du Felder ausfüllst. Tippe auf die Schaltfläche unten, um in den Ausfüllmodus zu wechseln.';

  @override
  String get nonogramTutorialClueIsCount =>
      'Die Zahl gibt an, wie viele Felder der Zeile ausgefüllt sind. Diese Zeile hat 5, also fülle alle aus!';

  @override
  String get nonogramTutorialEdgeCell =>
      'Das letzte Feld ist schon ausgefüllt. Der 4er-Block muss es enthalten, also gibt es nur eine Möglichkeit: Fülle die 3 Felder links davon aus.';

  @override
  String get nonogramTutorialMultipleClues =>
      'Mehrere Zahlen bedeuten mehrere Blöcke mit mindestens einem leeren Feld dazwischen. 2 2 passt nur auf eine Weise in diese 5 Felder.';

  @override
  String get nonogramTutorialClueOrder =>
      'Auch die Reihenfolge zählt: 3 1 heißt, zuerst kommt der 3er-Block, dann der 1er-Block.';

  @override
  String get nonogramTutorialColumns =>
      'Auch Spalten haben Zahlen, gelesen von oben nach unten. Wechsle in den X-Modus, um Felder zu markieren, die leer bleiben müssen.';

  @override
  String get nonogramTutorialMarkEmpty =>
      'Spalten mit ✓ haben schon alle ihre Felder. Markiere ihre übrigen leeren Felder mit einem X.';

  @override
  String get nonogramTutorialOneCellLeft =>
      'Für die 1 in der letzten Zeile bleibt jetzt nur noch ein Platz. Wechsle zurück in den Ausfüllmodus.';

  @override
  String get nonogramTutorialFinish =>
      'Fülle das letzte Feld aus, um das Rätsel zu lösen!';

  @override
  String get nonogramTutorialDoneTitle => 'Gut gemacht!';

  @override
  String get nonogramTutorialDone =>
      'Alles bereit! Bei großen Rätseln ziehst du mit zwei Fingern (oder aus dem leeren Bereich neben dem Gitter), um das Spielfeld zu verschieben; die App erinnert dich bei deinem ersten großen Rätsel daran.';

  @override
  String get nonogramTutorialShowTechniques => 'Lösungstechniken ansehen';

  @override
  String get nonogramTutorialPlay => 'Jetzt spielen';

  @override
  String get nonogramGuideTutorialCardTitle => 'Spielend lernen';

  @override
  String get nonogramGuideTutorialCardDesc =>
      'Lerne Regeln und Steuerung Schritt für Schritt an einem kleinen 5×5-Rätsel.';

  @override
  String get nonogramPlayInfoHide => 'Levelinfo ausblenden';

  @override
  String get nonogramPlayWandLabel => 'Zauberstab';

  @override
  String get nonogramPlayWandSelectPrompt =>
      'Tippe auf die Hinweise der Zeile oder Spalte, die aufgedeckt werden soll';

  @override
  String get nonogramPlayWandRowSolved =>
      'Diese Zeile ist schon richtig. Wähle eine andere Zeile oder Spalte.';

  @override
  String get nonogramPlayWandColSolved =>
      'Diese Spalte ist schon richtig. Wähle eine andere Zeile oder Spalte.';

  @override
  String get nonogramSettingsControlsGuide => 'Steuerung erklärt';

  @override
  String get nonogramCoachSkip => 'Überspringen';

  @override
  String get nonogramCoachNext => 'Weiter';

  @override
  String get nonogramCoachDone => 'Verstanden';

  @override
  String nonogramCoachStep(int current, int total) {
    return '$current/$total';
  }

  @override
  String get nonogramCoachHintTitle => 'Tipp';

  @override
  String get nonogramCoachHintBody =>
      'Füllt 5 richtige Felder für dich aus (Felder, die ausgefüllt sein müssten, es aber noch nicht sind), zufällig auf dem ganzen Spielfeld verteilt. Sie bekommen einen Stern: Sie lassen sich nicht ändern und bleiben auch nach einem Neustart erhalten. Du hast 3 pro Rätsel.';

  @override
  String get nonogramCoachWandTitle => 'Zauberstab';

  @override
  String get nonogramCoachWandBody =>
      'Tippe auf den Zauberstab und dann auf die Hinweise einer beliebigen Zeile oder Spalte: Die Lösung der ganzen Linie wird aufgedeckt und mit einem Stern markiert, der auch nach einem Neustart bleibt. Du hast 1 pro Rätsel.';

  @override
  String get nonogramCoachModeTitle => 'Ausfüllen oder X';

  @override
  String get nonogramCoachModeBody =>
      'Wähle, was ein Tippen bewirkt: das Feld ausfüllen oder es mit einem X als leer markieren. Tippe auf die Schaltfläche, um zu wechseln. Ziehe über das Gitter, um viele Felder auf einmal auszufüllen oder zu markieren.';

  @override
  String get nonogramCoachLongPressTitle => 'Gedrückt halten für das Gegenteil';

  @override
  String get nonogramCoachLongPressBody =>
      'Halte ein Feld gedrückt, um das Gegenteil des aktuellen Modus zu tun: X beim Ausfüllen, Ausfüllen beim Markieren. Eine kurze Vibration zeigt, dass es geklappt hat und du loslassen kannst.';

  @override
  String get nonogramCoachScrollTitle => 'Große Rätsel bewegen';

  @override
  String get nonogramCoachScrollBody =>
      'Große Rätsel passen nicht auf den Bildschirm: Ziehe mit zwei Fingern oder aus dem leeren Bereich neben dem Gitter, um das Spielfeld zu verschieben. Ziehe über die Hinweise, um verdeckte Zahlen zu sehen (das „+N“ in der Ecke zeigt, wie viele).';

  @override
  String get nonogramTutorialRulesDoneTitle => 'Du kennst die Regeln!';

  @override
  String get nonogramTutorialRulesDone =>
      'Jetzt üben wir Steuerung und Hilfen an einem weiteren Rätsel: Ziehen zum schnellen Ausfüllen, Gedrückthalten zum Markieren, Tipps und der Zauberstab.';

  @override
  String get nonogramTutorialContinue => 'Weiter';

  @override
  String get nonogramTutorialLater => 'Später, einfach spielen';

  @override
  String get nonogramTutorialDragRow =>
      'Tipp: Ziehe den Finger über die Felder, um sie in einem Zug auszufüllen. Die oberste Zeile hat 5, also ziehe über die ganze Zeile!';

  @override
  String get nonogramTutorialLongPressMark =>
      '1 1 1 passt genau in diese 5 Felder, also müssen das 2. und das 4. Feld leer sein. Du musst den Modus nicht wechseln: Halte jedes davon gedrückt, um es mit einem X zu markieren. Eine kurze Vibration zeigt, dass es geklappt hat.';

  @override
  String get nonogramTutorialUseHint =>
      'Kommst du nicht weiter? Tippe auf Tipp und die App füllt zufällig 5 richtige Felder aus. Du hast 3 pro Rätsel.';

  @override
  String get nonogramTutorialActivateWand =>
      'Der Tipp hat 5 Felder mit Stern ausgefüllt: Sie sind gesperrt und bleiben auch nach einem Neustart erhalten. Um eine ganze Zeile oder Spalte deiner Wahl aufzudecken, nimm den Zauberstab: Tippe auf die Zauberstab-Schaltfläche.';

  @override
  String get nonogramTutorialPickWandLine =>
      'Tippe jetzt auf die Hinweise der untersten Zeile, um sie aufzudecken. Du hast 1 Zauberstab pro Rätsel.';

  @override
  String get nonogramTutorialFinishTools =>
      'Fülle die übrigen Felder aus, um das Rätsel zu lösen. Ziehe eine Spalte hinunter, um schneller auszufüllen.';

  @override
  String get nonogramPlayHintNothingToFill =>
      'Alle Felder, die ausgefüllt sein müssen, sind es schon. Prüfe, ob zu viele Felder ausgefüllt sind.';

  @override
  String get settingsSound => 'Ton';

  @override
  String get settingsLicenses => 'Lizenzen';

  @override
  String get settingsSwitchPlayMode => 'Spielmodus wechseln';

  @override
  String get licensesTitle => 'Lizenzen';

  @override
  String get licensesLevelArtHeading => 'Rätsel';

  @override
  String get licensesLevelArtIntro =>
      'Die Rätsel stammen aus diesen Quellen. Icon-Sets wurden verkleinert, in Schwarzweiß umgewandelt und bearbeitet, damit jedes Rätsel lösbar ist; die Nonogramm-Sammlungen werden unverändert verwendet.';

  @override
  String get licensesFontHeading => 'Schriftart';

  @override
  String get licensesSoftwareButton => 'Open-Source-Lizenzen';

  @override
  String get licensesDeveloperLevelsNote =>
      'Die Rätsel im Entwicklermodus stammen von nonogram.org und sind nur für interne Tests gedacht. Sie sind nicht in der Store-Version enthalten.';

  @override
  String get playModeTitle => 'Spielmodus wählen';

  @override
  String get playModeSubtitle =>
      'Der Fortschritt wird für jeden Modus getrennt gespeichert.';

  @override
  String get playModeUserTitle => 'Spielermodus';

  @override
  String get playModeUserBody => 'Die lizenzierten Rätsel der Store-Version.';

  @override
  String get playModeDeveloperTitle => 'Entwicklermodus';

  @override
  String get playModeDeveloperBody =>
      'Die Originalrätsel von nonogram.org für interne Tests. Behält deinen bisherigen Fortschritt.';

  @override
  String get playModeLastUsed => 'Zuletzt verwendet';

  @override
  String licensesBy(String author) {
    return 'Von $author';
  }

  @override
  String licensesLevelCount(int count) {
    return '$count Rätsel';
  }

  @override
  String playModeProgress(int solved, int total) {
    return '$solved/$total gelöst';
  }

  @override
  String get adRewardNotReady =>
      'Die Werbung ist noch nicht bereit. Prüfe deine Internetverbindung und versuche es erneut.';

  @override
  String get settingsAdPrivacy => 'Datenschutz bei Werbung';

  @override
  String get ratingTitle => 'Gefällt dir Nonopix?';

  @override
  String get ratingMessage =>
      'Tippe auf einen Stern, um das Spiel zu bewerten.';

  @override
  String get ratingLater => 'Später';

  @override
  String get ratingSubmit => 'Senden';

  @override
  String get ratingThanks =>
      'Danke für dein Feedback! Wir arbeiten weiter daran, das Spiel zu verbessern.';

  @override
  String ratingStarLabel(int count) {
    return '$count Sterne';
  }

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsLanguageSystem => 'Gerätesprache';

  @override
  String get premiumTitle => 'Ohne Werbung spielen';

  @override
  String get premiumBenefitNoAds => 'Keine Werbung mehr zwischen den Levels';

  @override
  String get premiumBenefitDaily =>
      '2 Tipps und 1 Zauberstab an jedem Check-in-Tag';

  @override
  String premiumBuy(String price) {
    return 'Kaufen · $price';
  }

  @override
  String get premiumOneTime => 'Einmalige Zahlung über Google Play';

  @override
  String get premiumActiveTitle => 'Werbefrei-Paket aktiv';

  @override
  String get premiumActiveDaily =>
      'Checke jeden Tag ein, um 2 Tipps und 1 Zauberstab für diesen Tag zu bekommen.';

  @override
  String get premiumPurchased =>
      'Danke! Die Werbung zwischen den Levels ist jetzt aus.';

  @override
  String get premiumPending =>
      'Deine Zahlung steht noch aus. Das Paket wird aktiviert, sobald sie abgeschlossen ist.';

  @override
  String get premiumFailed =>
      'Der Kauf hat nicht geklappt. Bitte versuche es erneut.';

  @override
  String get checkInTitle => 'Tägliches Einchecken';

  @override
  String get checkInAction => 'Einchecken';

  @override
  String get checkInDoneToday => 'Heute eingecheckt';

  @override
  String checkInNextGift(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nächstes Geschenk in $count Check-ins',
      one: 'Nächstes Geschenk beim nächsten Einchecken',
    );
    return '$_temp0';
  }

  @override
  String get checkInCheckedIn => 'Eingecheckt!';

  @override
  String checkInReceived(String rewards) {
    return 'Du hast $rewards erhalten.';
  }

  @override
  String rewardHints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tipps',
      one: '1 Tipp',
    );
    return '$_temp0';
  }

  @override
  String rewardWands(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Zauberstäbe',
      one: '1 Zauberstab',
    );
    return '$_temp0';
  }

  @override
  String rewardTodayOnly(String reward) {
    return '$reward (nur heute)';
  }

  @override
  String get checkInMonthGifts => 'Geschenke diesen Monat';

  @override
  String get checkInTotalHints => 'Tipps';

  @override
  String get checkInTotalWands => 'Zauberstäbe';

  @override
  String get checkInTotalDailyHints => 'Tipps (nur heute)';

  @override
  String get checkInTotalDailyWands => 'Zauberstäbe (nur heute)';

  @override
  String get checkInPremiumToday => 'Heute aus deinem Werbefrei-Paket';

  @override
  String get checkInPremiumNotYet =>
      'Checke ein, um heute 2 Tipps und 1 Zauberstab zu bekommen.';

  @override
  String get checkInPremiumUsedUp => 'Für heute alles verbraucht. Bis morgen!';

  @override
  String checkInExpiresIn(String time) {
    return 'Läuft ab in $time';
  }

  @override
  String dashboardDailyReminder(String rewards, String time) {
    return 'Du hast heute noch $rewards. Sie laufen in $time ab – spiel jetzt, damit nichts verfällt!';
  }

  @override
  String get dashboardDailyReminderTitle => 'Deine heutigen Hilfen warten';

  @override
  String get dashboardDailyReminderPlay => 'Jetzt spielen';
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Pixel Nonogram';

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
      'Würde das Verbinden zweier gefüllter Stücke einen Block ergeben, der größer als die größte Zahl ist, muss das Kästchen dazwischen leer sein. Markiere es mit X.';

  @override
  String get nonogramGuideMethodDivisionTitle => '5. Trennung';

  @override
  String get nonogramGuideMethodDoublePositioningDesc =>
      'Manchmal kann ein gefülltes Kästchen nur zu einer oder zwei Zahlen gehören. Probiere jede Möglichkeit: Kästchen, die in allen leer bleiben, bekommen ein X.';

  @override
  String get nonogramGuideMethodDoublePositioningTitle =>
      '6. Doppelte Positionierung';

  @override
  String get nonogramGuideMethodInaccessibilityDesc =>
      'Kästchen, die kein Block erreichen kann, sind leer. Probiere jeden Block in seinen äußersten Lagen um die gefüllten Kästchen; alles außerhalb bekommt ein X.';

  @override
  String get nonogramGuideMethodInaccessibilityTitle => '3. Unerreichbarkeit';

  @override
  String get nonogramGuideMethodNotFitDesc =>
      'Eine Lücke zwischen X (oder zwischen X und Rand), die kürzer ist als jede Zahl, die dorthin passen könnte, fasst keinen Block: Markiere sie mit X.';

  @override
  String get nonogramGuideMethodNotFitTitle => '4. Passt nicht hinein';

  @override
  String get nonogramGuideMethodSuperpositionMultiDesc =>
      'Bei mehreren Zahlen schiebst du die ganze Gruppe nach links (mit je einer Lücke zwischen den Blöcken), dann nach rechts. Deckt derselbe Block ein Kästchen in beiden Lagen ab, ist es gefüllt. Schnelltest: Zahlen und Lücken addieren; der Rest zeigt, wie weit sich jeder Block bewegen kann.';

  @override
  String get nonogramGuideMethodSuperpositionMultiTitle =>
      'Überlagerung (mehrere Hinweise)';

  @override
  String get nonogramGuideMethodSuperpositionSimpleDesc =>
      'Ist eine Zahl größer als die halbe Linie, ist ein Teil davon immer gefüllt. Schieb den Block gedanklich ganz nach links, dann ganz nach rechts: Was er beide Male abdeckt, ist sicher gefüllt. Beispiel: 7 in 10 Kästchen füllt immer die mittleren 4.';

  @override
  String get nonogramGuideMethodSuperpositionSimpleTitle =>
      'Überlagerung (ein Hinweis)';

  @override
  String get nonogramGuideMethodWallPushingDesc =>
      'Ein gefülltes Kästchen nahe am Rand schränkt seinen Block ein. Der Block kann nicht über den Rand hinaus, also muss er sich vom Rand weg erstrecken. Beispiel: 5 mit gefülltem 4. Kästchen: Selbst ganz links deckt der Block noch das 5. Kästchen ab.';

  @override
  String get nonogramGuideMethodWallPushingTitle => '2. Vom Rand wegschieben';

  @override
  String get nonogramGuideRuleDesc =>
      'Jede Zahl steht für einen zusammenhängenden Block ausgefüllter Felder in dieser Zeile oder Spalte. Bei mehreren Zahlen sind es getrennte Blöcke, und zwischen zwei Blöcken muss mindestens ein leeres Feld liegen. Zum Beispiel bedeutet 3 1: ein Block aus 3 ausgefüllten Feldern, dann mindestens 1 leeres Feld, dann ein Block aus 1 ausgefülltem Feld.';

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
  String get nonogramTutorialWelcomeTitle => 'Willkommen bei Pixel Nonogram!';

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
      'Lerne Regeln, Steuerung und die wichtigsten Lösungstechniken Schritt für Schritt beim Spielen.';

  @override
  String get nonogramGuideRoutineTitle => 'Wo fängt man an?';

  @override
  String get nonogramGuideRoutineTip1 =>
      'Beginne mit den großen Zahlen. Ist eine Zahl größer als die halbe Linie, steht ein Teil davon schon fest (siehe Technik 1 unten).';

  @override
  String get nonogramGuideRoutineTip2 =>
      'Löse zuerst die einfachen Zeilen: 0 heißt, die ganze Zeile bleibt leer, und ergeben die Zahlen plus je eine Lücke genau die Zeilenlänge, gibt es nur eine Lösung.';

  @override
  String get nonogramGuideRoutineTip3 =>
      'Markiere Kästchen, die sicher leer sind, mit X. Ein X ist genauso nützlich wie ein gefülltes Kästchen.';

  @override
  String get nonogramGuideRoutineTip4 =>
      'Wechsle immer wieder zwischen Zeilen und Spalten. Jedes gelöste Kästchen ist ein neuer Hinweis für die Linie, die es kreuzt.';

  @override
  String get nonogramGuideRoutineTip5 =>
      'Nie raten. Wenn du feststeckst, such die Linie mit den wenigsten offenen Kästchen oder nimm einen Tipp.';

  @override
  String nonogramGuideExample(int number) {
    return 'Beispiel $number';
  }

  @override
  String get nonogramGuideExampleSingle => 'Beispiel';

  @override
  String get nonogramGuideLegendTitle => 'So liest du die Bilder';

  @override
  String get nonogramGuideLegendFilled => 'Gefülltes Kästchen';

  @override
  String get nonogramGuideLegendTrial => 'Probeweise platzierter Block';

  @override
  String get nonogramGuideLegendCross => 'Leeres Kästchen (X)';

  @override
  String get nonogramGuideLegendResult => 'Was daraus folgt';

  @override
  String get nonogramGuideMethodLineDoneTitle => 'Fertige Linien';

  @override
  String get nonogramGuideMethodLineDoneDesc =>
      'Sind alle Blöcke einer Linie platziert, sind alle übrigen Kästchen leer: Markiere sie mit X. Eine Linie mit der Zahl 0 ist von Anfang an leer.';

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
  String get nonogramTutorialToolsDoneTitle => 'Steuerung gemeistert!';

  @override
  String get nonogramTutorialToolsDone =>
      'Echte Rätsel sind größer, und die meisten Zeilen lassen sich nicht auf einen Blick lösen. Als Nächstes lernst du die Lösungstechniken an einem 8×8-Rätsel.';

  @override
  String get nonogramTutorialOverlapSingle =>
      'Such zuerst nach großen Zahlen. Die 6 passt auf 3 Arten in diese 8 Kästchen, jede blinkt nacheinander auf. Was bei jeder Art leuchtet, ist sicher gefüllt: Füll die 4 im gelben Rahmen.';

  @override
  String get nonogramTutorialOverlapMulti =>
      'Mit mehreren Zahlen genauso: 3 3 braucht mindestens 7 Kästchen (3 + Lücke + 3), passt also nur auf 3 Arten. Füll die Kästchen, die bei allen 3 leuchten.';

  @override
  String get nonogramTutorialFullRow =>
      '8 in 8 Kästchen: Die ganze Zeile wird gefüllt. Wisch einmal darüber.';

  @override
  String get nonogramTutorialZeroRow =>
      '0 bedeutet: In dieser Zeile ist kein einziges Kästchen gefüllt. Wechsle in den X-Modus.';

  @override
  String get nonogramTutorialMarkZeroRow =>
      'Markiere die ganze unterste Zeile mit X. X sind wichtig: Sie zeigen den Spalten, wo keine Blöcke hinkönnen.';

  @override
  String get nonogramTutorialOutOfReach =>
      'Jetzt die Spalten. Spalte 2 ist ein Block aus 3, der ihre 2 gefüllten Kästchen abdecken muss, also passt er nur auf 2 Arten. Kästchen, die nie leuchten, sind unerreichbar: Markiere sie mit X, ebenso in Spalte 7.';

  @override
  String get nonogramTutorialBackToFill =>
      'Sieh dir Spalte 3 an: Sie braucht 7. Wechsle zurück in den Ausfüllmodus.';

  @override
  String get nonogramTutorialExactSpace =>
      'Das X ganz unten lässt genau 7 Kästchen für die 7 übrig, also füll sie alle. Spalte 6 funktioniert genauso.';

  @override
  String get nonogramTutorialFinishTechniques =>
      'So geht\'s immer: Löse in den Zeilen, was geht, dann in den Spalten, und wiederhole das. Mach den Pilz jetzt allein fertig!';

  @override
  String get nonogramPlayHintNothingToFill =>
      'Alle Felder, die ausgefüllt sein müssen, sind es schon. Prüfe, ob zu viele Felder ausgefüllt sind.';

  @override
  String get settingsSound => 'Ton';

  @override
  String get settingsLicenses => 'Lizenzen';

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
  String licensesBy(String author) {
    return 'Von $author';
  }

  @override
  String licensesLevelCount(int count) {
    return '$count Rätsel';
  }

  @override
  String get adRewardNotReady =>
      'Die Werbung ist noch nicht bereit. Prüfe deine Internetverbindung und versuche es erneut.';

  @override
  String get settingsAdPrivacy => 'Datenschutz bei Werbung';

  @override
  String get ratingTitle => 'Gefällt dir Pixel Nonogram?';

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
  String get navHome => 'Start';

  @override
  String get navMe => 'Ich';

  @override
  String get meHelp => 'Hilfe';

  @override
  String get meMore => 'Mehr';

  @override
  String get checkInTodayButton => 'Heute einchecken';

  @override
  String get checkInGiftToday => 'Heute gibt\'s ein Geschenk!';

  @override
  String get checkInGiftCollect => 'Abholen';

  @override
  String checkInStreakTitle(int count) {
    return '$count-Tage-Serie';
  }

  @override
  String checkInStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tage',
      one: '1 Tag',
    );
    return '$_temp0';
  }

  @override
  String checkInStreakMakeUp(int missed, String days) {
    String _temp0 = intl.Intl.pluralLogic(
      missed,
      locale: localeName,
      other: '$missed verpasste Tage',
      one: '1 verpassten Tag',
    );
    return 'Hol $_temp0 nach, um deine Serie auf $days zu bringen';
  }

  @override
  String get checkInStreakKeepGoing =>
      'Check jeden Tag ein, um deine Serie zu halten';

  @override
  String get checkInStreakAllDone =>
      'Du hast diesen Monat alle Serien-Geschenke!';

  @override
  String checkInStreakDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Noch $count Tage bis zum Geschenk',
      one: 'Noch 1 Tag bis zum Geschenk',
    );
    return '$_temp0';
  }

  @override
  String get checkInLegendChecked => 'Eingecheckt';

  @override
  String get checkInLegendMissed => 'Verpasst';

  @override
  String get checkInLegendFuture => 'Kommt noch';

  @override
  String checkInGiftStreak(int count) {
    return 'Geschenk für $count Tage Serie';
  }

  @override
  String checkInMakeUpTitle(String date) {
    return '$date nachholen?';
  }

  @override
  String get checkInMakeUpBody =>
      'Sieh dir eine kurze Werbung an, um diesen Tag nachzuholen. Deine Serie wird wieder verbunden.';

  @override
  String get checkInMakeUpWatch => 'Werbung ansehen';

  @override
  String checkInMadeUp(String date) {
    return '$date nachgeholt';
  }

  @override
  String dashboardDailyReminder(String rewards, String time) {
    return 'Du hast noch $rewards, die in $time ablaufen. Nutze sie jetzt, damit nichts verfällt.';
  }

  @override
  String get premiumViewBenefits => 'Vorteile ansehen';

  @override
  String get premiumBenefitsTitle => 'Paketvorteile';

  @override
  String get premiumBenefitsTagline =>
      'Einmal kaufen, Werbung zwischen den Levels entfernen und jeden Tag Hilfsbelohnungen erhalten, dauerhaft auf deinem Konto.';

  @override
  String get premiumBenefitsOneTime => 'einmalig';

  @override
  String get premiumWhatYouGet => 'Das bekommst du';

  @override
  String get premiumPerkNoAdsTitle => 'Keine Werbung zwischen den Levels';

  @override
  String get premiumPerkNoAdsBody =>
      'Keine Vollbildwerbung mehr zwischen den Rätseln. Spiel ohne Unterbrechung von einem Level zum nächsten.';

  @override
  String get premiumPerkDailyTitle => 'Tägliche Check-in-Belohnungen';

  @override
  String get premiumPerkDailyBody =>
      'Jeder Check-in bringt dir an diesem Tag 2 zusätzliche Tipps und 1 Zauberstab, zusätzlich zu den üblichen Meilenstein-Belohnungen.';

  @override
  String get premiumItemsTitle => 'Was die Hilfen bewirken';

  @override
  String get powerUpHintName => 'Tipp';

  @override
  String get powerUpHintTagline => 'Deckt ein richtiges Feld deiner Wahl auf';

  @override
  String get powerUpHintDesc =>
      'Tippe auf die Glühbirne und wähle die Stelle, bei der du unsicher bist. Die App füllt ein richtiges Feld aus (gefüllt oder als leer markiert), damit du weiterkommst.';

  @override
  String get powerUpWandName => 'Zauberstab';

  @override
  String get powerUpWandTagline => 'Löst eine ganze Zeile oder Spalte';

  @override
  String get powerUpWandDesc =>
      'Tippe auf den Zauberstab, um den Auswahlmodus zu aktivieren, und tippe dann auf die Zahlen einer Zeile oder Spalte. Die App deckt diese ganze Zeile oder Spalte auf. Stärker als ein Tipp für ein einzelnes Feld.';

  @override
  String get powerUpStatesTitle => 'Das Symbol zeigt die Art der Nutzung';

  @override
  String get powerUpStatesLead =>
      'Die Zahl in der Ecke ist die Gesamtzahl deiner verbleibenden Nutzungen. Eine zeitlich begrenzte Nutzung färbt das Symbol golden mit einer kleinen Uhr:';

  @override
  String get powerUpTimeLimited => 'Zeitlich begrenzt';

  @override
  String get powerUpTimeLimitedDesc =>
      'Goldenes Symbol mit Uhr. Aus der täglichen Check-in-Belohnung des Pakets. Läuft am Ende des Tages ab.';

  @override
  String get powerUpPermanent => 'Dauerhaft';

  @override
  String get powerUpPermanentDesc =>
      'Normales Symbol mit blauem Abzeichen. Meilenstein- und Startnutzungen. Laufen nie ab.';

  @override
  String get powerUpSpendOrderTitle =>
      'Welche Nutzungen werden zuerst verbraucht?';

  @override
  String get powerUpSpendOrderHeading =>
      'Zeitlich begrenzte Nutzungen werden zuerst verbraucht';

  @override
  String get powerUpSpendOrderBody =>
      'Tägliche Nutzungen laufen am Ende des Tages ab. Darum verbraucht ein Tipp oder Zauberstab zuerst deine täglichen Nutzungen und erst dann deine dauerhaften, wenn die täglichen aufgebraucht sind. So geht nichts verloren.';

  @override
  String get powerUpSpendDaily => 'Tägliche Nutzungen';

  @override
  String get powerUpSpendPermanent => 'Dauerhafte Nutzungen';

  @override
  String get premiumBenefitsFootnote =>
      'Tägliche Nutzungen werden nicht auf den nächsten Tag übertragen. Meilenstein-Belohnungen sind dauerhafte Nutzungen und sammeln sich wie gewohnt an.';

  @override
  String dashboardDailyReminderBoth(String hints, String wands) {
    return '$hints und $wands';
  }
}

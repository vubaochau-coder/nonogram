// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Nonopix';

  @override
  String get commonCancel => 'Annulla';

  @override
  String get commonRetry => 'Riprova';

  @override
  String get commonSave => 'Salva';

  @override
  String nonogramDashboardContinueLevel(int level) {
    return 'Livello $level';
  }

  @override
  String get nonogramDashboardProgressSectionTitle => 'I tuoi progressi';

  @override
  String get nonogramDashboardStatCompleted => 'Completati';

  @override
  String get nonogramGuideIntro =>
      'I nonogrammi sono rompicapi logici con regole semplici e soluzioni impegnative. Lo scopo è svelare immagini nascoste riempiendo le caselle in base ai numeri a lato della griglia.';

  @override
  String get nonogramGuideMethodDivisionDesc =>
      'Se unire due blocchi esistenti creerebbe una figura più grande di qualsiasi indizio disponibile, lo spazio tra loro deve essere una X.';

  @override
  String get nonogramGuideMethodDivisionTitle => '5. Divisione';

  @override
  String get nonogramGuideMethodDoublePositioningDesc =>
      'Se una casella piena può appartenere solo ad alcune varianti specifiche di un blocco, tutte le caselle che non vengono riempite in nessuna di queste varianti vanno segnate con una X.';

  @override
  String get nonogramGuideMethodDoublePositioningTitle =>
      '6. Doppio posizionamento';

  @override
  String get nonogramGuideMethodInaccessibilityDesc =>
      'Segna con una croce (X) le caselle che non possono appartenere a nessuna delle figure rimanenti.';

  @override
  String get nonogramGuideMethodInaccessibilityTitle => '3. Inaccessibilità';

  @override
  String get nonogramGuideMethodNotFitDesc =>
      'Se uno spazio vuoto tra le croci è più piccolo di qualsiasi indizio disponibile per quella linea, va segnato con una X.';

  @override
  String get nonogramGuideMethodNotFitTitle => '4. Non ci sta';

  @override
  String get nonogramGuideMethodSuperpositionMultiDesc =>
      'Quando ci sono più numeri, sovrapponi le posizioni estreme a sinistra e a destra dell\'intero gruppo, tenendo conto dello spazio minimo obbligatorio di una casella tra blocchi dello stesso colore. Le caselle in cui un blocco si sovrappone a sé stesso in entrambe le varianti vanno riempite.';

  @override
  String get nonogramGuideMethodSuperpositionMultiTitle =>
      'Sovrapposizione (più indizi)';

  @override
  String get nonogramGuideMethodSuperpositionSimpleDesc =>
      'Se un numero supera metà della lunghezza, alcune caselle centrali saranno sicuramente piene. Sovrapponi le posizioni estreme a sinistra e a destra; dove coincidono, le caselle vanno riempite.';

  @override
  String get nonogramGuideMethodSuperpositionSimpleTitle =>
      'Sovrapposizione (un indizio)';

  @override
  String get nonogramGuideMethodWallPushingDesc =>
      'Se una casella piena nota è più vicina a un bordo della lunghezza del primo indizio, la figura a cui appartiene deve estendersi allontanandosi da quel bordo.';

  @override
  String get nonogramGuideMethodWallPushingTitle => '2. Spingere via dai bordi';

  @override
  String get nonogramGuideRuleDesc =>
      'Ogni numero rappresenta un blocco continuo di caselle piene in quella riga o colonna. Se ci sono più numeri, rappresentano blocchi separati, e ogni blocco deve essere separato dal successivo da almeno una casella vuota. Per esempio, `3 1` significa un blocco di 3 caselle piene, poi almeno 1 casella vuota, poi un blocco di 1 casella piena.';

  @override
  String get nonogramGuideRuleTitle => 'Regola base: cosa significano i numeri';

  @override
  String get nonogramGuideTitle => 'Come risolvere';

  @override
  String nonogramHistoryCompletedOn(String date) {
    return 'Completato il $date';
  }

  @override
  String get nonogramHistoryDetailNotFound =>
      'Dettagli del livello non trovati.';

  @override
  String get nonogramHistoryEmpty => 'Nessun livello completato finora.';

  @override
  String nonogramHistoryLevel(int n) {
    return 'Livello $n';
  }

  @override
  String get nonogramHistoryTitle => 'Risultati';

  @override
  String get nonogramPlayActionNextLevelFixed => 'Livello successivo';

  @override
  String get nonogramPlayActionShowClues => 'Mostra indizi';

  @override
  String nonogramPlayCompletionMessage(int level) {
    return 'Complimenti! Hai completato il livello $level.';
  }

  @override
  String get nonogramPlayCompletionTitle => 'Rompicapo risolto!';

  @override
  String nonogramPlayDurationFormat(int minutes, int seconds) {
    return '$minutes min $seconds s';
  }

  @override
  String nonogramPlayHintLabel(int count) {
    return 'Aiuto ($count)';
  }

  @override
  String get nonogramPlayNoNextLevelToast =>
      'Non c\'è ancora un livello successivo.';

  @override
  String get nonogramPlayPageTitle => 'Nonogramma';

  @override
  String get nonogramSettingsTitle => 'Impostazioni';

  @override
  String get nonogramDashboardContinueNext => 'Prossima sfida';

  @override
  String get nonogramDashboardPlay => 'Gioca';

  @override
  String get nonogramDashboardResumeAction => 'Continua';

  @override
  String get nonogramDashboardInProgressBadge => 'In corso';

  @override
  String nonogramDashboardDifficulty(String value) {
    return 'Difficoltà $value';
  }

  @override
  String nonogramDashboardSolvedOfTotal(int completed, int total) {
    return '$completed rompicapi risolti su $total';
  }

  @override
  String get nonogramDashboardStatFastest => 'Più veloce';

  @override
  String get nonogramDashboardStatTotalTime => 'Tempo totale';

  @override
  String get nonogramDashboardRecentTitle => 'Risolti di recente';

  @override
  String get nonogramDashboardSeeAll => 'Vedi tutti';

  @override
  String get nonogramDashboardRecentEmpty =>
      'Risolvi il tuo primo rompicapo per iniziare la tua collezione di immagini.';

  @override
  String get nonogramDashboardAllDoneTitle => 'Tutti i rompicapi risolti!';

  @override
  String nonogramDashboardAllDoneDesc(int total) {
    return 'Hai completato tutti i $total rompicapi. Rivedi la tua collezione quando vuoi.';
  }

  @override
  String nonogramDurationHoursMinutes(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String nonogramHistoryBestTime(String time) {
    return 'Record $time';
  }

  @override
  String get nonogramPlayActionDashboard => 'Home';

  @override
  String get appThemeTitle => 'Aspetto';

  @override
  String get appThemeLight => 'Chiaro';

  @override
  String get appThemeDark => 'Scuro';

  @override
  String get nonogramPlayModeFill => 'Modalità riempimento';

  @override
  String get nonogramPlayModeMark => 'Modalità X';

  @override
  String get nonogramSettingsRestart => 'Ricomincia questo livello';

  @override
  String get nonogramSettingsRestartConfirmTitle =>
      'Ricominciare questo livello?';

  @override
  String get nonogramSettingsRestartConfirmMessage =>
      'Tutte le caselle che hai riempito o segnato verranno cancellate. Le caselle con la stella (aperte con gli aiuti o la bacchetta) restano.';

  @override
  String get commonClose => 'Chiudi';

  @override
  String get nonogramSettingsRestartConfirm => 'Ricomincia';

  @override
  String get nonogramTutorialTitle => 'Come si gioca';

  @override
  String get nonogramTutorialSkip => 'Salta';

  @override
  String get nonogramTutorialWelcomeTitle => 'Benvenuto in Nonopix!';

  @override
  String get nonogramTutorialWelcome =>
      'Impariamo le regole di base con un piccolo rompicapo 5×5.';

  @override
  String get nonogramTutorialStart => 'Inizia';

  @override
  String get nonogramTutorialSwitchToFill =>
      'I rompicapi si risolvono riempiendo le caselle. Tocca il pulsante qui sotto per passare alla modalità riempimento.';

  @override
  String get nonogramTutorialClueIsCount =>
      'Il numero indica quante caselle della riga sono piene. Questa riga ne ha 5, quindi riempile tutte!';

  @override
  String get nonogramTutorialEdgeCell =>
      'L\'ultima casella è già piena. Il blocco da 4 deve includerla, quindi c\'è un solo modo di posizionarlo: riempi le 3 caselle alla sua sinistra.';

  @override
  String get nonogramTutorialMultipleClues =>
      'Più numeri significano più blocchi, con almeno una casella vuota tra loro. 2 2 entra in queste 5 caselle in un solo modo.';

  @override
  String get nonogramTutorialClueOrder =>
      'Anche l\'ordine conta: 3 1 significa che prima viene il blocco da 3 e poi quello da 1.';

  @override
  String get nonogramTutorialColumns =>
      'Anche le colonne hanno numeri, letti dall\'alto in basso. Passa alla modalità X per segnare le caselle che devono restare vuote.';

  @override
  String get nonogramTutorialMarkEmpty =>
      'Le colonne con ✓ hanno già tutte le loro caselle. Segna con una X le caselle vuote rimaste.';

  @override
  String get nonogramTutorialOneCellLeft =>
      'All\'1 dell\'ultima riga resta ormai un solo posto. Torna alla modalità riempimento.';

  @override
  String get nonogramTutorialFinish =>
      'Riempi l\'ultima casella per completare il rompicapo!';

  @override
  String get nonogramTutorialDoneTitle => 'Ben fatto!';

  @override
  String get nonogramTutorialDone =>
      'Sei pronto! Nei rompicapi grandi, trascina con due dita (o dallo spazio vuoto fuori dalla griglia) per spostare il tabellone; l\'app te lo ricorderà al tuo primo rompicapo grande.';

  @override
  String get nonogramTutorialShowTechniques =>
      'Vedi le tecniche di risoluzione';

  @override
  String get nonogramTutorialPlay => 'Inizia a giocare';

  @override
  String get nonogramGuideTutorialCardTitle => 'Impara giocando';

  @override
  String get nonogramGuideTutorialCardDesc =>
      'Impara regole e comandi passo dopo passo su un piccolo rompicapo 5×5.';

  @override
  String get nonogramPlayInfoHide => 'Nascondi info livello';

  @override
  String get nonogramPlayWandLabel => 'Bacchetta magica';

  @override
  String get nonogramPlayWandSelectPrompt =>
      'Tocca gli indizi della riga o colonna da svelare';

  @override
  String get nonogramPlayWandRowSolved =>
      'Questa riga è già corretta. Scegli un\'altra riga o colonna.';

  @override
  String get nonogramPlayWandColSolved =>
      'Questa colonna è già corretta. Scegli un\'altra riga o colonna.';

  @override
  String get nonogramSettingsControlsGuide => 'Guida ai comandi';

  @override
  String get nonogramCoachSkip => 'Salta';

  @override
  String get nonogramCoachNext => 'Avanti';

  @override
  String get nonogramCoachDone => 'Ho capito';

  @override
  String nonogramCoachStep(int current, int total) {
    return '$current/$total';
  }

  @override
  String get nonogramCoachHintTitle => 'Aiuto';

  @override
  String get nonogramCoachHintBody =>
      'Riempie per te 5 caselle corrette (caselle che dovrebbero essere piene ma non lo sono ancora), scelte a caso su tutto il tabellone. Ricevono una stella: non si possono modificare e restano anche se ricominci. Ne hai 3 per rompicapo.';

  @override
  String get nonogramCoachWandTitle => 'Bacchetta magica';

  @override
  String get nonogramCoachWandBody =>
      'Tocca la bacchetta, poi gli indizi di una riga o colonna qualsiasi: la soluzione dell\'intera linea viene svelata e segnata con una stella, che resta anche se ricominci. Ne hai 1 per rompicapo.';

  @override
  String get nonogramCoachModeTitle => 'Riempi o X';

  @override
  String get nonogramCoachModeBody =>
      'Scegli cosa fa un tocco: riempire la casella o segnarla con una X per ricordare che è vuota. Tocca il pulsante per cambiare. Trascina sulla griglia per riempire o segnare molte caselle in una volta.';

  @override
  String get nonogramCoachLongPressTitle => 'Tieni premuto per l\'opposto';

  @override
  String get nonogramCoachLongPressBody =>
      'Tieni premuta una casella per fare l\'opposto della modalità attuale: X mentre riempi, riempire mentre segni. Una breve vibrazione indica che è fatto e puoi lasciare.';

  @override
  String get nonogramCoachScrollTitle => 'Muoversi nei rompicapi grandi';

  @override
  String get nonogramCoachScrollBody =>
      'I rompicapi grandi non entrano nello schermo: trascina con due dita, o dallo spazio vuoto fuori dalla griglia, per spostare il tabellone. Trascina sugli indizi per vedere i numeri nascosti (il \"+N\" nell\'angolo indica quanti sono).';

  @override
  String get nonogramTutorialRulesDoneTitle => 'Conosci le regole!';

  @override
  String get nonogramTutorialRulesDone =>
      'Ora esercitiamoci con comandi e aiuti su un altro rompicapo: trascinare per riempire in fretta, tenere premuto per segnare, gli aiuti e la bacchetta magica.';

  @override
  String get nonogramTutorialContinue => 'Continua';

  @override
  String get nonogramTutorialLater => 'Più tardi, gioca e basta';

  @override
  String get nonogramTutorialDragRow =>
      'Suggerimento: trascina il dito sulle caselle per riempirle in un colpo solo. La riga in alto ne ha 5, quindi trascina su tutta la riga!';

  @override
  String get nonogramTutorialLongPressMark =>
      '1 1 1 entra esattamente in queste 5 caselle, quindi la 2ª e la 4ª casella devono essere vuote. Non serve cambiare modalità: tieni premuta ciascuna per segnarla con una X. Una breve vibrazione indica che è fatto.';

  @override
  String get nonogramTutorialUseHint =>
      'Bloccato? Tocca il pulsante Aiuto e l\'app riempie a caso 5 caselle corrette. Ne hai 3 per rompicapo.';

  @override
  String get nonogramTutorialActivateWand =>
      'L\'aiuto ha riempito 5 caselle segnate con una stella: sono bloccate e restano anche se ricominci. Per svelare un\'intera riga o colonna a tua scelta, usa la bacchetta magica: tocca il pulsante della bacchetta.';

  @override
  String get nonogramTutorialPickWandLine =>
      'Ora tocca gli indizi della riga in basso per svelarla. Hai 1 bacchetta per rompicapo.';

  @override
  String get nonogramTutorialFinishTools =>
      'Riempi le caselle rimaste per finire. Trascina lungo una colonna per riempire più in fretta.';

  @override
  String get nonogramPlayHintNothingToFill =>
      'Tutte le caselle da riempire sono già piene. Controlla se ci sono caselle piene di troppo.';

  @override
  String get settingsSound => 'Suoni';

  @override
  String get settingsLicenses => 'Licenze';

  @override
  String get settingsSwitchPlayMode => 'Cambia modalità di gioco';

  @override
  String get licensesTitle => 'Licenze';

  @override
  String get licensesLevelArtHeading => 'Rompicapi';

  @override
  String get licensesLevelArtIntro =>
      'I rompicapi provengono da queste fonti. I set di icone sono stati ridotti, convertiti in bianco e nero e modificati perché ogni rompicapo sia risolvibile; le raccolte di nonogrammi sono usate così come sono.';

  @override
  String get licensesFontHeading => 'Carattere';

  @override
  String get licensesSoftwareButton => 'Licenze del software open source';

  @override
  String get licensesDeveloperLevelsNote =>
      'I rompicapi della modalità sviluppatore provengono da nonogram.org e servono solo per i test interni. Non sono inclusi nella versione dello store.';

  @override
  String get playModeTitle => 'Scegli una modalità di gioco';

  @override
  String get playModeSubtitle =>
      'I progressi vengono salvati separatamente per ogni modalità.';

  @override
  String get playModeUserTitle => 'Modalità giocatore';

  @override
  String get playModeUserBody =>
      'I rompicapi con licenza inclusi nella versione dello store.';

  @override
  String get playModeDeveloperTitle => 'Modalità sviluppatore';

  @override
  String get playModeDeveloperBody =>
      'I rompicapi originali di nonogram.org, per i test interni. Mantiene i tuoi progressi precedenti.';

  @override
  String get playModeLastUsed => 'Ultima usata';

  @override
  String licensesBy(String author) {
    return 'Di $author';
  }

  @override
  String licensesLevelCount(int count) {
    return '$count rompicapi';
  }

  @override
  String playModeProgress(int solved, int total) {
    return '$solved/$total risolti';
  }

  @override
  String get adRewardNotReady =>
      'L\'annuncio non è ancora pronto. Controlla la connessione a Internet e riprova.';

  @override
  String get settingsAdPrivacy => 'Privacy degli annunci';

  @override
  String get ratingTitle => 'Ti piace Nonopix?';

  @override
  String get ratingMessage => 'Tocca una stella per valutare il gioco.';

  @override
  String get ratingLater => 'Più tardi';

  @override
  String get ratingSubmit => 'Invia';

  @override
  String get ratingThanks =>
      'Grazie per il tuo feedback! Continueremo a migliorare il gioco.';

  @override
  String ratingStarLabel(int count) {
    return '$count stelle';
  }

  @override
  String get settingsLanguage => 'Lingua';

  @override
  String get settingsLanguageSystem => 'Lingua del dispositivo';

  @override
  String get premiumTitle => 'Gioca senza pubblicità';

  @override
  String get premiumBenefitNoAds => 'Niente più pubblicità tra i livelli';

  @override
  String get premiumBenefitDaily =>
      '2 suggerimenti e 1 bacchetta magica ogni giorno in cui segni la presenza';

  @override
  String premiumBuy(String price) {
    return 'Acquista · $price';
  }

  @override
  String get premiumOneTime => 'Pagamento unico tramite Google Play';

  @override
  String get premiumActiveTitle => 'Pacchetto senza pubblicità attivo';

  @override
  String get premiumActiveDaily =>
      'Segna la presenza ogni giorno per ricevere 2 suggerimenti e 1 bacchetta magica per quel giorno.';

  @override
  String get premiumPurchased =>
      'Grazie! La pubblicità tra i livelli è disattivata.';

  @override
  String get premiumPending =>
      'Il pagamento è in sospeso. Il pacchetto si attiverà appena verrà completato.';

  @override
  String get premiumFailed => 'L\'acquisto non è andato a buon fine. Riprova.';

  @override
  String get checkInTitle => 'Presenza giornaliera';

  @override
  String get checkInAction => 'Segna presenza';

  @override
  String get checkInDoneToday => 'Presenza segnata oggi';

  @override
  String checkInNextGift(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Prossimo regalo tra $count presenze',
      one: 'Prossimo regalo alla prossima presenza',
    );
    return '$_temp0';
  }

  @override
  String get checkInCheckedIn => 'Presenza segnata!';

  @override
  String checkInReceived(String rewards) {
    return 'Hai ricevuto $rewards.';
  }

  @override
  String rewardHints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count suggerimenti',
      one: '1 suggerimento',
    );
    return '$_temp0';
  }

  @override
  String rewardWands(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bacchette magiche',
      one: '1 bacchetta magica',
    );
    return '$_temp0';
  }

  @override
  String rewardTodayOnly(String reward) {
    return '$reward (solo oggi)';
  }

  @override
  String get checkInMonthGifts => 'Regali del mese';

  @override
  String get navHome => 'Home';

  @override
  String get navMe => 'Io';

  @override
  String get meHelp => 'Aiuto';

  @override
  String get meMore => 'Altro';

  @override
  String get checkInNotYetToday => 'Presenza di oggi non ancora segnata';

  @override
  String get checkInTodayButton => 'Segna la presenza di oggi';

  @override
  String checkInGiftsLeftShort(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ancora $count per un regalo',
      one: 'Ancora 1 per un regalo',
    );
    return '$_temp0';
  }

  @override
  String get checkInGiftToday => 'Oggi c\'è un regalo!';

  @override
  String checkInGiftMilestone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Regalo per $count presenze',
      one: 'Regalo per 1 presenza',
    );
    return '$_temp0';
  }

  @override
  String get checkInGiftCollect => 'Ritira';

  @override
  String get checkInTotalHints => 'Suggerimenti';

  @override
  String get checkInTotalWands => 'Bacchette magiche';

  @override
  String get checkInTotalDailyHints => 'Suggerimenti (solo oggi)';

  @override
  String get checkInTotalDailyWands => 'Bacchette magiche (solo oggi)';

  @override
  String get checkInPremiumToday => 'Oggi dal tuo pacchetto senza pubblicità';

  @override
  String get checkInPremiumNotYet =>
      'Segna la presenza per ricevere 2 suggerimenti e 1 bacchetta magica per oggi.';

  @override
  String get checkInPremiumUsedUp => 'Tutto usato per oggi. A domani!';

  @override
  String checkInExpiresIn(String time) {
    return 'Scade tra $time';
  }

  @override
  String dashboardDailyReminder(String rewards, String time) {
    return 'Hai ancora $rewards per oggi. Scadono tra $time: gioca ora per non sprecarli!';
  }

  @override
  String get dashboardDailyReminderTitle => 'I tuoi aiuti di oggi ti aspettano';

  @override
  String get dashboardDailyReminderPlay => 'Gioca ora';

  @override
  String get premiumViewBenefits => 'Vedi i vantaggi';

  @override
  String get premiumBenefitsTitle => 'Vantaggi del pacchetto';

  @override
  String get premiumBenefitsTagline => 'Acquista una volta per rimuovere la pubblicità tra i livelli e ricevere ricompense di aiuto ogni giorno, per sempre sul tuo account.';

  @override
  String get premiumBenefitsOneTime => 'pagamento unico';

  @override
  String get premiumWhatYouGet => 'Cosa ottieni';

  @override
  String get premiumPerkNoAdsTitle => 'Niente pubblicità tra i livelli';

  @override
  String get premiumPerkNoAdsBody => 'Niente più pubblicità a schermo intero tra un puzzle e l\'altro. Passa da un livello al successivo senza interruzioni.';

  @override
  String get premiumPerkDailyTitle => 'Ricompense giornaliere di presenza';

  @override
  String get premiumPerkDailyBody => 'Ogni presenza ti dà 2 suggerimenti extra e 1 bacchetta magica per quel giorno, oltre alle solite ricompense dei traguardi.';

  @override
  String get premiumItemsTitle => 'Cosa fanno gli aiuti';

  @override
  String get powerUpHintName => 'Suggerimento';

  @override
  String get powerUpHintTagline => 'Rivela una casella corretta che scegli tu';

  @override
  String get powerUpHintDesc => 'Tocca la lampadina, poi scegli il punto su cui sei incerto. L\'app riempie una casella corretta (piena o segnata come vuota) per sbloccarti.';

  @override
  String get powerUpWandName => 'Bacchetta magica';

  @override
  String get powerUpWandTagline => 'Risolve un\'intera riga o colonna';

  @override
  String get powerUpWandDesc => 'Tocca la bacchetta per attivare la modalità selezione, poi tocca i numeri indizio di una riga o colonna. L\'app rivela l\'intera riga o colonna. Più potente di un suggerimento su una singola casella.';

  @override
  String get powerUpStatesTitle => 'L\'icona indica il tipo di utilizzo';

  @override
  String get powerUpStatesLead => 'Il numero nell\'angolo è il totale degli utilizzi rimasti. Un utilizzo a tempo limitato rende l\'icona dorata con un piccolo orologio:';

  @override
  String get powerUpTimeLimited => 'A tempo limitato';

  @override
  String get powerUpTimeLimitedDesc => 'Icona dorata con orologio. Dalla ricompensa giornaliera di presenza del pacchetto. Scade alla fine della giornata.';

  @override
  String get powerUpPermanent => 'Permanente';

  @override
  String get powerUpPermanentDesc => 'Icona normale con badge blu. Utilizzi dei traguardi e iniziali. Non scadono mai.';

  @override
  String get powerUpSpendOrderTitle => 'Quali utilizzi si consumano per primi?';

  @override
  String get powerUpSpendOrderHeading => 'Gli utilizzi a tempo limitato si consumano per primi';

  @override
  String get powerUpSpendOrderBody => 'Gli utilizzi giornalieri scadono alla fine della giornata, quindi un suggerimento o una bacchetta consuma prima gli utilizzi giornalieri e usa quelli permanenti solo quando i giornalieri finiscono. Niente va sprecato.';

  @override
  String get powerUpSpendDaily => 'Utilizzi giornalieri';

  @override
  String get powerUpSpendPermanent => 'Utilizzi permanenti';

  @override
  String get premiumBenefitsFootnote => 'Gli utilizzi giornalieri non passano al giorno successivo. Le ricompense dei traguardi sono utilizzi permanenti e si accumulano normalmente.';
}

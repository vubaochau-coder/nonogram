// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Nonopix';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonRetry => 'Réessayer';

  @override
  String get commonSave => 'Enregistrer';

  @override
  String nonogramDashboardContinueLevel(int level) {
    return 'Niveau $level';
  }

  @override
  String get nonogramDashboardProgressSectionTitle => 'Votre progression';

  @override
  String get nonogramDashboardStatCompleted => 'Terminés';

  @override
  String get nonogramGuideIntro =>
      'Les nonogrammes sont des casse-tête logiques aux règles simples et aux solutions stimulantes. Le but est de révéler des images cachées en remplissant des cases selon les nombres placés au bord de la grille.';

  @override
  String get nonogramGuideMethodDivisionDesc =>
      'Si relier deux blocs existants créait une figure plus grande que tous les indices disponibles, l\'espace entre eux doit être un X.';

  @override
  String get nonogramGuideMethodDivisionTitle => '5. Séparation';

  @override
  String get nonogramGuideMethodDoublePositioningDesc =>
      'Si une case remplie ne peut appartenir qu\'à quelques variantes précises d\'un bloc, toutes les cases qui ne sont remplies dans aucune de ces variantes doivent être marquées d\'un X.';

  @override
  String get nonogramGuideMethodDoublePositioningTitle =>
      '6. Double positionnement';

  @override
  String get nonogramGuideMethodInaccessibilityDesc =>
      'Marquez d\'une croix (X) les cases qui ne peuvent appartenir à aucune des figures restantes.';

  @override
  String get nonogramGuideMethodInaccessibilityTitle => '3. Inaccessibilité';

  @override
  String get nonogramGuideMethodNotFitDesc =>
      'Si un espace vide entre des croix est plus petit que tous les indices disponibles pour cette ligne, il doit être marqué d\'un X.';

  @override
  String get nonogramGuideMethodNotFitTitle => '4. Pas assez de place';

  @override
  String get nonogramGuideMethodSuperpositionMultiDesc =>
      'Lorsqu\'il y a plusieurs nombres, superposez les positions extrêmes à gauche et à droite de tout le groupe, en tenant compte de l\'espace minimal obligatoire d\'une case entre deux blocs de même couleur. Les cases où un bloc se recouvre lui-même dans les deux variantes sont remplies.';

  @override
  String get nonogramGuideMethodSuperpositionMultiTitle =>
      'Superposition (plusieurs indices)';

  @override
  String get nonogramGuideMethodSuperpositionSimpleDesc =>
      'Si un nombre dépasse la moitié de la longueur, certaines cases du milieu seront forcément remplies. Superposez les positions extrêmes à gauche et à droite ; là où elles se recouvrent, les cases sont remplies.';

  @override
  String get nonogramGuideMethodSuperpositionSimpleTitle =>
      'Superposition (un seul indice)';

  @override
  String get nonogramGuideMethodWallPushingDesc =>
      'Si une case remplie connue est plus proche d\'un bord que la taille du premier indice, la figure à laquelle elle appartient doit s\'étendre en s\'éloignant de ce bord.';

  @override
  String get nonogramGuideMethodWallPushingTitle =>
      '2. Repousser depuis les bords';

  @override
  String get nonogramGuideRuleDesc =>
      'Chaque nombre représente un bloc continu de cases remplies dans cette ligne ou colonne. S\'il y a plusieurs nombres, ils représentent des blocs distincts, et chaque bloc doit être séparé du suivant par au moins une case vide. Par exemple, `3 1` signifie un bloc de 3 cases remplies, puis au moins 1 case vide, puis un bloc de 1 case remplie.';

  @override
  String get nonogramGuideRuleTitle =>
      'Règle de base : ce que signifient les nombres';

  @override
  String get nonogramGuideTitle => 'Comment résoudre';

  @override
  String nonogramHistoryCompletedOn(String date) {
    return 'Terminé le $date';
  }

  @override
  String get nonogramHistoryDetailNotFound => 'Détails du niveau introuvables.';

  @override
  String get nonogramHistoryEmpty => 'Aucun niveau terminé pour l\'instant.';

  @override
  String nonogramHistoryLevel(int n) {
    return 'Niveau $n';
  }

  @override
  String get nonogramHistoryTitle => 'Résultats';

  @override
  String get nonogramPlayActionNextLevelFixed => 'Niveau suivant';

  @override
  String get nonogramPlayActionShowClues => 'Afficher les indices';

  @override
  String nonogramPlayCompletionMessage(int level) {
    return 'Félicitations ! Vous avez terminé le niveau $level.';
  }

  @override
  String get nonogramPlayCompletionTitle => 'Grille résolue !';

  @override
  String nonogramPlayDurationFormat(int minutes, int seconds) {
    return '$minutes min $seconds s';
  }

  @override
  String nonogramPlayHintLabel(int count) {
    return 'Indice ($count)';
  }

  @override
  String get nonogramPlayNoNextLevelToast => 'Pas encore de niveau suivant.';

  @override
  String get nonogramPlayPageTitle => 'Nonogramme';

  @override
  String get nonogramSettingsTitle => 'Paramètres';

  @override
  String get nonogramDashboardContinueNext => 'Défi suivant';

  @override
  String get nonogramDashboardPlay => 'Jouer';

  @override
  String get nonogramDashboardResumeAction => 'Continuer';

  @override
  String get nonogramDashboardInProgressBadge => 'En cours';

  @override
  String nonogramDashboardDifficulty(String value) {
    return 'Difficulté $value';
  }

  @override
  String nonogramDashboardSolvedOfTotal(int completed, int total) {
    return '$completed grilles résolues sur $total';
  }

  @override
  String get nonogramDashboardStatFastest => 'Plus rapide';

  @override
  String get nonogramDashboardStatTotalTime => 'Temps total';

  @override
  String get nonogramDashboardRecentTitle => 'Résolues récemment';

  @override
  String get nonogramDashboardSeeAll => 'Tout voir';

  @override
  String get nonogramDashboardRecentEmpty =>
      'Résolvez votre première grille pour commencer votre collection d\'images.';

  @override
  String get nonogramDashboardAllDoneTitle =>
      'Toutes les grilles sont résolues !';

  @override
  String nonogramDashboardAllDoneDesc(int total) {
    return 'Vous avez terminé les $total grilles. Revoyez votre collection quand vous voulez.';
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
  String get nonogramPlayActionDashboard => 'Accueil';

  @override
  String get appThemeTitle => 'Apparence';

  @override
  String get appThemeLight => 'Clair';

  @override
  String get appThemeDark => 'Sombre';

  @override
  String get nonogramPlayModeFill => 'Mode remplissage';

  @override
  String get nonogramPlayModeMark => 'Mode croix (X)';

  @override
  String get nonogramSettingsRestart => 'Recommencer ce niveau';

  @override
  String get nonogramSettingsRestartConfirmTitle => 'Recommencer ce niveau ?';

  @override
  String get nonogramSettingsRestartConfirmMessage =>
      'Toutes les cases que vous avez remplies ou marquées seront effacées. Les cases avec une étoile (ouvertes par un indice ou la baguette) sont conservées.';

  @override
  String get commonClose => 'Fermer';

  @override
  String get nonogramSettingsRestartConfirm => 'Recommencer';

  @override
  String get nonogramTutorialTitle => 'Comment jouer';

  @override
  String get nonogramTutorialSkip => 'Passer';

  @override
  String get nonogramTutorialWelcomeTitle => 'Bienvenue dans Nonopix !';

  @override
  String get nonogramTutorialWelcome =>
      'Découvrons les règles de base avec une petite grille de 5×5.';

  @override
  String get nonogramTutorialStart => 'Commencer';

  @override
  String get nonogramTutorialSwitchToFill =>
      'On résout les grilles en remplissant des cases. Touchez le bouton ci-dessous pour passer en mode remplissage.';

  @override
  String get nonogramTutorialClueIsCount =>
      'Le nombre indique combien de cases de la ligne sont remplies. Cette ligne en a 5 : remplissez-les toutes !';

  @override
  String get nonogramTutorialEdgeCell =>
      'La dernière case est déjà remplie. Le bloc de 4 doit l\'inclure, il n\'y a donc qu\'une seule façon de le placer : remplissez les 3 cases à sa gauche.';

  @override
  String get nonogramTutorialMultipleClues =>
      'Plusieurs nombres signifient plusieurs blocs, séparés par au moins une case vide. 2 2 ne tient dans ces 5 cases que d\'une seule façon.';

  @override
  String get nonogramTutorialClueOrder =>
      'L\'ordre compte aussi : 3 1 signifie que le bloc de 3 vient d\'abord, puis le bloc de 1.';

  @override
  String get nonogramTutorialColumns =>
      'Les colonnes ont aussi des nombres, qui se lisent de haut en bas. Passez en mode X pour marquer les cases qui doivent rester vides.';

  @override
  String get nonogramTutorialMarkEmpty =>
      'Les colonnes avec un ✓ ont déjà toutes leurs cases. Marquez leurs cases vides restantes d\'un X.';

  @override
  String get nonogramTutorialOneCellLeft =>
      'Le 1 de la dernière ligne n\'a plus qu\'une place possible. Revenez en mode remplissage.';

  @override
  String get nonogramTutorialFinish =>
      'Remplissez la dernière case pour terminer la grille !';

  @override
  String get nonogramTutorialDoneTitle => 'Bravo !';

  @override
  String get nonogramTutorialDone =>
      'Vous êtes prêt ! Sur les grandes grilles, faites glisser avec deux doigts (ou depuis l\'espace vide autour de la grille) pour déplacer le plateau ; l\'app vous le rappellera sur votre première grande grille.';

  @override
  String get nonogramTutorialShowTechniques =>
      'Voir les techniques de résolution';

  @override
  String get nonogramTutorialPlay => 'Commencer à jouer';

  @override
  String get nonogramGuideTutorialCardTitle => 'Apprendre en jouant';

  @override
  String get nonogramGuideTutorialCardDesc =>
      'Apprenez les règles et les commandes pas à pas sur une petite grille de 5×5.';

  @override
  String get nonogramPlayInfoHide => 'Masquer les infos du niveau';

  @override
  String get nonogramPlayWandLabel => 'Baguette magique';

  @override
  String get nonogramPlayWandSelectPrompt =>
      'Touchez les indices de la ligne ou de la colonne à révéler';

  @override
  String get nonogramPlayWandRowSolved =>
      'Cette ligne est déjà correcte. Choisissez une autre ligne ou colonne.';

  @override
  String get nonogramPlayWandColSolved =>
      'Cette colonne est déjà correcte. Choisissez une autre ligne ou colonne.';

  @override
  String get nonogramSettingsControlsGuide => 'Guide des commandes';

  @override
  String get nonogramCoachSkip => 'Passer';

  @override
  String get nonogramCoachNext => 'Suivant';

  @override
  String get nonogramCoachDone => 'Compris';

  @override
  String nonogramCoachStep(int current, int total) {
    return '$current/$total';
  }

  @override
  String get nonogramCoachHintTitle => 'Indice';

  @override
  String get nonogramCoachHintBody =>
      'Remplit pour vous 5 cases correctes (des cases qui devraient être remplies et ne le sont pas encore), choisies au hasard sur tout le plateau. Elles reçoivent une étoile : on ne peut plus les modifier et elles restent même si vous recommencez. Vous en avez 3 par grille.';

  @override
  String get nonogramCoachWandTitle => 'Baguette magique';

  @override
  String get nonogramCoachWandBody =>
      'Touchez la baguette, puis les indices de n\'importe quelle ligne ou colonne : la solution de toute la ligne est révélée et marquée d\'une étoile, conservée même si vous recommencez. Vous en avez 1 par grille.';

  @override
  String get nonogramCoachModeTitle => 'Remplir ou X';

  @override
  String get nonogramCoachModeBody =>
      'Choisissez l\'effet d\'un toucher : remplir la case, ou la marquer d\'un X pour vous rappeler qu\'elle est vide. Touchez le bouton pour changer. Faites glisser sur la grille pour remplir ou marquer plusieurs cases d\'un coup.';

  @override
  String get nonogramCoachLongPressTitle => 'Appui long pour l\'inverse';

  @override
  String get nonogramCoachLongPressBody =>
      'Appuyez longuement sur une case pour faire l\'inverse du mode actuel : un X en mode remplissage, remplir en mode croix. Une courte vibration indique que c\'est fait et que vous pouvez relâcher.';

  @override
  String get nonogramCoachScrollTitle => 'Se déplacer sur les grandes grilles';

  @override
  String get nonogramCoachScrollBody =>
      'Les grandes grilles ne tiennent pas à l\'écran : faites glisser avec deux doigts, ou depuis l\'espace vide autour de la grille, pour déplacer le plateau. Faites glisser sur les indices pour voir les nombres masqués (le « +N » dans le coin indique combien).';

  @override
  String get nonogramTutorialRulesDoneTitle => 'Vous connaissez les règles !';

  @override
  String get nonogramTutorialRulesDone =>
      'Entraînons-nous maintenant aux commandes et aux aides sur une autre grille : glisser pour remplir vite, appui long pour marquer, les indices et la baguette magique.';

  @override
  String get nonogramTutorialContinue => 'Continuer';

  @override
  String get nonogramTutorialLater => 'Plus tard, jouer directement';

  @override
  String get nonogramTutorialDragRow =>
      'Astuce : faites glisser le doigt sur les cases pour les remplir d\'un coup. La ligne du haut en a 5 : glissez sur toute la ligne !';

  @override
  String get nonogramTutorialLongPressMark =>
      '1 1 1 tient exactement dans ces 5 cases, donc la 2e et la 4e case doivent être vides. Pas besoin de changer de mode : appuyez longuement sur chacune pour la marquer d\'un X. Une courte vibration indique que c\'est fait.';

  @override
  String get nonogramTutorialUseHint =>
      'Bloqué ? Touchez le bouton Indice et l\'app remplit 5 cases correctes au hasard. Vous en avez 3 par grille.';

  @override
  String get nonogramTutorialActivateWand =>
      'L\'indice a rempli 5 cases marquées d\'une étoile : elles sont verrouillées et conservées même si vous recommencez. Pour révéler une ligne ou une colonne entière de votre choix, utilisez la baguette magique : touchez le bouton de la baguette.';

  @override
  String get nonogramTutorialPickWandLine =>
      'Touchez maintenant les indices de la ligne du bas pour la révéler. Vous avez 1 baguette par grille.';

  @override
  String get nonogramTutorialFinishTools =>
      'Remplissez les cases restantes pour terminer. Faites glisser vers le bas le long d\'une colonne pour aller plus vite.';

  @override
  String get nonogramPlayHintNothingToFill =>
      'Toutes les cases à remplir le sont déjà. Vérifiez s\'il y a des cases remplies en trop.';

  @override
  String get settingsLicenses => 'Licences';

  @override
  String get settingsSwitchPlayMode => 'Changer de mode de jeu';

  @override
  String get licensesTitle => 'Licences';

  @override
  String get licensesLevelArtHeading => 'Grilles';

  @override
  String get licensesLevelArtIntro =>
      'Les grilles proviennent de ces sources. Les jeux d\'icônes ont été réduits, convertis en noir et blanc et retouchés pour que chaque grille ait une solution ; les collections de nonogrammes sont utilisées telles quelles.';

  @override
  String get licensesFontHeading => 'Police';

  @override
  String get licensesSoftwareButton => 'Licences des logiciels open source';

  @override
  String get licensesDeveloperLevelsNote =>
      'Les grilles du mode développeur proviennent de nonogram.org et servent uniquement aux tests internes. Elles ne sont pas incluses dans la version du store.';

  @override
  String get playModeTitle => 'Choisissez un mode de jeu';

  @override
  String get playModeSubtitle =>
      'La progression est enregistrée séparément pour chaque mode.';

  @override
  String get playModeUserTitle => 'Mode joueur';

  @override
  String get playModeUserBody =>
      'Les grilles sous licence incluses dans la version du store.';

  @override
  String get playModeDeveloperTitle => 'Mode développeur';

  @override
  String get playModeDeveloperBody =>
      'Les grilles d\'origine de nonogram.org, pour les tests internes. Conserve votre progression précédente.';

  @override
  String get playModeLastUsed => 'Dernier utilisé';

  @override
  String licensesBy(String author) {
    return 'Par $author';
  }

  @override
  String licensesLevelCount(int count) {
    return '$count grilles';
  }

  @override
  String playModeProgress(int solved, int total) {
    return '$solved/$total résolues';
  }

  @override
  String get adRewardNotReady =>
      'La publicité n\'est pas encore prête. Vérifiez votre connexion Internet et réessayez.';

  @override
  String get settingsAdPrivacy => 'Confidentialité des annonces';

  @override
  String get ratingTitle => 'Vous aimez Nonopix ?';

  @override
  String get ratingMessage => 'Touchez une étoile pour noter le jeu.';

  @override
  String get ratingLater => 'Plus tard';

  @override
  String get ratingSubmit => 'Envoyer';

  @override
  String get ratingThanks =>
      'Merci pour votre avis ! Nous continuerons d\'améliorer le jeu.';

  @override
  String ratingStarLabel(int count) {
    return '$count étoiles';
  }

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsLanguageSystem => 'Langue de l\'appareil';

  @override
  String get premiumTitle => 'Jouer sans publicité';

  @override
  String get premiumBenefitNoAds => 'Plus de publicités entre les niveaux';

  @override
  String get premiumBenefitDaily =>
      '2 indices et 1 baguette magique chaque jour de présence';

  @override
  String premiumBuy(String price) {
    return 'Acheter · $price';
  }

  @override
  String get premiumOneTime => 'Paiement unique via Google Play';

  @override
  String get premiumActiveTitle => 'Pack sans publicité activé';

  @override
  String get premiumActiveDaily =>
      'Valide ta présence chaque jour pour recevoir 2 indices et 1 baguette magique pour la journée.';

  @override
  String get premiumPurchased =>
      'Merci ! Les publicités entre les niveaux sont désactivées.';

  @override
  String get premiumPending =>
      'Ton paiement est en attente. Le pack s\'activera dès qu\'il sera validé.';

  @override
  String get premiumFailed => 'L\'achat n\'a pas abouti. Réessaie.';

  @override
  String get checkInTitle => 'Connexion quotidienne';

  @override
  String get checkInAction => 'Valider ma présence';

  @override
  String get checkInDoneToday => 'Présence validée aujourd\'hui';

  @override
  String checkInNextGift(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Prochain cadeau dans $count présences',
      one: 'Prochain cadeau à ta prochaine présence',
    );
    return '$_temp0';
  }

  @override
  String get checkInCheckedIn => 'Présence validée !';

  @override
  String checkInReceived(String rewards) {
    return 'Tu as reçu $rewards.';
  }

  @override
  String rewardHints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count indices',
      one: '1 indice',
    );
    return '$_temp0';
  }

  @override
  String rewardWands(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count baguettes magiques',
      one: '1 baguette magique',
    );
    return '$_temp0';
  }

  @override
  String rewardTodayOnly(String reward) {
    return '$reward (aujourd\'hui seulement)';
  }

  @override
  String get checkInMonthGifts => 'Cadeaux du mois';

  @override
  String get checkInTotalHints => 'Indices';

  @override
  String get checkInTotalWands => 'Baguettes magiques';

  @override
  String get checkInTotalDailyHints => 'Indices (aujourd\'hui seulement)';

  @override
  String get checkInTotalDailyWands =>
      'Baguettes magiques (aujourd\'hui seulement)';

  @override
  String get checkInPremiumToday =>
      'Aujourd\'hui grâce à ton pack sans publicité';

  @override
  String get checkInPremiumNotYet =>
      'Valide ta présence pour recevoir 2 indices et 1 baguette magique pour aujourd\'hui.';

  @override
  String get checkInPremiumUsedUp =>
      'Tout est utilisé pour aujourd\'hui. À demain !';

  @override
  String checkInExpiresIn(String time) {
    return 'Expire dans $time';
  }

  @override
  String dashboardDailyReminder(String rewards, String time) {
    return 'Il te reste $rewards pour aujourd\'hui. Ils expirent dans $time : joue maintenant pour ne rien perdre !';
  }

  @override
  String get dashboardDailyReminderTitle => 'Tes aides du jour t\'attendent';

  @override
  String get dashboardDailyReminderPlay => 'Jouer';
}

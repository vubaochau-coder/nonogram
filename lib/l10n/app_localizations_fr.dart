// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Pixel Nonogram';

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
      'Si relier deux morceaux noircis formait un bloc plus grand que le plus grand nombre, la case entre eux doit être vide. Marquez-la d\'un X pour les séparer.';

  @override
  String get nonogramGuideMethodDivisionTitle => '5. Séparation';

  @override
  String get nonogramGuideMethodDoublePositioningDesc =>
      'Parfois, une case noircie ne peut appartenir qu\'à un ou deux des nombres. Essayez chaque possibilité : les cases vides dans toutes reçoivent un X.';

  @override
  String get nonogramGuideMethodDoublePositioningTitle =>
      '6. Double positionnement';

  @override
  String get nonogramGuideMethodInaccessibilityDesc =>
      'Les cases qu\'aucun bloc ne peut atteindre sont vides. Essayez chaque bloc dans ses positions extrêmes autour des cases noircies ; tout ce qui est hors de portée reçoit un X.';

  @override
  String get nonogramGuideMethodInaccessibilityTitle => '3. Inaccessibilité';

  @override
  String get nonogramGuideMethodNotFitDesc =>
      'Un espace entre des X (ou entre un X et le bord) plus court que tous les nombres qui pourraient s\'y placer ne peut contenir aucun bloc : marquez-le d\'un X.';

  @override
  String get nonogramGuideMethodNotFitTitle => '4. Pas assez de place';

  @override
  String get nonogramGuideMethodSuperpositionMultiDesc =>
      'Avec plusieurs nombres, poussez tout le groupe à gauche (une case vide entre les blocs), puis à droite. Si le même bloc couvre une case dans les deux positions, elle est noircie. Astuce : additionnez les nombres et les espaces ; le reste indique de combien chaque bloc peut bouger.';

  @override
  String get nonogramGuideMethodSuperpositionMultiTitle =>
      'Superposition (plusieurs indices)';

  @override
  String get nonogramGuideMethodSuperpositionSimpleDesc =>
      'Si un nombre dépasse la moitié de sa ligne, une partie est toujours noircie. Imaginez le bloc poussé tout à gauche, puis tout à droite : les cases couvertes les deux fois sont sûres. Exemple : 7 sur 10 cases noircit toujours les 4 du milieu.';

  @override
  String get nonogramGuideMethodSuperpositionSimpleTitle =>
      'Superposition (un seul indice)';

  @override
  String get nonogramGuideMethodWallPushingDesc =>
      'Une case noircie près du bord limite la position de son bloc. Le bloc ne peut pas dépasser le bord, il doit donc s\'étendre de l\'autre côté. Exemple : 5 avec la 4e case noircie : même collé au bord gauche, le bloc couvre encore la 5e case.';

  @override
  String get nonogramGuideMethodWallPushingTitle =>
      '2. Repousser depuis les bords';

  @override
  String get nonogramGuideRuleDesc =>
      'Chaque nombre représente un bloc continu de cases remplies dans cette ligne ou colonne. S\'il y a plusieurs nombres, ils représentent des blocs distincts, et chaque bloc doit être séparé du suivant par au moins une case vide. Par exemple, 3 1 signifie un bloc de 3 cases remplies, puis au moins 1 case vide, puis un bloc de 1 case remplie.';

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
  String get nonogramTutorialWelcomeTitle => 'Bienvenue dans Pixel Nonogram !';

  @override
  String get nonogramTutorialWelcome =>
      'Découvrons les règles de base avec une petite grille de 5×5.';

  @override
  String get nonogramTutorialInfoFree =>
      'Gratuit : tous les niveaux sont débloqués.';

  @override
  String get nonogramTutorialInfoAds =>
      'Vous pouvez regarder une pub (facultatif) pour obtenir des indices et baguettes en plus. Une pub s\'affiche parfois entre les niveaux.';

  @override
  String get nonogramTutorialInfoPremium =>
      'Un achat unique supprime les pubs entre les niveaux et ajoute des indices et baguettes du jour à chaque pointage.';

  @override
  String get nonogramTutorialStart => 'Commencer';

  @override
  String get nonogramTutorialSwitchToFill =>
      'On résout les grilles en remplissant des cases. Touchez le bouton ci-dessous pour passer en mode remplissage.';

  @override
  String get nonogramTutorialClueIsCount =>
      'Le nombre indique combien de cases de la ligne sont remplies. Cette ligne en a 5 : remplissez-les toutes !';

  @override
  String get nonogramTutorialDragNote =>
      'Astuce : faites glisser le doigt sur la ligne pour la remplir d\'un coup.';

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
      'Apprenez les règles, les commandes et les principales techniques pas à pas, en jouant.';

  @override
  String get nonogramGuideRoutineTitle => 'Par où commencer';

  @override
  String get nonogramGuideRoutineTip1 =>
      'Commencez par les grands nombres. Si un nombre dépasse la moitié de sa ligne, une partie est déjà certaine (voir la technique 1 plus bas).';

  @override
  String get nonogramGuideRoutineTip2 =>
      'Résolvez d\'abord les lignes faciles : 0 signifie que toute la ligne est vide, et si les nombres plus un espace entre chacun font la longueur de la ligne, ils ne rentrent que d\'une façon.';

  @override
  String get nonogramGuideRoutineTip3 =>
      'Marquez d\'un X les cases que vous savez vides. Un X est aussi utile qu\'une case noircie.';

  @override
  String get nonogramGuideRoutineTip4 =>
      'Alternez entre lignes et colonnes. Chaque case résolue est un nouvel indice pour la ligne qui la croise.';

  @override
  String get nonogramGuideRoutineTip5 =>
      'Ne devinez jamais. Si vous bloquez, cherchez la ligne avec le moins de cases inconnues, ou utilisez un indice.';

  @override
  String nonogramGuideExample(int number) {
    return 'Exemple $number';
  }

  @override
  String get nonogramGuideExampleSingle => 'Exemple';

  @override
  String get nonogramGuideLegendTitle => 'Comment lire les schémas';

  @override
  String get nonogramGuideLegendFilled => 'Case noircie';

  @override
  String get nonogramGuideLegendTrial => 'Position de bloc à l\'essai';

  @override
  String get nonogramGuideLegendCross => 'Case vide (X)';

  @override
  String get nonogramGuideLegendResult => 'Ce qu\'on en déduit';

  @override
  String get nonogramGuideMethodLineDoneTitle => 'Lignes terminées';

  @override
  String get nonogramGuideMethodLineDoneDesc =>
      'Quand tous les blocs d\'une ligne sont placés, toutes ses autres cases sont vides : marquez-les d\'un X. Une ligne avec le nombre 0 est vide dès le départ.';

  @override
  String get nonogramPlayInfoHide => 'Masquer les infos du niveau';

  @override
  String get nonogramPlayWandLabel => 'Baguette magique';

  @override
  String get nonogramPlayUndo => 'Annuler';

  @override
  String get nonogramPlayDragTip =>
      'Faites glisser le doigt sur les cases pour en remplir plusieurs d\'un coup.';

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
      'Choisissez l\'effet d\'un toucher : remplir la case, ou la marquer d\'un X pour vous rappeler qu\'elle est vide. Touchez le bouton pour changer.';

  @override
  String get nonogramCoachDragTitle => 'Glissez pour remplir plusieurs cases';

  @override
  String get nonogramCoachDragBody =>
      'Posez le doigt sur une case et faites-le glisser sur d\'autres : chaque case traversée est remplie (ou marquée d\'un X en mode X) d\'un coup. En partant d\'une case remplie, vous effacez les cases traversées.';

  @override
  String get nonogramCoachLongPressTitle => 'Appui long pour l\'inverse';

  @override
  String get nonogramCoachLongPressBody =>
      'Appuyez longuement sur une case pour faire l\'inverse du mode actuel : un X en mode remplissage, remplir en mode croix. Une courte vibration indique que c\'est fait et que vous pouvez relâcher.';

  @override
  String get nonogramCoachRotateTitle => 'Mode paysage';

  @override
  String get nonogramCoachRotateBody =>
      'Touchez pour passer la grille en paysage, pratique pour les grilles larges ; les boutons passent sur les côtés. Touchez à nouveau pour revenir en portrait.';

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
  String get nonogramTutorialToolsDoneTitle => 'Commandes maîtrisées !';

  @override
  String get nonogramTutorialToolsDone =>
      'Les vraies grilles sont plus grandes, et la plupart des lignes ne se résolvent pas d\'un coup d\'œil. Découvrez maintenant les techniques de résolution sur une grille 8×8.';

  @override
  String get nonogramTutorialOverlapSingle =>
      'Cherchez d\'abord les grands nombres. Le 6 tient de 3 façons dans ces 8 cases, et chacune clignote tour à tour. Les cases allumées à chaque fois sont sûres : noircissez les 4 du cadre jaune.';

  @override
  String get nonogramTutorialOverlapMulti =>
      'Pareil avec plusieurs nombres : 3 3 demande au moins 7 cases (3 + espace + 3), il ne tient donc que de 3 façons. Noircissez les cases allumées dans les 3.';

  @override
  String get nonogramTutorialFullRow =>
      '8 sur 8 cases : toute la ligne est noircie. Glissez le doigt dessus.';

  @override
  String get nonogramTutorialZeroRow =>
      '0 signifie qu\'aucune case de la ligne n\'est noircie. Passez en mode X.';

  @override
  String get nonogramTutorialMarkZeroRow =>
      'Marquez toute la dernière ligne d\'un X. Les X comptent : ils montrent aux colonnes où les blocs ne peuvent pas aller.';

  @override
  String get nonogramTutorialOutOfReach =>
      'Passons aux colonnes. La colonne 2 est un bloc de 3 qui doit couvrir ses 2 cases noires : il ne tient que de 2 façons. Les cases jamais allumées sont hors de portée : marquez-les d\'un X, et pareil dans la colonne 7.';

  @override
  String get nonogramTutorialBackToFill =>
      'Regardez la colonne 3 : elle demande 7. Revenez en mode remplissage.';

  @override
  String get nonogramTutorialExactSpace =>
      'Le X du bas laisse exactement 7 cases pour le 7 : noircissez-les toutes. La colonne 6 fonctionne pareil.';

  @override
  String get nonogramTutorialFinishTechniques =>
      'Voilà la méthode : résolvez ce que vous pouvez dans les lignes, puis dans les colonnes, et recommencez. Terminez le champignon tout seul !';

  @override
  String get nonogramPlayHintNothingToFill =>
      'Toutes les cases à remplir le sont déjà. Vérifiez s\'il y a des cases remplies en trop.';

  @override
  String get settingsSound => 'Son';

  @override
  String get settingsLicenses => 'Licences';

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
  String licensesBy(String author) {
    return 'Par $author';
  }

  @override
  String licensesLevelCount(int count) {
    return '$count grilles';
  }

  @override
  String get adRewardNotReady =>
      'La publicité n\'est pas encore prête. Réessayez dans quelques minutes.';

  @override
  String get settingsAdPrivacy => 'Confidentialité des annonces';

  @override
  String get ratingTitle => 'Vous aimez Pixel Nonogram ?';

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
  String get navHome => 'Accueil';

  @override
  String get navMe => 'Moi';

  @override
  String get meHelp => 'Aide';

  @override
  String get meMore => 'Plus';

  @override
  String get checkInTodayButton => 'Valider ma présence';

  @override
  String get checkInGiftToday => 'Cadeau aujourd\'hui !';

  @override
  String get checkInGiftCollect => 'Récupérer';

  @override
  String get checkInGiftDouble => 'Récupérer x2';

  @override
  String checkInStreakTitle(int count) {
    return 'Série de $count jours';
  }

  @override
  String checkInStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours',
      one: '1 jour',
    );
    return '$_temp0';
  }

  @override
  String checkInStreakMakeUp(int missed, String days) {
    String _temp0 = intl.Intl.pluralLogic(
      missed,
      locale: localeName,
      other: '$missed jours manqués',
      one: '1 jour manqué',
    );
    return 'Rattrapez $_temp0 pour porter votre série à $days';
  }

  @override
  String get checkInStreakKeepGoing =>
      'Pointez chaque jour pour garder votre série';

  @override
  String get checkInStreakAllDone =>
      'Vous avez tous les cadeaux de série ce mois-ci !';

  @override
  String checkInStreakDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Encore $count jours pour un cadeau',
      one: 'Encore 1 jour pour un cadeau',
    );
    return '$_temp0';
  }

  @override
  String get checkInLegendChecked => 'Pointé';

  @override
  String get checkInLegendMissed => 'Manqué';

  @override
  String get checkInLegendFuture => 'À venir';

  @override
  String checkInGiftStreak(int count) {
    return 'Cadeau de série de $count jours';
  }

  @override
  String checkInMakeUpTitle(String date) {
    return 'Rattraper le $date ?';
  }

  @override
  String get checkInMakeUpBody =>
      'Regardez une courte pub pour rattraper ce jour. Votre série sera reconstituée.';

  @override
  String get checkInMakeUpWatch => 'Voir la pub';

  @override
  String checkInMadeUp(String date) {
    return '$date rattrapé';
  }

  @override
  String dashboardDailyReminder(String rewards, String time) {
    return 'Il te reste $rewards qui expirent dans $time. Utilise-les maintenant pour ne rien perdre.';
  }

  @override
  String get premiumViewBenefits => 'Voir les avantages';

  @override
  String get premiumBenefitsTitle => 'Avantages du pack';

  @override
  String get premiumBenefitsTagline =>
      'Achète une fois pour supprimer les publicités entre les niveaux et recevoir des récompenses d\'aide chaque jour, à vie sur ton compte.';

  @override
  String get premiumBenefitsOneTime => 'paiement unique';

  @override
  String get premiumWhatYouGet => 'Ce que tu obtiens';

  @override
  String get premiumPerkNoAdsTitle => 'Pas de publicités entre les niveaux';

  @override
  String get premiumPerkNoAdsBody =>
      'Fini les publicités plein écran entre les puzzles. Passe d\'un niveau à l\'autre sans interruption.';

  @override
  String get premiumPerkDailyTitle => 'Récompenses de présence quotidiennes';

  @override
  String get premiumPerkDailyBody =>
      'Chaque présence te donne 2 indices supplémentaires et 1 baguette magique pour la journée, en plus des récompenses de palier habituelles.';

  @override
  String get premiumItemsTitle => 'À quoi servent les aides';

  @override
  String get powerUpHintName => 'Indice';

  @override
  String get powerUpHintTagline => 'Révèle une case correcte que tu choisis';

  @override
  String get powerUpHintDesc =>
      'Touche l\'ampoule, puis choisis l\'endroit qui te pose problème. L\'appli remplit une case correcte (remplie ou marquée vide) pour te débloquer.';

  @override
  String get powerUpWandName => 'Baguette magique';

  @override
  String get powerUpWandTagline => 'Résout une ligne ou une colonne entière';

  @override
  String get powerUpWandDesc =>
      'Touche la baguette pour activer le mode sélection, puis touche les chiffres d\'indice d\'une ligne ou d\'une colonne. L\'appli révèle toute cette ligne ou colonne. Plus puissant qu\'un indice d\'une seule case.';

  @override
  String get powerUpStatesTitle => 'L\'icône indique le type d\'utilisation';

  @override
  String get powerUpStatesLead =>
      'Le nombre dans le coin est le total de tes utilisations restantes. Une utilisation à durée limitée rend l\'icône dorée avec une petite horloge :';

  @override
  String get powerUpTimeLimited => 'Durée limitée';

  @override
  String get powerUpTimeLimitedDesc =>
      'Icône dorée avec horloge. Issue de la récompense de présence quotidienne du pack. Expire à la fin de la journée.';

  @override
  String get powerUpPermanent => 'Permanent';

  @override
  String get powerUpPermanentDesc =>
      'Icône normale avec badge bleu. Utilisations de palier et de départ. N\'expirent jamais.';

  @override
  String get powerUpSpendOrderTitle =>
      'Quelles utilisations sont dépensées en premier ?';

  @override
  String get powerUpSpendOrderHeading =>
      'Les utilisations à durée limitée sont dépensées en premier';

  @override
  String get powerUpSpendOrderBody =>
      'Les utilisations quotidiennes expirent à la fin de la journée, donc un indice ou une baguette dépense d\'abord tes utilisations quotidiennes et n\'utilise les permanentes qu\'une fois les quotidiennes épuisées. Rien n\'est gaspillé.';

  @override
  String get powerUpSpendDaily => 'Utilisations quotidiennes';

  @override
  String get powerUpSpendPermanent => 'Utilisations permanentes';

  @override
  String get premiumBenefitsFootnote =>
      'Les utilisations quotidiennes ne sont pas reportées au lendemain. Les récompenses de palier sont des utilisations permanentes et s\'accumulent normalement.';

  @override
  String dashboardDailyReminderBoth(String hints, String wands) {
    return '$hints et $wands';
  }

  @override
  String get playClockPause => 'Mettre le chrono en pause';

  @override
  String get playClockResume => 'Reprendre';

  @override
  String get playClockPausedTitle => 'En pause';

  @override
  String get playClockPausedBody =>
      'La grille est masquée pendant la pause. Le chrono s\'arrête aussi tout seul quand vous quittez la grille ou fermez l\'app.';

  @override
  String get settingsShowClock => 'Afficher le chrono';
}

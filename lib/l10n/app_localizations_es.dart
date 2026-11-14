// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Nonopix';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonRetry => 'Reintentar';

  @override
  String get commonSave => 'Guardar';

  @override
  String nonogramDashboardContinueLevel(int level) {
    return 'Nivel $level';
  }

  @override
  String get nonogramDashboardProgressSectionTitle => 'Tu progreso';

  @override
  String get nonogramDashboardStatCompleted => 'Completados';

  @override
  String get nonogramGuideIntro =>
      'Los nonogramas son puzles de lógica con reglas sencillas y soluciones desafiantes. El objetivo es revelar dibujos ocultos rellenando casillas según los números que hay junto a la cuadrícula.';

  @override
  String get nonogramGuideMethodDivisionDesc =>
      'Si unir dos bloques existentes formaría una figura más grande que cualquier pista disponible, el hueco entre ellos debe ser una X.';

  @override
  String get nonogramGuideMethodDivisionTitle => '5. División';

  @override
  String get nonogramGuideMethodDoublePositioningDesc =>
      'Si una casilla rellena solo puede pertenecer a unas pocas variantes concretas de un bloque, cualquier casilla que no se rellene en ninguna de esas variantes debe marcarse con X.';

  @override
  String get nonogramGuideMethodDoublePositioningTitle =>
      '6. Doble posicionamiento';

  @override
  String get nonogramGuideMethodInaccessibilityDesc =>
      'Marca con una cruz (X) las casillas que no pueden pertenecer a ninguna de las figuras restantes.';

  @override
  String get nonogramGuideMethodInaccessibilityTitle => '3. Inaccesibilidad';

  @override
  String get nonogramGuideMethodNotFitDesc =>
      'Si un espacio vacío entre cruces es más pequeño que cualquier pista disponible para esa línea, debe marcarse con X.';

  @override
  String get nonogramGuideMethodNotFitTitle => '4. No cabe';

  @override
  String get nonogramGuideMethodSuperpositionMultiDesc =>
      'Cuando hay varios números, superpón las posiciones extremas izquierda y derecha de todo el grupo, teniendo en cuenta el hueco mínimo obligatorio de una casilla entre bloques del mismo color. Las casillas en las que un bloque coincide consigo mismo en ambas variantes se rellenan.';

  @override
  String get nonogramGuideMethodSuperpositionMultiTitle =>
      'Superposición (varias pistas)';

  @override
  String get nonogramGuideMethodSuperpositionSimpleDesc =>
      'Si un número ocupa más de la mitad de la línea, algunas casillas del centro estarán rellenas con seguridad. Superpón las posiciones extremas izquierda y derecha; donde coinciden, las casillas se rellenan.';

  @override
  String get nonogramGuideMethodSuperpositionSimpleTitle =>
      'Superposición (una pista)';

  @override
  String get nonogramGuideMethodWallPushingDesc =>
      'Si una casilla rellena conocida está más cerca de un borde que el tamaño de la primera pista, la figura a la que pertenece debe extenderse alejándose de ese borde.';

  @override
  String get nonogramGuideMethodWallPushingTitle =>
      '2. Empujar desde las paredes';

  @override
  String get nonogramGuideRuleDesc =>
      'Cada número representa un bloque continuo de casillas rellenas en esa fila o columna. Si hay varios números, representan bloques separados, y cada bloque debe estar separado del siguiente por al menos una casilla vacía. Por ejemplo, `3 1` significa un bloque de 3 casillas rellenas, luego al menos 1 casilla vacía y después un bloque de 1 casilla rellena.';

  @override
  String get nonogramGuideRuleTitle =>
      'Regla básica: qué significan los números';

  @override
  String get nonogramGuideTitle => 'Cómo resolver';

  @override
  String nonogramHistoryCompletedOn(String date) {
    return 'Completado el $date';
  }

  @override
  String get nonogramHistoryDetailNotFound =>
      'No se encontraron los detalles del nivel.';

  @override
  String get nonogramHistoryEmpty => 'Aún no has completado ningún nivel.';

  @override
  String nonogramHistoryLevel(int n) {
    return 'Nivel $n';
  }

  @override
  String get nonogramHistoryTitle => 'Resultados';

  @override
  String get nonogramPlayActionNextLevelFixed => 'Siguiente nivel';

  @override
  String get nonogramPlayActionShowClues => 'Mostrar pistas';

  @override
  String nonogramPlayCompletionMessage(int level) {
    return '¡Enhorabuena! Has completado el nivel $level.';
  }

  @override
  String get nonogramPlayCompletionTitle => '¡Puzle resuelto!';

  @override
  String nonogramPlayDurationFormat(int minutes, int seconds) {
    return '$minutes min $seconds s';
  }

  @override
  String nonogramPlayHintLabel(int count) {
    return 'Pista ($count)';
  }

  @override
  String get nonogramPlayNoNextLevelToast =>
      'Todavía no hay un nivel siguiente.';

  @override
  String get nonogramPlayPageTitle => 'Nonograma';

  @override
  String get nonogramSettingsTitle => 'Ajustes';

  @override
  String get nonogramDashboardContinueNext => 'Siguiente desafío';

  @override
  String get nonogramDashboardPlay => 'Jugar';

  @override
  String get nonogramDashboardResumeAction => 'Continuar';

  @override
  String get nonogramDashboardInProgressBadge => 'En curso';

  @override
  String nonogramDashboardDifficulty(String value) {
    return 'Dificultad $value';
  }

  @override
  String nonogramDashboardSolvedOfTotal(int completed, int total) {
    return '$completed de $total puzles resueltos';
  }

  @override
  String get nonogramDashboardStatFastest => 'Más rápido';

  @override
  String get nonogramDashboardStatTotalTime => 'Tiempo total';

  @override
  String get nonogramDashboardRecentTitle => 'Resueltos recientemente';

  @override
  String get nonogramDashboardSeeAll => 'Ver todo';

  @override
  String get nonogramDashboardRecentEmpty =>
      'Resuelve tu primer puzle para empezar tu colección de dibujos.';

  @override
  String get nonogramDashboardAllDoneTitle => '¡Todos los puzles resueltos!';

  @override
  String nonogramDashboardAllDoneDesc(int total) {
    return 'Has completado los $total puzles. Vuelve a ver tu colección cuando quieras.';
  }

  @override
  String nonogramDurationHoursMinutes(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String nonogramHistoryBestTime(String time) {
    return 'Mejor $time';
  }

  @override
  String get nonogramPlayActionDashboard => 'Inicio';

  @override
  String get appThemeTitle => 'Apariencia';

  @override
  String get appThemeLight => 'Claro';

  @override
  String get appThemeDark => 'Oscuro';

  @override
  String get nonogramPlayModeFill => 'Modo rellenar';

  @override
  String get nonogramPlayModeMark => 'Modo marcar X';

  @override
  String get nonogramSettingsRestart => 'Reiniciar este nivel';

  @override
  String get nonogramSettingsRestartConfirmTitle => '¿Reiniciar este nivel?';

  @override
  String get nonogramSettingsRestartConfirmMessage =>
      'Se borrarán todas las casillas que hayas rellenado o marcado. Las casillas con estrella (abiertas con pistas o con la varita) se conservan.';

  @override
  String get commonClose => 'Cerrar';

  @override
  String get nonogramSettingsRestartConfirm => 'Reiniciar';

  @override
  String get nonogramTutorialTitle => 'Cómo jugar';

  @override
  String get nonogramTutorialSkip => 'Omitir';

  @override
  String get nonogramTutorialWelcomeTitle =>
      '¡Te damos la bienvenida a Nonopix!';

  @override
  String get nonogramTutorialWelcome =>
      'Aprendamos las reglas básicas con un pequeño puzle de 5×5.';

  @override
  String get nonogramTutorialStart => 'Empezar';

  @override
  String get nonogramTutorialSwitchToFill =>
      'Los puzles se resuelven rellenando casillas. Toca el botón de abajo para pasar al modo rellenar.';

  @override
  String get nonogramTutorialClueIsCount =>
      'El número indica cuántas casillas de la fila están rellenas. Esta fila tiene 5, ¡así que rellénalas todas!';

  @override
  String get nonogramTutorialEdgeCell =>
      'La última casilla ya está rellena. El bloque de 4 debe incluirla, así que solo se puede colocar de una forma: rellena las 3 casillas a su izquierda.';

  @override
  String get nonogramTutorialMultipleClues =>
      'Más de un número significa más de un bloque, con al menos una casilla vacía entre ellos. 2 2 cabe en estas 5 casillas de una sola forma.';

  @override
  String get nonogramTutorialClueOrder =>
      'El orden también importa: 3 1 significa que primero va el bloque de 3 y después el bloque de 1.';

  @override
  String get nonogramTutorialColumns =>
      'Las columnas también tienen números, que se leen de arriba abajo. Cambia al modo X para marcar las casillas que deben quedar vacías.';

  @override
  String get nonogramTutorialMarkEmpty =>
      'Las columnas con ✓ ya tienen todas sus casillas. Marca con una X sus casillas vacías restantes.';

  @override
  String get nonogramTutorialOneCellLeft =>
      'Al 1 de la última fila ya solo le queda un sitio. Vuelve al modo rellenar.';

  @override
  String get nonogramTutorialFinish =>
      '¡Rellena la última casilla para terminar el puzle!';

  @override
  String get nonogramTutorialDoneTitle => '¡Muy bien!';

  @override
  String get nonogramTutorialDone =>
      '¡Ya estás listo! En los puzles grandes, arrastra con dos dedos (o desde el espacio vacío fuera de la cuadrícula) para mover el tablero; la app te lo recordará en tu primer puzle grande.';

  @override
  String get nonogramTutorialShowTechniques => 'Ver técnicas de resolución';

  @override
  String get nonogramTutorialPlay => 'Empezar a jugar';

  @override
  String get nonogramGuideTutorialCardTitle => 'Aprende jugando';

  @override
  String get nonogramGuideTutorialCardDesc =>
      'Aprende las reglas y los controles paso a paso con un pequeño puzle de 5×5.';

  @override
  String get nonogramPlayInfoHide => 'Ocultar información del nivel';

  @override
  String get nonogramPlayWandLabel => 'Varita mágica';

  @override
  String get nonogramPlayWandSelectPrompt =>
      'Toca las pistas de la fila o columna que quieres revelar';

  @override
  String get nonogramPlayWandRowSolved =>
      'Esta fila ya es correcta. Elige otra fila o columna.';

  @override
  String get nonogramPlayWandColSolved =>
      'Esta columna ya es correcta. Elige otra fila o columna.';

  @override
  String get nonogramSettingsControlsGuide => 'Guía de controles';

  @override
  String get nonogramCoachSkip => 'Omitir';

  @override
  String get nonogramCoachNext => 'Siguiente';

  @override
  String get nonogramCoachDone => 'Entendido';

  @override
  String nonogramCoachStep(int current, int total) {
    return '$current/$total';
  }

  @override
  String get nonogramCoachHintTitle => 'Pista';

  @override
  String get nonogramCoachHintBody =>
      'Rellena por ti 5 casillas correctas (casillas que deberían estar rellenas y aún no lo están), elegidas al azar en todo el tablero. Llevan una estrella: no se pueden cambiar y se conservan aunque reinicies. Tienes 3 por puzle.';

  @override
  String get nonogramCoachWandTitle => 'Varita mágica';

  @override
  String get nonogramCoachWandBody =>
      'Toca la varita y luego las pistas de cualquier fila o columna: se revela la solución de toda esa línea, marcada con una estrella y conservada aunque reinicies. Tienes 1 por puzle.';

  @override
  String get nonogramCoachModeTitle => 'Rellenar o X';

  @override
  String get nonogramCoachModeBody =>
      'Elige qué hace un toque: rellenar la casilla o marcarla con una X para recordar que está vacía. Toca el botón para cambiar. Arrastra por la cuadrícula para rellenar o marcar muchas casillas a la vez.';

  @override
  String get nonogramCoachLongPressTitle => 'Mantén pulsado para lo contrario';

  @override
  String get nonogramCoachLongPressBody =>
      'Mantén pulsada una casilla para hacer lo contrario del modo actual: X mientras rellenas, rellenar mientras marcas. Una vibración corta indica que ya está y puedes soltar.';

  @override
  String get nonogramCoachScrollTitle => 'Moverse por puzles grandes';

  @override
  String get nonogramCoachScrollBody =>
      'Los puzles grandes no caben en la pantalla: arrastra con dos dedos, o arrastra desde el espacio vacío fuera de la cuadrícula para mover el tablero. Arrastra sobre las pistas para ver los números ocultos (el \"+N\" de la esquina indica cuántos hay).';

  @override
  String get nonogramTutorialRulesDoneTitle => '¡Ya conoces las reglas!';

  @override
  String get nonogramTutorialRulesDone =>
      'Ahora practiquemos los controles y las ayudas en otro puzle: arrastrar para rellenar rápido, mantener pulsado para marcar, las pistas y la varita mágica.';

  @override
  String get nonogramTutorialContinue => 'Continuar';

  @override
  String get nonogramTutorialLater => 'Más tarde, solo jugar';

  @override
  String get nonogramTutorialDragRow =>
      'Consejo: desliza el dedo por las casillas para rellenarlas de una vez. La fila de arriba tiene 5, ¡así que arrastra por toda la fila!';

  @override
  String get nonogramTutorialLongPressMark =>
      '1 1 1 cabe exactamente en estas 5 casillas, así que la 2.ª y la 4.ª deben estar vacías. No hace falta cambiar de modo: mantén pulsada cada una para marcarla con una X. Una vibración corta indica que ya está.';

  @override
  String get nonogramTutorialUseHint =>
      '¿Atascado? Toca el botón Pista y la app rellenará 5 casillas correctas al azar. Tienes 3 por puzle.';

  @override
  String get nonogramTutorialActivateWand =>
      'La pista ha rellenado 5 casillas marcadas con una estrella: están bloqueadas y se conservan aunque reinicies. Para revelar una fila o columna entera a tu elección, usa la varita mágica: toca el botón de la varita.';

  @override
  String get nonogramTutorialPickWandLine =>
      'Ahora toca las pistas de la fila de abajo para revelarla. Tienes 1 varita por puzle.';

  @override
  String get nonogramTutorialFinishTools =>
      'Rellena las casillas restantes para terminar. Arrastra hacia abajo por una columna para rellenar más rápido.';

  @override
  String get nonogramPlayHintNothingToFill =>
      'Todas las casillas que deben estar rellenas ya lo están. Revisa si sobra alguna casilla rellena.';

  @override
  String get settingsSound => 'Sonido';

  @override
  String get settingsLicenses => 'Licencias';

  @override
  String get settingsSwitchPlayMode => 'Cambiar modo de juego';

  @override
  String get licensesTitle => 'Licencias';

  @override
  String get licensesLevelArtHeading => 'Puzles';

  @override
  String get licensesLevelArtIntro =>
      'Los puzles proceden de estas fuentes. Los conjuntos de iconos se redujeron, se pasaron a blanco y negro y se editaron para que todos los puzles tengan solución; las colecciones de nonogramas se usan tal cual.';

  @override
  String get licensesFontHeading => 'Fuente';

  @override
  String get licensesSoftwareButton =>
      'Licencias de software de código abierto';

  @override
  String get licensesDeveloperLevelsNote =>
      'Los puzles del modo desarrollador proceden de nonogram.org y son solo para pruebas internas. No se incluyen en la versión de la tienda.';

  @override
  String get playModeTitle => 'Elige un modo de juego';

  @override
  String get playModeSubtitle =>
      'El progreso se guarda por separado para cada modo.';

  @override
  String get playModeUserTitle => 'Modo jugador';

  @override
  String get playModeUserBody =>
      'Los puzles con licencia que incluye la versión de la tienda.';

  @override
  String get playModeDeveloperTitle => 'Modo desarrollador';

  @override
  String get playModeDeveloperBody =>
      'Los puzles originales de nonogram.org, para pruebas internas. Conserva tu progreso anterior.';

  @override
  String get playModeLastUsed => 'Último usado';

  @override
  String licensesBy(String author) {
    return 'Por $author';
  }

  @override
  String licensesLevelCount(int count) {
    return '$count puzles';
  }

  @override
  String playModeProgress(int solved, int total) {
    return '$solved/$total resueltos';
  }

  @override
  String get adRewardNotReady =>
      'El anuncio aún no está listo. Comprueba tu conexión a internet e inténtalo de nuevo.';

  @override
  String get settingsAdPrivacy => 'Privacidad de anuncios';

  @override
  String get ratingTitle => '¿Te gusta Nonopix?';

  @override
  String get ratingMessage => 'Toca una estrella para valorar el juego.';

  @override
  String get ratingLater => 'Más tarde';

  @override
  String get ratingSubmit => 'Enviar';

  @override
  String get ratingThanks =>
      '¡Gracias por tu opinión! Seguiremos mejorando el juego.';

  @override
  String ratingStarLabel(int count) {
    return '$count estrellas';
  }

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsLanguageSystem => 'Idioma del dispositivo';

  @override
  String get premiumTitle => 'Jugar sin anuncios';

  @override
  String get premiumBenefitNoAds => 'Sin anuncios entre niveles';

  @override
  String get premiumBenefitDaily =>
      '2 pistas y 1 varita mágica cada día que te registres';

  @override
  String premiumBuy(String price) {
    return 'Comprar · $price';
  }

  @override
  String get premiumOneTime => 'Pago único a través de Google Play';

  @override
  String get premiumActiveTitle => 'Paquete sin anuncios activo';

  @override
  String get premiumActiveDaily =>
      'Regístrate cada día para recibir 2 pistas y 1 varita mágica para ese día.';

  @override
  String get premiumPurchased => '¡Gracias! Ya no hay anuncios entre niveles.';

  @override
  String get premiumPending =>
      'Tu pago está pendiente. El paquete se activará en cuanto se complete.';

  @override
  String get premiumFailed => 'La compra no se completó. Inténtalo de nuevo.';

  @override
  String get checkInTitle => 'Registro diario';

  @override
  String get checkInAction => 'Registrarme';

  @override
  String get checkInDoneToday => 'Ya te registraste hoy';

  @override
  String checkInNextGift(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Próximo regalo en $count registros',
      one: 'Próximo regalo en tu próximo registro',
    );
    return '$_temp0';
  }

  @override
  String get checkInCheckedIn => '¡Registrado!';

  @override
  String checkInReceived(String rewards) {
    return 'Recibiste $rewards.';
  }

  @override
  String rewardHints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pistas',
      one: '1 pista',
    );
    return '$_temp0';
  }

  @override
  String rewardWands(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count varitas mágicas',
      one: '1 varita mágica',
    );
    return '$_temp0';
  }

  @override
  String rewardTodayOnly(String reward) {
    return '$reward (solo hoy)';
  }

  @override
  String get checkInMonthGifts => 'Regalos de este mes';

  @override
  String get navHome => 'Inicio';

  @override
  String get navMe => 'Yo';

  @override
  String get meHelp => 'Ayuda';

  @override
  String get meMore => 'Más';

  @override
  String get checkInNotYetToday => 'Aún no te registraste hoy';

  @override
  String get checkInTodayButton => 'Registrarme hoy';

  @override
  String checkInGiftsLeftShort(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count registros más para un regalo',
      one: '1 registro más para un regalo',
    );
    return '$_temp0';
  }

  @override
  String get checkInGiftToday => '¡Hoy hay regalo!';

  @override
  String checkInGiftMilestone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Regalo por $count registros',
      one: 'Regalo por 1 registro',
    );
    return '$_temp0';
  }

  @override
  String get checkInGiftCollect => 'Recoger';

  @override
  String get checkInTotalHints => 'Pistas';

  @override
  String get checkInTotalWands => 'Varitas mágicas';

  @override
  String get checkInTotalDailyHints => 'Pistas (solo hoy)';

  @override
  String get checkInTotalDailyWands => 'Varitas mágicas (solo hoy)';

  @override
  String get checkInPremiumToday => 'Hoy de tu paquete sin anuncios';

  @override
  String get checkInPremiumNotYet =>
      'Regístrate para recibir 2 pistas y 1 varita mágica para hoy.';

  @override
  String get checkInPremiumUsedUp => 'Ya usaste todo por hoy. ¡Hasta mañana!';

  @override
  String checkInExpiresIn(String time) {
    return 'Caduca en $time';
  }

  @override
  String dashboardDailyReminder(String rewards, String time) {
    return 'Aún tienes $rewards para hoy. Caducan en $time, ¡juega ahora para no desperdiciarlas!';
  }

  @override
  String get dashboardDailyReminderTitle => 'Tus ayudas de hoy te esperan';

  @override
  String get dashboardDailyReminderPlay => 'Jugar ahora';
}

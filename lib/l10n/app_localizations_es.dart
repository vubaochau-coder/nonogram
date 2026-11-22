// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Pixel Nonogram';

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
      'Si unir dos tramos rellenos formaría un bloque mayor que el número más grande, la casilla entre ellos debe estar vacía. Márcala con X para separarlos.';

  @override
  String get nonogramGuideMethodDivisionTitle => '5. División';

  @override
  String get nonogramGuideMethodDoublePositioningDesc =>
      'A veces una casilla rellena solo puede pertenecer a uno o dos de los números. Prueba cada posibilidad: las casillas que quedan vacías en todas llevan X.';

  @override
  String get nonogramGuideMethodDoublePositioningTitle =>
      '6. Doble posicionamiento';

  @override
  String get nonogramGuideMethodInaccessibilityDesc =>
      'Las casillas a las que ningún bloque puede llegar están vacías. Prueba cada bloque en sus posiciones más alejadas alrededor de las casillas rellenas; lo que quede fuera lleva X.';

  @override
  String get nonogramGuideMethodInaccessibilityTitle => '3. Inaccesibilidad';

  @override
  String get nonogramGuideMethodNotFitDesc =>
      'Un hueco entre X (o entre una X y el borde) más corto que cualquier número que pudiera ir ahí no admite ningún bloque: márcalo con X.';

  @override
  String get nonogramGuideMethodNotFitTitle => '4. No cabe';

  @override
  String get nonogramGuideMethodSuperpositionMultiDesc =>
      'Con varios números, empuja todo el grupo a la izquierda (dejando una casilla vacía entre bloques) y luego a la derecha. Si el mismo bloque cubre una casilla en ambas posiciones, esa casilla se rellena. Truco: suma los números y los huecos; lo que sobra es cuánto puede moverse cada bloque.';

  @override
  String get nonogramGuideMethodSuperpositionMultiTitle =>
      'Superposición (varias pistas)';

  @override
  String get nonogramGuideMethodSuperpositionSimpleDesc =>
      'Si un número ocupa más de la mitad de su línea, una parte siempre se rellena. Imagina el bloque empujado del todo a la izquierda y luego del todo a la derecha: las casillas que cubre las dos veces son seguras. Ejemplo: 7 en 10 casillas siempre rellena las 4 del centro.';

  @override
  String get nonogramGuideMethodSuperpositionSimpleTitle =>
      'Superposición (una pista)';

  @override
  String get nonogramGuideMethodWallPushingDesc =>
      'Una casilla rellena cerca del borde limita dónde puede estar su bloque. El bloque no puede salirse del borde, así que debe extenderse hacia el otro lado. Ejemplo: 5 con la 4.ª casilla rellena: aunque se pegue al borde izquierdo, el bloque sigue cubriendo la 5.ª.';

  @override
  String get nonogramGuideMethodWallPushingTitle =>
      '2. Empujar desde las paredes';

  @override
  String get nonogramGuideRuleDesc =>
      'Cada número representa un bloque continuo de casillas rellenas en esa fila o columna. Si hay varios números, representan bloques separados, y cada bloque debe estar separado del siguiente por al menos una casilla vacía. Por ejemplo, 3 1 significa un bloque de 3 casillas rellenas, luego al menos 1 casilla vacía y después un bloque de 1 casilla rellena.';

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
      '¡Te damos la bienvenida a Pixel Nonogram!';

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
      'Aprende las reglas, los controles y las técnicas principales paso a paso, jugando.';

  @override
  String get nonogramGuideRoutineTitle => 'Por dónde empezar';

  @override
  String get nonogramGuideRoutineTip1 =>
      'Empieza por los números grandes. Si un número ocupa más de la mitad de su línea, una parte ya es segura (ver la técnica 1 abajo).';

  @override
  String get nonogramGuideRoutineTip2 =>
      'Resuelve primero las líneas fáciles: 0 significa que toda la línea está vacía, y si los números más un hueco entre cada uno suman la longitud de la línea, solo caben de una forma.';

  @override
  String get nonogramGuideRoutineTip3 =>
      'Marca con X las casillas que sabes que están vacías. Una X es tan útil como una casilla rellena.';

  @override
  String get nonogramGuideRoutineTip4 =>
      'Alterna entre filas y columnas. Cada casilla que resuelves es una pista nueva para la línea que la cruza.';

  @override
  String get nonogramGuideRoutineTip5 =>
      'No adivines nunca. Si te atascas, busca la línea con menos casillas desconocidas o usa una pista.';

  @override
  String get nonogramGuideMethodLineDoneTitle => 'Líneas terminadas';

  @override
  String get nonogramGuideMethodLineDoneDesc =>
      'Cuando todos los bloques de una línea están colocados, el resto de sus casillas está vacío: márcalas con X. Una línea con el número 0 está vacía desde el principio.';

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
  String get nonogramTutorialToolsDoneTitle => '¡Ya dominas los controles!';

  @override
  String get nonogramTutorialToolsDone =>
      'Los puzles reales son más grandes y la mayoría de las líneas no se resuelven a simple vista. Ahora aprende las técnicas de resolución en un puzle de 8×8.';

  @override
  String get nonogramTutorialOverlapSingle =>
      'Busca primero los números grandes. Las dos barras azules muestran el 6 pegado a la izquierda y a la derecha. Donde se solapan siempre se rellena, esté donde esté el bloque. Rellena esas 4 casillas.';

  @override
  String get nonogramTutorialOverlapMulti =>
      'Igual con varios números: 3 3 necesita al menos 7 casillas (3 + hueco + 3), así que el grupo solo se mueve 1 casilla. Barras de arriba: a la izquierda; de abajo: a la derecha. Rellena lo que cubren ambas.';

  @override
  String get nonogramTutorialFullRow =>
      '8 en 8 casillas: toda la fila se rellena. Arrastra a lo largo de ella.';

  @override
  String get nonogramTutorialZeroRow =>
      '0 significa que la fila no tiene ninguna casilla rellena. Cambia al modo X.';

  @override
  String get nonogramTutorialMarkZeroRow =>
      'Marca toda la fila de abajo con X. Las X importan: muestran a las columnas dónde no pueden ir los bloques.';

  @override
  String get nonogramTutorialOutOfReach =>
      'Ahora las columnas. La columna 2 es un bloque de 3 que debe cubrir sus 2 casillas rellenas. Las dos barras azules son sus posiciones extremas: las casillas fuera de ambas no se alcanzan. Márcalas con X, y lo mismo en la columna 7.';

  @override
  String get nonogramTutorialBackToFill =>
      'Mira la columna 3: necesita 7. Vuelve al modo de rellenar.';

  @override
  String get nonogramTutorialExactSpace =>
      'La X de abajo deja exactamente 7 casillas para el 7, así que rellénalas todas. La columna 6 funciona igual.';

  @override
  String get nonogramTutorialFinishTechniques =>
      'Ese es el método: resuelve lo que puedas en las filas, luego en las columnas, y repite. ¡Termina la seta tú solo!';

  @override
  String get nonogramPlayHintNothingToFill =>
      'Todas las casillas que deben estar rellenas ya lo están. Revisa si sobra alguna casilla rellena.';

  @override
  String get settingsSound => 'Sonido';

  @override
  String get settingsLicenses => 'Licencias';

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
  String licensesBy(String author) {
    return 'Por $author';
  }

  @override
  String licensesLevelCount(int count) {
    return '$count puzles';
  }

  @override
  String get adRewardNotReady =>
      'El anuncio aún no está listo. Comprueba tu conexión a internet e inténtalo de nuevo.';

  @override
  String get settingsAdPrivacy => 'Privacidad de anuncios';

  @override
  String get ratingTitle => '¿Te gusta Pixel Nonogram?';

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
  String get checkInPremiumNotYet =>
      'Regístrate para recibir 2 pistas y 1 varita mágica para hoy.';

  @override
  String dashboardDailyReminder(String rewards, String time) {
    return 'Te quedan $rewards que caducan en $time. Úsalos ahora para no desperdiciarlos.';
  }

  @override
  String get premiumViewBenefits => 'Ver beneficios';

  @override
  String get premiumBenefitsTitle => 'Beneficios del paquete';

  @override
  String get premiumBenefitsTagline =>
      'Compra una vez para quitar los anuncios entre niveles y recibir recompensas de ayuda cada día, para siempre en tu cuenta.';

  @override
  String get premiumBenefitsOneTime => 'pago único';

  @override
  String get premiumWhatYouGet => 'Qué obtienes';

  @override
  String get premiumPerkNoAdsTitle => 'Sin anuncios entre niveles';

  @override
  String get premiumPerkNoAdsBody =>
      'Se acabaron los anuncios a pantalla completa entre los puzzles. Pasa de un nivel a otro sin interrupciones.';

  @override
  String get premiumPerkDailyTitle => 'Recompensas diarias por registrarte';

  @override
  String get premiumPerkDailyBody =>
      'Cada registro te da 2 pistas adicionales y 1 varita mágica para ese día, además de las recompensas de hito habituales.';

  @override
  String get premiumItemsTitle => 'Qué hacen las ayudas';

  @override
  String get powerUpHintName => 'Pista';

  @override
  String get powerUpHintTagline => 'Revela una casilla correcta que tú eliges';

  @override
  String get powerUpHintDesc =>
      'Toca la bombilla y elige el punto que te genera dudas. La app rellena una casilla correcta (marcada o vacía) para que puedas seguir.';

  @override
  String get powerUpWandName => 'Varita mágica';

  @override
  String get powerUpWandTagline => 'Resuelve una fila o columna entera';

  @override
  String get powerUpWandDesc =>
      'Toca la varita para activar el modo de selección y luego toca los números de pista de una fila o columna. La app revela esa fila o columna completa. Más potente que una pista de una sola casilla.';

  @override
  String get powerUpStatesTitle => 'El icono indica el tipo de uso';

  @override
  String get powerUpStatesLead =>
      'El número en la esquina es el total de usos que te quedan. Un uso con tiempo limitado pone el icono dorado con un pequeño reloj:';

  @override
  String get powerUpTimeLimited => 'Con tiempo limitado';

  @override
  String get powerUpTimeLimitedDesc =>
      'Icono dorado con reloj. De la recompensa diaria por registrarte del paquete. Caduca al final del día.';

  @override
  String get powerUpPermanent => 'Permanente';

  @override
  String get powerUpPermanentDesc =>
      'Icono normal con insignia azul. Usos de hito y de inicio. No caducan nunca.';

  @override
  String get powerUpSpendOrderTitle => '¿Qué usos se gastan primero?';

  @override
  String get powerUpSpendOrderHeading =>
      'Los usos con tiempo limitado se gastan primero';

  @override
  String get powerUpSpendOrderBody =>
      'Los usos diarios caducan al final del día, así que una pista o varita gasta primero tus usos diarios y solo usa los permanentes cuando los diarios se agotan. Nada se desperdicia.';

  @override
  String get powerUpSpendDaily => 'Usos diarios';

  @override
  String get powerUpSpendPermanent => 'Usos permanentes';

  @override
  String get premiumBenefitsFootnote =>
      'Los usos diarios no pasan al día siguiente. Las recompensas de hito son usos permanentes y se acumulan con normalidad.';

  @override
  String dashboardDailyReminderBoth(String hints, String wands) {
    return '$hints y $wands';
  }

  @override
  String checkInLegendMilestone(int count) {
    return 'Regalo cada $count registros';
  }

  @override
  String get checkInLegendPremium => 'Recompensa del paquete sin anuncios';
}

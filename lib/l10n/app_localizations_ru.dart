// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Nonopix';

  @override
  String get commonCancel => 'Отмена';

  @override
  String get commonRetry => 'Повторить';

  @override
  String get commonSave => 'Сохранить';

  @override
  String nonogramDashboardContinueLevel(int level) {
    return 'Уровень $level';
  }

  @override
  String get nonogramDashboardProgressSectionTitle => 'Ваш прогресс';

  @override
  String get nonogramDashboardStatCompleted => 'Решено';

  @override
  String get nonogramGuideIntro =>
      'Японские кроссворды (нонограммы) — логические головоломки с простыми правилами и непростыми решениями. Цель — открыть скрытую картинку, закрашивая клетки по числам сбоку от сетки.';

  @override
  String get nonogramGuideMethodDivisionDesc =>
      'Если соединение двух уже закрашенных блоков дало бы фигуру длиннее любого из доступных чисел, промежуток между ними должен быть крестиком.';

  @override
  String get nonogramGuideMethodDivisionTitle => '5. Разделение';

  @override
  String get nonogramGuideMethodDoublePositioningDesc =>
      'Если закрашенная клетка может принадлежать лишь нескольким определённым вариантам блока, все клетки, которые не закрашены ни в одном из этих вариантов, нужно отметить крестиком.';

  @override
  String get nonogramGuideMethodDoublePositioningTitle =>
      '6. Двойное позиционирование';

  @override
  String get nonogramGuideMethodInaccessibilityDesc =>
      'Отметьте крестиком (X) клетки, которые не могут принадлежать ни одной из оставшихся фигур.';

  @override
  String get nonogramGuideMethodInaccessibilityTitle => '3. Недоступность';

  @override
  String get nonogramGuideMethodNotFitDesc =>
      'Если пустой участок между крестиками короче любого из доступных чисел этой линии, его нужно отметить крестиками.';

  @override
  String get nonogramGuideMethodNotFitTitle => '4. Не помещается';

  @override
  String get nonogramGuideMethodSuperpositionMultiDesc =>
      'Если чисел несколько, наложите крайнее левое и крайнее правое положения всей группы, учитывая обязательный промежуток минимум в одну клетку между блоками одного цвета. Клетки, где блок пересекается сам с собой в обоих вариантах, закрашиваются.';

  @override
  String get nonogramGuideMethodSuperpositionMultiTitle =>
      'Наложение (несколько чисел)';

  @override
  String get nonogramGuideMethodSuperpositionSimpleDesc =>
      'Если число больше половины длины линии, некоторые клетки в середине точно закрашены. Наложите крайнее левое и крайнее правое положения; там, где они пересекаются, клетки закрашиваются.';

  @override
  String get nonogramGuideMethodSuperpositionSimpleTitle =>
      'Наложение (одно число)';

  @override
  String get nonogramGuideMethodWallPushingDesc =>
      'Если известная закрашенная клетка ближе к краю, чем длина первого числа, фигура, к которой она относится, должна продолжаться в сторону от этого края.';

  @override
  String get nonogramGuideMethodWallPushingTitle => '2. Отталкивание от края';

  @override
  String get nonogramGuideRuleDesc =>
      'Каждое число обозначает один непрерывный блок закрашенных клеток в этой строке или столбце. Если чисел несколько, это отдельные блоки, и между соседними блоками должна быть хотя бы одна пустая клетка. Например, `3 1` означает блок из 3 закрашенных клеток, затем хотя бы 1 пустую клетку, затем блок из 1 закрашенной клетки.';

  @override
  String get nonogramGuideRuleTitle => 'Главное правило: что значат числа';

  @override
  String get nonogramGuideTitle => 'Как решать';

  @override
  String nonogramHistoryCompletedOn(String date) {
    return 'Решено $date';
  }

  @override
  String get nonogramHistoryDetailNotFound => 'Сведения об уровне не найдены.';

  @override
  String get nonogramHistoryEmpty => 'Пока нет решённых уровней.';

  @override
  String nonogramHistoryLevel(int n) {
    return 'Уровень $n';
  }

  @override
  String get nonogramHistoryTitle => 'Результаты';

  @override
  String get nonogramPlayActionNextLevelFixed => 'Следующий уровень';

  @override
  String get nonogramPlayActionShowClues => 'Показать числа';

  @override
  String nonogramPlayCompletionMessage(int level) {
    return 'Поздравляем! Вы прошли уровень $level.';
  }

  @override
  String get nonogramPlayCompletionTitle => 'Головоломка решена!';

  @override
  String nonogramPlayDurationFormat(int minutes, int seconds) {
    return '$minutes мин $seconds с';
  }

  @override
  String nonogramPlayHintLabel(int count) {
    return 'Подсказка ($count)';
  }

  @override
  String get nonogramPlayNoNextLevelToast => 'Следующего уровня пока нет.';

  @override
  String get nonogramPlayPageTitle => 'Нонограмма';

  @override
  String get nonogramSettingsTitle => 'Настройки';

  @override
  String get nonogramDashboardContinueNext => 'Следующий уровень';

  @override
  String get nonogramDashboardPlay => 'Играть';

  @override
  String get nonogramDashboardResumeAction => 'Продолжить';

  @override
  String get nonogramDashboardInProgressBadge => 'Начато';

  @override
  String nonogramDashboardDifficulty(String value) {
    return 'Сложность $value';
  }

  @override
  String nonogramDashboardSolvedOfTotal(int completed, int total) {
    return 'Решено: $completed из $total';
  }

  @override
  String get nonogramDashboardStatFastest => 'Лучшее время';

  @override
  String get nonogramDashboardStatTotalTime => 'Общее время';

  @override
  String get nonogramDashboardRecentTitle => 'Недавно решённые';

  @override
  String get nonogramDashboardSeeAll => 'Все';

  @override
  String get nonogramDashboardRecentEmpty =>
      'Решите первую головоломку, чтобы начать собирать коллекцию картинок.';

  @override
  String get nonogramDashboardAllDoneTitle => 'Все головоломки решены!';

  @override
  String nonogramDashboardAllDoneDesc(int total) {
    return 'Вы решили все головоломки ($total). Возвращайтесь к своей коллекции в любое время.';
  }

  @override
  String nonogramDurationHoursMinutes(int hours, int minutes) {
    return '$hours ч $minutes мин';
  }

  @override
  String nonogramHistoryBestTime(String time) {
    return 'Рекорд $time';
  }

  @override
  String get nonogramPlayActionDashboard => 'На главную';

  @override
  String get appThemeTitle => 'Оформление';

  @override
  String get appThemeLight => 'Светлое';

  @override
  String get appThemeDark => 'Тёмное';

  @override
  String get nonogramPlayModeFill => 'Режим закрашивания';

  @override
  String get nonogramPlayModeMark => 'Режим крестиков';

  @override
  String get nonogramSettingsRestart => 'Начать уровень заново';

  @override
  String get nonogramSettingsRestartConfirmTitle => 'Начать уровень заново?';

  @override
  String get nonogramSettingsRestartConfirmMessage =>
      'Все закрашенные и отмеченные вами клетки будут очищены. Клетки со звёздочкой (открытые подсказкой или волшебной палочкой) сохранятся.';

  @override
  String get commonClose => 'Закрыть';

  @override
  String get nonogramSettingsRestartConfirm => 'Заново';

  @override
  String get nonogramTutorialTitle => 'Как играть';

  @override
  String get nonogramTutorialSkip => 'Пропустить';

  @override
  String get nonogramTutorialWelcomeTitle => 'Добро пожаловать в Nonopix!';

  @override
  String get nonogramTutorialWelcome =>
      'Давайте разберём основные правила на маленькой головоломке 5×5.';

  @override
  String get nonogramTutorialStart => 'Начать';

  @override
  String get nonogramTutorialSwitchToFill =>
      'Головоломки решают, закрашивая клетки. Нажмите кнопку внизу, чтобы включить режим закрашивания.';

  @override
  String get nonogramTutorialClueIsCount =>
      'Число показывает, сколько клеток в строке закрашено. В этой строке 5 — закрасьте их все!';

  @override
  String get nonogramTutorialEdgeCell =>
      'Последняя клетка уже закрашена. Блок из 4 должен её включать, поэтому разместить его можно только одним способом: закрасьте 3 клетки слева от неё.';

  @override
  String get nonogramTutorialMultipleClues =>
      'Несколько чисел — несколько блоков, между которыми хотя бы одна пустая клетка. 2 2 помещается в эти 5 клеток только одним способом.';

  @override
  String get nonogramTutorialClueOrder =>
      'Порядок тоже важен: 3 1 значит, что сначала идёт блок из 3, а потом блок из 1.';

  @override
  String get nonogramTutorialColumns =>
      'У столбцов тоже есть числа, они читаются сверху вниз. Включите режим крестиков, чтобы отметить клетки, которые должны остаться пустыми.';

  @override
  String get nonogramTutorialMarkEmpty =>
      'В столбцах с ✓ уже закрашены все нужные клетки. Отметьте их оставшиеся пустые клетки крестиком.';

  @override
  String get nonogramTutorialOneCellLeft =>
      'Для 1 в последней строке осталось только одно место. Вернитесь в режим закрашивания.';

  @override
  String get nonogramTutorialFinish =>
      'Закрасьте последнюю клетку, чтобы решить головоломку!';

  @override
  String get nonogramTutorialDoneTitle => 'Отлично!';

  @override
  String get nonogramTutorialDone =>
      'Всё готово! В больших головоломках перетаскивайте поле двумя пальцами (или из пустого места вокруг сетки); приложение напомнит об этом в первой большой головоломке.';

  @override
  String get nonogramTutorialShowTechniques => 'Посмотреть приёмы решения';

  @override
  String get nonogramTutorialPlay => 'Начать игру';

  @override
  String get nonogramGuideTutorialCardTitle => 'Учитесь, играя';

  @override
  String get nonogramGuideTutorialCardDesc =>
      'Шаг за шагом освойте правила и управление на маленькой головоломке 5×5.';

  @override
  String get nonogramPlayInfoHide => 'Скрыть сведения об уровне';

  @override
  String get nonogramPlayWandLabel => 'Волшебная палочка';

  @override
  String get nonogramPlayWandSelectPrompt =>
      'Нажмите на числа строки или столбца, который нужно открыть';

  @override
  String get nonogramPlayWandRowSolved =>
      'Эта строка уже верна. Выберите другую строку или столбец.';

  @override
  String get nonogramPlayWandColSolved =>
      'Этот столбец уже верен. Выберите другую строку или столбец.';

  @override
  String get nonogramSettingsControlsGuide => 'Управление';

  @override
  String get nonogramCoachSkip => 'Пропустить';

  @override
  String get nonogramCoachNext => 'Далее';

  @override
  String get nonogramCoachDone => 'Понятно';

  @override
  String nonogramCoachStep(int current, int total) {
    return '$current/$total';
  }

  @override
  String get nonogramCoachHintTitle => 'Подсказка';

  @override
  String get nonogramCoachHintBody =>
      'Закрашивает за вас 5 верных клеток (те, что должны быть закрашены, но ещё не закрашены), выбранных случайно по всему полю. Они отмечаются звёздочкой: их нельзя изменить, и они сохраняются даже при перезапуске. На каждую головоломку — 3 подсказки.';

  @override
  String get nonogramCoachWandTitle => 'Волшебная палочка';

  @override
  String get nonogramCoachWandBody =>
      'Нажмите на палочку, а затем на числа любой строки или столбца: ответ для всей линии откроется и будет отмечен звёздочкой, которая сохранится даже при перезапуске. На каждую головоломку — 1 палочка.';

  @override
  String get nonogramCoachModeTitle => 'Закрасить или X';

  @override
  String get nonogramCoachModeBody =>
      'Выберите, что делает нажатие: закрашивает клетку или ставит крестик, чтобы запомнить, что она пустая. Нажмите кнопку, чтобы переключиться. Проведите по сетке, чтобы закрасить или отметить сразу много клеток.';

  @override
  String get nonogramCoachLongPressTitle =>
      'Удерживайте для обратного действия';

  @override
  String get nonogramCoachLongPressBody =>
      'Удерживайте клетку, чтобы сделать обратное текущему режиму: крестик при закрашивании, закрашивание при отметке. Короткая вибрация означает, что готово и можно отпустить.';

  @override
  String get nonogramCoachScrollTitle => 'Перемещение по большим головоломкам';

  @override
  String get nonogramCoachScrollBody =>
      'Большие головоломки не помещаются на экран: перетаскивайте поле двумя пальцами или из пустого места вокруг сетки. Проведите по числам, чтобы увидеть скрытые (число «+N» в углу показывает, сколько их).';

  @override
  String get nonogramTutorialRulesDoneTitle => 'Правила вы знаете!';

  @override
  String get nonogramTutorialRulesDone =>
      'Теперь потренируемся с управлением и помощниками на другой головоломке: быстрое закрашивание проведением, отметка удержанием, подсказки и волшебная палочка.';

  @override
  String get nonogramTutorialContinue => 'Продолжить';

  @override
  String get nonogramTutorialLater => 'Позже, просто играть';

  @override
  String get nonogramTutorialDragRow =>
      'Совет: проведите пальцем по клеткам, чтобы закрасить их одним движением. В верхней строке 5 — проведите по всей строке!';

  @override
  String get nonogramTutorialLongPressMark =>
      '1 1 1 ровно помещается в эти 5 клеток, значит 2-я и 4-я клетки должны быть пустыми. Режим менять не нужно: удерживайте каждую из них, чтобы поставить крестик. Короткая вибрация означает, что готово.';

  @override
  String get nonogramTutorialUseHint =>
      'Застряли? Нажмите кнопку «Подсказка», и приложение закрасит 5 верных клеток в случайных местах. На каждую головоломку — 3 подсказки.';

  @override
  String get nonogramTutorialActivateWand =>
      'Подсказка закрасила 5 клеток со звёздочкой: они заблокированы и сохраняются даже при перезапуске. Чтобы открыть целиком любую строку или столбец на ваш выбор, используйте волшебную палочку: нажмите на кнопку палочки.';

  @override
  String get nonogramTutorialPickWandLine =>
      'Теперь нажмите на числа нижней строки, чтобы открыть её. На каждую головоломку — 1 палочка.';

  @override
  String get nonogramTutorialFinishTools =>
      'Закрасьте оставшиеся клетки, чтобы закончить. Проведите вниз по столбцу, чтобы закрашивать быстрее.';

  @override
  String get nonogramPlayHintNothingToFill =>
      'Все клетки, которые нужно закрасить, уже закрашены. Проверьте, нет ли лишних закрашенных клеток.';

  @override
  String get settingsSound => 'Звук';

  @override
  String get settingsLicenses => 'Лицензии';

  @override
  String get settingsSwitchPlayMode => 'Сменить режим игры';

  @override
  String get licensesTitle => 'Лицензии';

  @override
  String get licensesLevelArtHeading => 'Головоломки';

  @override
  String get licensesLevelArtIntro =>
      'Головоломки взяты из этих источников. Наборы иконок уменьшены, переведены в чёрно-белый вид и отредактированы, чтобы каждая головоломка имела решение; коллекции нонограмм используются без изменений.';

  @override
  String get licensesFontHeading => 'Шрифт';

  @override
  String get licensesSoftwareButton => 'Лицензии открытого ПО';

  @override
  String get licensesDeveloperLevelsNote =>
      'Головоломки режима разработчика взяты с nonogram.org и предназначены только для внутреннего тестирования. В версию для магазина они не входят.';

  @override
  String get playModeTitle => 'Выберите режим игры';

  @override
  String get playModeSubtitle =>
      'Прогресс сохраняется отдельно для каждого режима.';

  @override
  String get playModeUserTitle => 'Режим игрока';

  @override
  String get playModeUserBody =>
      'Лицензированные головоломки из версии для магазина.';

  @override
  String get playModeDeveloperTitle => 'Режим разработчика';

  @override
  String get playModeDeveloperBody =>
      'Оригинальные головоломки с nonogram.org для внутреннего тестирования. Сохраняет ваш прежний прогресс.';

  @override
  String get playModeLastUsed => 'Последний';

  @override
  String licensesBy(String author) {
    return 'Автор: $author';
  }

  @override
  String licensesLevelCount(int count) {
    return 'Головоломок: $count';
  }

  @override
  String playModeProgress(int solved, int total) {
    return 'Решено $solved/$total';
  }

  @override
  String get adRewardNotReady =>
      'Реклама ещё не готова. Проверьте подключение к интернету и попробуйте снова.';

  @override
  String get settingsAdPrivacy => 'Конфиденциальность рекламы';

  @override
  String get ratingTitle => 'Нравится Nonopix?';

  @override
  String get ratingMessage => 'Нажмите на звезду, чтобы оценить игру.';

  @override
  String get ratingLater => 'Позже';

  @override
  String get ratingSubmit => 'Отправить';

  @override
  String get ratingThanks => 'Спасибо за отзыв! Мы продолжим улучшать игру.';

  @override
  String ratingStarLabel(int count) {
    return 'Звёзд: $count';
  }

  @override
  String get settingsLanguage => 'Язык';

  @override
  String get settingsLanguageSystem => 'Язык устройства';

  @override
  String get premiumTitle => 'Играть без рекламы';

  @override
  String get premiumBenefitNoAds => 'Больше никакой рекламы между уровнями';

  @override
  String get premiumBenefitDaily =>
      '2 подсказки и 1 волшебная палочка в каждый день отметки';

  @override
  String premiumBuy(String price) {
    return 'Купить · $price';
  }

  @override
  String get premiumOneTime => 'Разовый платёж через Google Play';

  @override
  String get premiumActiveTitle => 'Пакет без рекламы активен';

  @override
  String get premiumActiveDaily =>
      'Отмечайтесь каждый день, чтобы получать 2 подсказки и 1 волшебную палочку на этот день.';

  @override
  String get premiumPurchased => 'Спасибо! Реклама между уровнями отключена.';

  @override
  String get premiumPending =>
      'Платёж ожидает обработки. Пакет включится, как только он пройдёт.';

  @override
  String get premiumFailed => 'Покупка не удалась. Попробуйте ещё раз.';

  @override
  String get checkInTitle => 'Ежедневная отметка';

  @override
  String get checkInAction => 'Отметиться';

  @override
  String get checkInDoneToday => 'Сегодня вы уже отметились';

  @override
  String checkInNextGift(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'До следующего подарка $count отметки',
      many: 'До следующего подарка $count отметок',
      few: 'До следующего подарка $count отметки',
      one: 'До следующего подарка $count отметка',
    );
    return '$_temp0';
  }

  @override
  String get checkInCheckedIn => 'Вы отметились!';

  @override
  String checkInReceived(String rewards) {
    return 'Вы получили: $rewards.';
  }

  @override
  String rewardHints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count подсказки',
      many: '$count подсказок',
      few: '$count подсказки',
      one: '$count подсказка',
    );
    return '$_temp0';
  }

  @override
  String rewardWands(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count волшебной палочки',
      many: '$count волшебных палочек',
      few: '$count волшебные палочки',
      one: '$count волшебная палочка',
    );
    return '$_temp0';
  }

  @override
  String rewardTodayOnly(String reward) {
    return '$reward (только сегодня)';
  }

  @override
  String get checkInMonthGifts => 'Подарки за месяц';

  @override
  String get navHome => 'Главная';

  @override
  String get navMe => 'Я';

  @override
  String get meHelp => 'Помощь';

  @override
  String get meMore => 'Ещё';

  @override
  String get checkInNotYetToday => 'Сегодня вы ещё не отметились';

  @override
  String get checkInTodayButton => 'Отметиться сегодня';

  @override
  String checkInGiftsLeftShort(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ещё $count отметки до подарка',
      many: 'Ещё $count отметок до подарка',
      few: 'Ещё $count отметки до подарка',
      one: 'Ещё $count отметка до подарка',
    );
    return '$_temp0';
  }

  @override
  String get checkInGiftToday => 'Сегодня подарок!';

  @override
  String checkInGiftMilestone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Подарок за $count отметки',
      many: 'Подарок за $count отметок',
      few: 'Подарок за $count отметки',
      one: 'Подарок за $count отметку',
    );
    return '$_temp0';
  }

  @override
  String get checkInGiftCollect => 'Забрать';

  @override
  String get checkInTotalHints => 'Подсказки';

  @override
  String get checkInTotalWands => 'Волшебные палочки';

  @override
  String get checkInTotalDailyHints => 'Подсказки (только сегодня)';

  @override
  String get checkInTotalDailyWands => 'Волшебные палочки (только сегодня)';

  @override
  String get checkInPremiumToday => 'Сегодня из пакета без рекламы';

  @override
  String get checkInPremiumNotYet =>
      'Отметьтесь, чтобы получить 2 подсказки и 1 волшебную палочку на сегодня.';

  @override
  String get checkInPremiumUsedUp => 'На сегодня всё использовано. До завтра!';

  @override
  String checkInExpiresIn(String time) {
    return 'Истекает через $time';
  }

  @override
  String dashboardDailyReminder(String rewards, String time) {
    return 'У вас ещё есть $rewards на сегодня. Они сгорят через $time — сыграйте сейчас, чтобы не потерять их!';
  }

  @override
  String get dashboardDailyReminderTitle => 'Сегодняшние бонусы ждут вас';

  @override
  String get dashboardDailyReminderPlay => 'Играть';

  @override
  String get premiumViewBenefits => 'Смотреть преимущества';

  @override
  String get premiumBenefitsTitle => 'Преимущества набора';

  @override
  String get premiumBenefitsTagline =>
      'Купите один раз, чтобы убрать рекламу между уровнями и каждый день получать награды-помощники — навсегда на вашем аккаунте.';

  @override
  String get premiumBenefitsOneTime => 'разовая покупка';

  @override
  String get premiumWhatYouGet => 'Что вы получаете';

  @override
  String get premiumPerkNoAdsTitle => 'Без рекламы между уровнями';

  @override
  String get premiumPerkNoAdsBody =>
      'Больше никакой полноэкранной рекламы между головоломками. Переходите с уровня на уровень без пауз.';

  @override
  String get premiumPerkDailyTitle => 'Ежедневные награды за отметку';

  @override
  String get premiumPerkDailyBody =>
      'Каждая отметка даёт вам 2 дополнительные подсказки и 1 волшебную палочку на этот день — помимо обычных наград за рубежи.';

  @override
  String get premiumItemsTitle => 'Что делают помощники';

  @override
  String get powerUpHintName => 'Подсказка';

  @override
  String get powerUpHintTagline => 'Открывает одну верную клетку на ваш выбор';

  @override
  String get powerUpHintDesc =>
      'Нажмите на лампочку и выберите место, в котором сомневаетесь. Приложение заполнит одну верную клетку (закрашенную или отмеченную пустой), чтобы помочь вам продолжить.';

  @override
  String get powerUpWandName => 'Волшебная палочка';

  @override
  String get powerUpWandTagline => 'Решает целую строку или столбец';

  @override
  String get powerUpWandDesc =>
      'Нажмите на палочку, чтобы включить режим выбора, затем нажмите на числа-подсказки строки или столбца. Приложение откроет всю эту строку или столбец. Сильнее подсказки для одной клетки.';

  @override
  String get powerUpStatesTitle => 'Значок показывает тип использования';

  @override
  String get powerUpStatesLead =>
      'Число в углу — это общее количество оставшихся использований. Использование с ограниченным сроком делает значок золотым с маленькими часами:';

  @override
  String get powerUpTimeLimited => 'Ограниченный срок';

  @override
  String get powerUpTimeLimitedDesc =>
      'Золотой значок с часами. Из ежедневной награды набора за отметку. Истекает в конце дня.';

  @override
  String get powerUpPermanent => 'Бессрочные';

  @override
  String get powerUpPermanentDesc =>
      'Обычный значок с синим бейджем. Использования за рубежи и стартовые. Никогда не истекают.';

  @override
  String get powerUpSpendOrderTitle => 'Какие использования тратятся первыми?';

  @override
  String get powerUpSpendOrderHeading =>
      'Сначала тратятся использования с ограниченным сроком';

  @override
  String get powerUpSpendOrderBody =>
      'Ежедневные использования истекают в конце дня, поэтому подсказка или палочка сначала тратит ежедневные использования и берётся за бессрочные только после того, как ежедневные закончатся. Ничего не пропадает.';

  @override
  String get powerUpSpendDaily => 'Ежедневные использования';

  @override
  String get powerUpSpendPermanent => 'Бессрочные использования';

  @override
  String get premiumBenefitsFootnote =>
      'Ежедневные использования не переносятся на следующий день. Награды за рубежи — это бессрочные использования, и они накапливаются как обычно.';
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Nonopix';

  @override
  String get commonCancel => '取消';

  @override
  String get commonRetry => '重试';

  @override
  String get commonSave => '保存';

  @override
  String nonogramDashboardContinueLevel(int level) {
    return '第 $level 关';
  }

  @override
  String get nonogramDashboardProgressSectionTitle => '你的进度';

  @override
  String get nonogramDashboardStatCompleted => '已完成';

  @override
  String get nonogramGuideIntro =>
      '数织（Nonogram）是一种规则简单、解法富有挑战的逻辑谜题。目标是根据网格旁边的数字涂满方格，让隐藏的图画显现出来。';

  @override
  String get nonogramGuideMethodDivisionDesc =>
      '如果把两个已有的色块连起来会形成比任何可用数字都长的图形，那么它们之间的空隙必须是 X。';

  @override
  String get nonogramGuideMethodDivisionTitle => '5. 分隔';

  @override
  String get nonogramGuideMethodDoublePositioningDesc =>
      '如果一个已涂的方格只能属于某个色块的少数几种摆法，那么在所有这些摆法中都不会被涂的方格都必须标记为 X。';

  @override
  String get nonogramGuideMethodDoublePositioningTitle => '6. 双重定位';

  @override
  String get nonogramGuideMethodInaccessibilityDesc =>
      '将不可能属于任何剩余色块的方格标上叉号（X）。';

  @override
  String get nonogramGuideMethodInaccessibilityTitle => '3. 不可达';

  @override
  String get nonogramGuideMethodNotFitDesc =>
      '如果两个叉号之间的空格比该行任何可用数字都短，就必须标记为 X。';

  @override
  String get nonogramGuideMethodNotFitTitle => '4. 放不下';

  @override
  String get nonogramGuideMethodSuperpositionMultiDesc =>
      '有多个数字时，考虑同色色块之间至少要空一格的规定，把整组数字分别靠最左和靠最右摆放后叠在一起。同一个色块在两种摆法中都重叠的方格要涂上。';

  @override
  String get nonogramGuideMethodSuperpositionMultiTitle => '叠加法（多个数字）';

  @override
  String get nonogramGuideMethodSuperpositionSimpleDesc =>
      '如果一个数字超过该行长度的一半，中间的某些方格一定会被涂。把靠最左和靠最右的摆法叠在一起，重叠的方格就要涂上。';

  @override
  String get nonogramGuideMethodSuperpositionSimpleTitle => '叠加法（单个数字）';

  @override
  String get nonogramGuideMethodWallPushingDesc =>
      '如果一个确定已涂的方格离边缘的距离比第一个数字还短，那么它所属的色块必须向远离该边缘的方向延伸。';

  @override
  String get nonogramGuideMethodWallPushingTitle => '2. 从边缘推开';

  @override
  String get nonogramGuideRuleDesc =>
      '每个数字代表该行或该列中一段连续的已涂方格（色块）。如果有多个数字，它们代表不同的色块，且相邻色块之间至少要隔一个空格。例如 `3 1` 表示先是 3 个连续的涂色方格，然后至少 1 个空格，再是 1 个涂色方格。';

  @override
  String get nonogramGuideRuleTitle => '基本规则：数字的含义';

  @override
  String get nonogramGuideTitle => '解题技巧';

  @override
  String nonogramHistoryCompletedOn(String date) {
    return '完成于 $date';
  }

  @override
  String get nonogramHistoryDetailNotFound => '找不到关卡详情。';

  @override
  String get nonogramHistoryEmpty => '还没有完成任何关卡。';

  @override
  String nonogramHistoryLevel(int n) {
    return '第 $n 关';
  }

  @override
  String get nonogramHistoryTitle => '成绩';

  @override
  String get nonogramPlayActionNextLevelFixed => '下一关';

  @override
  String get nonogramPlayActionShowClues => '显示数字';

  @override
  String nonogramPlayCompletionMessage(int level) {
    return '恭喜！你完成了第 $level 关。';
  }

  @override
  String get nonogramPlayCompletionTitle => '谜题完成！';

  @override
  String nonogramPlayDurationFormat(int minutes, int seconds) {
    return '$minutes分$seconds秒';
  }

  @override
  String nonogramPlayHintLabel(int count) {
    return '提示（$count）';
  }

  @override
  String get nonogramPlayNoNextLevelToast => '暂时没有下一关。';

  @override
  String get nonogramPlayPageTitle => '数织';

  @override
  String get nonogramSettingsTitle => '设置';

  @override
  String get nonogramDashboardContinueNext => '下一个挑战';

  @override
  String get nonogramDashboardPlay => '开始';

  @override
  String get nonogramDashboardResumeAction => '继续';

  @override
  String get nonogramDashboardInProgressBadge => '进行中';

  @override
  String nonogramDashboardDifficulty(String value) {
    return '难度 $value';
  }

  @override
  String nonogramDashboardSolvedOfTotal(int completed, int total) {
    return '已完成 $completed/$total 个谜题';
  }

  @override
  String get nonogramDashboardStatFastest => '最快';

  @override
  String get nonogramDashboardStatTotalTime => '总用时';

  @override
  String get nonogramDashboardRecentTitle => '最近完成';

  @override
  String get nonogramDashboardSeeAll => '查看全部';

  @override
  String get nonogramDashboardRecentEmpty => '完成第一个谜题，开始收集你的图画吧。';

  @override
  String get nonogramDashboardAllDoneTitle => '全部谜题已完成！';

  @override
  String nonogramDashboardAllDoneDesc(int total) {
    return '你已完成全部 $total 个谜题。随时回来欣赏你的收藏吧。';
  }

  @override
  String nonogramDurationHoursMinutes(int hours, int minutes) {
    return '$hours小时$minutes分';
  }

  @override
  String nonogramHistoryBestTime(String time) {
    return '最佳 $time';
  }

  @override
  String get nonogramPlayActionDashboard => '主页';

  @override
  String get appThemeTitle => '外观';

  @override
  String get appThemeLight => '浅色';

  @override
  String get appThemeDark => '深色';

  @override
  String get nonogramPlayModeFill => '涂色模式';

  @override
  String get nonogramPlayModeMark => '标 X 模式';

  @override
  String get nonogramSettingsRestart => '重新开始本关';

  @override
  String get nonogramSettingsRestartConfirmTitle => '重新开始本关？';

  @override
  String get nonogramSettingsRestartConfirmMessage =>
      '你涂过或标记过的所有方格都会被清除。带星标的方格（由提示或魔杖揭开）会保留。';

  @override
  String get commonClose => '关闭';

  @override
  String get nonogramSettingsRestartConfirm => '重新开始';

  @override
  String get nonogramTutorialTitle => '玩法说明';

  @override
  String get nonogramTutorialSkip => '跳过';

  @override
  String get nonogramTutorialWelcomeTitle => '欢迎来到 Nonopix！';

  @override
  String get nonogramTutorialWelcome => '让我们通过一个 5×5 的小谜题来学习基本规则。';

  @override
  String get nonogramTutorialStart => '开始';

  @override
  String get nonogramTutorialSwitchToFill => '解谜的方法是给方格涂色。点按下方按钮切换到涂色模式。';

  @override
  String get nonogramTutorialClueIsCount => '数字表示这一行有几个方格要涂色。这一行是 5，所以全部涂上！';

  @override
  String get nonogramTutorialEdgeCell =>
      '最后一格已经涂好了。4 格的色块必须包含它，所以只有一种摆法：涂上它左边的 3 格。';

  @override
  String get nonogramTutorialMultipleClues =>
      '多个数字代表多个色块，色块之间至少隔一个空格。2 2 放进这 5 格只有一种摆法。';

  @override
  String get nonogramTutorialClueOrder => '顺序也很重要：3 1 表示先是 3 格的色块，然后才是 1 格的色块。';

  @override
  String get nonogramTutorialColumns => '每一列也有数字，从上往下读。切换到 X 模式，标记必须留空的方格。';

  @override
  String get nonogramTutorialMarkEmpty => '带 ✓ 的列已经涂满了所需的方格。把它们剩下的空格标上 X。';

  @override
  String get nonogramTutorialOneCellLeft => '最后一行的 1 现在只剩一个位置了。切换回涂色模式。';

  @override
  String get nonogramTutorialFinish => '涂上最后一格，完成谜题！';

  @override
  String get nonogramTutorialDoneTitle => '做得好！';

  @override
  String get nonogramTutorialDone =>
      '准备就绪！在大谜题中，用两根手指拖动（或从网格外的空白处拖动）来移动棋盘；在你的第一个大谜题中，应用会再提醒你。';

  @override
  String get nonogramTutorialShowTechniques => '查看解题技巧';

  @override
  String get nonogramTutorialPlay => '开始游戏';

  @override
  String get nonogramGuideTutorialCardTitle => '边玩边学';

  @override
  String get nonogramGuideTutorialCardDesc => '在一个 5×5 的小谜题上一步步学习规则和操作。';

  @override
  String get nonogramPlayInfoHide => '隐藏关卡信息';

  @override
  String get nonogramPlayWandLabel => '魔杖';

  @override
  String get nonogramPlayWandSelectPrompt => '点按要揭开的行或列的数字';

  @override
  String get nonogramPlayWandRowSolved => '这一行已经正确了。请选择其他行或列。';

  @override
  String get nonogramPlayWandColSolved => '这一列已经正确了。请选择其他行或列。';

  @override
  String get nonogramSettingsControlsGuide => '操作指南';

  @override
  String get nonogramCoachSkip => '跳过';

  @override
  String get nonogramCoachNext => '下一步';

  @override
  String get nonogramCoachDone => '知道了';

  @override
  String nonogramCoachStep(int current, int total) {
    return '$current/$total';
  }

  @override
  String get nonogramCoachHintTitle => '提示';

  @override
  String get nonogramCoachHintBody =>
      '从整个棋盘中随机选 5 个正确的方格（应该涂但还没涂的方格）帮你涂上。它们会带有星标：不能更改，即使重新开始也会保留。每个谜题有 3 次。';

  @override
  String get nonogramCoachWandTitle => '魔杖';

  @override
  String get nonogramCoachWandBody =>
      '点按魔杖，再点按任意一行或一列的数字：整条线的答案就会揭开并带有星标，即使重新开始也会保留。每个谜题有 1 次。';

  @override
  String get nonogramCoachModeTitle => '涂色或 X';

  @override
  String get nonogramCoachModeBody =>
      '选择点按时的操作：给方格涂色，或标上 X 提醒自己这里是空格。点按按钮即可切换。在网格上拖动可以一次涂色或标记多个方格。';

  @override
  String get nonogramCoachLongPressTitle => '长按执行相反操作';

  @override
  String get nonogramCoachLongPressBody =>
      '长按方格会执行与当前模式相反的操作：涂色时标 X，标记时涂色。短暂振动表示已完成，可以松手了。';

  @override
  String get nonogramCoachScrollTitle => '浏览大谜题';

  @override
  String get nonogramCoachScrollBody =>
      '大谜题无法完整显示在屏幕上：用两根手指拖动，或从网格外的空白处拖动来移动棋盘。在数字上拖动可以查看被隐藏的数字（角落的“+N”表示有几个）。';

  @override
  String get nonogramTutorialRulesDoneTitle => '你已经掌握规则了！';

  @override
  String get nonogramTutorialRulesDone =>
      '接下来在另一个谜题上练习操作和辅助功能：拖动快速涂色、长按标记、提示和魔杖。';

  @override
  String get nonogramTutorialContinue => '继续';

  @override
  String get nonogramTutorialLater => '以后再说，直接玩';

  @override
  String get nonogramTutorialDragRow => '小技巧：用手指划过方格就能一次涂完。最上面一行是 5，划过整行吧！';

  @override
  String get nonogramTutorialLongPressMark =>
      '1 1 1 正好放满这 5 格，所以第 2 格和第 4 格必须是空的。不用切换模式：长按每一格就能标上 X。短暂振动表示已完成。';

  @override
  String get nonogramTutorialUseHint =>
      '卡住了？点按提示按钮，应用会随机帮你涂上 5 个正确的方格。每个谜题有 3 次。';

  @override
  String get nonogramTutorialActivateWand =>
      '提示涂上了 5 个带星标的方格：它们已锁定，即使重新开始也会保留。想揭开你选择的一整行或一整列，就用魔杖：点按魔杖按钮。';

  @override
  String get nonogramTutorialPickWandLine => '现在点按最下面一行的数字来揭开这一行。每个谜题有 1 次魔杖。';

  @override
  String get nonogramTutorialFinishTools => '涂完剩下的方格就完成了。沿着一列向下拖动可以涂得更快。';

  @override
  String get nonogramPlayHintNothingToFill => '所有该涂的方格都已经涂好了。检查一下是否有多涂的方格。';

  @override
  String get settingsSound => '音效';

  @override
  String get settingsLicenses => '许可';

  @override
  String get settingsSwitchPlayMode => '切换游戏模式';

  @override
  String get licensesTitle => '许可';

  @override
  String get licensesLevelArtHeading => '谜题';

  @override
  String get licensesLevelArtIntro =>
      '谜题来自以下来源。图标集经过缩小、转换为黑白并加以修改，确保每个谜题都有解；数织合集则按原样使用。';

  @override
  String get licensesFontHeading => '字体';

  @override
  String get licensesSoftwareButton => '开源软件许可';

  @override
  String get licensesDeveloperLevelsNote =>
      '开发者模式的谜题来自 nonogram.org，仅供内部测试使用，不包含在商店版本中。';

  @override
  String get playModeTitle => '选择游戏模式';

  @override
  String get playModeSubtitle => '每种模式的进度分别保存。';

  @override
  String get playModeUserTitle => '玩家模式';

  @override
  String get playModeUserBody => '商店版本中附带的已授权谜题。';

  @override
  String get playModeDeveloperTitle => '开发者模式';

  @override
  String get playModeDeveloperBody => '来自 nonogram.org 的原版谜题，供内部测试使用。保留你之前的进度。';

  @override
  String get playModeLastUsed => '上次使用';

  @override
  String licensesBy(String author) {
    return '作者：$author';
  }

  @override
  String licensesLevelCount(int count) {
    return '$count 个谜题';
  }

  @override
  String playModeProgress(int solved, int total) {
    return '已完成 $solved/$total';
  }

  @override
  String get adRewardNotReady => '广告还没准备好。请检查网络连接后重试。';

  @override
  String get settingsAdPrivacy => '广告隐私';

  @override
  String get ratingTitle => '喜欢 Nonopix 吗？';

  @override
  String get ratingMessage => '点按星星为游戏评分。';

  @override
  String get ratingLater => '以后再说';

  @override
  String get ratingSubmit => '提交';

  @override
  String get ratingThanks => '感谢你的反馈！我们会继续改进游戏。';

  @override
  String ratingStarLabel(int count) {
    return '$count 星';
  }

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsLanguageSystem => '跟随系统';

  @override
  String get premiumTitle => '无广告畅玩';

  @override
  String get premiumBenefitNoAds => '关卡之间不再有广告';

  @override
  String get premiumBenefitDaily => '每次签到都有 2 次提示和 1 次魔法棒';

  @override
  String premiumBuy(String price) {
    return '购买 · $price';
  }

  @override
  String get premiumOneTime => '通过 Google Play 一次性付款';

  @override
  String get premiumActiveTitle => '无广告礼包已激活';

  @override
  String get premiumActiveDaily => '每天签到即可获得当天可用的 2 次提示和 1 次魔法棒。';

  @override
  String get premiumPurchased => '谢谢！关卡之间的广告已关闭。';

  @override
  String get premiumPending => '付款处理中。付款完成后礼包将自动激活。';

  @override
  String get premiumFailed => '购买未成功，请重试。';

  @override
  String get checkInTitle => '每日签到';

  @override
  String get checkInAction => '签到';

  @override
  String get checkInDoneToday => '今天已签到';

  @override
  String checkInNextGift(int count) {
    return '再签到 $count 次即可获得下一份礼物';
  }

  @override
  String get checkInCheckedIn => '签到成功！';

  @override
  String checkInReceived(String rewards) {
    return '你获得了 $rewards。';
  }

  @override
  String rewardHints(int count) {
    return '$count 次提示';
  }

  @override
  String rewardWands(int count) {
    return '$count 次魔法棒';
  }

  @override
  String rewardTodayOnly(String reward) {
    return '$reward（仅限今天）';
  }

  @override
  String get checkInMonthGifts => '本月礼物';

  @override
  String get navHome => '首页';

  @override
  String get navMe => '我的';

  @override
  String get meHelp => '帮助';

  @override
  String get meMore => '更多';

  @override
  String get checkInNotYetToday => '今天还没签到';

  @override
  String get checkInTodayButton => '今日签到';

  @override
  String checkInGiftsLeftShort(int count) {
    return '再签 $count 次得礼物';
  }

  @override
  String get checkInGiftToday => '今天有礼物！';

  @override
  String checkInGiftMilestone(int count) {
    return '累计签到 $count 次礼物';
  }

  @override
  String get checkInGiftCollect => '领取';

  @override
  String get checkInTotalHints => '提示';

  @override
  String get checkInTotalWands => '魔法棒';

  @override
  String get checkInTotalDailyHints => '提示（仅限今天）';

  @override
  String get checkInTotalDailyWands => '魔法棒（仅限今天）';

  @override
  String get checkInPremiumToday => '今天来自无广告礼包';

  @override
  String get checkInPremiumNotYet => '签到即可获得今天可用的 2 次提示和 1 次魔法棒。';

  @override
  String get checkInPremiumUsedUp => '今天的已用完，明天见！';

  @override
  String checkInExpiresIn(String time) {
    return '$time后过期';
  }

  @override
  String dashboardDailyReminder(String rewards, String time) {
    return '你今天还有 $rewards，将在 $time后过期，快来玩别浪费了！';
  }

  @override
  String get dashboardDailyReminderTitle => '今天的道具在等你';

  @override
  String get dashboardDailyReminderPlay => '立即游玩';

  @override
  String get premiumViewBenefits => '查看权益';

  @override
  String get premiumBenefitsTitle => '套餐权益';

  @override
  String get premiumBenefitsTagline => '一次购买即可去除关卡之间的广告，并每天获得帮助奖励，永久绑定你的账号。';

  @override
  String get premiumBenefitsOneTime => '一次性';

  @override
  String get premiumWhatYouGet => '你能获得什么';

  @override
  String get premiumPerkNoAdsTitle => '关卡之间无广告';

  @override
  String get premiumPerkNoAdsBody => '谜题之间不再有全屏广告，一关接一关畅玩无中断。';

  @override
  String get premiumPerkDailyTitle => '每日签到奖励';

  @override
  String get premiumPerkDailyBody => '除常规里程碑奖励外，每次签到都会额外获得当天可用的 2 次提示和 1 次魔法棒。';

  @override
  String get premiumItemsTitle => '道具有什么用';

  @override
  String get powerUpHintName => '提示';

  @override
  String get powerUpHintTagline => '揭示你所选的一个正确格子';

  @override
  String get powerUpHintDesc => '点击灯泡，再选择你拿不准的位置。应用会填入一个正确的格子（填涂或标记为空），帮你走出困境。';

  @override
  String get powerUpWandName => '魔法棒';

  @override
  String get powerUpWandTagline => '解开一整行或一整列';

  @override
  String get powerUpWandDesc => '点击魔法棒开启选择模式，再点击某一行或某一列的提示数字。应用会揭示该整行或整列，比单格提示更强。';

  @override
  String get powerUpStatesTitle => '图标显示使用类型';

  @override
  String get powerUpStatesLead => '角标数字是剩余的总次数。有时限的次数会让图标变成金色并带一个小时钟：';

  @override
  String get powerUpTimeLimited => '有时限';

  @override
  String get powerUpTimeLimitedDesc => '带时钟的金色图标。来自套餐的每日签到奖励，当天结束时过期。';

  @override
  String get powerUpPermanent => '永久';

  @override
  String get powerUpPermanentDesc => '带蓝色徽章的普通图标。里程碑和初始次数，永不过期。';

  @override
  String get powerUpSpendOrderTitle => '先用哪种次数？';

  @override
  String get powerUpSpendOrderHeading => '优先消耗有时限的次数';

  @override
  String get powerUpSpendOrderBody => '每日次数会在当天结束时过期，所以提示或魔法棒会先消耗你的每日次数，只有在每日次数用完后才会动用永久次数，不会浪费。';

  @override
  String get powerUpSpendDaily => '每日次数';

  @override
  String get powerUpSpendPermanent => '永久次数';

  @override
  String get premiumBenefitsFootnote => '每日次数不会累积到第二天。里程碑签到奖励属于永久次数，照常累积。';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get appTitle => 'Nonopix';

  @override
  String get commonCancel => '取消';

  @override
  String get commonRetry => '重試';

  @override
  String get commonSave => '儲存';

  @override
  String nonogramDashboardContinueLevel(int level) {
    return '第 $level 關';
  }

  @override
  String get nonogramDashboardProgressSectionTitle => '你的進度';

  @override
  String get nonogramDashboardStatCompleted => '已完成';

  @override
  String get nonogramGuideIntro =>
      '數織（Nonogram）是一種規則簡單、解法富有挑戰的邏輯謎題。目標是根據網格旁邊的數字塗滿方格，讓隱藏的圖畫顯現出來。';

  @override
  String get nonogramGuideMethodDivisionDesc =>
      '如果把兩個已有的色塊連起來會形成比任何可用數字都長的圖形，那麼它們之間的空隙必須是 X。';

  @override
  String get nonogramGuideMethodDivisionTitle => '5. 分隔';

  @override
  String get nonogramGuideMethodDoublePositioningDesc =>
      '如果一個已塗的方格只能屬於某個色塊的少數幾種擺法，那麼在所有這些擺法中都不會被塗的方格都必須標記為 X。';

  @override
  String get nonogramGuideMethodDoublePositioningTitle => '6. 雙重定位';

  @override
  String get nonogramGuideMethodInaccessibilityDesc =>
      '將不可能屬於任何剩餘色塊的方格標上叉號（X）。';

  @override
  String get nonogramGuideMethodInaccessibilityTitle => '3. 不可達';

  @override
  String get nonogramGuideMethodNotFitDesc =>
      '如果兩個叉號之間的空格比這條線上任何可用數字都短，就必須標記為 X。';

  @override
  String get nonogramGuideMethodNotFitTitle => '4. 放不下';

  @override
  String get nonogramGuideMethodSuperpositionMultiDesc =>
      '有多個數字時，考慮同色色塊之間至少要空一格的規定，把整組數字分別靠最左和靠最右擺放後疊在一起。同一個色塊在兩種擺法中都重疊的方格要塗上。';

  @override
  String get nonogramGuideMethodSuperpositionMultiTitle => '疊加法（多個數字）';

  @override
  String get nonogramGuideMethodSuperpositionSimpleDesc =>
      '如果一個數字超過這條線長度的一半，中間的某些方格一定會被塗。把靠最左和靠最右的擺法疊在一起，重疊的方格就要塗上。';

  @override
  String get nonogramGuideMethodSuperpositionSimpleTitle => '疊加法（單個數字）';

  @override
  String get nonogramGuideMethodWallPushingDesc =>
      '如果一個確定已塗的方格離邊緣的距離比第一個數字還短，那麼它所屬的色塊必須朝遠離該邊緣的方向延伸。';

  @override
  String get nonogramGuideMethodWallPushingTitle => '2. 從邊緣推開';

  @override
  String get nonogramGuideRuleDesc =>
      '每個數字代表該橫列或直行中一段連續的已塗方格（色塊）。如果有多個數字，它們代表不同的色塊，且相鄰色塊之間至少要隔一個空格。例如 `3 1` 表示先是 3 個連續的塗色方格，然後至少 1 個空格，再是 1 個塗色方格。';

  @override
  String get nonogramGuideRuleTitle => '基本規則：數字的含義';

  @override
  String get nonogramGuideTitle => '解題技巧';

  @override
  String nonogramHistoryCompletedOn(String date) {
    return '完成於 $date';
  }

  @override
  String get nonogramHistoryDetailNotFound => '找不到關卡詳情。';

  @override
  String get nonogramHistoryEmpty => '還沒有完成任何關卡。';

  @override
  String nonogramHistoryLevel(int n) {
    return '第 $n 關';
  }

  @override
  String get nonogramHistoryTitle => '成績';

  @override
  String get nonogramPlayActionNextLevelFixed => '下一關';

  @override
  String get nonogramPlayActionShowClues => '顯示數字';

  @override
  String nonogramPlayCompletionMessage(int level) {
    return '恭喜！你完成了第 $level 關。';
  }

  @override
  String get nonogramPlayCompletionTitle => '謎題完成！';

  @override
  String nonogramPlayDurationFormat(int minutes, int seconds) {
    return '$minutes分$seconds秒';
  }

  @override
  String nonogramPlayHintLabel(int count) {
    return '提示（$count）';
  }

  @override
  String get nonogramPlayNoNextLevelToast => '暫時沒有下一關。';

  @override
  String get nonogramPlayPageTitle => '數織';

  @override
  String get nonogramSettingsTitle => '設定';

  @override
  String get nonogramDashboardContinueNext => '下一個挑戰';

  @override
  String get nonogramDashboardPlay => '開始';

  @override
  String get nonogramDashboardResumeAction => '繼續';

  @override
  String get nonogramDashboardInProgressBadge => '進行中';

  @override
  String nonogramDashboardDifficulty(String value) {
    return '難度 $value';
  }

  @override
  String nonogramDashboardSolvedOfTotal(int completed, int total) {
    return '已完成 $completed/$total 個謎題';
  }

  @override
  String get nonogramDashboardStatFastest => '最快';

  @override
  String get nonogramDashboardStatTotalTime => '總用時';

  @override
  String get nonogramDashboardRecentTitle => '最近完成';

  @override
  String get nonogramDashboardSeeAll => '查看全部';

  @override
  String get nonogramDashboardRecentEmpty => '完成第一個謎題，開始收集你的圖畫吧。';

  @override
  String get nonogramDashboardAllDoneTitle => '全部謎題已完成！';

  @override
  String nonogramDashboardAllDoneDesc(int total) {
    return '你已完成全部 $total 個謎題。隨時回來欣賞你的收藏吧。';
  }

  @override
  String nonogramDurationHoursMinutes(int hours, int minutes) {
    return '$hours小時$minutes分';
  }

  @override
  String nonogramHistoryBestTime(String time) {
    return '最佳 $time';
  }

  @override
  String get nonogramPlayActionDashboard => '主頁';

  @override
  String get appThemeTitle => '外觀';

  @override
  String get appThemeLight => '淺色';

  @override
  String get appThemeDark => '深色';

  @override
  String get nonogramPlayModeFill => '塗色模式';

  @override
  String get nonogramPlayModeMark => '標 X 模式';

  @override
  String get nonogramSettingsRestart => '重新開始本關';

  @override
  String get nonogramSettingsRestartConfirmTitle => '重新開始本關？';

  @override
  String get nonogramSettingsRestartConfirmMessage =>
      '你塗過或標記過的所有方格都會被清除。帶星號的方格（由提示或魔杖揭開）會保留。';

  @override
  String get commonClose => '關閉';

  @override
  String get nonogramSettingsRestartConfirm => '重新開始';

  @override
  String get nonogramTutorialTitle => '玩法說明';

  @override
  String get nonogramTutorialSkip => '略過';

  @override
  String get nonogramTutorialWelcomeTitle => '歡迎來到 Nonopix！';

  @override
  String get nonogramTutorialWelcome => '讓我們透過一個 5×5 的小謎題來學習基本規則。';

  @override
  String get nonogramTutorialStart => '開始';

  @override
  String get nonogramTutorialSwitchToFill => '解謎的方法是為方格塗色。點按下方按鈕切換到塗色模式。';

  @override
  String get nonogramTutorialClueIsCount => '數字表示這一橫列有幾個方格要塗色。這一橫列是 5，所以全部塗上！';

  @override
  String get nonogramTutorialEdgeCell =>
      '最後一格已經塗好了。4 格的色塊必須包含它，所以只有一種擺法：塗上它左邊的 3 格。';

  @override
  String get nonogramTutorialMultipleClues =>
      '多個數字代表多個色塊，色塊之間至少隔一個空格。2 2 放進這 5 格只有一種擺法。';

  @override
  String get nonogramTutorialClueOrder => '順序也很重要：3 1 表示先是 3 格的色塊，然後才是 1 格的色塊。';

  @override
  String get nonogramTutorialColumns => '每一直行也有數字，從上往下讀。切換到 X 模式，標記必須留空的方格。';

  @override
  String get nonogramTutorialMarkEmpty => '帶 ✓ 的直行已經塗滿了所需的方格。把它們剩下的空格標上 X。';

  @override
  String get nonogramTutorialOneCellLeft => '最後一橫列的 1 現在只剩一個位置了。切換回塗色模式。';

  @override
  String get nonogramTutorialFinish => '塗上最後一格，完成謎題！';

  @override
  String get nonogramTutorialDoneTitle => '做得好！';

  @override
  String get nonogramTutorialDone =>
      '準備就緒！在大謎題中，用兩根手指拖曳（或從網格外的空白處拖曳）來移動棋盤；在你的第一個大謎題中，應用程式會再提醒你。';

  @override
  String get nonogramTutorialShowTechniques => '查看解題技巧';

  @override
  String get nonogramTutorialPlay => '開始遊戲';

  @override
  String get nonogramGuideTutorialCardTitle => '邊玩邊學';

  @override
  String get nonogramGuideTutorialCardDesc => '在一個 5×5 的小謎題上一步步學習規則和操作。';

  @override
  String get nonogramPlayInfoHide => '隱藏關卡資訊';

  @override
  String get nonogramPlayWandLabel => '魔杖';

  @override
  String get nonogramPlayWandSelectPrompt => '點按要揭開的橫列或直行的數字';

  @override
  String get nonogramPlayWandRowSolved => '這一橫列已經正確了。請選擇其他橫列或直行。';

  @override
  String get nonogramPlayWandColSolved => '這一直行已經正確了。請選擇其他橫列或直行。';

  @override
  String get nonogramSettingsControlsGuide => '操作指南';

  @override
  String get nonogramCoachSkip => '略過';

  @override
  String get nonogramCoachNext => '下一步';

  @override
  String get nonogramCoachDone => '知道了';

  @override
  String nonogramCoachStep(int current, int total) {
    return '$current/$total';
  }

  @override
  String get nonogramCoachHintTitle => '提示';

  @override
  String get nonogramCoachHintBody =>
      '從整個棋盤中隨機選 5 個正確的方格（應該塗但還沒塗的方格）幫你塗上。它們會帶有星號：不能更改，即使重新開始也會保留。每個謎題有 3 次。';

  @override
  String get nonogramCoachWandTitle => '魔杖';

  @override
  String get nonogramCoachWandBody =>
      '點按魔杖，再點按任意橫列或直行的數字：整條線的答案就會揭開並帶有星號，即使重新開始也會保留。每個謎題有 1 次。';

  @override
  String get nonogramCoachModeTitle => '塗色或 X';

  @override
  String get nonogramCoachModeBody =>
      '選擇點按時的操作：為方格塗色，或標上 X 提醒自己這裡是空格。點按按鈕即可切換。在網格上拖曳可以一次塗色或標記多個方格。';

  @override
  String get nonogramCoachLongPressTitle => '長按執行相反操作';

  @override
  String get nonogramCoachLongPressBody =>
      '長按方格會執行與目前模式相反的操作：塗色時標 X，標記時塗色。短暫震動表示已完成，可以放開了。';

  @override
  String get nonogramCoachScrollTitle => '瀏覽大謎題';

  @override
  String get nonogramCoachScrollBody =>
      '大謎題無法完整顯示在螢幕上：用兩根手指拖曳，或從網格外的空白處拖曳來移動棋盤。在數字上拖曳可以查看被隱藏的數字（角落的「+N」表示有幾個）。';

  @override
  String get nonogramTutorialRulesDoneTitle => '你已經掌握規則了！';

  @override
  String get nonogramTutorialRulesDone =>
      '接下來在另一個謎題上練習操作和輔助功能：拖曳快速塗色、長按標記、提示和魔杖。';

  @override
  String get nonogramTutorialContinue => '繼續';

  @override
  String get nonogramTutorialLater => '以後再說，直接玩';

  @override
  String get nonogramTutorialDragRow => '小技巧：用手指劃過方格就能一次塗完。最上面一橫列是 5，劃過整列吧！';

  @override
  String get nonogramTutorialLongPressMark =>
      '1 1 1 正好放滿這 5 格，所以第 2 格和第 4 格必須是空的。不用切換模式：長按每一格就能標上 X。短暫震動表示已完成。';

  @override
  String get nonogramTutorialUseHint =>
      '卡住了？點按提示按鈕，應用程式會隨機幫你塗上 5 個正確的方格。每個謎題有 3 次。';

  @override
  String get nonogramTutorialActivateWand =>
      '提示塗上了 5 個帶星號的方格：它們已鎖定，即使重新開始也會保留。想揭開你選擇的一整條橫列或直行，就用魔杖：點按魔杖按鈕。';

  @override
  String get nonogramTutorialPickWandLine => '現在點按最下面一橫列的數字來揭開這一列。每個謎題有 1 次魔杖。';

  @override
  String get nonogramTutorialFinishTools => '塗完剩下的方格就完成了。沿著一直行向下拖曳可以塗得更快。';

  @override
  String get nonogramPlayHintNothingToFill => '所有該塗的方格都已經塗好了。檢查一下是否有多塗的方格。';

  @override
  String get settingsSound => '音效';

  @override
  String get settingsLicenses => '授權';

  @override
  String get settingsSwitchPlayMode => '切換遊戲模式';

  @override
  String get licensesTitle => '授權';

  @override
  String get licensesLevelArtHeading => '謎題';

  @override
  String get licensesLevelArtIntro =>
      '謎題來自以下來源。圖示集經過縮小、轉換為黑白並加以修改，確保每個謎題都有解；數織合集則按原樣使用。';

  @override
  String get licensesFontHeading => '字型';

  @override
  String get licensesSoftwareButton => '開放原始碼軟體授權';

  @override
  String get licensesDeveloperLevelsNote =>
      '開發者模式的謎題來自 nonogram.org，僅供內部測試使用，不包含在商店版本中。';

  @override
  String get playModeTitle => '選擇遊戲模式';

  @override
  String get playModeSubtitle => '每種模式的進度分別儲存。';

  @override
  String get playModeUserTitle => '玩家模式';

  @override
  String get playModeUserBody => '商店版本中附帶的已授權謎題。';

  @override
  String get playModeDeveloperTitle => '開發者模式';

  @override
  String get playModeDeveloperBody => '來自 nonogram.org 的原版謎題，供內部測試使用。保留你之前的進度。';

  @override
  String get playModeLastUsed => '上次使用';

  @override
  String licensesBy(String author) {
    return '作者：$author';
  }

  @override
  String licensesLevelCount(int count) {
    return '$count 個謎題';
  }

  @override
  String playModeProgress(int solved, int total) {
    return '已完成 $solved/$total';
  }

  @override
  String get adRewardNotReady => '廣告還沒準備好。請檢查網路連線後重試。';

  @override
  String get settingsAdPrivacy => '廣告隱私';

  @override
  String get ratingTitle => '喜歡 Nonopix 嗎？';

  @override
  String get ratingMessage => '點按星星為遊戲評分。';

  @override
  String get ratingLater => '以後再說';

  @override
  String get ratingSubmit => '送出';

  @override
  String get ratingThanks => '感謝你的回饋！我們會繼續改進遊戲。';

  @override
  String ratingStarLabel(int count) {
    return '$count 星';
  }

  @override
  String get settingsLanguage => '語言';

  @override
  String get settingsLanguageSystem => '跟隨系統';

  @override
  String get premiumTitle => '無廣告暢玩';

  @override
  String get premiumBenefitNoAds => '關卡之間不再有廣告';

  @override
  String get premiumBenefitDaily => '每次簽到都有 2 次提示和 1 次魔法棒';

  @override
  String premiumBuy(String price) {
    return '購買 · $price';
  }

  @override
  String get premiumOneTime => '透過 Google Play 一次性付款';

  @override
  String get premiumActiveTitle => '無廣告禮包已啟用';

  @override
  String get premiumActiveDaily => '每天簽到即可獲得當天可用的 2 次提示和 1 次魔法棒。';

  @override
  String get premiumPurchased => '謝謝！關卡之間的廣告已關閉。';

  @override
  String get premiumPending => '付款處理中。付款完成後禮包將自動啟用。';

  @override
  String get premiumFailed => '購買未成功，請再試一次。';

  @override
  String get checkInTitle => '每日簽到';

  @override
  String get checkInAction => '簽到';

  @override
  String get checkInDoneToday => '今天已簽到';

  @override
  String checkInNextGift(int count) {
    return '再簽到 $count 次即可獲得下一份禮物';
  }

  @override
  String get checkInCheckedIn => '簽到成功！';

  @override
  String checkInReceived(String rewards) {
    return '你獲得了 $rewards。';
  }

  @override
  String rewardHints(int count) {
    return '$count 次提示';
  }

  @override
  String rewardWands(int count) {
    return '$count 次魔法棒';
  }

  @override
  String rewardTodayOnly(String reward) {
    return '$reward（僅限今天）';
  }

  @override
  String get checkInMonthGifts => '本月禮物';

  @override
  String get navHome => '首頁';

  @override
  String get navMe => '我的';

  @override
  String get meHelp => '說明';

  @override
  String get meMore => '更多';

  @override
  String get checkInNotYetToday => '今天還沒簽到';

  @override
  String get checkInTodayButton => '今日簽到';

  @override
  String checkInGiftsLeftShort(int count) {
    return '再簽 $count 次得禮物';
  }

  @override
  String get checkInGiftToday => '今天有禮物！';

  @override
  String checkInGiftMilestone(int count) {
    return '累計簽到 $count 次禮物';
  }

  @override
  String get checkInGiftCollect => '領取';

  @override
  String get checkInTotalHints => '提示';

  @override
  String get checkInTotalWands => '魔法棒';

  @override
  String get checkInTotalDailyHints => '提示（僅限今天）';

  @override
  String get checkInTotalDailyWands => '魔法棒（僅限今天）';

  @override
  String get checkInPremiumToday => '今天來自無廣告禮包';

  @override
  String get checkInPremiumNotYet => '簽到即可獲得今天可用的 2 次提示和 1 次魔法棒。';

  @override
  String get checkInPremiumUsedUp => '今天的已用完，明天見！';

  @override
  String checkInExpiresIn(String time) {
    return '$time後過期';
  }

  @override
  String dashboardDailyReminder(String rewards, String time) {
    return '你今天還有 $rewards，將在 $time後過期，快來玩別浪費了！';
  }

  @override
  String get dashboardDailyReminderTitle => '今天的道具在等你';

  @override
  String get dashboardDailyReminderPlay => '立即遊玩';

  @override
  String get premiumViewBenefits => '查看權益';

  @override
  String get premiumBenefitsTitle => '套餐權益';

  @override
  String get premiumBenefitsTagline => '一次購買即可去除關卡之間的廣告，並每天獲得幫助獎勵，永久綁定你的帳號。';

  @override
  String get premiumBenefitsOneTime => '一次性';

  @override
  String get premiumWhatYouGet => '你能獲得什麼';

  @override
  String get premiumPerkNoAdsTitle => '關卡之間無廣告';

  @override
  String get premiumPerkNoAdsBody => '謎題之間不再有全螢幕廣告，一關接一關暢玩無中斷。';

  @override
  String get premiumPerkDailyTitle => '每日簽到獎勵';

  @override
  String get premiumPerkDailyBody => '除常規里程碑獎勵外，每次簽到都會額外獲得當天可用的 2 次提示和 1 次魔法棒。';

  @override
  String get premiumItemsTitle => '道具有什麼用';

  @override
  String get powerUpHintName => '提示';

  @override
  String get powerUpHintTagline => '揭示你所選的一個正確格子';

  @override
  String get powerUpHintDesc => '點擊燈泡，再選擇你拿不準的位置。應用會填入一個正確的格子（填塗或標記為空），幫你走出困境。';

  @override
  String get powerUpWandName => '魔法棒';

  @override
  String get powerUpWandTagline => '解開一整行或一整列';

  @override
  String get powerUpWandDesc => '點擊魔法棒開啟選擇模式，再點擊某一行或某一列的提示數字。應用會揭示該整行或整列，比單格提示更強。';

  @override
  String get powerUpStatesTitle => '圖示顯示使用類型';

  @override
  String get powerUpStatesLead => '角標數字是剩餘的總次數。有時限的次數會讓圖示變成金色並帶一個小時鐘：';

  @override
  String get powerUpTimeLimited => '有時限';

  @override
  String get powerUpTimeLimitedDesc => '帶時鐘的金色圖示。來自套餐的每日簽到獎勵，當天結束時過期。';

  @override
  String get powerUpPermanent => '永久';

  @override
  String get powerUpPermanentDesc => '帶藍色徽章的普通圖示。里程碑和初始次數，永不過期。';

  @override
  String get powerUpSpendOrderTitle => '先用哪種次數？';

  @override
  String get powerUpSpendOrderHeading => '優先消耗有時限的次數';

  @override
  String get powerUpSpendOrderBody => '每日次數會在當天結束時過期，所以提示或魔法棒會先消耗你的每日次數，只有在每日次數用完後才會動用永久次數，不會浪費。';

  @override
  String get powerUpSpendDaily => '每日次數';

  @override
  String get powerUpSpendPermanent => '永久次數';

  @override
  String get premiumBenefitsFootnote => '每日次數不會累積到第二天。里程碑簽到獎勵屬於永久次數，照常累積。';
}

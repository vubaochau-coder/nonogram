// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Pixel Nonogram';

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
      '如果把两段已涂格连起来会得到比最大数字还长的色块，它们之间的格子一定为空。标上 X 把它们隔开。';

  @override
  String get nonogramGuideMethodDivisionTitle => '5. 分隔';

  @override
  String get nonogramGuideMethodDoublePositioningDesc =>
      '有时一个已涂格只可能属于其中一两个数字。逐一尝试每种可能：在所有可能中都为空的格子标上 X。';

  @override
  String get nonogramGuideMethodDoublePositioningTitle => '6. 双重定位';

  @override
  String get nonogramGuideMethodInaccessibilityDesc =>
      '任何色块都够不到的格子一定为空。把每个色块放在已涂格周围最远的位置试试，范围之外的格子都标 X。';

  @override
  String get nonogramGuideMethodInaccessibilityTitle => '3. 不可达';

  @override
  String get nonogramGuideMethodNotFitDesc =>
      'X 之间（或 X 与边缘之间）的空隙如果比任何可能放进去的数字都短，就放不下色块：把它标上 X。';

  @override
  String get nonogramGuideMethodNotFitTitle => '4. 放不下';

  @override
  String get nonogramGuideMethodSuperpositionMultiDesc =>
      '有多个数字时，把整组推到最左（色块之间留 1 个空格），再推到最右。同一个色块在两种位置都覆盖的格子一定要涂。速算法：把数字和间隔加起来，剩下的格数就是每个色块能移动的距离。';

  @override
  String get nonogramGuideMethodSuperpositionMultiTitle => '叠加法（多个数字）';

  @override
  String get nonogramGuideMethodSuperpositionSimpleDesc =>
      '如果一个数字超过该行长度的一半，它总有一部分会被涂上。想象把色块推到最左，再推到最右：两次都覆盖的格子一定要涂。例如：10 格中的 7 总会涂满中间 4 格。';

  @override
  String get nonogramGuideMethodSuperpositionSimpleTitle => '叠加法（单个数字）';

  @override
  String get nonogramGuideMethodWallPushingDesc =>
      '靠近边缘的已涂格会限制它所在色块的位置。色块不能超出边缘，只能往另一侧延伸。例如：5 且第 4 格已涂：即使推到最左，色块仍会覆盖第 5 格。';

  @override
  String get nonogramGuideMethodWallPushingTitle => '2. 从边缘推开';

  @override
  String get nonogramGuideRuleDesc =>
      '每个数字代表该行或该列中一段连续的已涂方格（色块）。如果有多个数字，它们代表不同的色块，且相邻色块之间至少要隔一个空格。例如 3 1 表示先是 3 个连续的涂色方格，然后至少 1 个空格，再是 1 个涂色方格。';

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
  String get nonogramTutorialWelcomeTitle => '欢迎来到 Pixel Nonogram！';

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
  String get nonogramGuideTutorialCardDesc => '边玩边学，一步步掌握规则、操作和主要解题技巧。';

  @override
  String get nonogramGuideRoutineTitle => '从哪里开始';

  @override
  String get nonogramGuideRoutineTip1 =>
      '从大数字开始。如果一个数字超过所在行列长度的一半，它的一部分已经可以确定（见下方技巧 1）。';

  @override
  String get nonogramGuideRoutineTip2 =>
      '先解简单的行：0 表示整行为空；如果数字之和加上每两个数字之间 1 个空格正好等于行长，就只有一种排法。';

  @override
  String get nonogramGuideRoutineTip3 => '确定为空的格子要标上 X。X 和涂色的格子一样有用。';

  @override
  String get nonogramGuideRoutineTip4 => '在行与列之间来回切换。每解出一格，都是与它交叉的那一行或列的新线索。';

  @override
  String get nonogramGuideRoutineTip5 => '不要猜。卡住时，找未知格最少的那一行或列，或使用提示。';

  @override
  String nonogramGuideExample(int number) {
    return '示例 $number';
  }

  @override
  String get nonogramGuideExampleSingle => '示例';

  @override
  String get nonogramGuideLegendTitle => '如何看图示';

  @override
  String get nonogramGuideLegendFilled => '已涂的格子';

  @override
  String get nonogramGuideLegendTrial => '试放色块的位置';

  @override
  String get nonogramGuideLegendCross => '空格（X）';

  @override
  String get nonogramGuideLegendResult => '可以推出的结果';

  @override
  String get nonogramGuideMethodLineDoneTitle => '已完成的行列';

  @override
  String get nonogramGuideMethodLineDoneDesc =>
      '当一行的所有色块都已就位，其余格子都是空的：把它们标上 X。数字为 0 的行一开始就是全空的。';

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
      '选择点按时的操作：给方格涂色，或标上 X 提醒自己这里是空格。点按按钮即可切换。';

  @override
  String get nonogramCoachDragTitle => '拖动一次涂多格';

  @override
  String get nonogramCoachDragBody =>
      '手指按住一格，滑过其他格子：经过的格子会一次全部涂色（X 模式下则标上 X）。从已涂的格子开始滑动，则会清除经过的格子。';

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
  String get nonogramTutorialToolsDoneTitle => '操作已掌握！';

  @override
  String get nonogramTutorialToolsDone =>
      '正式谜题更大，大多数行列无法一眼看出答案。接下来，在一个 8×8 谜题上学习解题技巧。';

  @override
  String get nonogramTutorialOverlapSingle =>
      '先找大数字。6 在这 8 格里有 3 种放法，会轮流闪烁。每种放法都亮起的格子一定要涂：涂上黄框里的 4 格。';

  @override
  String get nonogramTutorialOverlapMulti =>
      '多个数字也一样：3 3 至少需要 7 格（3 + 空格 + 3），所以只有 3 种放法。涂上 3 种放法都亮起的格子。';

  @override
  String get nonogramTutorialFullRow => '8 格里是 8：整行都要涂。滑动涂满整行。';

  @override
  String get nonogramTutorialZeroRow => '0 表示这一行没有任何要涂的格子。切换到 X 模式。';

  @override
  String get nonogramTutorialMarkZeroRow => '把最下面一整行都标上 X。X 很有用：它告诉各列哪里不可能有色块。';

  @override
  String get nonogramTutorialOutOfReach =>
      '现在看列。第 2 列是一个长度 3 的色块，必须盖住已涂的 2 格，所以只有 2 种放法。从不亮起的格子够不到：标上 X，第 7 列也一样。';

  @override
  String get nonogramTutorialBackToFill => '看第 3 列：它需要 7 格。切换回涂色模式。';

  @override
  String get nonogramTutorialExactSpace =>
      '底部的 X 让 7 正好剩下 7 格，所以全部涂上。第 6 列也一样。';

  @override
  String get nonogramTutorialFinishTechniques =>
      '这就是解题套路：先在行里解出能确定的格子，再看列，如此反复。自己完成这个蘑菇吧！';

  @override
  String get nonogramPlayHintNothingToFill => '所有该涂的方格都已经涂好了。检查一下是否有多涂的方格。';

  @override
  String get settingsSound => '音效';

  @override
  String get settingsLicenses => '许可';

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
  String licensesBy(String author) {
    return '作者：$author';
  }

  @override
  String licensesLevelCount(int count) {
    return '$count 个谜题';
  }

  @override
  String get adRewardNotReady => '广告还没准备好，请几分钟后再试。';

  @override
  String get settingsAdPrivacy => '广告隐私';

  @override
  String get ratingTitle => '喜欢 Pixel Nonogram 吗？';

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
  String get navHome => '首页';

  @override
  String get navMe => '我的';

  @override
  String get meHelp => '帮助';

  @override
  String get meMore => '更多';

  @override
  String get checkInTodayButton => '今日签到';

  @override
  String get checkInGiftToday => '今天有礼物！';

  @override
  String get checkInGiftCollect => '领取';

  @override
  String get checkInGiftDouble => '领取 x2';

  @override
  String checkInStreakTitle(int count) {
    return '连续 $count 天';
  }

  @override
  String checkInStreakDays(int count) {
    return '$count 天';
  }

  @override
  String checkInStreakMakeUp(int missed, String days) {
    return '补签 $missed 天，连续天数将达到 $days';
  }

  @override
  String get checkInStreakKeepGoing => '每天签到，保持连续';

  @override
  String get checkInStreakAllDone => '本月连续签到奖励已全部领取！';

  @override
  String checkInStreakDaysLeft(int count) {
    return '再签 $count 天得礼物';
  }

  @override
  String get checkInLegendChecked => '已签到';

  @override
  String get checkInLegendMissed => '漏签';

  @override
  String get checkInLegendFuture => '未到';

  @override
  String checkInGiftStreak(int count) {
    return '连续 $count 天礼物';
  }

  @override
  String checkInMakeUpTitle(String date) {
    return '补签 $date？';
  }

  @override
  String get checkInMakeUpBody => '观看一段短广告即可补签这一天，连续天数会重新接上。';

  @override
  String get checkInMakeUpWatch => '观看广告';

  @override
  String checkInMadeUp(String date) {
    return '已补签 $date';
  }

  @override
  String dashboardDailyReminder(String rewards, String time) {
    return '你还有$rewards将在$time后过期，立即使用以免浪费。';
  }

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
  String get powerUpWandDesc =>
      '点击魔法棒开启选择模式，再点击某一行或某一列的提示数字。应用会揭示该整行或整列，比单格提示更强。';

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
  String get powerUpSpendOrderBody =>
      '每日次数会在当天结束时过期，所以提示或魔法棒会先消耗你的每日次数，只有在每日次数用完后才会动用永久次数，不会浪费。';

  @override
  String get powerUpSpendDaily => '每日次数';

  @override
  String get powerUpSpendPermanent => '永久次数';

  @override
  String get premiumBenefitsFootnote => '每日次数不会累积到第二天。里程碑签到奖励属于永久次数，照常累积。';

  @override
  String dashboardDailyReminderBoth(String hints, String wands) {
    return '$hints和$wands';
  }
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get appTitle => 'Pixel Nonogram';

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
      '如果把兩段已塗格連起來會得到比最大數字還長的色塊，它們之間的格子一定為空。標上 X 把它們隔開。';

  @override
  String get nonogramGuideMethodDivisionTitle => '5. 分隔';

  @override
  String get nonogramGuideMethodDoublePositioningDesc =>
      '有時一個已塗格只可能屬於其中一兩個數字。逐一嘗試每種可能：在所有可能中都為空的格子標上 X。';

  @override
  String get nonogramGuideMethodDoublePositioningTitle => '6. 雙重定位';

  @override
  String get nonogramGuideMethodInaccessibilityDesc =>
      '任何色塊都搆不到的格子一定為空。把每個色塊放在已塗格周圍最遠的位置試試，範圍之外的格子都標 X。';

  @override
  String get nonogramGuideMethodInaccessibilityTitle => '3. 不可達';

  @override
  String get nonogramGuideMethodNotFitDesc =>
      'X 之間（或 X 與邊緣之間）的空隙如果比任何可能放進去的數字都短，就放不下色塊：把它標上 X。';

  @override
  String get nonogramGuideMethodNotFitTitle => '4. 放不下';

  @override
  String get nonogramGuideMethodSuperpositionMultiDesc =>
      '有多個數字時，把整組推到最左（色塊之間留 1 個空格），再推到最右。同一個色塊在兩種位置都覆蓋的格子一定要塗。速算法：把數字和間隔加起來，剩下的格數就是每個色塊能移動的距離。';

  @override
  String get nonogramGuideMethodSuperpositionMultiTitle => '疊加法（多個數字）';

  @override
  String get nonogramGuideMethodSuperpositionSimpleDesc =>
      '如果一個數字超過該行長度的一半，它總有一部分會被塗上。想像把色塊推到最左，再推到最右：兩次都覆蓋的格子一定要塗。例如：10 格中的 7 總會塗滿中間 4 格。';

  @override
  String get nonogramGuideMethodSuperpositionSimpleTitle => '疊加法（單個數字）';

  @override
  String get nonogramGuideMethodWallPushingDesc =>
      '靠近邊緣的已塗格會限制它所在色塊的位置。色塊不能超出邊緣，只能往另一側延伸。例如：5 且第 4 格已塗：即使推到最左，色塊仍會覆蓋第 5 格。';

  @override
  String get nonogramGuideMethodWallPushingTitle => '2. 從邊緣推開';

  @override
  String get nonogramGuideRuleDesc =>
      '每個數字代表該橫列或直行中一段連續的已塗方格（色塊）。如果有多個數字，它們代表不同的色塊，且相鄰色塊之間至少要隔一個空格。例如 3 1 表示先是 3 個連續的塗色方格，然後至少 1 個空格，再是 1 個塗色方格。';

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
  String get nonogramTutorialWelcomeTitle => '歡迎來到 Pixel Nonogram！';

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
  String get nonogramGuideTutorialCardDesc => '邊玩邊學，一步步掌握規則、操作和主要解題技巧。';

  @override
  String get nonogramGuideRoutineTitle => '從哪裡開始';

  @override
  String get nonogramGuideRoutineTip1 =>
      '從大數字開始。如果一個數字超過所在行列長度的一半，它的一部分已經可以確定（見下方技巧 1）。';

  @override
  String get nonogramGuideRoutineTip2 =>
      '先解簡單的行列：0 表示整行為空；如果數字之和加上每兩個數字之間 1 個空格正好等於長度，就只有一種排法。';

  @override
  String get nonogramGuideRoutineTip3 => '確定為空的格子要標上 X。X 和塗色的格子一樣有用。';

  @override
  String get nonogramGuideRoutineTip4 => '在橫列與直行之間來回切換。每解出一格，都是與它交叉的那一行或列的新線索。';

  @override
  String get nonogramGuideRoutineTip5 => '不要猜。卡住時，找未知格最少的那一行或列，或使用提示。';

  @override
  String nonogramGuideExample(int number) {
    return '範例 $number';
  }

  @override
  String get nonogramGuideExampleSingle => '範例';

  @override
  String get nonogramGuideLegendTitle => '如何看圖示';

  @override
  String get nonogramGuideLegendFilled => '已塗的格子';

  @override
  String get nonogramGuideLegendTrial => '試放色塊的位置';

  @override
  String get nonogramGuideLegendCross => '空格（X）';

  @override
  String get nonogramGuideLegendResult => '可以推出的結果';

  @override
  String get nonogramGuideMethodLineDoneTitle => '已完成的行列';

  @override
  String get nonogramGuideMethodLineDoneDesc =>
      '當一行的所有色塊都已就位，其餘格子都是空的：把它們標上 X。數字為 0 的行一開始就是全空的。';

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
      '選擇點按時的操作：為方格塗色，或標上 X 提醒自己這裡是空格。點按按鈕即可切換。';

  @override
  String get nonogramCoachDragTitle => '拖曳一次塗多格';

  @override
  String get nonogramCoachDragBody =>
      '手指按住一格，滑過其他格子：經過的格子會一次全部塗色（X 模式下則標上 X）。從已塗的格子開始滑動，則會清除經過的格子。';

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
  String get nonogramTutorialToolsDoneTitle => '操作已掌握！';

  @override
  String get nonogramTutorialToolsDone =>
      '正式謎題更大，大多數橫列和直行無法一眼看出答案。接下來，在一個 8×8 謎題上學習解題技巧。';

  @override
  String get nonogramTutorialOverlapSingle =>
      '先找大數字。6 在這 8 格裡有 3 種放法，會輪流閃爍。每種放法都亮起的格子一定要塗：塗上黃框裡的 4 格。';

  @override
  String get nonogramTutorialOverlapMulti =>
      '多個數字也一樣：3 3 至少需要 7 格（3 + 空格 + 3），所以只有 3 種放法。塗上 3 種放法都亮起的格子。';

  @override
  String get nonogramTutorialFullRow => '8 格裡是 8：整列都要塗。滑動塗滿整列。';

  @override
  String get nonogramTutorialZeroRow => '0 表示這一橫列沒有任何要塗的格子。切換到 X 模式。';

  @override
  String get nonogramTutorialMarkZeroRow =>
      '把最下面一整列都標上 X。X 很有用：它告訴各直行哪裡不可能有色塊。';

  @override
  String get nonogramTutorialOutOfReach =>
      '現在看直行。第 2 行是一個長度 3 的色塊，必須蓋住已塗的 2 格，所以只有 2 種放法。從不亮起的格子搆不到：標上 X，第 7 行也一樣。';

  @override
  String get nonogramTutorialBackToFill => '看第 3 行：它需要 7 格。切換回塗色模式。';

  @override
  String get nonogramTutorialExactSpace =>
      '底部的 X 讓 7 正好剩下 7 格，所以全部塗上。第 6 行也一樣。';

  @override
  String get nonogramTutorialFinishTechniques =>
      '這就是解題套路：先在橫列裡解出能確定的格子，再看直行，如此反覆。自己完成這個蘑菇吧！';

  @override
  String get nonogramPlayHintNothingToFill => '所有該塗的方格都已經塗好了。檢查一下是否有多塗的方格。';

  @override
  String get settingsSound => '音效';

  @override
  String get settingsLicenses => '授權';

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
  String licensesBy(String author) {
    return '作者：$author';
  }

  @override
  String licensesLevelCount(int count) {
    return '$count 個謎題';
  }

  @override
  String get adRewardNotReady => '廣告還沒準備好，請幾分鐘後再試。';

  @override
  String get settingsAdPrivacy => '廣告隱私';

  @override
  String get ratingTitle => '喜歡 Pixel Nonogram 嗎？';

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
  String get navHome => '首頁';

  @override
  String get navMe => '我的';

  @override
  String get meHelp => '說明';

  @override
  String get meMore => '更多';

  @override
  String get checkInTodayButton => '今日簽到';

  @override
  String get checkInGiftToday => '今天有禮物！';

  @override
  String get checkInGiftCollect => '領取';

  @override
  String get checkInGiftDouble => '領取 x2';

  @override
  String checkInStreakTitle(int count) {
    return '連續 $count 天';
  }

  @override
  String checkInStreakDays(int count) {
    return '$count 天';
  }

  @override
  String checkInStreakMakeUp(int missed, String days) {
    return '補簽 $missed 天，連續天數將達到 $days';
  }

  @override
  String get checkInStreakKeepGoing => '每天簽到，保持連續';

  @override
  String get checkInStreakAllDone => '本月連續簽到獎勵已全部領取！';

  @override
  String checkInStreakDaysLeft(int count) {
    return '再簽 $count 天得禮物';
  }

  @override
  String get checkInLegendChecked => '已簽到';

  @override
  String get checkInLegendMissed => '漏簽';

  @override
  String get checkInLegendFuture => '未到';

  @override
  String checkInGiftStreak(int count) {
    return '連續 $count 天禮物';
  }

  @override
  String checkInMakeUpTitle(String date) {
    return '補簽 $date？';
  }

  @override
  String get checkInMakeUpBody => '觀看一段短廣告即可補簽這一天，連續天數會重新接上。';

  @override
  String get checkInMakeUpWatch => '觀看廣告';

  @override
  String checkInMadeUp(String date) {
    return '已補簽 $date';
  }

  @override
  String dashboardDailyReminder(String rewards, String time) {
    return '你還有$rewards將在$time後過期，立即使用以免浪費。';
  }

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
  String get powerUpWandDesc =>
      '點擊魔法棒開啟選擇模式，再點擊某一行或某一列的提示數字。應用會揭示該整行或整列，比單格提示更強。';

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
  String get powerUpSpendOrderBody =>
      '每日次數會在當天結束時過期，所以提示或魔法棒會先消耗你的每日次數，只有在每日次數用完後才會動用永久次數，不會浪費。';

  @override
  String get powerUpSpendDaily => '每日次數';

  @override
  String get powerUpSpendPermanent => '永久次數';

  @override
  String get premiumBenefitsFootnote => '每日次數不會累積到第二天。里程碑簽到獎勵屬於永久次數，照常累積。';

  @override
  String dashboardDailyReminderBoth(String hints, String wands) {
    return '$hints和$wands';
  }
}

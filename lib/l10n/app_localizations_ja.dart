// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Nonopix';

  @override
  String get commonCancel => 'キャンセル';

  @override
  String get commonRetry => '再試行';

  @override
  String get commonSave => '保存';

  @override
  String nonogramDashboardContinueLevel(int level) {
    return 'レベル $level';
  }

  @override
  String get nonogramDashboardProgressSectionTitle => '進捗';

  @override
  String get nonogramDashboardStatCompleted => 'クリア';

  @override
  String get nonogramGuideIntro =>
      'ノノグラム（お絵かきロジック）は、ルールはシンプルでも解きごたえのあるロジックパズルです。盤面の横と上にある数字をもとにマスを塗り、隠れた絵を浮かび上がらせましょう。';

  @override
  String get nonogramGuideMethodDivisionDesc =>
      '既にある2つのブロックをつなぐと、どのヒント数字よりも長くなってしまう場合、その間のマスは×になります。';

  @override
  String get nonogramGuideMethodDivisionTitle => '5. 分断';

  @override
  String get nonogramGuideMethodDoublePositioningDesc =>
      '塗られたマスが属するブロックの置き方が数通りに限られる場合、そのどの置き方でも塗られないマスには×を付けます。';

  @override
  String get nonogramGuideMethodDoublePositioningTitle => '6. 二重配置';

  @override
  String get nonogramGuideMethodInaccessibilityDesc =>
      '残りのどのブロックにも属することができないマスに×を付けます。';

  @override
  String get nonogramGuideMethodInaccessibilityTitle => '3. 届かないマス';

  @override
  String get nonogramGuideMethodNotFitDesc =>
      '×で挟まれた空きマスの長さが、その列のどのヒント数字よりも短い場合、そこには×を付けます。';

  @override
  String get nonogramGuideMethodNotFitTitle => '4. 入りきらない';

  @override
  String get nonogramGuideMethodSuperpositionMultiDesc =>
      '数字が複数あるときは、同じ色のブロック同士の間に最低1マスの空きが必要なことを考慮して、グループ全体を左端に寄せた配置と右端に寄せた配置を重ねます。両方の配置で同じブロックが重なるマスは塗られます。';

  @override
  String get nonogramGuideMethodSuperpositionMultiTitle => '重ね合わせ（ヒントが複数）';

  @override
  String get nonogramGuideMethodSuperpositionSimpleDesc =>
      '数字が列の長さの半分を超えるなら、中央のいくつかのマスは必ず塗られます。左端に寄せた配置と右端に寄せた配置を重ね、重なったマスを塗ります。';

  @override
  String get nonogramGuideMethodSuperpositionSimpleTitle => '重ね合わせ（ヒントが1つ）';

  @override
  String get nonogramGuideMethodWallPushingDesc =>
      '塗られていると分かっているマスが、最初のヒント数字の長さよりも端に近い場合、そのブロックは端から離れる方向へ伸びているはずです。';

  @override
  String get nonogramGuideMethodWallPushingTitle => '2. 壁から押し出す';

  @override
  String get nonogramGuideRuleDesc =>
      'それぞれの数字は、その行または列で連続して塗られるマスのかたまり（ブロック）を表します。数字が複数ある場合はそれぞれ別のブロックで、ブロックとブロックの間には少なくとも1マスの空きが必要です。たとえば `3 1` は、3マス塗ったブロック、少なくとも1マスの空き、1マス塗ったブロックの順に並ぶことを意味します。';

  @override
  String get nonogramGuideRuleTitle => '基本ルール：数字の意味';

  @override
  String get nonogramGuideTitle => '解き方';

  @override
  String nonogramHistoryCompletedOn(String date) {
    return '$dateにクリア';
  }

  @override
  String get nonogramHistoryDetailNotFound => 'レベルの詳細が見つかりません。';

  @override
  String get nonogramHistoryEmpty => 'クリアしたレベルはまだありません。';

  @override
  String nonogramHistoryLevel(int n) {
    return 'レベル $n';
  }

  @override
  String get nonogramHistoryTitle => '記録';

  @override
  String get nonogramPlayActionNextLevelFixed => '次のレベル';

  @override
  String get nonogramPlayActionShowClues => 'ヒント数字を表示';

  @override
  String nonogramPlayCompletionMessage(int level) {
    return 'おめでとうございます！レベル $level をクリアしました。';
  }

  @override
  String get nonogramPlayCompletionTitle => 'パズルクリア！';

  @override
  String nonogramPlayDurationFormat(int minutes, int seconds) {
    return '$minutes分$seconds秒';
  }

  @override
  String nonogramPlayHintLabel(int count) {
    return 'ヒント（$count）';
  }

  @override
  String get nonogramPlayNoNextLevelToast => '次のレベルはまだありません。';

  @override
  String get nonogramPlayPageTitle => 'ノノグラム';

  @override
  String get nonogramSettingsTitle => '設定';

  @override
  String get nonogramDashboardContinueNext => '次のチャレンジ';

  @override
  String get nonogramDashboardPlay => 'プレイ';

  @override
  String get nonogramDashboardResumeAction => '続ける';

  @override
  String get nonogramDashboardInProgressBadge => 'プレイ中';

  @override
  String nonogramDashboardDifficulty(String value) {
    return '難易度 $value';
  }

  @override
  String nonogramDashboardSolvedOfTotal(int completed, int total) {
    return '$total問中$completed問クリア';
  }

  @override
  String get nonogramDashboardStatFastest => '最速';

  @override
  String get nonogramDashboardStatTotalTime => '合計時間';

  @override
  String get nonogramDashboardRecentTitle => '最近クリアしたパズル';

  @override
  String get nonogramDashboardSeeAll => 'すべて見る';

  @override
  String get nonogramDashboardRecentEmpty => '最初のパズルを解いて、絵のコレクションを始めましょう。';

  @override
  String get nonogramDashboardAllDoneTitle => '全パズルクリア！';

  @override
  String nonogramDashboardAllDoneDesc(int total) {
    return '全$total問をクリアしました。コレクションはいつでも見返せます。';
  }

  @override
  String nonogramDurationHoursMinutes(int hours, int minutes) {
    return '$hours時間$minutes分';
  }

  @override
  String nonogramHistoryBestTime(String time) {
    return 'ベスト $time';
  }

  @override
  String get nonogramPlayActionDashboard => 'ホーム';

  @override
  String get appThemeTitle => '外観';

  @override
  String get appThemeLight => 'ライト';

  @override
  String get appThemeDark => 'ダーク';

  @override
  String get nonogramPlayModeFill => '塗りモード';

  @override
  String get nonogramPlayModeMark => '×モード';

  @override
  String get nonogramSettingsRestart => 'このレベルを最初から';

  @override
  String get nonogramSettingsRestartConfirmTitle => 'このレベルを最初からやり直しますか？';

  @override
  String get nonogramSettingsRestartConfirmMessage =>
      '塗ったマスや×を付けたマスはすべて消えます。星の付いたマス（ヒントや魔法の杖で開いたマス）は残ります。';

  @override
  String get commonClose => '閉じる';

  @override
  String get nonogramSettingsRestartConfirm => 'やり直す';

  @override
  String get nonogramTutorialTitle => '遊び方';

  @override
  String get nonogramTutorialSkip => 'スキップ';

  @override
  String get nonogramTutorialWelcomeTitle => 'Nonopixへようこそ！';

  @override
  String get nonogramTutorialWelcome => '小さな5×5のパズルで基本ルールを覚えましょう。';

  @override
  String get nonogramTutorialStart => 'はじめる';

  @override
  String get nonogramTutorialSwitchToFill =>
      'パズルはマスを塗って解きます。下のボタンをタップして塗りモードに切り替えましょう。';

  @override
  String get nonogramTutorialClueIsCount =>
      '数字はその行で塗るマスの数を表します。この行は5なので、全部塗りましょう！';

  @override
  String get nonogramTutorialEdgeCell =>
      '最後のマスはもう塗られています。4のブロックはこのマスを含むので、置き方は1通りだけ。左側の3マスを塗りましょう。';

  @override
  String get nonogramTutorialMultipleClues =>
      '数字が複数あるとブロックも複数あり、間には少なくとも1マスの空きがあります。2 2 がこの5マスに入る置き方は1通りだけです。';

  @override
  String get nonogramTutorialClueOrder =>
      '順番も大切です。3 1 は、3のブロックが先、1のブロックが後という意味です。';

  @override
  String get nonogramTutorialColumns =>
      '列にも数字があり、上から下へ読みます。×モードに切り替えて、空いたままになるマスに印を付けましょう。';

  @override
  String get nonogramTutorialMarkEmpty =>
      '✓の付いた列は必要なマスがすべて塗られています。残りの空きマスに×を付けましょう。';

  @override
  String get nonogramTutorialOneCellLeft =>
      '最後の行の1は、もう置ける場所が1つしかありません。塗りモードに戻しましょう。';

  @override
  String get nonogramTutorialFinish => '最後のマスを塗ってパズルを完成させましょう！';

  @override
  String get nonogramTutorialDoneTitle => 'よくできました！';

  @override
  String get nonogramTutorialDone =>
      '準備完了です！大きなパズルでは、2本指で（または盤面の外の空いた場所から）ドラッグして盤面を動かせます。最初の大きなパズルでもう一度お知らせします。';

  @override
  String get nonogramTutorialShowTechniques => '解き方のテクニックを見る';

  @override
  String get nonogramTutorialPlay => 'プレイを始める';

  @override
  String get nonogramGuideTutorialCardTitle => '遊びながら覚える';

  @override
  String get nonogramGuideTutorialCardDesc => '小さな5×5のパズルで、ルールと操作を一歩ずつ覚えましょう。';

  @override
  String get nonogramPlayInfoHide => 'レベル情報を隠す';

  @override
  String get nonogramPlayWandLabel => '魔法の杖';

  @override
  String get nonogramPlayWandSelectPrompt => '答えを見たい行または列のヒント数字をタップ';

  @override
  String get nonogramPlayWandRowSolved => 'この行はもう正解です。別の行か列を選んでください。';

  @override
  String get nonogramPlayWandColSolved => 'この列はもう正解です。別の行か列を選んでください。';

  @override
  String get nonogramSettingsControlsGuide => '操作ガイド';

  @override
  String get nonogramCoachSkip => 'スキップ';

  @override
  String get nonogramCoachNext => '次へ';

  @override
  String get nonogramCoachDone => 'わかった';

  @override
  String nonogramCoachStep(int current, int total) {
    return '$current/$total';
  }

  @override
  String get nonogramCoachHintTitle => 'ヒント';

  @override
  String get nonogramCoachHintBody =>
      '正しいマスを5つ（塗るべきなのにまだ塗っていないマス）、盤面全体からランダムに選んで塗ります。これらのマスには星が付き、変更できず、やり直しても残ります。1問につき3回使えます。';

  @override
  String get nonogramCoachWandTitle => '魔法の杖';

  @override
  String get nonogramCoachWandBody =>
      '杖をタップしてから、好きな行または列のヒント数字をタップすると、その列全体の答えが星付きで表示され、やり直しても残ります。1問につき1回使えます。';

  @override
  String get nonogramCoachModeTitle => '塗る？×？';

  @override
  String get nonogramCoachModeBody =>
      'タップしたときの動作を選びます。マスを塗るか、空きマスだと覚えておくために×を付けるかです。ボタンをタップで切り替え。盤面をドラッグすると、まとめて塗ったり×を付けたりできます。';

  @override
  String get nonogramCoachLongPressTitle => '長押しで逆の操作';

  @override
  String get nonogramCoachLongPressBody =>
      'マスを長押しすると、今のモードと逆の操作になります。塗りモードなら×、×モードなら塗り。短く振動したら完了なので指を離してください。';

  @override
  String get nonogramCoachScrollTitle => '大きなパズルの移動';

  @override
  String get nonogramCoachScrollBody =>
      '大きなパズルは画面に収まりません。2本指でドラッグするか、盤面の外の空いた場所からドラッグして盤面を動かしましょう。ヒント数字の上をドラッグすると隠れた数字が見えます（角の「+N」は隠れている数です）。';

  @override
  String get nonogramTutorialRulesDoneTitle => 'ルールはばっちり！';

  @override
  String get nonogramTutorialRulesDone =>
      '次は別のパズルで操作と便利機能を練習しましょう。ドラッグでまとめて塗る、長押しで×を付ける、ヒント、そして魔法の杖です。';

  @override
  String get nonogramTutorialContinue => '続ける';

  @override
  String get nonogramTutorialLater => 'あとで、すぐ遊ぶ';

  @override
  String get nonogramTutorialDragRow =>
      'コツ：指でマスをなぞると一気に塗れます。一番上の行は5なので、行全体をなぞりましょう！';

  @override
  String get nonogramTutorialLongPressMark =>
      '1 1 1 はこの5マスにぴったり収まるので、2番目と4番目のマスは空きです。モードを切り替えなくても大丈夫。それぞれ長押しすると×が付きます。短く振動したら完了です。';

  @override
  String get nonogramTutorialUseHint =>
      '行き詰まったら？ヒントボタンをタップすると、正しいマスを5つランダムに塗ります。1問につき3回使えます。';

  @override
  String get nonogramTutorialActivateWand =>
      'ヒントで星付きのマスが5つ塗られました。これらは固定され、やり直しても残ります。好きな行や列を丸ごと開きたいときは魔法の杖を使いましょう。杖のボタンをタップしてください。';

  @override
  String get nonogramTutorialPickWandLine =>
      '一番下の行のヒント数字をタップして、その行を開きましょう。杖は1問につき1回使えます。';

  @override
  String get nonogramTutorialFinishTools =>
      '残りのマスを塗って完成させましょう。列に沿って下へドラッグすると速く塗れます。';

  @override
  String get nonogramPlayHintNothingToFill =>
      '塗るべきマスはすべて塗られています。余分に塗ったマスがないか確認してください。';

  @override
  String get settingsSound => 'サウンド';

  @override
  String get settingsLicenses => 'ライセンス';

  @override
  String get settingsSwitchPlayMode => 'プレイモードを切り替え';

  @override
  String get licensesTitle => 'ライセンス';

  @override
  String get licensesLevelArtHeading => 'パズル';

  @override
  String get licensesLevelArtIntro =>
      'パズルは以下の素材をもとにしています。アイコンセットは縮小して白黒に変換し、すべてのパズルが解けるように編集しました。ノノグラム集はそのまま使用しています。';

  @override
  String get licensesFontHeading => 'フォント';

  @override
  String get licensesSoftwareButton => 'オープンソースソフトウェアのライセンス';

  @override
  String get licensesDeveloperLevelsNote =>
      '開発者モードのパズルは nonogram.org のもので、社内テスト専用です。ストア版には含まれません。';

  @override
  String get playModeTitle => 'プレイモードを選択';

  @override
  String get playModeSubtitle => '進捗はモードごとに別々に保存されます。';

  @override
  String get playModeUserTitle => 'プレイヤーモード';

  @override
  String get playModeUserBody => 'ストア版に収録されているライセンス済みのパズル。';

  @override
  String get playModeDeveloperTitle => '開発者モード';

  @override
  String get playModeDeveloperBody =>
      '社内テスト用の nonogram.org のオリジナルパズル。これまでの進捗を引き継ぎます。';

  @override
  String get playModeLastUsed => '前回使用';

  @override
  String licensesBy(String author) {
    return '作者：$author';
  }

  @override
  String licensesLevelCount(int count) {
    return '$count問';
  }

  @override
  String playModeProgress(int solved, int total) {
    return '$solved/$total問クリア';
  }

  @override
  String get adRewardNotReady => '広告の準備ができていません。インターネット接続を確認して、もう一度お試しください。';

  @override
  String get settingsAdPrivacy => '広告のプライバシー';

  @override
  String get ratingTitle => 'Nonopixを楽しんでいますか？';

  @override
  String get ratingMessage => '星をタップしてゲームを評価してください。';

  @override
  String get ratingLater => 'あとで';

  @override
  String get ratingSubmit => '送信';

  @override
  String get ratingThanks => 'ご意見ありがとうございます！これからもゲームを改善していきます。';

  @override
  String ratingStarLabel(int count) {
    return '星$countつ';
  }

  @override
  String get settingsLanguage => '言語';

  @override
  String get settingsLanguageSystem => '端末の言語';

  @override
  String get premiumTitle => '広告なしでプレイ';

  @override
  String get premiumBenefitNoAds => 'レベル間の広告がなくなります';

  @override
  String get premiumBenefitDaily => 'チェックインした日はヒント2回と魔法の杖1回';

  @override
  String premiumBuy(String price) {
    return '購入 · $price';
  }

  @override
  String get premiumOneTime => 'Google Play での1回払い';

  @override
  String get premiumActiveTitle => '広告なしパック有効';

  @override
  String get premiumActiveDaily => '毎日チェックインすると、その日使えるヒント2回と魔法の杖1回がもらえます。';

  @override
  String get premiumPurchased => 'ありがとうございます！レベル間の広告がオフになりました。';

  @override
  String get premiumPending => '支払いが保留中です。完了するとパックが有効になります。';

  @override
  String get premiumFailed => '購入できませんでした。もう一度お試しください。';

  @override
  String get checkInTitle => '毎日チェックイン';

  @override
  String get checkInAction => 'チェックイン';

  @override
  String get checkInDoneToday => '今日はチェックイン済み';

  @override
  String checkInNextGift(int count) {
    return 'あと$count回のチェックインで次のプレゼント';
  }

  @override
  String get checkInCheckedIn => 'チェックインしました！';

  @override
  String checkInReceived(String rewards) {
    return '$rewardsを受け取りました。';
  }

  @override
  String rewardHints(int count) {
    return 'ヒント$count回';
  }

  @override
  String rewardWands(int count) {
    return '魔法の杖$count回';
  }

  @override
  String rewardTodayOnly(String reward) {
    return '$reward（今日のみ）';
  }

  @override
  String get checkInMonthGifts => '今月のプレゼント';

  @override
  String get navHome => 'ホーム';

  @override
  String get navMe => 'マイページ';

  @override
  String get meHelp => 'ヘルプ';

  @override
  String get meMore => 'その他';

  @override
  String get checkInNotYetToday => '今日はまだチェックインしていません';

  @override
  String get checkInTodayButton => '今日のチェックイン';

  @override
  String checkInGiftsLeftShort(int count) {
    return 'あと$count回でプレゼント';
  }

  @override
  String get checkInGiftToday => '今日はプレゼントあり！';

  @override
  String checkInGiftMilestone(int count) {
    return 'チェックイン$count回達成のプレゼント';
  }

  @override
  String get checkInGiftCollect => '受け取る';

  @override
  String get checkInTotalHints => 'ヒント';

  @override
  String get checkInTotalWands => '魔法の杖';

  @override
  String get checkInTotalDailyHints => 'ヒント（今日のみ）';

  @override
  String get checkInTotalDailyWands => '魔法の杖（今日のみ）';

  @override
  String get checkInPremiumToday => '広告なしパックの今日の分';

  @override
  String get checkInPremiumNotYet => 'チェックインすると今日使えるヒント2回と魔法の杖1回がもらえます。';

  @override
  String get checkInPremiumUsedUp => '今日の分は使い切りました。また明日！';

  @override
  String checkInExpiresIn(String time) {
    return 'あと$timeで期限切れ';
  }

  @override
  String dashboardDailyReminder(String rewards, String time) {
    return '今日はまだ$rewards残っています。あと$timeで期限切れになるので、今すぐプレイして無駄にしないで！';
  }

  @override
  String get dashboardDailyReminderTitle => '今日の分が待っています';

  @override
  String get dashboardDailyReminderPlay => '今すぐプレイ';
}

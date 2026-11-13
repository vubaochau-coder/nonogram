// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Nonopix';

  @override
  String get commonCancel => '취소';

  @override
  String get commonRetry => '다시 시도';

  @override
  String get commonSave => '저장';

  @override
  String nonogramDashboardContinueLevel(int level) {
    return '레벨 $level';
  }

  @override
  String get nonogramDashboardProgressSectionTitle => '나의 진행 상황';

  @override
  String get nonogramDashboardStatCompleted => '완료';

  @override
  String get nonogramGuideIntro =>
      '노노그램은 규칙은 간단하지만 풀이는 도전적인 논리 퍼즐입니다. 격자 옆의 숫자를 보고 칸을 칠해 숨겨진 그림을 찾아내는 것이 목표입니다.';

  @override
  String get nonogramGuideMethodDivisionDesc =>
      '이미 있는 두 블록을 이으면 남은 어떤 숫자보다도 긴 모양이 된다면, 그 사이 칸은 X여야 합니다.';

  @override
  String get nonogramGuideMethodDivisionTitle => '5. 나누기';

  @override
  String get nonogramGuideMethodDoublePositioningDesc =>
      '칠해진 칸이 블록의 몇 가지 배치에만 속할 수 있다면, 그 배치 중 어디에서도 칠해지지 않는 칸은 모두 X로 표시해야 합니다.';

  @override
  String get nonogramGuideMethodDoublePositioningTitle => '6. 이중 배치';

  @override
  String get nonogramGuideMethodInaccessibilityDesc =>
      '남은 어떤 블록에도 속할 수 없는 칸은 X로 표시하세요.';

  @override
  String get nonogramGuideMethodInaccessibilityTitle => '3. 닿을 수 없는 칸';

  @override
  String get nonogramGuideMethodNotFitDesc =>
      'X 사이의 빈 공간이 그 줄의 어떤 숫자보다도 짧다면, 그 공간은 X로 표시해야 합니다.';

  @override
  String get nonogramGuideMethodNotFitTitle => '4. 들어가지 않음';

  @override
  String get nonogramGuideMethodSuperpositionMultiDesc =>
      '숫자가 여러 개일 때는, 같은 색 블록 사이에 반드시 한 칸 이상 비어야 한다는 점을 고려해 전체 묶음을 가장 왼쪽과 가장 오른쪽으로 붙인 두 배치를 겹쳐 보세요. 같은 블록이 두 배치 모두에서 겹치는 칸은 칠합니다.';

  @override
  String get nonogramGuideMethodSuperpositionMultiTitle => '겹치기 (숫자 여러 개)';

  @override
  String get nonogramGuideMethodSuperpositionSimpleDesc =>
      '숫자가 줄 길이의 절반보다 크면 가운데 몇 칸은 반드시 칠해집니다. 가장 왼쪽과 가장 오른쪽으로 붙인 배치를 겹쳐 보고, 겹치는 칸을 칠하세요.';

  @override
  String get nonogramGuideMethodSuperpositionSimpleTitle => '겹치기 (숫자 하나)';

  @override
  String get nonogramGuideMethodWallPushingDesc =>
      '칠해진 것이 확실한 칸이 첫 번째 숫자의 길이보다 벽에 더 가깝다면, 그 칸이 속한 블록은 벽에서 멀어지는 방향으로 이어져야 합니다.';

  @override
  String get nonogramGuideMethodWallPushingTitle => '2. 벽에서 밀어내기';

  @override
  String get nonogramGuideRuleDesc =>
      '각 숫자는 그 행이나 열에서 연속으로 칠해진 칸 묶음(블록) 하나를 나타냅니다. 숫자가 여러 개라면 각각 별개의 블록이며, 블록 사이에는 최소 한 칸의 빈칸이 있어야 합니다. 예를 들어 `3 1`은 3칸짜리 블록, 최소 1칸의 빈칸, 1칸짜리 블록이 차례로 온다는 뜻입니다.';

  @override
  String get nonogramGuideRuleTitle => '기본 규칙: 숫자의 의미';

  @override
  String get nonogramGuideTitle => '푸는 방법';

  @override
  String nonogramHistoryCompletedOn(String date) {
    return '$date 완료';
  }

  @override
  String get nonogramHistoryDetailNotFound => '레벨 정보를 찾을 수 없습니다.';

  @override
  String get nonogramHistoryEmpty => '아직 완료한 레벨이 없습니다.';

  @override
  String nonogramHistoryLevel(int n) {
    return '레벨 $n';
  }

  @override
  String get nonogramHistoryTitle => '기록';

  @override
  String get nonogramPlayActionNextLevelFixed => '다음 레벨';

  @override
  String get nonogramPlayActionShowClues => '숫자 보기';

  @override
  String nonogramPlayCompletionMessage(int level) {
    return '축하합니다! 레벨 $level을(를) 완료했습니다.';
  }

  @override
  String get nonogramPlayCompletionTitle => '퍼즐 완성!';

  @override
  String nonogramPlayDurationFormat(int minutes, int seconds) {
    return '$minutes분 $seconds초';
  }

  @override
  String nonogramPlayHintLabel(int count) {
    return '힌트 ($count)';
  }

  @override
  String get nonogramPlayNoNextLevelToast => '아직 다음 레벨이 없습니다.';

  @override
  String get nonogramPlayPageTitle => '노노그램';

  @override
  String get nonogramSettingsTitle => '설정';

  @override
  String get nonogramDashboardContinueNext => '다음 도전';

  @override
  String get nonogramDashboardPlay => '플레이';

  @override
  String get nonogramDashboardResumeAction => '계속하기';

  @override
  String get nonogramDashboardInProgressBadge => '진행 중';

  @override
  String nonogramDashboardDifficulty(String value) {
    return '난이도 $value';
  }

  @override
  String nonogramDashboardSolvedOfTotal(int completed, int total) {
    return '퍼즐 $total개 중 $completed개 완료';
  }

  @override
  String get nonogramDashboardStatFastest => '최단 기록';

  @override
  String get nonogramDashboardStatTotalTime => '총 플레이 시간';

  @override
  String get nonogramDashboardRecentTitle => '최근 완료';

  @override
  String get nonogramDashboardSeeAll => '모두 보기';

  @override
  String get nonogramDashboardRecentEmpty => '첫 퍼즐을 풀고 그림 컬렉션을 시작해 보세요.';

  @override
  String get nonogramDashboardAllDoneTitle => '모든 퍼즐 완료!';

  @override
  String nonogramDashboardAllDoneDesc(int total) {
    return '퍼즐 $total개를 모두 완료했습니다. 언제든 컬렉션을 다시 둘러보세요.';
  }

  @override
  String nonogramDurationHoursMinutes(int hours, int minutes) {
    return '$hours시간 $minutes분';
  }

  @override
  String nonogramHistoryBestTime(String time) {
    return '최고 $time';
  }

  @override
  String get nonogramPlayActionDashboard => '홈';

  @override
  String get appThemeTitle => '화면 테마';

  @override
  String get appThemeLight => '라이트';

  @override
  String get appThemeDark => '다크';

  @override
  String get nonogramPlayModeFill => '칠하기 모드';

  @override
  String get nonogramPlayModeMark => 'X 표시 모드';

  @override
  String get nonogramSettingsRestart => '이 레벨 처음부터 다시';

  @override
  String get nonogramSettingsRestartConfirmTitle => '이 레벨을 처음부터 다시 할까요?';

  @override
  String get nonogramSettingsRestartConfirmMessage =>
      '칠하거나 표시한 칸이 모두 지워집니다. 별이 있는 칸(힌트나 마법 지팡이로 연 칸)은 그대로 남습니다.';

  @override
  String get commonClose => '닫기';

  @override
  String get nonogramSettingsRestartConfirm => '다시 시작';

  @override
  String get nonogramTutorialTitle => '게임 방법';

  @override
  String get nonogramTutorialSkip => '건너뛰기';

  @override
  String get nonogramTutorialWelcomeTitle => 'Nonopix에 오신 것을 환영합니다!';

  @override
  String get nonogramTutorialWelcome => '작은 5×5 퍼즐로 기본 규칙을 배워 봅시다.';

  @override
  String get nonogramTutorialStart => '시작';

  @override
  String get nonogramTutorialSwitchToFill =>
      '퍼즐은 칸을 칠해서 풉니다. 아래 버튼을 눌러 칠하기 모드로 바꾸세요.';

  @override
  String get nonogramTutorialClueIsCount =>
      '숫자는 그 행에서 칠할 칸의 수를 알려 줍니다. 이 행은 5이니 모두 칠하세요!';

  @override
  String get nonogramTutorialEdgeCell =>
      '마지막 칸은 이미 칠해져 있습니다. 4칸 블록은 이 칸을 포함해야 하므로 놓을 수 있는 방법은 하나뿐입니다. 왼쪽의 3칸을 칠하세요.';

  @override
  String get nonogramTutorialMultipleClues =>
      '숫자가 여러 개면 블록도 여러 개이고, 블록 사이에는 최소 한 칸의 빈칸이 있습니다. 2 2가 이 5칸에 들어가는 방법은 하나뿐입니다.';

  @override
  String get nonogramTutorialClueOrder =>
      '순서도 중요합니다. 3 1은 3칸 블록이 먼저, 1칸 블록이 나중이라는 뜻입니다.';

  @override
  String get nonogramTutorialColumns =>
      '열에도 숫자가 있으며 위에서 아래로 읽습니다. X 모드로 바꿔 비워 둬야 할 칸을 표시하세요.';

  @override
  String get nonogramTutorialMarkEmpty =>
      '✓가 있는 열은 칠할 칸을 모두 칠했습니다. 남은 빈칸에 X를 표시하세요.';

  @override
  String get nonogramTutorialOneCellLeft =>
      '마지막 행의 1이 들어갈 자리는 이제 한 곳뿐입니다. 칠하기 모드로 돌아가세요.';

  @override
  String get nonogramTutorialFinish => '마지막 칸을 칠해 퍼즐을 완성하세요!';

  @override
  String get nonogramTutorialDoneTitle => '잘했어요!';

  @override
  String get nonogramTutorialDone =>
      '준비 완료! 큰 퍼즐에서는 두 손가락으로(또는 격자 밖 빈 공간에서) 드래그해 판을 움직이세요. 첫 큰 퍼즐에서 앱이 다시 알려 드립니다.';

  @override
  String get nonogramTutorialShowTechniques => '풀이 기법 보기';

  @override
  String get nonogramTutorialPlay => '게임 시작';

  @override
  String get nonogramGuideTutorialCardTitle => '플레이하며 배우기';

  @override
  String get nonogramGuideTutorialCardDesc =>
      '작은 5×5 퍼즐로 규칙과 조작법을 차근차근 배워 보세요.';

  @override
  String get nonogramPlayInfoHide => '레벨 정보 숨기기';

  @override
  String get nonogramPlayWandLabel => '마법 지팡이';

  @override
  String get nonogramPlayWandSelectPrompt => '답을 볼 행이나 열의 숫자를 탭하세요';

  @override
  String get nonogramPlayWandRowSolved => '이 행은 이미 정답입니다. 다른 행이나 열을 고르세요.';

  @override
  String get nonogramPlayWandColSolved => '이 열은 이미 정답입니다. 다른 행이나 열을 고르세요.';

  @override
  String get nonogramSettingsControlsGuide => '조작 안내';

  @override
  String get nonogramCoachSkip => '건너뛰기';

  @override
  String get nonogramCoachNext => '다음';

  @override
  String get nonogramCoachDone => '알겠어요';

  @override
  String nonogramCoachStep(int current, int total) {
    return '$current/$total';
  }

  @override
  String get nonogramCoachHintTitle => '힌트';

  @override
  String get nonogramCoachHintBody =>
      '판 전체에서 무작위로 고른 정답 칸 5개(칠해야 하는데 아직 칠하지 않은 칸)를 대신 칠해 줍니다. 이 칸에는 별이 붙어 바꿀 수 없고, 다시 시작해도 남습니다. 퍼즐마다 3번 쓸 수 있습니다.';

  @override
  String get nonogramCoachWandTitle => '마법 지팡이';

  @override
  String get nonogramCoachWandBody =>
      '지팡이를 탭한 다음 아무 행이나 열의 숫자를 탭하세요. 그 줄 전체의 답이 별과 함께 공개되고, 다시 시작해도 남습니다. 퍼즐마다 1번 쓸 수 있습니다.';

  @override
  String get nonogramCoachModeTitle => '칠하기 또는 X';

  @override
  String get nonogramCoachModeBody =>
      '탭했을 때 할 동작을 고르세요. 칸을 칠하거나, 빈칸임을 기억하도록 X를 표시합니다. 버튼을 탭해 전환하세요. 격자 위를 드래그하면 여러 칸을 한 번에 칠하거나 표시할 수 있습니다.';

  @override
  String get nonogramCoachLongPressTitle => '길게 눌러 반대 동작';

  @override
  String get nonogramCoachLongPressBody =>
      '칸을 길게 누르면 현재 모드의 반대 동작을 합니다. 칠하기 중에는 X, 표시 중에는 칠하기입니다. 짧게 진동하면 완료된 것이니 손을 떼세요.';

  @override
  String get nonogramCoachScrollTitle => '큰 퍼즐 둘러보기';

  @override
  String get nonogramCoachScrollBody =>
      '큰 퍼즐은 화면에 다 들어가지 않습니다. 두 손가락으로 드래그하거나 격자 밖 빈 공간에서 드래그해 판을 움직이세요. 숫자 위를 드래그하면 가려진 숫자를 볼 수 있습니다(모서리의 \"+N\"은 가려진 개수입니다).';

  @override
  String get nonogramTutorialRulesDoneTitle => '규칙을 익혔어요!';

  @override
  String get nonogramTutorialRulesDone =>
      '이제 다른 퍼즐에서 조작법과 도우미 기능을 연습해 봅시다. 드래그로 빠르게 칠하기, 길게 눌러 표시하기, 힌트, 마법 지팡이입니다.';

  @override
  String get nonogramTutorialContinue => '계속';

  @override
  String get nonogramTutorialLater => '나중에, 바로 플레이';

  @override
  String get nonogramTutorialDragRow =>
      '팁: 손가락으로 칸을 쓸면 한 번에 칠할 수 있습니다. 맨 윗줄은 5이니 줄 전체를 쓸어 보세요!';

  @override
  String get nonogramTutorialLongPressMark =>
      '1 1 1은 이 5칸에 꼭 맞게 들어가므로 2번째와 4번째 칸은 비어야 합니다. 모드를 바꿀 필요 없이 각 칸을 길게 눌러 X를 표시하세요. 짧게 진동하면 완료된 것입니다.';

  @override
  String get nonogramTutorialUseHint =>
      '막혔나요? 힌트 버튼을 탭하면 앱이 정답 칸 5개를 무작위로 칠해 줍니다. 퍼즐마다 3번 쓸 수 있습니다.';

  @override
  String get nonogramTutorialActivateWand =>
      '힌트가 별이 붙은 칸 5개를 칠했습니다. 이 칸은 고정되어 다시 시작해도 남습니다. 원하는 행이나 열 전체를 공개하려면 마법 지팡이를 쓰세요. 지팡이 버튼을 탭하세요.';

  @override
  String get nonogramTutorialPickWandLine =>
      '이제 맨 아랫줄의 숫자를 탭해 그 줄을 공개하세요. 지팡이는 퍼즐마다 1번 쓸 수 있습니다.';

  @override
  String get nonogramTutorialFinishTools =>
      '남은 칸을 칠해 완성하세요. 열을 따라 아래로 드래그하면 더 빨리 칠할 수 있습니다.';

  @override
  String get nonogramPlayHintNothingToFill =>
      '칠해야 할 칸은 모두 칠해져 있습니다. 잘못 칠한 칸이 없는지 확인해 보세요.';

  @override
  String get settingsLicenses => '라이선스';

  @override
  String get settingsSwitchPlayMode => '플레이 모드 전환';

  @override
  String get licensesTitle => '라이선스';

  @override
  String get licensesLevelArtHeading => '퍼즐';

  @override
  String get licensesLevelArtIntro =>
      '퍼즐은 아래 출처에서 가져왔습니다. 아이콘 세트는 크기를 줄이고 흑백으로 바꾼 뒤 모든 퍼즐이 풀리도록 수정했으며, 노노그램 모음집은 그대로 사용했습니다.';

  @override
  String get licensesFontHeading => '글꼴';

  @override
  String get licensesSoftwareButton => '오픈소스 소프트웨어 라이선스';

  @override
  String get licensesDeveloperLevelsNote =>
      '개발자 모드 퍼즐은 nonogram.org에서 가져온 것으로 내부 테스트 전용입니다. 스토어 버전에는 포함되지 않습니다.';

  @override
  String get playModeTitle => '플레이 모드 선택';

  @override
  String get playModeSubtitle => '진행 상황은 모드별로 따로 저장됩니다.';

  @override
  String get playModeUserTitle => '플레이어 모드';

  @override
  String get playModeUserBody => '스토어 버전에 들어 있는 라이선스 퍼즐입니다.';

  @override
  String get playModeDeveloperTitle => '개발자 모드';

  @override
  String get playModeDeveloperBody =>
      '내부 테스트용 nonogram.org 원본 퍼즐입니다. 이전 진행 상황이 유지됩니다.';

  @override
  String get playModeLastUsed => '최근 사용';

  @override
  String licensesBy(String author) {
    return '제작: $author';
  }

  @override
  String licensesLevelCount(int count) {
    return '퍼즐 $count개';
  }

  @override
  String playModeProgress(int solved, int total) {
    return '$solved/$total 완료';
  }

  @override
  String get adRewardNotReady => '광고가 아직 준비되지 않았습니다. 인터넷 연결을 확인하고 다시 시도하세요.';

  @override
  String get settingsAdPrivacy => '광고 개인정보 보호';

  @override
  String get ratingTitle => 'Nonopix가 마음에 드시나요?';

  @override
  String get ratingMessage => '별을 탭해 게임을 평가해 주세요.';

  @override
  String get ratingLater => '나중에';

  @override
  String get ratingSubmit => '보내기';

  @override
  String get ratingThanks => '의견을 주셔서 감사합니다! 계속해서 게임을 개선하겠습니다.';

  @override
  String ratingStarLabel(int count) {
    return '별 $count개';
  }

  @override
  String get settingsLanguage => '언어';

  @override
  String get settingsLanguageSystem => '기기 언어';

  @override
  String get premiumTitle => '광고 없이 플레이';

  @override
  String get premiumBenefitNoAds => '레벨 사이 광고 제거';

  @override
  String get premiumBenefitDaily => '매일 힌트 2개와 마법 지팡이 1개';

  @override
  String premiumBuy(String price) {
    return '구매 · $price';
  }

  @override
  String get premiumOneTime => 'Google Play를 통한 1회 결제';

  @override
  String get premiumActiveTitle => '광고 제거 팩 활성화됨';

  @override
  String get premiumActiveDaily => '매일 힌트 2개와 마법 지팡이 1개까지 채워집니다.';

  @override
  String get premiumPurchased => '감사합니다! 레벨 사이 광고가 꺼졌습니다.';

  @override
  String get premiumPending => '결제가 대기 중입니다. 결제가 완료되면 팩이 활성화됩니다.';

  @override
  String get premiumFailed => '구매하지 못했습니다. 다시 시도해 주세요.';

  @override
  String premiumDailyReward(int hints, int wands) {
    return '일일 선물: 이제 힌트 $hints개와 마법 지팡이 $wands개가 있습니다.';
  }
}

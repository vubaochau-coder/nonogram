// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Pixel Nonogram';

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
      '칠해진 두 조각을 이으면 가장 큰 숫자보다 긴 블록이 된다면, 그 사이 칸은 비어 있어야 합니다. X를 표시해 나누세요.';

  @override
  String get nonogramGuideMethodDivisionTitle => '5. 나누기';

  @override
  String get nonogramGuideMethodDoublePositioningDesc =>
      '칠해진 칸이 한두 개의 숫자에만 속할 수 있을 때가 있습니다. 가능한 경우를 하나씩 놓아 보고, 모든 경우에 비어 있는 칸에 X를 표시하세요.';

  @override
  String get nonogramGuideMethodDoublePositioningTitle => '6. 이중 배치';

  @override
  String get nonogramGuideMethodInaccessibilityDesc =>
      '어떤 블록도 닿을 수 없는 칸은 비어 있습니다. 칠해진 칸 주변에서 각 블록을 가장 먼 위치까지 놓아 보고, 그 범위 밖의 칸에는 X를 표시하세요.';

  @override
  String get nonogramGuideMethodInaccessibilityTitle => '3. 닿을 수 없는 칸';

  @override
  String get nonogramGuideMethodNotFitDesc =>
      'X 사이(또는 X와 가장자리 사이)의 빈틈이 그곳에 들어갈 수 있는 어떤 숫자보다도 짧으면 블록이 들어갈 수 없습니다. X를 표시하세요.';

  @override
  String get nonogramGuideMethodNotFitTitle => '4. 들어가지 않음';

  @override
  String get nonogramGuideMethodSuperpositionMultiDesc =>
      '숫자가 여러 개면 묶음 전체를 왼쪽으로(블록 사이에 빈칸 1칸씩) 민 다음 오른쪽으로 밀어 보세요. 같은 블록이 두 위치 모두에서 덮는 칸은 칠해집니다. 빠른 계산: 숫자와 빈칸을 더하고 남는 칸 수가 각 블록이 움직일 수 있는 거리입니다.';

  @override
  String get nonogramGuideMethodSuperpositionMultiTitle => '겹치기 (숫자 여러 개)';

  @override
  String get nonogramGuideMethodSuperpositionSimpleDesc =>
      '숫자가 줄 길이의 절반보다 크면 일부는 항상 칠해집니다. 블록을 왼쪽 끝까지, 그다음 오른쪽 끝까지 밀어 본다고 생각하세요. 두 번 모두 덮이는 칸은 확실히 칠해집니다. 예: 10칸에 7이면 가운데 4칸은 항상 칠해집니다.';

  @override
  String get nonogramGuideMethodSuperpositionSimpleTitle => '겹치기 (숫자 하나)';

  @override
  String get nonogramGuideMethodWallPushingDesc =>
      '가장자리에 가까운 칠해진 칸은 그 블록의 위치를 제한합니다. 블록은 가장자리 밖으로 나갈 수 없으니 반대쪽으로 뻗어야 합니다. 예: 5에서 4번째 칸이 칠해져 있으면, 왼쪽 끝에 붙여도 블록은 5번째 칸을 덮습니다.';

  @override
  String get nonogramGuideMethodWallPushingTitle => '2. 벽에서 밀어내기';

  @override
  String get nonogramGuideRuleDesc =>
      '각 숫자는 그 행이나 열에서 연속으로 칠해진 칸 묶음(블록) 하나를 나타냅니다. 숫자가 여러 개라면 각각 별개의 블록이며, 블록 사이에는 최소 한 칸의 빈칸이 있어야 합니다. 예를 들어 3 1은 3칸짜리 블록, 최소 1칸의 빈칸, 1칸짜리 블록이 차례로 온다는 뜻입니다.';

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
  String get nonogramTutorialWelcomeTitle => 'Pixel Nonogram에 오신 것을 환영합니다!';

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
      '규칙, 조작법, 주요 풀이 기법을 직접 플레이하며 단계별로 배워 보세요.';

  @override
  String get nonogramGuideRoutineTitle => '어디서부터 풀까';

  @override
  String get nonogramGuideRoutineTip1 =>
      '큰 숫자부터 시작하세요. 숫자가 줄 길이의 절반보다 크면 일부는 이미 확정입니다(아래 기법 1 참고).';

  @override
  String get nonogramGuideRoutineTip2 =>
      '쉬운 줄부터 푸세요. 0은 줄 전체가 비어 있다는 뜻이고, 숫자들의 합에 사이마다 빈칸 1칸을 더한 값이 줄 길이와 같으면 배치는 한 가지뿐입니다.';

  @override
  String get nonogramGuideRoutineTip3 =>
      '비어 있다고 확신하는 칸에는 X를 표시하세요. X는 칠한 칸만큼 유용합니다.';

  @override
  String get nonogramGuideRoutineTip4 =>
      '행과 열을 번갈아 보세요. 푼 칸 하나하나가 그 칸을 지나는 다른 줄의 새 단서가 됩니다.';

  @override
  String get nonogramGuideRoutineTip5 =>
      '절대 찍지 마세요. 막히면 모르는 칸이 가장 적은 줄을 찾거나 힌트를 사용하세요.';

  @override
  String nonogramGuideExample(int number) {
    return '예시 $number';
  }

  @override
  String get nonogramGuideExampleSingle => '예시';

  @override
  String get nonogramGuideLegendTitle => '그림 보는 법';

  @override
  String get nonogramGuideLegendFilled => '칠해진 칸';

  @override
  String get nonogramGuideLegendTrial => '블록을 시험 삼아 놓은 자리';

  @override
  String get nonogramGuideLegendCross => '빈칸 (X)';

  @override
  String get nonogramGuideLegendResult => '알아낼 수 있는 결과';

  @override
  String get nonogramGuideMethodLineDoneTitle => '완성된 줄';

  @override
  String get nonogramGuideMethodLineDoneDesc =>
      '한 줄의 블록이 모두 자리를 잡으면 나머지 칸은 모두 비어 있습니다. X를 표시하세요. 숫자가 0인 줄은 처음부터 비어 있습니다.';

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
  String get nonogramTutorialToolsDoneTitle => '조작법 마스터!';

  @override
  String get nonogramTutorialToolsDone =>
      '실제 퍼즐은 더 크고, 대부분의 줄은 한눈에 풀리지 않습니다. 이제 8×8 퍼즐로 풀이 기법을 배워 보세요.';

  @override
  String get nonogramTutorialOverlapSingle =>
      '먼저 큰 숫자를 찾으세요. 6은 이 8칸에 놓는 방법이 3가지이고, 하나씩 차례로 깜박입니다. 모든 방법에서 빛나는 칸은 확실히 칠해집니다. 노란 테두리 안의 4칸을 칠하세요.';

  @override
  String get nonogramTutorialOverlapMulti =>
      '숫자가 여러 개여도 같습니다. 3 3은 최소 7칸(3 + 빈칸 + 3)이 필요해서 놓는 방법이 3가지뿐입니다. 3가지 모두에서 빛나는 칸을 칠하세요.';

  @override
  String get nonogramTutorialFullRow => '8칸에 8: 줄 전체를 칠합니다. 줄을 따라 쓸어 보세요.';

  @override
  String get nonogramTutorialZeroRow =>
      '0은 그 줄에 칠할 칸이 하나도 없다는 뜻입니다. X 모드로 바꾸세요.';

  @override
  String get nonogramTutorialMarkZeroRow =>
      '맨 아랫줄 전체에 X를 표시하세요. X도 중요합니다. 열에서 블록이 들어갈 수 없는 곳을 알려 줍니다.';

  @override
  String get nonogramTutorialOutOfReach =>
      '이제 열을 봅니다. 2열은 칠해진 2칸을 반드시 덮는 3짜리 블록 하나라서 놓는 방법이 2가지뿐입니다. 한 번도 빛나지 않는 칸에는 닿을 수 없습니다. X를 표시하고, 7열도 똑같이 하세요.';

  @override
  String get nonogramTutorialBackToFill =>
      '3열을 보세요. 7칸이 필요합니다. 다시 칠하기 모드로 바꾸세요.';

  @override
  String get nonogramTutorialExactSpace =>
      '맨 아래 X 덕분에 7이 들어갈 칸이 딱 7칸 남았습니다. 모두 칠하세요. 6열도 마찬가지입니다.';

  @override
  String get nonogramTutorialFinishTechniques =>
      '이것이 기본 흐름입니다. 행에서 풀 수 있는 만큼 풀고, 열로 넘어가고, 반복하세요. 버섯을 혼자 완성해 보세요!';

  @override
  String get nonogramPlayHintNothingToFill =>
      '칠해야 할 칸은 모두 칠해져 있습니다. 잘못 칠한 칸이 없는지 확인해 보세요.';

  @override
  String get settingsSound => '사운드';

  @override
  String get settingsLicenses => '라이선스';

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
  String licensesBy(String author) {
    return '제작: $author';
  }

  @override
  String licensesLevelCount(int count) {
    return '퍼즐 $count개';
  }

  @override
  String get adRewardNotReady => '광고가 아직 준비되지 않았습니다. 몇 분 후에 다시 시도하세요.';

  @override
  String get settingsAdPrivacy => '광고 개인정보 보호';

  @override
  String get ratingTitle => 'Pixel Nonogram이 마음에 드시나요?';

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
  String get premiumBenefitDaily => '출석하는 날마다 힌트 2개와 마법 지팡이 1개';

  @override
  String premiumBuy(String price) {
    return '구매 · $price';
  }

  @override
  String get premiumOneTime => 'Google Play를 통한 1회 결제';

  @override
  String get premiumActiveTitle => '광고 제거 팩 활성화됨';

  @override
  String get premiumActiveDaily => '매일 출석하면 그날 쓸 수 있는 힌트 2개와 마법 지팡이 1개를 받아요.';

  @override
  String get premiumPurchased => '감사합니다! 레벨 사이 광고가 꺼졌습니다.';

  @override
  String get premiumPending => '결제가 대기 중입니다. 결제가 완료되면 팩이 활성화됩니다.';

  @override
  String get premiumFailed => '구매하지 못했습니다. 다시 시도해 주세요.';

  @override
  String get checkInTitle => '매일 출석 체크';

  @override
  String get checkInAction => '출석 체크';

  @override
  String get checkInDoneToday => '오늘 출석 완료';

  @override
  String get checkInCheckedIn => '출석 완료!';

  @override
  String checkInReceived(String rewards) {
    return '$rewards을(를) 받았습니다.';
  }

  @override
  String rewardHints(int count) {
    return '힌트 $count개';
  }

  @override
  String rewardWands(int count) {
    return '마법 지팡이 $count개';
  }

  @override
  String rewardTodayOnly(String reward) {
    return '$reward (오늘만)';
  }

  @override
  String get navHome => '홈';

  @override
  String get navMe => '내 정보';

  @override
  String get meHelp => '도움말';

  @override
  String get meMore => '기타';

  @override
  String get checkInTodayButton => '오늘 출석 체크';

  @override
  String get checkInGiftToday => '오늘은 선물이 있어요!';

  @override
  String get checkInGiftCollect => '받기';

  @override
  String get checkInGiftDouble => '2배로 받기';

  @override
  String checkInStreakTitle(int count) {
    return '$count일 연속';
  }

  @override
  String checkInStreakDays(int count) {
    return '$count일';
  }

  @override
  String checkInStreakMakeUp(int missed, String days) {
    return '놓친 $missed일을 채우면 연속 기록이 $days이 됩니다';
  }

  @override
  String get checkInStreakKeepGoing => '매일 출석해서 연속 기록을 이어가세요';

  @override
  String get checkInStreakAllDone => '이번 달 연속 보상을 모두 받았어요!';

  @override
  String checkInStreakDaysLeft(int count) {
    return '선물까지 $count일 남음';
  }

  @override
  String get checkInLegendChecked => '출석함';

  @override
  String get checkInLegendMissed => '놓침';

  @override
  String get checkInLegendFuture => '예정';

  @override
  String checkInGiftStreak(int count) {
    return '$count일 연속 선물';
  }

  @override
  String checkInMakeUpTitle(String date) {
    return '$date을 채울까요?';
  }

  @override
  String get checkInMakeUpBody => '짧은 광고를 보면 이 날을 채울 수 있어요. 연속 기록이 다시 이어집니다.';

  @override
  String get checkInMakeUpWatch => '광고 보기';

  @override
  String checkInMadeUp(String date) {
    return '$date을 채웠어요';
  }

  @override
  String dashboardDailyReminder(String rewards, String time) {
    return '$time 후 만료되는 $rewards가 남아 있어요. 낭비하지 않도록 지금 사용하세요.';
  }

  @override
  String get premiumViewBenefits => '혜택 보기';

  @override
  String get premiumBenefitsTitle => '패키지 혜택';

  @override
  String get premiumBenefitsTagline =>
      '한 번 구매하면 레벨 사이 광고가 사라지고 매일 도움 보상을 받으며, 계정에 영구히 적용됩니다.';

  @override
  String get premiumBenefitsOneTime => '1회 결제';

  @override
  String get premiumWhatYouGet => '받는 혜택';

  @override
  String get premiumPerkNoAdsTitle => '레벨 사이 광고 없음';

  @override
  String get premiumPerkNoAdsBody =>
      '퍼즐 사이의 전체 화면 광고가 사라집니다. 쉬지 않고 다음 레벨로 넘어가세요.';

  @override
  String get premiumPerkDailyTitle => '매일 출석 보상';

  @override
  String get premiumPerkDailyBody =>
      '출석할 때마다 그날 쓸 수 있는 힌트 2개와 마법 지팡이 1개를 평소 마일스톤 보상에 더해 받습니다.';

  @override
  String get premiumItemsTitle => '도움 아이템의 역할';

  @override
  String get powerUpHintName => '힌트';

  @override
  String get powerUpHintTagline => '직접 고른 한 칸의 정답을 공개';

  @override
  String get powerUpHintDesc =>
      '전구를 누른 다음 헷갈리는 위치를 고르세요. 앱이 정답인 한 칸(채움 또는 빈칸 표시)을 채워 막힌 곳을 풀어 줍니다.';

  @override
  String get powerUpWandName => '마법 지팡이';

  @override
  String get powerUpWandTagline => '한 행 또는 한 열 전체를 풀기';

  @override
  String get powerUpWandDesc =>
      '지팡이를 눌러 선택 모드를 켠 뒤 행이나 열의 힌트 숫자를 누르세요. 앱이 그 행이나 열 전체를 공개합니다. 한 칸 힌트보다 강력합니다.';

  @override
  String get powerUpStatesTitle => '아이콘으로 사용 종류를 알 수 있어요';

  @override
  String get powerUpStatesLead =>
      '모서리의 숫자는 남은 총 사용 횟수입니다. 기한이 있는 사용은 아이콘이 금색으로 바뀌고 작은 시계가 붙습니다.';

  @override
  String get powerUpTimeLimited => '기한 있음';

  @override
  String get powerUpTimeLimitedDesc =>
      '시계가 있는 금색 아이콘. 패키지의 매일 출석 보상입니다. 그날이 끝나면 만료됩니다.';

  @override
  String get powerUpPermanent => '무기한';

  @override
  String get powerUpPermanentDesc =>
      '파란 배지가 있는 일반 아이콘. 마일스톤과 시작 사용입니다. 만료되지 않습니다.';

  @override
  String get powerUpSpendOrderTitle => '어떤 사용이 먼저 쓰이나요?';

  @override
  String get powerUpSpendOrderHeading => '기한 있는 사용이 먼저 쓰입니다';

  @override
  String get powerUpSpendOrderBody =>
      '매일 사용은 그날이 끝나면 만료되므로, 힌트나 지팡이는 매일 사용을 먼저 쓰고 매일 사용이 다 떨어진 뒤에야 무기한 사용을 씁니다. 낭비되지 않습니다.';

  @override
  String get powerUpSpendDaily => '매일 사용';

  @override
  String get powerUpSpendPermanent => '무기한 사용';

  @override
  String get premiumBenefitsFootnote =>
      '매일 사용은 다음 날로 넘어가지 않습니다. 마일스톤 출석 보상은 무기한 사용이며 평소대로 쌓입니다.';

  @override
  String dashboardDailyReminderBoth(String hints, String wands) {
    return '$hints와 $wands';
  }
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Nonopix';

  @override
  String get commonCancel => 'Hủy';

  @override
  String get commonRetry => 'Thử lại';

  @override
  String get commonSave => 'Lưu';

  @override
  String nonogramDashboardContinueLevel(int level) {
    return 'Màn $level';
  }

  @override
  String get nonogramDashboardProgressSectionTitle => 'Tiến trình của bạn';

  @override
  String get nonogramDashboardStatCompleted => 'Đã hoàn thành';

  @override
  String get nonogramGuideIntro =>
      'Nonogram là trò chơi giải đố logic với quy luật đơn giản nhưng đầy thử thách. Mục tiêu là tìm ra bức tranh ẩn sau các ô vuông bằng cách tô màu dựa trên các con số chỉ dẫn.';

  @override
  String get nonogramGuideMethodDivisionDesc =>
      'Nếu việc nối hai khối ô đã tô tạo ra một khối lớn hơn tất cả các chỉ dẫn có sẵn, ô trống giữa chúng chắc chắn phải là dấu X.';

  @override
  String get nonogramGuideMethodDivisionTitle => '5. Sự chia cắt';

  @override
  String get nonogramGuideMethodDoublePositioningDesc =>
      'Nếu một ô đã tô chỉ có thể thuộc về một vài phương án đặt khối nhất định, bất kỳ ô nào không nằm trong phương án nào đều phải được đánh dấu X.';

  @override
  String get nonogramGuideMethodDoublePositioningTitle => '6. Định vị kép';

  @override
  String get nonogramGuideMethodInaccessibilityDesc =>
      'Đánh dấu X vào những ô mà chắc chắn không có bất kỳ khối màu nào có thể chạm tới.';

  @override
  String get nonogramGuideMethodInaccessibilityTitle => '3. Không thể tiếp cận';

  @override
  String get nonogramGuideMethodNotFitDesc =>
      'Nếu một khoảng trống giữa các dấu X nhỏ hơn bất kỳ con số chỉ dẫn nào còn lại của hàng đó, khoảng trống đó chắc chắn phải được đánh dấu X.';

  @override
  String get nonogramGuideMethodNotFitTitle => '4. Không vừa khoảng trống';

  @override
  String get nonogramGuideMethodSuperpositionMultiDesc =>
      'Khi có nhiều số chỉ dẫn, ta thử đặt toàn bộ các khối ở vị trí xa nhất bên trái và phải, luôn giữ khoảng trống tối thiểu 1 ô giữa các khối cùng màu. Ô nào mà một khối tự chồng lên chính nó trong cả hai phương án thì ô đó chắc chắn được tô.';

  @override
  String get nonogramGuideMethodSuperpositionMultiTitle =>
      'Chồng lấp (Trường hợp đa số)';

  @override
  String get nonogramGuideMethodSuperpositionSimpleDesc =>
      'Nếu một con số lớn hơn một nửa chiều dài hàng, một vài ô ở giữa chắc chắn sẽ được tô. Thử đặt khối ô ở vị trí xa nhất bên trái và bên phải, phần giao nhau chính là phần chắc chắn được tô.';

  @override
  String get nonogramGuideMethodSuperpositionSimpleTitle =>
      'Chồng lấp (Trường hợp đơn số)';

  @override
  String get nonogramGuideMethodWallPushingDesc =>
      'Nếu một ô đã được tô nằm gần biên hơn kích thước của con số chỉ dẫn đầu tiên, khối đó chắc chắn phải kéo dài ra xa phía biên đó.';

  @override
  String get nonogramGuideMethodWallPushingTitle => '2. Đẩy từ biên';

  @override
  String get nonogramGuideRuleDesc =>
      'Mỗi con số biểu thị một nhóm ô được tô liền nhau trong hàng hoặc cột đó. Nếu có nhiều số, chúng biểu thị các nhóm riêng biệt, và giữa hai nhóm luôn phải có ít nhất 1 ô trống. Ví dụ, `3 1` nghĩa là một nhóm 3 ô tô liền nhau, sau đó là ít nhất 1 ô trống, rồi đến một nhóm 1 ô.';

  @override
  String get nonogramGuideRuleTitle =>
      'Quy luật cốt lõi: ý nghĩa của các con số';

  @override
  String get nonogramGuideTitle => 'Cách Giải Nonogram';

  @override
  String nonogramHistoryCompletedOn(String date) {
    return 'Hoàn thành lúc $date';
  }

  @override
  String get nonogramHistoryDetailNotFound =>
      'Không tìm thấy chi tiết màn chơi.';

  @override
  String get nonogramHistoryEmpty => 'Chưa có màn chơi nào hoàn thành.';

  @override
  String nonogramHistoryLevel(int n) {
    return 'Màn $n';
  }

  @override
  String get nonogramHistoryTitle => 'Kết quả';

  @override
  String get nonogramPlayActionNextLevelFixed => 'Màn Tiếp Theo';

  @override
  String get nonogramPlayActionShowClues => 'Hiện gợi ý';

  @override
  String nonogramPlayCompletionMessage(int level) {
    return 'Chúc mừng! Bạn đã hoàn thành Màn $level.';
  }

  @override
  String get nonogramPlayCompletionTitle => 'Giải đố thành công!';

  @override
  String nonogramPlayDurationFormat(int minutes, int seconds) {
    return '${minutes}p ${seconds}s';
  }

  @override
  String nonogramPlayHintLabel(int count) {
    return 'Gợi ý ($count)';
  }

  @override
  String get nonogramPlayNoNextLevelToast => 'Hiện chưa có màn tiếp theo.';

  @override
  String get nonogramPlayPageTitle => 'Nonogram';

  @override
  String get nonogramSettingsTitle => 'Cài đặt';

  @override
  String get nonogramDashboardContinueNext => 'Thử thách tiếp theo';

  @override
  String get nonogramDashboardPlay => 'Chơi';

  @override
  String get nonogramDashboardResumeAction => 'Chơi tiếp';

  @override
  String get nonogramDashboardInProgressBadge => 'Đang chơi dở';

  @override
  String nonogramDashboardDifficulty(String value) {
    return 'Độ khó $value';
  }

  @override
  String nonogramDashboardSolvedOfTotal(int completed, int total) {
    return 'Đã giải $completed/$total màn';
  }

  @override
  String get nonogramDashboardStatFastest => 'Nhanh nhất';

  @override
  String get nonogramDashboardStatTotalTime => 'Tổng thời gian';

  @override
  String get nonogramDashboardRecentTitle => 'Vừa giải xong';

  @override
  String get nonogramDashboardSeeAll => 'Xem tất cả';

  @override
  String get nonogramDashboardRecentEmpty =>
      'Giải màn đầu tiên để bắt đầu bộ sưu tập tranh của bạn.';

  @override
  String get nonogramDashboardAllDoneTitle => 'Bạn đã giải hết mọi màn!';

  @override
  String nonogramDashboardAllDoneDesc(int total) {
    return 'Bạn đã hoàn thành cả $total màn. Xem lại bộ sưu tập bất cứ lúc nào.';
  }

  @override
  String nonogramDurationHoursMinutes(int hours, int minutes) {
    return '$hours giờ $minutes phút';
  }

  @override
  String nonogramHistoryBestTime(String time) {
    return 'Kỷ lục $time';
  }

  @override
  String get nonogramPlayActionDashboard => 'Trang chủ';

  @override
  String get appThemeTitle => 'Giao diện';

  @override
  String get appThemeLight => 'Sáng';

  @override
  String get appThemeDark => 'Tối';

  @override
  String get nonogramPlayModeFill => 'Chế độ tô';

  @override
  String get nonogramPlayModeMark => 'Chế độ đánh X';

  @override
  String get nonogramSettingsRestart => 'Chơi lại từ đầu';

  @override
  String get nonogramSettingsRestartConfirmTitle => 'Chơi lại từ đầu?';

  @override
  String get nonogramSettingsRestartConfirmMessage =>
      'Toàn bộ ô đã tô và đánh X của màn này sẽ bị xoá. Các ô có dấu sao (mở bằng gợi ý / gậy phép) được giữ lại.';

  @override
  String get commonClose => 'Đóng';

  @override
  String get nonogramSettingsRestartConfirm => 'Chơi lại';

  @override
  String get nonogramTutorialTitle => 'Cách chơi';

  @override
  String get nonogramTutorialSkip => 'Bỏ qua';

  @override
  String get nonogramTutorialWelcomeTitle => 'Chào mừng đến với Nonopix!';

  @override
  String get nonogramTutorialWelcome =>
      'Cùng học luật chơi cơ bản qua một câu đố 5×5 nhỏ.';

  @override
  String get nonogramTutorialStart => 'Bắt đầu';

  @override
  String get nonogramTutorialSwitchToFill =>
      'Câu đố được giải bằng cách tô các ô vuông. Chạm vào nút bên dưới để chuyển sang chế độ tô.';

  @override
  String get nonogramTutorialClueIsCount =>
      'Con số cho biết hàng đó có bao nhiêu ô được tô. Hàng này có 5 ô, hãy tô hết!';

  @override
  String get nonogramTutorialEdgeCell =>
      'Ô cuối đã được tô sẵn. Khối 4 ô phải chứa ô đó nên chỉ có một cách đặt: tô 3 ô bên trái nó.';

  @override
  String get nonogramTutorialMultipleClues =>
      'Nhiều số nghĩa là nhiều khối, giữa các khối luôn có ít nhất một ô trống. 2 2 chỉ có đúng một cách xếp vừa 5 ô này.';

  @override
  String get nonogramTutorialClueOrder =>
      'Thứ tự cũng quan trọng: 3 1 nghĩa là khối 3 ô đứng trước, rồi mới tới khối 1 ô.';

  @override
  String get nonogramTutorialColumns =>
      'Các cột cũng có số, đọc từ trên xuống. Chuyển sang chế độ X để đánh dấu những ô chắc chắn bỏ trống.';

  @override
  String get nonogramTutorialMarkEmpty =>
      'Cột có dấu ✓ đã đủ ô tô. Đánh X vào các ô còn trống của những cột đó.';

  @override
  String get nonogramTutorialOneCellLeft =>
      'Số 1 của hàng cuối giờ chỉ còn đúng một chỗ. Chuyển lại sang chế độ tô.';

  @override
  String get nonogramTutorialFinish => 'Tô ô cuối cùng để hoàn thành câu đố!';

  @override
  String get nonogramTutorialDoneTitle => 'Tuyệt vời!';

  @override
  String get nonogramTutorialDone =>
      'Bạn đã sẵn sàng! Ở các màn lớn, kéo bằng hai ngón (hoặc kéo từ chỗ trống ngoài lưới) để di chuyển bàn chơi, app sẽ nhắc khi bạn gặp màn lớn đầu tiên.';

  @override
  String get nonogramTutorialShowTechniques => 'Xem các kỹ thuật giải';

  @override
  String get nonogramTutorialPlay => 'Bắt đầu chơi';

  @override
  String get nonogramGuideTutorialCardTitle => 'Học qua bài tập';

  @override
  String get nonogramGuideTutorialCardDesc =>
      'Học luật chơi và các thao tác từng bước trên câu đố 5×5 nhỏ.';

  @override
  String get nonogramPlayInfoHide => 'Ẩn thông tin màn';

  @override
  String get nonogramPlayWandLabel => 'Gậy phép';

  @override
  String get nonogramPlayWandSelectPrompt =>
      'Chạm vào dãy số của hàng hoặc cột cần hiện đáp án';

  @override
  String get nonogramPlayWandRowSolved =>
      'Hàng này đã đúng rồi, hãy chọn hàng hoặc cột khác.';

  @override
  String get nonogramPlayWandColSolved =>
      'Cột này đã đúng rồi, hãy chọn hàng hoặc cột khác.';

  @override
  String get nonogramSettingsControlsGuide => 'Hướng dẫn thao tác';

  @override
  String get nonogramCoachSkip => 'Bỏ qua';

  @override
  String get nonogramCoachNext => 'Tiếp';

  @override
  String get nonogramCoachDone => 'Đã hiểu';

  @override
  String nonogramCoachStep(int current, int total) {
    return '$current/$total';
  }

  @override
  String get nonogramCoachHintTitle => 'Gợi ý';

  @override
  String get nonogramCoachHintBody =>
      'Tô giúp 5 ô đúng (ô cần tô mà bạn chưa tô), chọn ngẫu nhiên trên cả bàn chơi. Các ô này có dấu sao: không đổi được và được giữ lại kể cả khi chơi lại từ đầu. Mỗi màn có 3 lượt.';

  @override
  String get nonogramCoachWandTitle => 'Gậy phép';

  @override
  String get nonogramCoachWandBody =>
      'Chạm vào gậy phép, rồi chạm vào dãy số của hàng hoặc cột bạn muốn: đáp án của trọn hàng/cột đó sẽ hiện ra và được đánh dấu sao, giữ lại kể cả khi chơi lại. Mỗi màn có 1 lượt.';

  @override
  String get nonogramCoachModeTitle => 'Tô hay đánh X';

  @override
  String get nonogramCoachModeBody =>
      'Chọn việc sẽ làm khi chạm vào ô: tô ô, hoặc đánh X để ghi nhớ ô chắc chắn trống. Chạm vào nút để đổi chế độ. Kéo ngón tay trên lưới để tô / đánh X nhiều ô liền.';

  @override
  String get nonogramCoachLongPressTitle => 'Nhấn giữ để làm ngược lại';

  @override
  String get nonogramCoachLongPressBody =>
      'Nhấn giữ một ô để làm việc ngược với chế độ đang chọn: đang tô thì đánh X, đang đánh X thì tô. Khi máy rung nhẹ là đã xong, có thể nhấc tay.';

  @override
  String get nonogramCoachScrollTitle => 'Di chuyển trên màn lớn';

  @override
  String get nonogramCoachScrollBody =>
      'Màn lớn không vừa màn hình: kéo bằng hai ngón, hoặc kéo từ chỗ trống ngoài lưới để di chuyển bàn chơi. Kéo trên dãy số để xem các số bị che (số \"+N\" ở góc cho biết còn bao nhiêu).';

  @override
  String get nonogramTutorialRulesDoneTitle => 'Bạn đã nắm luật chơi!';

  @override
  String get nonogramTutorialRulesDone =>
      'Tiếp theo, cùng thực hành các thao tác và công cụ hỗ trợ trên một câu đố khác: kéo để tô nhanh, nhấn giữ để đánh X, gợi ý và gậy phép.';

  @override
  String get nonogramTutorialContinue => 'Tiếp tục';

  @override
  String get nonogramTutorialLater => 'Để sau, chơi luôn';

  @override
  String get nonogramTutorialDragRow =>
      'Mẹo: kéo ngón tay qua nhiều ô để tô liền một lúc. Hàng đầu có 5 ô, hãy kéo một đường qua cả hàng!';

  @override
  String get nonogramTutorialLongPressMark =>
      '1 1 1 vừa khít 5 ô nên ô thứ 2 và thứ 4 chắc chắn trống. Không cần đổi chế độ: nhấn giữ từng ô để đánh X, máy rung nhẹ là xong.';

  @override
  String get nonogramTutorialUseHint =>
      'Bí rồi? Chạm vào nút Gợi ý: app sẽ tô giúp 5 ô đúng ở vị trí ngẫu nhiên. Mỗi màn có 3 lượt.';

  @override
  String get nonogramTutorialActivateWand =>
      'Gợi ý vừa tô giúp 5 ô có dấu sao: các ô này đã khoá, không bị xoá kể cả khi chơi lại. Muốn hiện trọn một hàng hoặc cột do bạn chọn thì dùng gậy phép: chạm vào nút gậy phép.';

  @override
  String get nonogramTutorialPickWandLine =>
      'Giờ chạm vào dãy số của hàng cuối cùng để hiện đáp án hàng đó. Mỗi màn có 1 lượt gậy phép.';

  @override
  String get nonogramTutorialFinishTools =>
      'Tô nốt các ô còn lại để hoàn thành. Kéo dọc theo cột để tô nhanh hơn.';

  @override
  String get nonogramPlayHintNothingToFill =>
      'Mọi ô cần tô đều đã được tô. Hãy kiểm tra những ô tô thừa.';

  @override
  String get settingsLicenses => 'Giấy phép';

  @override
  String get settingsSwitchPlayMode => 'Đổi chế độ chơi';

  @override
  String get licensesTitle => 'Giấy phép';

  @override
  String get licensesLevelArtHeading => 'Màn chơi';

  @override
  String get licensesLevelArtIntro =>
      'Các màn chơi lấy từ những nguồn dưới đây. Các bộ icon được thu nhỏ, chuyển sang đen trắng và chỉnh sửa để màn nào cũng giải được; các bộ nonogram được dùng nguyên bản.';

  @override
  String get licensesFontHeading => 'Phông chữ';

  @override
  String get licensesSoftwareButton => 'Giấy phép phần mềm mã nguồn mở';

  @override
  String get licensesDeveloperLevelsNote =>
      'Các màn ở chế độ nhà phát triển lấy từ nonogram.org, chỉ dùng để thử nội bộ và không có trong bản phát hành trên store.';

  @override
  String get playModeTitle => 'Chọn chế độ chơi';

  @override
  String get playModeSubtitle => 'Tiến độ của mỗi chế độ được lưu riêng.';

  @override
  String get playModeUserTitle => 'Chế độ người dùng';

  @override
  String get playModeUserBody =>
      'Bộ màn có bản quyền, giống bản phát hành trên store.';

  @override
  String get playModeDeveloperTitle => 'Chế độ nhà phát triển';

  @override
  String get playModeDeveloperBody =>
      'Bộ màn gốc từ nonogram.org, chỉ dùng để thử nội bộ. Giữ tiến độ chơi trước đây.';

  @override
  String get playModeLastUsed => 'Lần trước';

  @override
  String licensesBy(String author) {
    return 'Tác giả: $author';
  }

  @override
  String licensesLevelCount(int count) {
    return '$count màn';
  }

  @override
  String playModeProgress(int solved, int total) {
    return 'Đã giải $solved/$total màn';
  }

  @override
  String get adRewardNotReady =>
      'Quảng cáo chưa sẵn sàng. Hãy kiểm tra kết nối mạng rồi thử lại.';

  @override
  String get settingsAdPrivacy => 'Quyền riêng tư quảng cáo';

  @override
  String get ratingTitle => 'Bạn thấy Nonopix thế nào?';

  @override
  String get ratingMessage => 'Chạm vào số sao để đánh giá game nhé.';

  @override
  String get ratingLater => 'Để sau';

  @override
  String get ratingSubmit => 'Gửi';

  @override
  String get ratingThanks =>
      'Cảm ơn bạn đã góp ý! Chúng mình sẽ tiếp tục làm game tốt hơn.';

  @override
  String ratingStarLabel(int count) {
    return '$count sao';
  }
}

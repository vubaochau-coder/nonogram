// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Nonogram';

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
  String get nonogramDashboardHeroSubtitle =>
      'Hé lộ bức tranh ẩn bằng cách điền các ô dựa trên gợi ý số ở các cạnh của lưới.';

  @override
  String nonogramDashboardInSessionDesc(int level) {
    return 'Bạn đang giải dở Màn $level';
  }

  @override
  String get nonogramDashboardInSessionTitle => 'Đang giải dở';

  @override
  String get nonogramDashboardProgressSectionTitle => 'Tiến trình của bạn';

  @override
  String nonogramDashboardReadyDesc(int level) {
    return 'Vượt qua Màn $level để mở khóa thêm thử thách';
  }

  @override
  String get nonogramDashboardReadyTitle => 'Sẵn sàng cho màn mới';

  @override
  String get nonogramDashboardStatCompleted => 'Đã hoàn thành';

  @override
  String get nonogramDashboardStatNextTarget => 'Mục tiêu tiếp theo';

  @override
  String get nonogramDashboardTitle => 'Nonogram';

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
  String get nonogramHistoryBest => 'Kỷ lục';

  @override
  String nonogramHistoryCompletedOn(String date) {
    return 'Hoàn thành lúc $date';
  }

  @override
  String get nonogramHistoryCompletionDate => 'Ngày hoàn thành';

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
  String get nonogramHistoryPlayTime => 'Tổng thời gian chơi';

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
    return 'Gợi ý $count/3';
  }

  @override
  String get nonogramPlayNoNextLevelToast => 'Hiện chưa có màn tiếp theo.';

  @override
  String get nonogramPlayPageTitle => 'Nonogram';

  @override
  String get nonogramPlayStatDifficulty => 'Độ khó';

  @override
  String get nonogramPlayStatTime => 'Thời gian';

  @override
  String get nonogramSettingsCellSize => 'Kích thước ô';

  @override
  String get nonogramSettingsCellSizeCustom => 'Tuỳ chỉnh';

  @override
  String get nonogramSettingsCellSizeDefault => '(mặc định)';

  @override
  String get nonogramSettingsCellSizeError => 'Kích thước phải từ 12 đến 80';

  @override
  String get nonogramSettingsTitle => 'Cài đặt';

  @override
  String get nonogramDashboardContinueNext => 'Thử thách tiếp theo';

  @override
  String get nonogramDashboardContinueResume => 'Tiếp tục chơi';
}

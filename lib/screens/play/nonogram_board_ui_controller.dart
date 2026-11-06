import 'package:flutter/widgets.dart';
import 'package:nested/nested.dart';

/// Trạng thái giao diện của bàn chơi không cần lưu cùng ván: dải gợi ý thu
/// gọn hay không, và người chơi có đang giữ nút "giữ để kéo" không.
class NonogramBoardUiController extends ChangeNotifier {
  bool _compactClues = false;
  bool _panHeld = false;
  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  /// Thu gọn hai dải gợi ý để nhường chỗ cho lưới.
  bool get compactClues => _compactClues;

  /// Đang giữ nút kéo: một ngón trên bàn sẽ kéo bàn thay vì tô.
  bool get panHeld => _panHeld;

  void toggleCompactClues() {
    _compactClues = !_compactClues;
    notifyListeners();
  }

  set panHeld(bool value) {
    if (_disposed || value == _panHeld) return;
    _panHeld = value;
    notifyListeners();
  }
}

class NonogramBoardUiScope extends SingleChildStatelessWidget {
  final NonogramBoardUiController controller;

  const NonogramBoardUiScope({
    super.key,
    required this.controller,
    super.child,
  });

  /// Lấy controller và lắng nghe thay đổi.
  static NonogramBoardUiController of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<_BoardUiInherited>();
    if (scope?.notifier case final controller?) return controller;
    throw FlutterError('NonogramBoardUiScope is missing in the widget tree.');
  }

  /// Lấy controller mà không lắng nghe (dùng trong callback).
  static NonogramBoardUiController read(BuildContext context) {
    final element =
        context.getElementForInheritedWidgetOfExactType<_BoardUiInherited>();
    final scope = element?.widget as _BoardUiInherited?;
    if (scope?.notifier case final controller?) return controller;
    throw FlutterError('NonogramBoardUiScope is missing in the widget tree.');
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return _BoardUiInherited(
      notifier: controller,
      child: child ?? const SizedBox.shrink(),
    );
  }
}

class _BoardUiInherited extends InheritedNotifier<NonogramBoardUiController> {
  const _BoardUiInherited({required super.notifier, required super.child});
}

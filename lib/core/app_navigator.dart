import 'package:flutter/material.dart';
import 'package:nonogram/l10n/app_localizations.dart';

abstract final class AppNavigator {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static BuildContext? get context {
    try {
      return navigatorKey.currentContext;
    } on FlutterError {
      return null;
    }
  }

  static OverlayState? get overlayState {
    try {
      return navigatorKey.currentState?.overlay;
    } on FlutterError {
      return null;
    }
  }

  /// Chuỗi dịch hiện tại, cho những chỗ không có context (vd. thông báo từ
  /// dịch vụ chạy nền); null nếu app chưa dựng xong.
  static AppLocalizations? get l10nOrNull {
    final context = AppNavigator.context;
    return context == null ? null : AppLocalizations.of(context);
  }
}

import 'package:nonogram/core/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastUtils {
  ToastUtils._();

  static const _autoCloseDuration = Duration(seconds: 3);

  static void success({required String title, String? description}) {
    _show(
      type: ToastificationType.success,
      title: title,
      description: description,
      primaryColor: const Color(0xFF1B8F4E),
      backgroundColor: const Color(0xFFE9F8EF),
      foregroundColor: const Color(0xFF0E3D23),
      borderColor: const Color(0xFF8FD8AF),
    );
  }

  static void info({required String title, String? description}) {
    _show(
      type: ToastificationType.info,
      title: title,
      description: description,
      primaryColor: const Color(0xFF1E6FD8),
      backgroundColor: const Color(0xFFEAF3FF),
      foregroundColor: const Color(0xFF0D315F),
      borderColor: const Color(0xFF9DC2F3),
    );
  }

  static void warning({required String title, String? description}) {
    _show(
      type: ToastificationType.warning,
      title: title,
      description: description,
      primaryColor: const Color(0xFFB46A00),
      backgroundColor: const Color(0xFFFFF4E5),
      foregroundColor: const Color(0xFF5C3500),
      borderColor: const Color(0xFFF0C98A),
    );
  }

  static void error({required String title, String? description}) {
    _show(
      type: ToastificationType.error,
      title: title,
      description: description,
      primaryColor: const Color(0xFFC33939),
      backgroundColor: const Color(0xFFFFEBEB),
      foregroundColor: const Color(0xFF5E1616),
      borderColor: const Color(0xFFF1A7A7),
    );
  }

  static void _show({
    required ToastificationType type,
    required String title,
    String? description,
    required Color primaryColor,
    required Color backgroundColor,
    required Color foregroundColor,
    required Color borderColor,
  }) {
    final overlayState = AppNavigator.overlayState;
    if (overlayState == null) return;

    toastification.show(
      overlayState: overlayState,
      type: type,
      style: ToastificationStyle.flatColored,
      alignment: Alignment.bottomCenter,
      autoCloseDuration: _autoCloseDuration,
      primaryColor: primaryColor,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      borderSide: BorderSide(color: borderColor),
      title: Text(title),
      description: description == null ? null : Text(description),
    );
  }
}

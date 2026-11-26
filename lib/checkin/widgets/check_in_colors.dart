import 'package:flutter/material.dart';

/// Màu cam của chuỗi (ngọn lửa, thanh tiến trình, hộp quà).
Color checkInFireColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
    ? const Color(0xFFFF8A3D)
    : const Color(0xFFF76707);

/// Màu của ngày bỏ lỡ (bù được).
Color checkInMissedColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
    ? const Color(0xFFFFB547)
    : const Color(0xFFF08C00);

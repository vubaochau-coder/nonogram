import 'package:flutter/material.dart';
import 'package:nonogram/screens/dashboard/nonogram_dashboard_screen.dart';
import 'package:nonogram/screens/guide/nonogram_guide_screen.dart';
import 'package:nonogram/screens/history/nonogram_history_detail_screen.dart';
import 'package:nonogram/screens/history/nonogram_history_screen.dart';
import 'package:nonogram/screens/play/nonogram_play_screen.dart';
import 'package:nonogram/screens/tutorial/nonogram_tutorial_screen.dart';

/// Các màn hình của app. Giữ cùng tên với bản trong Nexora để code UI
/// chuyển sang không phải sửa, nhưng điều hướng chỉ là Navigator thường.
sealed class AppRouteIntent<T> {
  const AppRouteIntent();

  Widget build();
}

class NonogramIntent extends AppRouteIntent<void> {
  const NonogramIntent();

  @override
  Widget build() => const NonogramDashboardScreen();
}

class NonogramPlayIntent extends AppRouteIntent<void> {
  final int initialLevel;
  const NonogramPlayIntent({this.initialLevel = 1});

  @override
  Widget build() => NonogramPlayScreen(initialLevel: initialLevel);
}

class NonogramCompletedResultsIntent extends AppRouteIntent<void> {
  const NonogramCompletedResultsIntent();

  @override
  Widget build() => const NonogramHistoryScreen();
}

class NonogramCompletedResultDetailIntent extends AppRouteIntent<void> {
  final int level;
  const NonogramCompletedResultDetailIntent({required this.level});

  @override
  Widget build() => NonogramHistoryDetailScreen(level: level);
}

class NonogramGuideIntent extends AppRouteIntent<void> {
  const NonogramGuideIntent();

  @override
  Widget build() => const NonogramGuideScreen();
}

/// Bài hướng dẫn tương tác. Kết quả `true`: người chơi muốn xem tiếp các kỹ
/// thuật giải.
class NonogramTutorialIntent extends AppRouteIntent<bool> {
  const NonogramTutorialIntent();

  @override
  Widget build() => const NonogramTutorialScreen();
}

extension AppRouteNavigation on BuildContext {
  Future<T?> navigate<T>(AppRouteIntent<T> intent) {
    return Navigator.of(
      this,
    ).push<T>(MaterialPageRoute<T>(builder: (_) => intent.build()));
  }
}

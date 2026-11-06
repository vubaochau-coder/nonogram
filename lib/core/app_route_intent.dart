import 'package:flutter/material.dart';
import 'package:nonogram/screens/dashboard/nonogram_dashboard_page.dart';
import 'package:nonogram/screens/guide/nonogram_guide_page.dart';
import 'package:nonogram/screens/history/nonogram_history_detail_page.dart';
import 'package:nonogram/screens/history/nonogram_history_page.dart';
import 'package:nonogram/screens/play/nonogram_play_page.dart';
import 'package:nonogram/screens/tutorial/nonogram_tutorial_page.dart';

/// Các màn hình của app. Giữ cùng tên với bản trong Nexora để code UI
/// chuyển sang không phải sửa, nhưng điều hướng chỉ là Navigator thường.
sealed class AppRouteIntent<T> {
  const AppRouteIntent();

  Widget build();
}

class NonogramIntent extends AppRouteIntent<void> {
  const NonogramIntent();

  @override
  Widget build() => const NonogramDashboardPage();
}

class NonogramPlayIntent extends AppRouteIntent<void> {
  final int initialLevel;
  const NonogramPlayIntent({this.initialLevel = 1});

  @override
  Widget build() => NonogramPlayPage(initialLevel: initialLevel);
}

class NonogramCompletedResultsIntent extends AppRouteIntent<void> {
  const NonogramCompletedResultsIntent();

  @override
  Widget build() => const NonogramHistoryPage();
}

class NonogramCompletedResultDetailIntent extends AppRouteIntent<void> {
  final int level;
  const NonogramCompletedResultDetailIntent({required this.level});

  @override
  Widget build() => NonogramHistoryDetailPage(level: level);
}

class NonogramGuideIntent extends AppRouteIntent<void> {
  const NonogramGuideIntent();

  @override
  Widget build() => const NonogramGuidePage();
}

/// Bài hướng dẫn tương tác. Kết quả `true`: người chơi muốn xem tiếp các kỹ
/// thuật giải.
class NonogramTutorialIntent extends AppRouteIntent<bool> {
  const NonogramTutorialIntent();

  @override
  Widget build() => const NonogramTutorialPage();
}

extension AppRouteNavigation on BuildContext {
  Future<T?> navigate<T>(AppRouteIntent<T> intent) {
    return Navigator.of(
      this,
    ).push<T>(MaterialPageRoute<T>(builder: (_) => intent.build()));
  }
}

import 'package:flutter/material.dart';
import 'package:nonogram/checkin/check_in_page.dart';
import 'package:nonogram/checkin/check_in_service.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/screens/dashboard/nonogram_dashboard_page.dart';
import 'package:nonogram/screens/me/me_page.dart';
import 'package:provider/provider.dart';

/// Trang gốc của app: 3 tab Chính, Điểm danh, Tôi với thanh điều hướng dưới.
/// Các tab giữ nguyên trạng thái khi chuyển qua lại. Không có điểm danh
/// (test) thì chỉ có 2 tab.
class AppHomePage extends StatefulWidget {
  const AppHomePage({super.key, this.showTutorialOnStart = false});

  /// Mở bài hướng dẫn "Cách chơi" ngay khi vào (lần đầu mở app).
  final bool showTutorialOnStart;

  @override
  State<AppHomePage> createState() => _AppHomePageState();
}

enum _HomeTab { home, checkIn, me }

class _AppHomePageState extends State<AppHomePage> {
  _HomeTab _tab = _HomeTab.home;

  @override
  Widget build(BuildContext context) {
    final checkIn = _checkIn(context);
    final tabs = [
      _HomeTab.home,
      if (checkIn != null) _HomeTab.checkIn,
      _HomeTab.me,
    ];
    if (!tabs.contains(_tab)) _tab = _HomeTab.home;

    return Scaffold(
      body: IndexedStack(
        index: tabs.indexOf(_tab),
        children: [
          for (final tab in tabs)
            switch (tab) {
              _HomeTab.home => NonogramDashboardPage(
                showTutorialOnStart: widget.showTutorialOnStart,
              ),
              _HomeTab.checkIn => const CheckInTab(),
              _HomeTab.me => const MePage(),
            },
        ],
      ),
      bottomNavigationBar: _BottomNav(
        tabs: tabs,
        selected: _tab,
        // Chấm đỏ trên tab Điểm danh khi hôm nay còn điểm danh được.
        checkInDot: checkIn?.canCheckIn ?? false,
        onSelected: (tab) => setState(() => _tab = tab),
      ),
    );
  }

  static CheckInService? _checkIn(BuildContext context) {
    try {
      return context.watch<CheckInService>();
    } on ProviderNotFoundException {
      return null;
    }
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.tabs,
    required this.selected,
    required this.checkInDot,
    required this.onSelected,
  });

  final List<_HomeTab> tabs;
  final _HomeTab selected;
  final bool checkInDot;
  final ValueChanged<_HomeTab> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.color;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        border: Border(top: BorderSide(color: colors.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
          child: Row(
            children: [
              for (final tab in tabs)
                Expanded(
                  child: _NavItem(
                    key: ValueKey('home-tab-${tab.name}'),
                    icon: switch (tab) {
                      _HomeTab.home => Icons.home_rounded,
                      _HomeTab.checkIn => Icons.event_available_rounded,
                      _HomeTab.me => Icons.person_rounded,
                    },
                    label: switch (tab) {
                      _HomeTab.home => l10n.navHome,
                      _HomeTab.checkIn => l10n.checkInAction,
                      _HomeTab.me => l10n.navMe,
                    },
                    selected: tab == selected,
                    dot: tab == _HomeTab.checkIn && checkInDot,
                    onTap: () => onSelected(tab),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.dot,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final bool dot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final color = selected ? colors.primary : colors.onSurfaceVariant;
    return Semantics(
      selected: selected,
      button: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Material(
          color:
              selected
                  ? colors.primary.withValues(alpha: 0.10)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Badge(
                    isLabelVisible: dot,
                    smallSize: 9,
                    child: Icon(icon, size: 28, color: color),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.labelMedium.copyWith(
                      color: color,
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

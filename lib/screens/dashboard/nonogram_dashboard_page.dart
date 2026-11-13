import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/app_locale.dart';
import 'package:nonogram/core/app_route_intent.dart';
import 'package:nonogram/core/app_theme_mode.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/premium/premium_card.dart';
import 'package:nonogram/widgets/app_language_selector.dart';

import 'bloc/nonogram_dashboard_bloc.dart';
import 'bloc/nonogram_dashboard_event.dart';
import 'sections/nonogram_dashboard_hero_section.dart';
import 'sections/nonogram_dashboard_progress_section.dart';
import 'sections/nonogram_dashboard_recent_section.dart';

class NonogramDashboardPage extends StatelessWidget {
  const NonogramDashboardPage({super.key, this.showTutorialOnStart = false});

  /// Mở bài hướng dẫn "Cách chơi" ngay khi vào (lần đầu mở app).
  final bool showTutorialOnStart;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return NonogramDashboardBloc(repository: context.read())
          ..add(const DashboardInitialized());
      },
      child: _NonogramDashboardView(showTutorialOnStart: showTutorialOnStart),
    );
  }
}

class _NonogramDashboardView extends StatefulWidget {
  const _NonogramDashboardView({required this.showTutorialOnStart});

  final bool showTutorialOnStart;

  @override
  State<_NonogramDashboardView> createState() => _NonogramDashboardViewState();
}

class _NonogramDashboardViewState extends State<_NonogramDashboardView> {
  @override
  void initState() {
    super.initState();
    if (widget.showTutorialOnStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _openTutorial());
    }
  }

  /// Học xong mà chọn "Xem các kỹ thuật giải" thì mở tiếp trang lý thuyết.
  Future<void> _openTutorial() async {
    if (!mounted) return;
    final showTechniques = await context.navigate(
      const NonogramTutorialIntent(),
    );
    if (!mounted || showTechniques != true) return;
    await context.navigate(const NonogramGuideIntent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              titleSpacing: 20,
              title: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: Image.asset(
                      'assets/branding/logo.png',
                      width: 32,
                      height: 32,
                      cacheWidth: 96,
                      filterQuality: FilterQuality.medium,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(context.l10n.appTitle, style: context.titleLarge),
                ],
              ),
              actions: [
                IconButton(
                  onPressed:
                      () => context.read<AppThemeModeController>().toggle(),
                  icon: Icon(
                    Theme.of(context).brightness == Brightness.dark
                        ? LucideIcons.moon
                        : LucideIcons.sun,
                  ),
                  tooltip: context.l10n.appThemeTitle,
                ),
                if (_localeController(context) case final controller?)
                  IconButton(
                    key: const ValueKey('dashboard-language'),
                    onPressed: () => showAppLanguageDialog(context, controller),
                    icon: const Icon(LucideIcons.globe),
                    tooltip: context.l10n.settingsLanguage,
                  ),
                IconButton(
                  onPressed:
                      () => context.navigate(const NonogramGuideIntent()),
                  icon: const Icon(LucideIcons.helpCircle),
                  tooltip: context.l10n.nonogramGuideTitle,
                ),
                const SizedBox(width: 8),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              sliver: SliverList.list(
                children: const [
                  NonogramDashboardHeroSection(),
                  SizedBox(height: 20),
                  PremiumCard(),
                  SizedBox(height: 20),
                  NonogramDashboardProgressSection(),
                  SizedBox(height: 24),
                  NonogramDashboardRecentSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Null trong test dựng trang chính mà không cấp [AppLocaleController].
AppLocaleController? _localeController(BuildContext context) {
  try {
    return context.read<AppLocaleController>();
  } on ProviderNotFoundException {
    return null;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/app_route_intent.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/widgets/app_theme_mode_selector.dart';

import 'bloc/nonogram_dashboard_bloc.dart';
import 'bloc/nonogram_dashboard_event.dart';
import 'dashboard_navigation.dart';
import 'sections/nonogram_dashboard_hero_section.dart';
import 'sections/nonogram_dashboard_progress_section.dart';
import 'sections/nonogram_dashboard_recent_section.dart';

class NonogramDashboardPage extends StatelessWidget {
  const NonogramDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return NonogramDashboardBloc(repository: context.read())
          ..add(const DashboardInitialized());
      },
      child: const _NonogramDashboardView(),
    );
  }
}

class _NonogramDashboardView extends StatelessWidget {
  const _NonogramDashboardView();

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
                      () => openFromDashboard(
                        context,
                        const NonogramCompletedResultsIntent(),
                      ),
                  icon: const Icon(LucideIcons.history),
                  tooltip: context.l10n.nonogramHistoryTitle,
                ),
                IconButton(
                  onPressed: () => showAppThemeModeDialog(context),
                  icon: Icon(
                    Theme.of(context).brightness == Brightness.dark
                        ? LucideIcons.moon
                        : LucideIcons.sun,
                  ),
                  tooltip: context.l10n.appThemeTitle,
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

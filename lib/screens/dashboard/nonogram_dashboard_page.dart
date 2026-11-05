import 'package:nonogram/core/context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/nonogram_dashboard_bloc.dart';
import 'bloc/nonogram_dashboard_event.dart';
import 'bloc/nonogram_dashboard_state.dart';
import 'package:nonogram/core/app_route_intent.dart';
import 'sections/nonogram_dashboard_hero_section.dart';
import 'sections/nonogram_dashboard_continue_section.dart';
import 'sections/nonogram_dashboard_summary_section.dart';

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
      backgroundColor: context.color.surface,
      body: BlocBuilder<NonogramDashboardBloc, NonogramDashboardState>(
        buildWhen: (p, c) => p.isLoading != c.isLoading,
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 0,
                floating: true,
                pinned: true,
                elevation: 0,
                scrolledUnderElevation: 2,
                title: const Text('Nonogram'),
                backgroundColor: context.color.surface,
                actions: [
                  IconButton(
                    onPressed: () {
                      context.navigate(const NonogramGuideIntent());
                    },
                    icon: const Icon(Icons.help_outline),
                    tooltip: context.l10n.nonogramGuideTitle,
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const NonogramDashboardHeroSection(),
                    const SizedBox(height: 16),
                    const NonogramDashboardContinueSection(),
                    const SizedBox(height: 24),
                    const NonogramDashboardSummarySection(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

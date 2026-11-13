import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/app_route_intent.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/screens/dashboard/bloc/nonogram_dashboard_bloc.dart';
import 'package:nonogram/screens/dashboard/bloc/nonogram_dashboard_state.dart';
import 'package:nonogram/screens/dashboard/dashboard_navigation.dart';

import 'check_in_service.dart';
import 'reward_view.dart';

CheckInService? _service(BuildContext context, {bool listen = false}) {
  try {
    return listen
        ? context.watch<CheckInService>()
        : context.read<CheckInService>();
  } on ProviderNotFoundException {
    return null;
  }
}

/// Thẻ nhắc trên trang chính: người mua gói còn lượt trong ngày chưa dùng.
class DailyUsesReminder extends StatelessWidget {
  const DailyUsesReminder({super.key});

  @override
  Widget build(BuildContext context) {
    if (_service(context, listen: true) == null) return const SizedBox.shrink();
    return PowerUpsBuilder(
      builder: (context, inv, now) {
        if (inv == null || !inv.hasDaily) return const SizedBox.shrink();
        final l10n = context.l10n;
        final yellow = rewardColor(context, daily: true);
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Card(
            key: const ValueKey('dashboard-daily-reminder'),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(LucideIcons.hourglass, color: yellow),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          l10n.dashboardDailyReminderTitle,
                          style: context.titleSmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.dashboardDailyReminder(
                      context.dailyLeftLabel(inv),
                      context.timeLeft(now, endOfTodayOf(context, now)),
                    ),
                    style: context.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: BlocBuilder<
                      NonogramDashboardBloc,
                      NonogramDashboardState
                    >(
                      builder:
                          (context, state) => FilledButton.icon(
                            onPressed:
                                state.isLoading || state.isCampaignComplete
                                    ? null
                                    : () => openFromDashboard(
                                      context,
                                      NonogramPlayIntent(
                                        initialLevel: state.currentLevel,
                                      ),
                                    ),
                            icon: const Icon(LucideIcons.play),
                            label: Text(l10n.dashboardDailyReminderPlay),
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/context_ext.dart';

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

/// Dải nhắc trên trang chính: người mua gói còn lượt trong ngày chưa dùng.
/// Chỉ là một dòng chữ trên nền vàng nhạt (màu của lượt có thời hạn).
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
          child: Container(
            key: const ValueKey('dashboard-daily-reminder'),
            padding: const EdgeInsets.fromLTRB(12, 10, 14, 10),
            decoration: BoxDecoration(
              color: yellow.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: yellow.withValues(alpha: 0.35)),
            ),
            child: Row(
              children: [
                Icon(LucideIcons.clock, color: yellow, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.dashboardDailyReminder(
                      context.dailyLeftLabel(inv),
                      context.timeLeft(now, endOfTodayOf(context, now)),
                    ),
                    style: context.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

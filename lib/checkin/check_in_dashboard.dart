import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/app_route_intent.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/screens/dashboard/bloc/nonogram_dashboard_bloc.dart';
import 'package:nonogram/screens/dashboard/bloc/nonogram_dashboard_state.dart';
import 'package:nonogram/screens/dashboard/dashboard_navigation.dart';

import 'check_in_page.dart';
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

/// Nút điểm danh trên thanh tiêu đề trang chính, có chấm đỏ khi hôm nay
/// chưa điểm danh. Không có điểm danh (test) thì ẩn.
class CheckInButton extends StatelessWidget {
  const CheckInButton({super.key});

  @override
  Widget build(BuildContext context) {
    final service = _service(context, listen: true);
    if (service == null) return const SizedBox.shrink();
    return IconButton(
      key: const ValueKey('dashboard-check-in'),
      onPressed: () => openCheckIn(context),
      tooltip: context.l10n.checkInTitle,
      icon: Badge(
        isLabelVisible: service.canCheckIn,
        smallSize: 9,
        child: const Icon(LucideIcons.calendarCheck),
      ),
    );
  }
}

/// Tự mở màn điểm danh lần đầu mỗi ngày (khi còn điểm danh được). Gắn vào
/// trang chính; [enabled] = false khi trang chính đang mở bài hướng dẫn.
class CheckInAutoOpener extends StatefulWidget {
  const CheckInAutoOpener({
    super.key,
    required this.enabled,
    required this.child,
  });

  final bool enabled;
  final Widget child;

  @override
  State<CheckInAutoOpener> createState() => _CheckInAutoOpenerState();
}

class _CheckInAutoOpenerState extends State<CheckInAutoOpener> {
  CheckInService? _checkIn;
  bool _opening = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final service = _service(context);
    if (service != _checkIn) {
      _checkIn?.removeListener(_maybeOpen);
      _checkIn = service?..addListener(_maybeOpen);
      WidgetsBinding.instance.addPostFrameCallback((_) => _maybeOpen());
    }
  }

  @override
  void dispose() {
    _checkIn?.removeListener(_maybeOpen);
    super.dispose();
  }

  Future<void> _maybeOpen() async {
    final service = _checkIn;
    if (!mounted || !widget.enabled || _opening || service == null) return;
    if (!service.shouldAutoOpen) return;
    // Chỉ mở khi trang chính đang ở trên cùng (không chen vào giữa ván).
    if (ModalRoute.of(context)?.isCurrent != true) return;
    _opening = true;
    await service.markAutoOpened();
    if (mounted) await openCheckIn(context);
    _opening = false;
  }

  @override
  Widget build(BuildContext context) => widget.child;
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

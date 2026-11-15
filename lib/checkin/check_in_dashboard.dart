import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/models/power_up_inventory.dart';

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
        final yellow = rewardColor(context, daily: true);
        final background = yellow.withValues(alpha: 0.12);
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Container(
            key: const ValueKey('dashboard-daily-reminder'),
            padding: const EdgeInsets.fromLTRB(12, 10, 14, 10),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: yellow.withValues(alpha: 0.35)),
            ),
            child: Row(
              children: [
                Icon(LucideIcons.clock, color: yellow, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text.rich(
                    _reminderText(
                      context,
                      inv,
                      now,
                      // Nền thật sau icon (banner trong suốt trên nền trang).
                      Color.alphaBlend(background, context.color.surface),
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

/// "Bạn còn 2 gợi ý [icon] và 1 gậy phép [icon] sẽ hết hạn sau …": chuỗi
/// dịch có chỗ trống cho phần quà; mỗi loại quà được thay bằng số lượng kèm
/// icon lượt có hạn (vàng, có đồng hồ) nằm ngay trong câu.
TextSpan _reminderText(
  BuildContext context,
  PowerUpInventory inv,
  DateTime now,
  Color background,
) {
  final l10n = context.l10n;
  // Ký tự riêng (vùng Private Use) đánh dấu chỗ đặt từng loại quà.
  const hintMark = '\uE000';
  const wandMark = '\uE001';
  final hasHints = inv.dailyHints > 0;
  final hasWands = inv.dailyWands > 0;
  final rewards =
      hasHints && hasWands
          ? l10n.dashboardDailyReminderBoth(hintMark, wandMark)
          : (hasHints ? hintMark : wandMark);
  final message = l10n.dashboardDailyReminder(
    rewards,
    context.timeLeft(now, endOfTodayOf(context, now)),
  );

  InlineSpan reward(PowerUp powerUp, String label) => TextSpan(
    children: [
      TextSpan(text: '$label '),
      WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: PowerUpGlyph(
          powerUp: powerUp,
          timeLimited: true,
          size: 16,
          background: background,
        ),
      ),
    ],
  );

  final spans = <InlineSpan>[];
  final buffer = StringBuffer();
  for (final rune in message.runes) {
    final char = String.fromCharCode(rune);
    if (char != hintMark && char != wandMark) {
      buffer.write(char);
      continue;
    }
    if (buffer.isNotEmpty) {
      spans.add(TextSpan(text: buffer.toString()));
      buffer.clear();
    }
    spans.add(
      char == hintMark
          ? reward(PowerUp.hint, l10n.rewardHints(inv.dailyHints))
          : reward(PowerUp.wand, l10n.rewardWands(inv.dailyWands)),
    );
  }
  if (buffer.isNotEmpty) spans.add(TextSpan(text: buffer.toString()));
  return TextSpan(children: spans);
}

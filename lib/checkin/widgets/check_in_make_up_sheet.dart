import 'package:flutter/material.dart';
import 'package:nonogram/core/context_ext.dart';

import 'check_in_colors.dart';

/// Hỏi lại trước khi phát quảng cáo bù ngày.
class CheckInMakeUpSheet extends StatelessWidget {
  const CheckInMakeUpSheet({super.key, required this.date});

  final String date;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final missed = checkInMissedColor(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: missed.withValues(alpha: 0.16),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.play_arrow_rounded, color: missed, size: 32),
            ),
            const SizedBox(height: 14),
            Text(
              l10n.checkInMakeUpTitle(date),
              textAlign: TextAlign.center,
              style: context.titleLarge.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.checkInMakeUpBody,
              textAlign: TextAlign.center,
              style: context.bodyMedium.copyWith(
                color: context.color.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                key: const ValueKey('check-in-make-up-watch'),
                onPressed: () => Navigator.of(context).pop(true),
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(l10n.checkInMakeUpWatch),
              ),
            ),
            const SizedBox(height: 6),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.commonCancel),
            ),
          ],
        ),
      ),
    );
  }
}

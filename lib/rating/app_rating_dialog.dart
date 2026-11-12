import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/core/toast_utils.dart';
import 'package:nonogram/widgets/dialogs/app_dialog.dart';
import 'package:provider/provider.dart';

import 'app_rating.dart';

/// Hỏi đánh giá nếu đến lúc (xem `RatingPolicy`). Trả về true nếu đã hiện
/// lời mời, để lần này không hiện thêm quảng cáo xen kẽ.
Future<bool> maybeAskForRating(BuildContext context, int solvedLevels) async {
  final AppRatingController rating;
  try {
    rating = context.read<AppRatingController>();
  } on ProviderNotFoundException {
    return false; // iOS, web, test: không có lời mời.
  }
  if (!rating.shouldPrompt(solvedLevels)) return false;

  await rating.recordPrompt(solvedLevels);
  if (!context.mounted) return true;
  final thanks = context.l10n.ratingThanks;
  final stars = await showDialog<int>(
    context: context,
    builder: (_) => const AppRatingDialog(),
  );
  if (stars == null) return true; // Để sau.

  await rating.submit(stars);
  if (stars < AppRatingController.storeStars) {
    ToastUtils.success(title: thanks);
  }
  return true;
}

/// Hộp thoại chọn 1–5 sao. Trả về số sao, hoặc null nếu "Để sau".
class AppRatingDialog extends StatefulWidget {
  const AppRatingDialog({super.key});

  @override
  State<AppRatingDialog> createState() => _AppRatingDialogState();
}

class _AppRatingDialogState extends State<AppRatingDialog> {
  int _stars = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.color;
    return AppDialog(
      title: Text(l10n.ratingTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.ratingMessage,
            style: context.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 1; i <= 5; i++)
                IconButton(
                  key: ValueKey('rating-star-$i'),
                  tooltip: l10n.ratingStarLabel(i),
                  onPressed: () => setState(() => _stars = i),
                  icon: AnimatedScale(
                    scale: i <= _stars ? 1.15 : 1,
                    duration: const Duration(milliseconds: 150),
                    child: Icon(
                      i <= _stars
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      size: 36,
                      color:
                          i <= _stars
                              ? const Color(0xFFFFB400)
                              : colors.outline,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          key: const ValueKey('rating-later'),
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.ratingLater),
        ),
        FilledButton.icon(
          key: const ValueKey('rating-submit'),
          onPressed: _stars == 0 ? null : () => Navigator.pop(context, _stars),
          icon: const Icon(LucideIcons.send, size: 18),
          label: Text(l10n.ratingSubmit),
        ),
      ],
    );
  }
}

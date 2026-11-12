import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/ads/ad_scope.dart';
import 'package:nonogram/ads/ad_service.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/core/toast_utils.dart';
import 'package:nonogram/widgets/dialogs/app_dialog.dart';

import '../bloc/nonogram_play_bloc.dart';
import '../bloc/nonogram_play_event.dart';
import '../nonogram_transformation_controller_provider.dart';

/// Hết lượt gợi ý / gậy phép: hỏi người chơi có muốn xem quảng cáo để nhận
/// thêm lượt không. Xem đủ thì cộng lượt vào màn đang chơi.
Future<void> offerRewardedAd(BuildContext context, AdReward reward) async {
  final ads = context.ads;
  if (!ads.isEnabled) return;
  final bloc = context.read<NonogramPlayBloc>();
  final controller = NonogramTransformationControllerProvider.of(context);
  final l10n = context.l10n;

  final watch = await showDialog<bool>(
    context: context,
    builder: (_) => _RewardedOfferDialog(ads: ads, reward: reward),
  );
  if (watch != true) return;

  final earned = await ads.showRewarded();
  if (!earned || bloc.isClosed) return;
  final t = controller.value.getTranslation();
  bloc.add(RewardGranted(reward: reward, offsetX: t.x, offsetY: t.y));
  ToastUtils.success(
    title: switch (reward) {
      AdReward.hint => l10n.adRewardHintGranted,
      AdReward.wand => l10n.adRewardWandGranted,
    },
  );
}

class _RewardedOfferDialog extends StatelessWidget {
  const _RewardedOfferDialog({required this.ads, required this.reward});

  final AdService ads;
  final AdReward reward;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppDialog(
      title: Text(switch (reward) {
        AdReward.hint => l10n.adRewardHintTitle,
        AdReward.wand => l10n.adRewardWandTitle,
      }),
      content: ValueListenableBuilder<bool>(
        valueListenable: ads.rewardedReady,
        builder:
            (context, ready, _) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.adRewardMessage, style: context.bodyMedium),
                if (!ready) ...[
                  const SizedBox(height: 12),
                  Text(
                    l10n.adRewardNotReady,
                    style: context.bodySmall.copyWith(
                      color: context.color.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.commonCancel),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: ads.rewardedReady,
          builder:
              (context, ready, _) => FilledButton.icon(
                key: const ValueKey('nonogram-watch-ad'),
                onPressed: ready ? () => Navigator.pop(context, true) : null,
                icon: const Icon(LucideIcons.play, size: 18),
                label: Text(l10n.adRewardWatch),
              ),
        ),
      ],
    );
  }
}

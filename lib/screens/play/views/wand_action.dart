import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/ads/ad_scope.dart';
import 'package:nonogram/ads/ad_service.dart';
import 'package:nonogram/core/context_ext.dart';

import '../bloc/nonogram_play_bloc.dart';
import '../bloc/nonogram_play_event.dart';
import '../bloc/nonogram_play_state.dart';
import '../widgets/overlay_button.dart';
import 'rewarded_offer.dart';

/// Gậy phép: bật chế độ chọn, rồi chạm vào dãy số của một hàng / cột để
/// hiện đáp án của đúng hàng / cột đó (khác nút gợi ý tự chọn hàng).
/// Số lượt còn lại hiện thành huy hiệu nhỏ.
class WandAction extends StatelessWidget {
  const WandAction({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NonogramPlayBloc, NonogramPlayState>(
      buildWhen:
          (p, c) =>
              p.remainingWands != c.remainingWands ||
              p.isWandActive != c.isWandActive ||
              p.isSolved != c.isSolved,
      builder: (context, state) {
        final colors = context.color;
        // Hết lượt mà có quảng cáo: nút vẫn bấm được, để xem quảng cáo lấy
        // thêm lượt.
        final adOffer =
            !state.isWandActive &&
            state.remainingWands <= 0 &&
            context.ads.isEnabled;
        final enabled =
            !state.isSolved &&
            (state.isWandActive || state.remainingWands > 0 || adOffer);
        return Tooltip(
          message: context.l10n.nonogramPlayWandLabel,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              OverlayButton(
                key: const ValueKey('nonogram-wand'),
                icon: LucideIcons.wand2,
                color: state.isWandActive ? colors.primary : null,
                enabled: enabled,
                onPressed: () {
                  if (adOffer) {
                    offerRewardedAd(context, AdReward.wand);
                    return;
                  }
                  context.read<NonogramPlayBloc>().add(const WandToggled());
                },
              ),
              Positioned(
                right: -4,
                top: -4,
                child: IgnorePointer(
                  child: CountBadge(
                    count: state.remainingWands,
                    active: state.remainingWands > 0,
                    adOffer: adOffer,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Huy hiệu số lượt còn lại ở góc nút.
class CountBadge extends StatelessWidget {
  const CountBadge({
    super.key,
    required this.count,
    required this.active,
    this.adOffer = false,
  });

  final int count;
  final bool active;

  /// Hết lượt nhưng xem quảng cáo được: hiện biểu tượng phát video thay cho
  /// số 0.
  final bool adOffer;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 16),
      height: 16,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color:
            active || adOffer ? context.color.primary : context.color.outline,
        borderRadius: BorderRadius.circular(8),
      ),
      child:
          adOffer
              ? Icon(LucideIcons.play, size: 9, color: context.color.onPrimary)
              : Text(
                '$count',
                style: context.labelSmall.copyWith(
                  fontSize: 10,
                  height: 1,
                  fontWeight: FontWeight.w800,
                  color: context.color.onPrimary,
                ),
              ),
    );
  }
}

/// Dải hướng dẫn khi đang chọn hàng / cột cho gậy phép, kèm nút huỷ.
class WandSelectBanner extends StatelessWidget {
  const WandSelectBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    return Material(
      color: colors.primaryContainer,
      elevation: 3,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 6, 6, 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.wand2, size: 18, color: colors.onPrimaryContainer),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                context.l10n.nonogramPlayWandSelectPrompt,
                style: context.labelLarge.copyWith(
                  color: colors.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(width: 4),
            TextButton(
              key: const ValueKey('nonogram-wand-cancel'),
              style: TextButton.styleFrom(
                foregroundColor: colors.onPrimaryContainer,
                // Giữ font của theme, chỉ đậm hơn.
                textStyle: context.labelLarge.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              onPressed:
                  () =>
                      context.read<NonogramPlayBloc>().add(const WandToggled()),
              child: Text(context.l10n.commonCancel),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:nonogram/models/power_up_inventory.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../bloc/nonogram_play_bloc.dart';
import '../bloc/nonogram_play_event.dart';
import '../bloc/nonogram_play_state.dart';
import '../nonogram_transformation_controller_provider.dart';
import '../widgets/overlay_button.dart';
import 'rewarded_offer.dart';
import 'wand_action.dart';

class HintAction extends StatelessWidget {
  const HintAction({super.key, this.compact = false});

  /// Nút vuông, số lượt còn lại hiện thành huy hiệu nhỏ (cột nút hẹp khi
  /// màn ngang).
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NonogramPlayBloc, NonogramPlayState>(
      buildWhen:
          (p, c) =>
              p.remainingHints != c.remainingHints ||
              p.dailyHints != c.dailyHints ||
              p.isSolved != c.isSolved,
      builder: (context, state) {
        final l10n = context.l10n;
        // Hết lượt: nút vẫn bấm được, bấm là xem quảng cáo để dùng một lượt.
        final adOffer = state.remainingHints <= 0;
        final button = OverlayButton(
          icon: LucideIcons.lightbulb,
          label:
              compact ? null : l10n.nonogramPlayHintLabel(state.remainingHints),
          enabled: !state.isSolved,
          onPressed: () {
            if (adOffer) {
              usePowerUpWithAd(context, PowerUp.hint);
              return;
            }
            final controller = NonogramTransformationControllerProvider.of(
              context,
            );
            final translation = controller.value.getTranslation();
            context.read<NonogramPlayBloc>().add(
              HintRequested(offsetX: translation.x, offsetY: translation.y),
            );
          },
        );
        // Nút rộng đã ghi số lượt; chỉ thêm badge khi hết lượt hoặc có lượt
        // trong ngày (badge vàng).
        if (!compact && !adOffer && state.dailyHints == 0) return button;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            button,
            Positioned(
              right: -4,
              top: -4,
              child: IgnorePointer(
                child: CountBadge(
                  count: state.remainingHints,
                  active: state.remainingHints > 0,
                  adOffer: adOffer,
                  daily: state.dailyHints > 0,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

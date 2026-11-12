import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nonogram/ads/ad_scope.dart';
import 'package:nonogram/ads/ad_service.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/core/toast_utils.dart';
import 'package:nonogram/models/power_up_inventory.dart';

import '../bloc/nonogram_play_bloc.dart';
import '../bloc/nonogram_play_event.dart';
import '../nonogram_transformation_controller_provider.dart';

extension on PowerUp {
  AdPlacement get placement => switch (this) {
    PowerUp.hint => AdPlacement.hintRefill,
    PowerUp.wand => AdPlacement.wandRefill,
  };
}

bool _showing = false;

/// Kho [powerUp] đã hết: phát ngay quảng cáo có thưởng, xem xong thì dùng luôn
/// một lượt. Bản không có quảng cáo (web, iOS) cho dùng miễn phí.
Future<void> usePowerUpWithAd(BuildContext context, PowerUp powerUp) async {
  if (_showing) return;
  final bloc = context.read<NonogramPlayBloc>();
  final controller = NonogramTransformationControllerProvider.of(context);
  final l10n = context.l10n;
  final ads = context.ads;

  // Không bắt xem quảng cáo cho một gợi ý không mở được ô nào.
  if (powerUp == PowerUp.hint && !bloc.hasHintCells) {
    ToastUtils.info(title: l10n.nonogramPlayHintNothingToFill);
    return;
  }

  void grant() {
    if (bloc.isClosed) return;
    final t = controller.value.getTranslation();
    bloc.add(RewardGranted(powerUp: powerUp, offsetX: t.x, offsetY: t.y));
  }

  if (!ads.isEnabled) {
    grant();
    return;
  }
  if (!ads.isReady(powerUp.placement)) {
    ToastUtils.warning(title: l10n.adRewardNotReady);
    return;
  }

  _showing = true;
  try {
    if (await ads.showRewarded(powerUp.placement)) grant();
  } finally {
    _showing = false;
  }
}

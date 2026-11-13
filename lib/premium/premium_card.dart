import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/core/toast_utils.dart';
import 'package:provider/provider.dart';

import 'premium_controller.dart';
import 'purchase_gateway.dart';

/// Thẻ "Chơi không quảng cáo" trên trang chính: chưa mua thì mời mua kèm
/// giá, đã mua thì báo gói đang hoạt động. Không có cửa hàng (web, iOS, test)
/// thì không hiện.
class PremiumCard extends StatelessWidget {
  const PremiumCard({super.key});

  @override
  Widget build(BuildContext context) {
    final PremiumController premium;
    try {
      premium = context.watch<PremiumController>();
    } on ProviderNotFoundException {
      return const SizedBox.shrink();
    }
    if (premium.isPremium) return const _ActiveCard();
    if (!premium.canPurchase) return const SizedBox.shrink();
    return _OfferCard(premium: premium);
  }
}

class _OfferCard extends StatelessWidget {
  const _OfferCard({required this.premium});

  final PremiumController premium;

  Future<void> _buy(BuildContext context) async {
    final l10n = context.l10n;
    final outcome = await premium.buy();
    switch (outcome) {
      case PurchaseOutcome.purchased:
        ToastUtils.success(title: l10n.premiumPurchased);
      case PurchaseOutcome.pending:
        ToastUtils.info(title: l10n.premiumPending);
      case PurchaseOutcome.failed:
      case PurchaseOutcome.unavailable:
        ToastUtils.error(title: l10n.premiumFailed);
      case PurchaseOutcome.cancelled:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final game = context.gameColors;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(LucideIcons.crown, color: game.reward),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(l10n.premiumTitle, style: context.titleMedium),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _Benefit(icon: LucideIcons.ban, text: l10n.premiumBenefitNoAds),
            const SizedBox(height: 6),
            _Benefit(icon: LucideIcons.gift, text: l10n.premiumBenefitDaily),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                key: const ValueKey('premium-buy'),
                onPressed: premium.isBusy ? null : () => _buy(context),
                child:
                    premium.isBusy
                        ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : Text(l10n.premiumBuy(premium.price ?? '')),
              ),
            ),
            const SizedBox(height: 6),
            Center(
              child: Text(
                l10n.premiumOneTime,
                style: context.bodySmall.copyWith(
                  color: context.color.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Benefit extends StatelessWidget {
  const _Benefit({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: context.color.primary),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: context.bodyMedium)),
      ],
    );
  }
}

class _ActiveCard extends StatelessWidget {
  const _ActiveCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Card(
      key: const ValueKey('premium-active'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(LucideIcons.crown, color: context.gameColors.reward),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.premiumActiveTitle, style: context.titleSmall),
                  const SizedBox(height: 2),
                  Text(
                    l10n.premiumActiveDaily,
                    style: context.bodySmall.copyWith(
                      color: context.color.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

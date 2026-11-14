import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/checkin/reward_view.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/models/power_up_inventory.dart';
import 'package:provider/provider.dart';

import 'premium_controller.dart';

/// Trang giải thích quyền lợi gói "Chơi không quảng cáo": đặc quyền nhận
/// được, hai vật phẩm hỗ trợ (gợi ý / gậy phép) và sự khác nhau giữa lượt có
/// thời hạn (icon vàng kèm đồng hồ) và lượt vĩnh viễn, cùng thứ tự app tiêu
/// lượt. Mở từ nút "Xem chi tiết quyền lợi" trên thẻ gói.
class PremiumBenefitsPage extends StatelessWidget {
  const PremiumBenefitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    String? price;
    try {
      price = context.watch<PremiumController>().price;
    } on ProviderNotFoundException {
      price = null;
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.premiumBenefitsTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        children: [
          _Hero(price: price),
          const SizedBox(height: 22),
          _SectionTitle(l10n.premiumWhatYouGet),
          const SizedBox(height: 10),
          const _PerksCard(),
          const SizedBox(height: 22),
          _SectionTitle(l10n.premiumItemsTitle),
          const SizedBox(height: 10),
          _ItemCard(
            powerUp: PowerUp.hint,
            name: l10n.powerUpHintName,
            tagline: l10n.powerUpHintTagline,
            description: l10n.powerUpHintDesc,
          ),
          const SizedBox(height: 12),
          _ItemCard(
            powerUp: PowerUp.wand,
            name: l10n.powerUpWandName,
            tagline: l10n.powerUpWandTagline,
            description: l10n.powerUpWandDesc,
          ),
          const SizedBox(height: 22),
          _SectionTitle(l10n.powerUpStatesTitle),
          const SizedBox(height: 10),
          const _StatesCard(),
          const SizedBox(height: 22),
          _SectionTitle(l10n.powerUpSpendOrderTitle),
          const SizedBox(height: 10),
          const _SpendOrderCard(),
          const SizedBox(height: 14),
          Text(
            l10n.premiumBenefitsFootnote,
            textAlign: TextAlign.center,
            style: context.bodySmall.copyWith(
              color: context.color.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text.toUpperCase(),
        style: context.labelLarge.copyWith(
          color: context.color.onSurfaceVariant,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.price});

  final String? price;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final game = context.gameColors;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [game.heroStart, game.heroEnd],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(LucideIcons.crown, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.premiumTitle,
            style: context.titleLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.premiumBenefitsTagline,
            style: context.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          if (price != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: price,
                      style: context.titleSmall.copyWith(
                        color: game.heroStart,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextSpan(
                      text: '  ·  ${l10n.premiumBenefitsOneTime}',
                      style: context.bodySmall.copyWith(
                        color: game.heroStart.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PerksCard extends StatelessWidget {
  const _PerksCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final game = context.gameColors;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _Perk(
              icon: LucideIcons.ban,
              tint: context.color.primary,
              title: l10n.premiumPerkNoAdsTitle,
              body: l10n.premiumPerkNoAdsBody,
            ),
            const SizedBox(height: 16),
            _Perk(
              icon: LucideIcons.gift,
              tint: game.reward,
              title: l10n.premiumPerkDailyTitle,
              body: l10n.premiumPerkDailyBody,
            ),
          ],
        ),
      ),
    );
  }
}

class _Perk extends StatelessWidget {
  const _Perk({
    required this.icon,
    required this.tint,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final Color tint;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: tint.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: tint, size: 22),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: context.titleSmall),
              const SizedBox(height: 2),
              Text(
                body,
                style: context.bodySmall.copyWith(
                  color: context.color.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({
    required this.powerUp,
    required this.name,
    required this.tagline,
    required this.description,
  });

  final PowerUp powerUp;
  final String name;
  final String tagline;
  final String description;

  @override
  Widget build(BuildContext context) {
    final tint =
        powerUp == PowerUp.hint
            ? context.gameColors.reward
            : context.color.primary;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: tint.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(powerUpIcon(powerUp), color: tint, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: context.titleSmall),
                      const SizedBox(height: 1),
                      Text(
                        tagline,
                        style: context.bodySmall.copyWith(
                          color: context.color.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: context.bodyMedium.copyWith(
                color: context.color.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Minh hoạ hai trạng thái của vật phẩm: có thời hạn (icon vàng + đồng hồ)
/// và vĩnh viễn (icon thường + huy hiệu xanh).
class _StatesCard extends StatelessWidget {
  const _StatesCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final game = context.gameColors;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.powerUpStatesLead,
              style: context.bodyMedium.copyWith(
                color: context.color.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _StateColumn(
                    timeLimited: true,
                    accent: game.reward,
                    label: l10n.powerUpTimeLimited,
                    description: l10n.powerUpTimeLimitedDesc,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StateColumn(
                    timeLimited: false,
                    accent: context.color.primary,
                    label: l10n.powerUpPermanent,
                    description: l10n.powerUpPermanentDesc,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StateColumn extends StatelessWidget {
  const _StateColumn({
    required this.timeLimited,
    required this.accent,
    required this.label,
    required this.description,
  });

  final bool timeLimited;
  final Color accent;
  final String label;
  final String description;

  @override
  Widget build(BuildContext context) {
    final badgeCounts = timeLimited ? [2, 1] : [3, 1];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: context.color.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _MiniButton(
                powerUp: PowerUp.hint,
                timeLimited: timeLimited,
                badgeColor: accent,
                count: badgeCounts[0],
              ),
              const SizedBox(width: 12),
              _MiniButton(
                powerUp: PowerUp.wand,
                timeLimited: timeLimited,
                badgeColor: accent,
                count: badgeCounts[1],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 7),
              Text(label, style: context.titleSmall.copyWith(color: accent)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            description,
            textAlign: TextAlign.center,
            style: context.bodySmall.copyWith(
              color: context.color.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// Nút vật phẩm thu nhỏ (kiểu nút trong màn chơi) với huy hiệu số lượt.
class _MiniButton extends StatelessWidget {
  const _MiniButton({
    required this.powerUp,
    required this.timeLimited,
    required this.badgeColor,
    required this.count,
  });

  final PowerUp powerUp;
  final bool timeLimited;
  final Color badgeColor;
  final int count;

  @override
  Widget build(BuildContext context) {
    final onBadge =
        timeLimited ? const Color(0xFF2B1A00) : context.color.onPrimary;
    final surface = context.color.surface;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: context.gameColors.cardBorder),
          ),
          alignment: Alignment.center,
          child: PowerUpGlyph(
            powerUp: powerUp,
            timeLimited: timeLimited,
            size: 22,
            background: surface,
          ),
        ),
        Positioned(
          right: -6,
          top: -6,
          child: Container(
            constraints: const BoxConstraints(minWidth: 18),
            height: 18,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: surface, width: 2),
            ),
            child: Text(
              '$count',
              style: context.labelSmall.copyWith(
                fontSize: 10,
                height: 1,
                fontWeight: FontWeight.w800,
                color: onBadge,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SpendOrderCard extends StatelessWidget {
  const _SpendOrderCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final game = context.gameColors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: game.reward.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: game.reward.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.clock, color: game.reward, size: 20),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  l10n.powerUpSpendOrderHeading,
                  style: context.titleSmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Text(
            l10n.powerUpSpendOrderBody,
            style: context.bodySmall.copyWith(
              color: context.color.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              _FlowChip(label: l10n.powerUpSpendDaily, color: game.reward),
              const SizedBox(width: 8),
              Icon(
                LucideIcons.arrowRight,
                size: 18,
                color: context.color.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              _FlowChip(
                label: l10n.powerUpSpendPermanent,
                color: context.color.onSurfaceVariant,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FlowChip extends StatelessWidget {
  const _FlowChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: context.color.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: context.gameColors.cardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: context.labelLarge.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

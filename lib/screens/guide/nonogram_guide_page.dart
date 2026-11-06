import 'package:nonogram/core/app_route_intent.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/screens/guide/illustrations/guide_illustration_card.dart';
import 'package:nonogram/screens/guide/illustrations/guide_nonogram_illustration.dart';
import 'package:nonogram/screens/guide/models/guide_diagrams.dart';
import 'package:nonogram/screens/guide/models/nonogram_guide_item.dart';
import 'package:nonogram/screens/painters/nonogram_illustration_painter.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class NonogramGuidePage extends StatelessWidget {
  const NonogramGuidePage({super.key});

  Color _clueBackgroundColor(BuildContext context) {
    return context.gameColors.clueBackground;
  }

  List<NonogramGuideItem> _guideItems(BuildContext context) {
    final l10n = context.l10n;

    return [
      NonogramGuideItem(
        title: _normalizedTitle(
          l10n.nonogramGuideMethodSuperpositionSimpleTitle,
        ),
        description: l10n.nonogramGuideMethodSuperpositionSimpleDesc,
        diagrams: GuideDiagrams.superpositionSimple,
      ),
      NonogramGuideItem(
        title: _normalizedTitle(
          l10n.nonogramGuideMethodSuperpositionMultiTitle,
        ),
        description: l10n.nonogramGuideMethodSuperpositionMultiDesc,
        diagrams: GuideDiagrams.superpositionMulti,
      ),
      NonogramGuideItem(
        title: _normalizedTitle(l10n.nonogramGuideMethodWallPushingTitle),
        description: l10n.nonogramGuideMethodWallPushingDesc,
        diagrams: GuideDiagrams.wallPushing,
      ),
      NonogramGuideItem(
        title: _normalizedTitle(l10n.nonogramGuideMethodInaccessibilityTitle),
        description: l10n.nonogramGuideMethodInaccessibilityDesc,
        diagrams: GuideDiagrams.inaccessibility,
      ),
      NonogramGuideItem(
        title: _normalizedTitle(l10n.nonogramGuideMethodNotFitTitle),
        description: l10n.nonogramGuideMethodNotFitDesc,
        diagrams: GuideDiagrams.notFit,
      ),
      NonogramGuideItem(
        title: _normalizedTitle(l10n.nonogramGuideMethodDivisionTitle),
        description: l10n.nonogramGuideMethodDivisionDesc,
        diagrams: GuideDiagrams.division,
      ),
      NonogramGuideItem(
        title: _normalizedTitle(l10n.nonogramGuideMethodDoublePositioningTitle),
        description: l10n.nonogramGuideMethodDoublePositioningDesc,
        diagrams: GuideDiagrams.doublePositioning,
      ),
    ];
  }

  String _normalizedTitle(String title) {
    return title.replaceFirst(RegExp(r'^\d+\.\s*'), '');
  }

  @override
  Widget build(BuildContext context) {
    final guideItems = _guideItems(context);

    return Scaffold(
      backgroundColor: context.color.surface,
      appBar: AppBar(
        title: Text(context.l10n.nonogramGuideTitle),
        backgroundColor: context.color.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.nonogramGuideIntro, style: context.bodyMedium),
            const SizedBox(height: 20),
            const _TutorialEntryCard(),
            const SizedBox(height: 32),
            _GuideSection(
              title: context.l10n.nonogramGuideRuleTitle,
              description: context.l10n.nonogramGuideRuleDesc,
              examples: [
                _basicRuleIllustration(context),
                const SizedBox(height: 16),
                _basicRuleWideGapIllustration(context),
              ],
            ),
            ...List.generate(guideItems.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: GuideIllustrationCard(
                  number: index + 1,
                  item: guideItems[index],
                ),
              );
            }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _basicRuleIllustration(BuildContext context) {
    return GuideNonogramIllustration(
      clues: const [3, 1],
      rows: [
        NonogramIllustrationRow.fromIndices(length: 8, filled: [0, 1, 2, 4]),
      ],
      filledColor: context.color.primary,
      markerColor: context.color.error,
      lineColor: context.color.outlineVariant,
      textColor: context.color.onSurface,
      clueBackgroundColor: _clueBackgroundColor(context),
    );
  }

  Widget _basicRuleWideGapIllustration(BuildContext context) {
    return GuideNonogramIllustration(
      clues: const [2, 2],
      rows: [
        NonogramIllustrationRow.fromIndices(length: 9, filled: [0, 1, 5, 6]),
      ],
      filledColor: context.color.primary,
      markerColor: context.color.error,
      lineColor: context.color.outlineVariant,
      textColor: context.color.onSurface,
      clueBackgroundColor: _clueBackgroundColor(context),
    );
  }
}

class _GuideSection extends StatelessWidget {
  const _GuideSection({
    required this.title,
    required this.description,
    required this.examples,
  });

  final String title;
  final String description;
  final List<Widget> examples;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.titleSmall.copyWith(color: context.color.primary),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: context.bodyMedium.copyWith(
              color: context.color.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          ...examples,
        ],
      ),
    );
  }
}

/// Lối vào bài hướng dẫn tương tác, đặt trước phần lý thuyết.
class _TutorialEntryCard extends StatelessWidget {
  const _TutorialEntryCard();

  @override
  Widget build(BuildContext context) {
    final colors = context.color;

    return Material(
      color: colors.primaryContainer,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        key: const ValueKey('nonogram-guide-tutorial-card'),
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.navigate(const NonogramTutorialIntent()),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.touch_app, color: colors.onPrimary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.nonogramGuideTutorialCardTitle,
                      style: context.titleSmall.copyWith(
                        color: colors.onPrimaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      context.l10n.nonogramGuideTutorialCardDesc,
                      style: context.bodySmall.copyWith(
                        color: colors.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(LucideIcons.chevronRight, color: colors.onPrimaryContainer),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/screens/guide/illustrations/guide_illustration_card.dart';
import 'package:nonogram/screens/guide/illustrations/guide_nonogram_illustration.dart';
import 'package:nonogram/screens/guide/models/nonogram_guide_item.dart';
import 'package:nonogram/screens/painters/nonogram_illustration_painter.dart';
import 'package:flutter/material.dart';

class NonogramGuidePage extends StatelessWidget {
  const NonogramGuidePage({super.key});

  Color _clueBackgroundColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final overlay = context.color.onSurface.withValues(
      alpha: isDark ? 0.14 : 0.06,
    );
    return Color.alphaBlend(overlay, context.color.surface);
  }

  List<NonogramGuideItem> _guideItems(BuildContext context) {
    final l10n = context.l10n;

    return [
      NonogramGuideItem(
        title: _normalizedTitle(
          l10n.nonogramGuideMethodSuperpositionSimpleTitle,
        ),
        description: l10n.nonogramGuideMethodSuperpositionSimpleDesc,
        imagePaths: ['assets/guide/solution_methods_p1 (1).png'],
      ),
      NonogramGuideItem(
        title: _normalizedTitle(
          l10n.nonogramGuideMethodSuperpositionMultiTitle,
        ),
        description: l10n.nonogramGuideMethodSuperpositionMultiDesc,
        imagePaths: ['assets/guide/solution_methods_p1.png'],
      ),
      NonogramGuideItem(
        title: _normalizedTitle(l10n.nonogramGuideMethodWallPushingTitle),
        description: l10n.nonogramGuideMethodWallPushingDesc,
        imagePaths: [
          'assets/guide/solution_methods_p2.png',
          'assets/guide/solution_methods_p2 (1).png',
        ],
      ),
      NonogramGuideItem(
        title: _normalizedTitle(l10n.nonogramGuideMethodInaccessibilityTitle),
        description: l10n.nonogramGuideMethodInaccessibilityDesc,
        imagePaths: [
          'assets/guide/solution_methods_p3.png',
          'assets/guide/solution_methods_p3 (1).png',
          'assets/guide/solution_methods_p3 (2).png',
        ],
      ),
      NonogramGuideItem(
        title: _normalizedTitle(l10n.nonogramGuideMethodNotFitTitle),
        description: l10n.nonogramGuideMethodNotFitDesc,
        imagePaths: [
          'assets/guide/solution_methods_p4.png',
          'assets/guide/solution_methods_p4 (1).png',
          'assets/guide/solution_methods_p4 (2).png',
        ],
      ),
      NonogramGuideItem(
        title: _normalizedTitle(l10n.nonogramGuideMethodDivisionTitle),
        description: l10n.nonogramGuideMethodDivisionDesc,
        imagePaths: [
          'assets/guide/solution_methods_p5.png',
          'assets/guide/solution_methods_p5 (1).png',
          'assets/guide/solution_methods_p5 (2).png',
        ],
      ),
      NonogramGuideItem(
        title: _normalizedTitle(l10n.nonogramGuideMethodDoublePositioningTitle),
        description: l10n.nonogramGuideMethodDoublePositioningDesc,
        imagePaths: [
          'assets/guide/solution_methods_p6.png',
          'assets/guide/solution_methods_p6 (1).png',
        ],
      ),
      NonogramGuideItem(
        title: _normalizedTitle(l10n.nonogramGuideMethodDoublePositioningTitle),
        description: l10n.nonogramGuideMethodDoublePositioningDesc,
        imagePaths: [
          'assets/guide/solution_methods_p7.png',
          'assets/guide/solution_methods_p7 (1).png',
        ],
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

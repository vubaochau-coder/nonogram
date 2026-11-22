import 'package:nonogram/core/app_route_intent.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/screens/guide/illustrations/guide_illustration_card.dart';
import 'package:nonogram/screens/guide/illustrations/guide_diagram_view.dart';
import 'package:nonogram/screens/guide/models/guide_diagrams.dart';
import 'package:nonogram/screens/guide/models/nonogram_guide_item.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class NonogramGuidePage extends StatelessWidget {
  const NonogramGuidePage({super.key});

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
        title: l10n.nonogramGuideMethodLineDoneTitle,
        description: l10n.nonogramGuideMethodLineDoneDesc,
        diagrams: GuideDiagrams.lineDone,
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
                for (final diagram in GuideDiagrams.basicRule) ...[
                  GuideExampleBlock(child: GuideDiagramView(diagram: diagram)),
                  const SizedBox(height: 12),
                ],
              ],
            ),
            _RoutineSection(
              title: context.l10n.nonogramGuideRoutineTitle,
              tips: [
                context.l10n.nonogramGuideRoutineTip1,
                context.l10n.nonogramGuideRoutineTip2,
                context.l10n.nonogramGuideRoutineTip3,
                context.l10n.nonogramGuideRoutineTip4,
                context.l10n.nonogramGuideRoutineTip5,
              ],
            ),
            const _GuideLegend(),
            const SizedBox(height: 24),
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

/// Chú giải các ký hiệu dùng trong hình minh hoạ kỹ thuật giải.
class _GuideLegend extends StatelessWidget {
  const _GuideLegend();

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final l10n = context.l10n;
    const size = 22.0;

    Widget item(Widget icon, String label) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: size, height: size, child: Center(child: icon)),
          const SizedBox(width: 8),
          Flexible(child: Text(label, style: context.bodySmall)),
        ],
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.nonogramGuideLegendTitle,
            style: context.titleSmall.copyWith(color: colors.primary),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 20,
            runSpacing: 10,
            children: [
              item(
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: colors.onSurface,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                l10n.nonogramGuideLegendFilled,
              ),
              item(
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                l10n.nonogramGuideLegendTrial,
              ),
              item(
                Icon(LucideIcons.x, size: 18, color: colors.onSurfaceVariant),
                l10n.nonogramGuideLegendCross,
              ),
              item(
                Icon(
                  Icons.arrow_downward_rounded,
                  size: 20,
                  color: colors.primary,
                ),
                l10n.nonogramGuideLegendResult,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Các bước nên làm khi bắt đầu một câu đố, trước khi vào từng kỹ thuật.
class _RoutineSection extends StatelessWidget {
  const _RoutineSection({required this.title, required this.tips});

  final String title;
  final List<String> tips;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;

    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.titleSmall.copyWith(color: colors.primary),
          ),
          const SizedBox(height: 12),
          for (final tip in tips)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 7, right: 12),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: colors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      tip,
                      style: context.bodyMedium.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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

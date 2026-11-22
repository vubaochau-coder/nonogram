import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/screens/guide/illustrations/guide_diagram_view.dart';
import 'package:nonogram/screens/guide/models/nonogram_guide_item.dart';
import 'package:flutter/material.dart';

class GuideIllustrationCard extends StatelessWidget {
  const GuideIllustrationCard({
    required this.number,
    required this.item,
    super.key,
  });

  final int number;
  final NonogramGuideItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.color.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.color.surfaceContainerHigh.withValues(alpha: 0.72),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: context.color.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$number',
                  style: context.labelLarge.copyWith(
                    color: context.color.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.title,
                  style: context.titleSmall.copyWith(
                    color: context.color.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(item.description),
          for (var i = 0; i < item.diagrams.length; i++) ...[
            const SizedBox(height: 16),
            GuideExampleBlock(
              label:
                  item.diagrams.length > 1
                      ? context.l10n.nonogramGuideExample(i + 1)
                      : context.l10n.nonogramGuideExampleSingle,
              child: GuideDiagramView(diagram: item.diagrams[i]),
            ),
          ],
        ],
      ),
    );
  }
}

/// Một ví dụ trong khối nền riêng có nhãn, để các ví dụ của cùng một kỹ
/// thuật không dính vào nhau.
class GuideExampleBlock extends StatelessWidget {
  const GuideExampleBlock({required this.child, this.label, super.key});

  final String? label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label case final label?) ...[
            Text(
              label,
              style: context.labelMedium.copyWith(
                color: colors.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
          ],
          child,
        ],
      ),
    );
  }
}

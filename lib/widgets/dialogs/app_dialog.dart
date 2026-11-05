import 'package:nonogram/core/app_spacing.dart';
import 'package:flutter/material.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    this.title,
    this.content,
    this.actions,
    this.insetPadding = const EdgeInsets.all(AppSpacing.dialogScreenInset),
    this.contentPadding,
    this.actionsPadding,
  });

  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;
  final EdgeInsets insetPadding;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? actionsPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;
    final dividerColor = color.surfaceContainerHigh.withValues(alpha: 0.72);
    final mediaQuery = MediaQuery.of(context);
    final maxHeight = mediaQuery.size.height - insetPadding.vertical;

    return Dialog(
      insetPadding: insetPadding,
      backgroundColor: color.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.surfaceContainerHigh),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 420, maxHeight: maxHeight),
        child: SingleChildScrollView(
          child: Padding(
            padding:
                contentPadding ??
                const EdgeInsets.fromLTRB(20, 20, 20, AppSpacing.cardPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) title!,
                if (content != null) ...[
                  if (title != null) ...[
                    const SizedBox(height: 12),
                    Divider(height: 1, thickness: 1, color: dividerColor),
                    const SizedBox(height: 12),
                  ],
                  content!,
                ],
                if (actions != null && actions!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Padding(
                    padding: actionsPadding ?? EdgeInsets.zero,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: actions!,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

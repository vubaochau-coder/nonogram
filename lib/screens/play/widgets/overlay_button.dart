import 'package:nonogram/core/context_ext.dart';
import 'package:flutter/material.dart';

class OverlayButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final VoidCallback onPressed;
  final Color? color;
  final bool enabled;

  const OverlayButton({
    super.key,
    required this.icon,
    this.label,
    required this.onPressed,
    this.color,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor =
        enabled
            ? (color ?? context.color.onSurfaceVariant)
            : context.color.onSurfaceVariant.withValues(alpha: 0.4);

    return InkWell(
      onTap: enabled ? onPressed : null,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: enabled ? 1.0 : 0.6,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color:
                color?.withValues(alpha: 0.1) ??
                context.color.surfaceContainerHighest.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color:
                  color?.withValues(alpha: 0.3) ??
                  context.color.outlineVariant.withValues(alpha: 0.5),
              width: 0.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: effectiveColor),
              if (label != null) ...[
                const SizedBox(width: 8),
                Text(
                  label!,
                  style: context.labelLarge.copyWith(
                    color: effectiveColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

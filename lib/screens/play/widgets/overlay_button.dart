import 'package:flutter/material.dart';
import 'package:nonogram/core/app_theme.dart';
import 'package:nonogram/core/context_ext.dart';

/// Nút nổi trên bàn chơi (gợi ý, chế độ, xoá, toàn màn hình).
/// [color] khác null nghĩa là nút đang ở trạng thái bật.
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
    final active = color;
    final foreground =
        !enabled
            ? context.color.onSurfaceVariant.withValues(alpha: 0.45)
            : (active ?? context.color.onSurface);
    final background =
        active?.withValues(alpha: 0.12) ?? context.color.surfaceContainerLow;
    final border =
        active?.withValues(alpha: 0.4) ?? context.gameColors.cardBorder;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 40,
          constraints: const BoxConstraints(minWidth: 40),
          padding: EdgeInsets.symmetric(horizontal: label == null ? 10 : 12),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: foreground),
              if (label != null) ...[
                const SizedBox(width: 6),
                Text(
                  label!,
                  style: context.labelLarge.copyWith(color: foreground),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

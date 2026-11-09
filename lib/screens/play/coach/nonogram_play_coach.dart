import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/l10n/app_localizations.dart';

/// Các bước hướng dẫn thao tác trong màn chơi.
enum NonogramCoachStep { hint, wand, mode, longPress, scroll }

/// Yêu cầu mở lại hướng dẫn thao tác (từ hộp thoại cài đặt). Bàn chơi lắng
/// nghe và hiện lại toàn bộ các bước.
class NonogramCoachReplayNotifier extends ChangeNotifier {
  void requestReplay() => notifyListeners();
}

/// Vị trí cần làm nổi bật cho từng bước, tính lại mỗi lần dựng (xoay màn
/// hình, toàn màn hình...). Trả về null thì bước đó hiện thẻ ở giữa màn,
/// không có vùng sáng.
typedef NonogramCoachTargetResolver = Rect? Function(NonogramCoachStep step);

/// Phủ lớp hướng dẫn lên toàn màn hình, lần lượt từng bước trong [steps].
/// Hoàn tất khi người chơi xem hết hoặc bỏ qua.
Future<void> showNonogramPlayCoach(
  BuildContext context, {
  required List<NonogramCoachStep> steps,
  required NonogramCoachTargetResolver targetFor,
}) {
  if (steps.isEmpty) return Future.value();
  final overlay = Overlay.of(context, rootOverlay: true);
  late final OverlayEntry entry;
  var finished = false;
  final done = Completer<void>();
  void finish() {
    if (finished) return;
    finished = true;
    entry.remove();
    done.complete();
  }

  entry = OverlayEntry(
    builder:
        (_) => NonogramPlayCoachOverlay(
          steps: steps,
          targetFor: targetFor,
          onFinished: finish,
        ),
  );
  overlay.insert(entry);
  return done.future;
}

class NonogramPlayCoachOverlay extends StatefulWidget {
  const NonogramPlayCoachOverlay({
    super.key,
    required this.steps,
    required this.targetFor,
    required this.onFinished,
  });

  final List<NonogramCoachStep> steps;
  final NonogramCoachTargetResolver targetFor;
  final VoidCallback onFinished;

  @override
  State<NonogramPlayCoachOverlay> createState() =>
      _NonogramPlayCoachOverlayState();
}

class _NonogramPlayCoachOverlayState extends State<NonogramPlayCoachOverlay> {
  int _index = 0;

  bool get _isLast => _index == widget.steps.length - 1;

  void _next() {
    if (_isLast) {
      widget.onFinished();
    } else {
      setState(() => _index++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.steps[_index];
    // Thay đổi kích thước màn hình (xoay) thì dựng lại để tính lại vị trí.
    final screen = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);
    final raw = widget.targetFor(step);
    final target = raw?.inflate(6);
    final content = _contentFor(context.l10n, step);

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          // Chạm vào bất cứ đâu = sang bước tiếp; chặn mọi thao tác bên dưới.
          Positioned.fill(
            child: GestureDetector(
              key: const ValueKey('nonogram-coach-barrier'),
              behavior: HitTestBehavior.opaque,
              onTap: _next,
              child: TweenAnimationBuilder<Rect?>(
                tween: _NullableRectTween(end: target),
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutCubic,
                builder:
                    (context, rect, _) => CustomPaint(
                      size: screen,
                      painter: _SpotlightPainter(
                        hole: rect,
                        scrim: Colors.black.withValues(alpha: 0.62),
                        ring: context.color.primary,
                      ),
                    ),
              ),
            ),
          ),
          _CoachCard(
            key: ValueKey(step),
            screen: screen,
            safe: padding,
            target: target,
            icon: content.icon,
            title: content.title,
            body: content.body,
            stepLabel: context.l10n.nonogramCoachStep(
              _index + 1,
              widget.steps.length,
            ),
            isLast: _isLast,
            onNext: _next,
            onSkip: widget.onFinished,
          ),
        ],
      ),
    );
  }

  static ({IconData icon, String title, String body}) _contentFor(
    AppLocalizations l10n,
    NonogramCoachStep step,
  ) {
    return switch (step) {
      NonogramCoachStep.hint => (
        icon: LucideIcons.lightbulb,
        title: l10n.nonogramCoachHintTitle,
        body: l10n.nonogramCoachHintBody,
      ),
      NonogramCoachStep.wand => (
        icon: LucideIcons.wand2,
        title: l10n.nonogramCoachWandTitle,
        body: l10n.nonogramCoachWandBody,
      ),
      NonogramCoachStep.mode => (
        icon: LucideIcons.squareStack,
        title: l10n.nonogramCoachModeTitle,
        body: l10n.nonogramCoachModeBody,
      ),
      NonogramCoachStep.longPress => (
        icon: LucideIcons.pointer,
        title: l10n.nonogramCoachLongPressTitle,
        body: l10n.nonogramCoachLongPressBody,
      ),
      NonogramCoachStep.scroll => (
        icon: LucideIcons.move,
        title: l10n.nonogramCoachScrollTitle,
        body: l10n.nonogramCoachScrollBody,
      ),
    };
  }
}

/// Thẻ nội dung: đặt dưới vùng sáng nếu phía dưới đủ chỗ, không thì đặt
/// phía trên; không có vùng sáng thì ở giữa.
class _CoachCard extends StatelessWidget {
  const _CoachCard({
    super.key,
    required this.screen,
    required this.safe,
    required this.target,
    required this.icon,
    required this.title,
    required this.body,
    required this.stepLabel,
    required this.isLast,
    required this.onNext,
    required this.onSkip,
  });

  final Size screen;
  final EdgeInsets safe;
  final Rect? target;
  final IconData icon;
  final String title;
  final String body;
  final String stepLabel;
  final bool isLast;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  static const double _gap = 12;
  static const double _margin = 16;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.color;
    final width = min(360.0, screen.width - safe.horizontal - _margin * 2);

    final card = Material(
      color: colors.surface,
      elevation: 8,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 10, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: colors.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      icon,
                      size: 18,
                      color: colors.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      style: context.titleMedium.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Text(
                    stepLabel,
                    style: context.labelMedium.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(body, style: context.bodyMedium),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                if (!isLast)
                  TextButton(
                    key: const ValueKey('nonogram-coach-skip'),
                    onPressed: onSkip,
                    style: TextButton.styleFrom(
                      foregroundColor: colors.onSurfaceVariant,
                    ),
                    child: Text(l10n.nonogramCoachSkip),
                  ),
                const Spacer(),
                TextButton(
                  key: const ValueKey('nonogram-coach-next'),
                  onPressed: onNext,
                  child: Text(
                    isLast ? l10n.nonogramCoachDone : l10n.nonogramCoachNext,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    return Positioned.fill(
      child: CustomSingleChildLayout(
        delegate: _CardLayoutDelegate(
          target: target,
          safe: safe,
          width: width,
          margin: _margin,
          gap: _gap,
        ),
        child: card,
      ),
    );
  }
}

/// Đặt thẻ dưới vùng sáng nếu vừa, không thì phía trên; không bên nào vừa
/// (vùng sáng chiếm gần hết màn, ví dụ cả lưới khi màn ngang) hoặc không có
/// vùng sáng thì đặt giữa màn hình, đè lên vùng sáng.
class _CardLayoutDelegate extends SingleChildLayoutDelegate {
  _CardLayoutDelegate({
    required this.target,
    required this.safe,
    required this.width,
    required this.margin,
    required this.gap,
  });

  final Rect? target;
  final EdgeInsets safe;
  final double width;
  final double margin;
  final double gap;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: width,
      maxWidth: width,
      maxHeight: max(0, constraints.maxHeight - safe.vertical - margin * 2),
    );
  }

  @override
  Offset getPositionForChild(Size size, Size child) {
    final t = target;
    final minX = safe.left + margin;
    final maxX = max(minX, size.width - safe.right - margin - child.width);
    final minY = safe.top + margin;
    final maxY = max(minY, size.height - safe.bottom - margin - child.height);
    final centerY = (minY + maxY) / 2;
    if (t == null) {
      return Offset(
        ((size.width - child.width) / 2).clamp(minX, maxX),
        centerY,
      );
    }
    final x = (t.center.dx - child.width / 2).clamp(minX, maxX);
    final belowY = t.bottom + gap;
    final aboveY = t.top - gap - child.height;
    final fitsBelow =
        belowY + child.height <= size.height - safe.bottom - margin;
    final fitsAbove = aboveY >= minY;
    final below = size.height - t.bottom;
    final above = t.top;
    if (fitsBelow && (below >= above || !fitsAbove)) return Offset(x, belowY);
    if (fitsAbove) return Offset(x, aboveY);
    return Offset(x, centerY);
  }

  @override
  bool shouldRelayout(_CardLayoutDelegate old) =>
      old.target != target ||
      old.safe != safe ||
      old.width != width ||
      old.margin != margin ||
      old.gap != gap;
}

class _NullableRectTween extends Tween<Rect?> {
  _NullableRectTween({super.end});

  @override
  Rect? lerp(double t) {
    final a = begin;
    final b = end;
    if (a == null || b == null) return b;
    return Rect.lerp(a, b, t);
  }
}

/// Lớp tối phủ toàn màn hình, khoét một ô bo tròn quanh [hole] và viền sáng.
class _SpotlightPainter extends CustomPainter {
  _SpotlightPainter({
    required this.hole,
    required this.scrim,
    required this.ring,
  });

  final Rect? hole;
  final Color scrim;
  final Color ring;

  @override
  void paint(Canvas canvas, Size size) {
    final full = Path()..addRect(Offset.zero & size);
    final h = hole;
    if (h == null) {
      canvas.drawPath(full, Paint()..color = scrim);
      return;
    }
    final rrect = RRect.fromRectAndRadius(h, const Radius.circular(14));
    final path = Path.combine(
      PathOperation.difference,
      full,
      Path()..addRRect(rrect),
    );
    canvas.drawPath(path, Paint()..color = scrim);
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = ring
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(_SpotlightPainter old) =>
      old.hole != hole || old.scrim != scrim || old.ring != ring;
}

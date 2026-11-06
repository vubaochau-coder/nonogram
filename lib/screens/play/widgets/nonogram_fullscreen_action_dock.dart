import 'dart:async';

import 'package:nonogram/core/context_ext.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class NonogramFullscreenActionDock extends StatefulWidget {
  final Widget child;
  final Duration autoCollapseDelay;
  final Duration animationDuration;
  final double dragThreshold;

  const NonogramFullscreenActionDock({
    super.key,
    required this.child,
    this.autoCollapseDelay = const Duration(milliseconds: 1800),
    this.animationDuration = const Duration(milliseconds: 240),
    this.dragThreshold = 24,
  });

  @override
  State<NonogramFullscreenActionDock> createState() =>
      _NonogramFullscreenActionDockState();
}

class _NonogramFullscreenActionDockState
    extends State<NonogramFullscreenActionDock>
    with SingleTickerProviderStateMixin {
  Timer? _autoCollapseTimer;
  late final AnimationController _controller;
  late CurvedAnimation _curve;
  double _dragDeltaY = 0;

  bool get _isExpanded => _controller.value > 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
      value: 1,
    );
    _curve = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _scheduleAutoCollapse();
  }

  @override
  void didUpdateWidget(covariant NonogramFullscreenActionDock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animationDuration != widget.animationDuration) {
      _controller.duration = widget.animationDuration;
    }
    if (_isExpanded &&
        oldWidget.autoCollapseDelay != widget.autoCollapseDelay) {
      _scheduleAutoCollapse();
    }
  }

  @override
  void dispose() {
    _autoCollapseTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _scheduleAutoCollapse() {
    _autoCollapseTimer?.cancel();
    if (!_isExpanded) return;
    _autoCollapseTimer = Timer(widget.autoCollapseDelay, _collapse);
  }

  void _expand() {
    _autoCollapseTimer?.cancel();
    _controller.forward();
    _scheduleAutoCollapse();
  }

  void _collapse() {
    _autoCollapseTimer?.cancel();
    _controller.reverse();
  }

  void _restartAutoCollapse() {
    if (!_isExpanded) return;
    _scheduleAutoCollapse();
  }

  void _onPointerDown(PointerDownEvent event) {
    _dragDeltaY = 0;
  }

  void _onPointerMove(PointerMoveEvent event) {
    _dragDeltaY += event.delta.dy;
  }

  void _onPointerUp(PointerUpEvent event) {
    if (_dragDeltaY >= widget.dragThreshold) {
      _expand();
    } else if (_dragDeltaY <= -widget.dragThreshold) {
      _collapse();
    } else if (_isExpanded) {
      _scheduleAutoCollapse();
    }
    _dragDeltaY = 0;
  }

  void _onPointerCancel(PointerCancelEvent event) {
    _dragDeltaY = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('nonogram-fullscreen-action-dock'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (event) {
              _restartAutoCollapse();
              _onPointerDown(event);
            },
            onPointerMove: _onPointerMove,
            onPointerUp: _onPointerUp,
            onPointerCancel: _onPointerCancel,
            child: ClipRect(
              child: SizeTransition(
                key: const ValueKey('nonogram-fullscreen-action-dock-body'),
                sizeFactor: _curve,
                axisAlignment: -1,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -0.22),
                    end: Offset.zero,
                  ).animate(_curve),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ),
        ),
        Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: _onPointerDown,
          onPointerMove: _onPointerMove,
          onPointerUp: _onPointerUp,
          onPointerCancel: _onPointerCancel,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (_isExpanded) {
                _collapse();
              } else {
                _expand();
              }
            },
            child: Container(
              key: const ValueKey('nonogram-fullscreen-action-dock-handle'),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: context.color.surfaceContainerHighest.withValues(
                  alpha: 0.82,
                ),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: context.color.outlineVariant.withValues(alpha: 0.55),
                  width: 0.5,
                ),
              ),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  // Mũi tên chỉ hướng hàng nút sẽ đi khi bấm: đang mở thì
                  // chỉ lên (thu lại), đang thu thì chỉ xuống (thả ra).
                  return Transform.rotate(
                    angle: _curve.value * 3.141592653589793,
                    child: child,
                  );
                },
                child: Icon(
                  LucideIcons.chevronDown,
                  size: 16,
                  color: context.color.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

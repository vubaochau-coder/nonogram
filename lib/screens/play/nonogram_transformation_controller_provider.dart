import 'package:flutter/material.dart';
import 'package:nested/nested.dart';

class NonogramTransformationControllerProvider
    extends SingleChildStatelessWidget {
  final TransformationController controller;
  final Widget? child;

  const NonogramTransformationControllerProvider({
    super.key,
    required this.controller,
    this.child,
  });

  static TransformationController of(BuildContext context) {
    final scope =
        context
            .dependOnInheritedWidgetOfExactType<
              _TransformationControllerScope
            >();
    if (scope?.notifier case final controller?) return controller;
    throw FlutterError(
      'NonogramTransformationControllerProvider is missing in the widget tree.',
    );
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return _TransformationControllerScope(
      notifier: controller,
      child: child ?? this.child ?? const SizedBox.shrink(),
    );
  }
}

class _TransformationControllerScope
    extends InheritedNotifier<TransformationController> {
  const _TransformationControllerScope({
    required super.notifier,
    required super.child,
  });
}

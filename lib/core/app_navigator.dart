import 'package:flutter/material.dart';

abstract final class AppNavigator {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static BuildContext? get context {
    try {
      return navigatorKey.currentContext;
    } on FlutterError {
      return null;
    }
  }

  static OverlayState? get overlayState {
    try {
      return navigatorKey.currentState?.overlay;
    } on FlutterError {
      return null;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:nonogram/core/app_spacing.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFFFFFFF),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFFFFFF),
      foregroundColor: Color(0xFF24292F),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 57, color: Color(0xFF24292F)),
      displayMedium: TextStyle(fontSize: 45, color: Color(0xFF24292F)),
      displaySmall: TextStyle(fontSize: 36, color: Color(0xFF24292F)),
      headlineLarge: TextStyle(fontSize: 32, color: Color(0xFF24292F)),
      headlineMedium: TextStyle(fontSize: 28, color: Color(0xFF24292F)),
      headlineSmall: TextStyle(fontSize: 24, color: Color(0xFF24292F)),
      titleLarge: TextStyle(
        fontSize: 22,
        color: Color(0xFF24292F),
        fontWeight: FontWeight.w500,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        color: Color(0xFF24292F),
        fontWeight: FontWeight.w500,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        color: Color(0xFF24292F),
        fontWeight: FontWeight.w500,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        color: Color(0xFF24292F),
        fontWeight: FontWeight.w500,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        color: Color(0xFF24292F),
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        color: Color(0xFF24292F),
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF24292F)),
      bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF24292F)),
      bodySmall: TextStyle(fontSize: 12, color: Color(0xFF57606A)),
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF0969DA),
      onPrimary: Colors.white,
      secondary: Color(0xFF57606A),
      onSecondary: Colors.white,
      error: Color(0xFFCF222E),
      onError: Colors.white,
      surface: Color(0xFFF6F8FA),
      onSurface: Color(0xFF24292F),
      surfaceContainerHigh: Color(0xFFD0D7DE),
    ),
    iconTheme: const IconThemeData(size: 18, color: Color(0xFF57606A)),
    listTileTheme: const ListTileThemeData(iconColor: Color(0xFF57606A)),
    dialogTheme: const DialogThemeData(
      insetPadding: EdgeInsets.all(AppSpacing.dialogScreenInset),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF24292F),
        side: const BorderSide(color: Color(0xFFD0D7DE)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.buttonVerticalPadding,
          horizontal: AppSpacing.buttonHorizontalPadding,
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFF0969DA),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.buttonVerticalPadding,
          horizontal: AppSpacing.buttonHorizontalPadding,
        ),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0969DA),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0D1117),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0D1117),
      foregroundColor: Color(0xFFE6EDF3),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 57, color: Color(0xFFE6EDF3)),
      displayMedium: TextStyle(fontSize: 45, color: Color(0xFFE6EDF3)),
      displaySmall: TextStyle(fontSize: 36, color: Color(0xFFE6EDF3)),
      headlineLarge: TextStyle(fontSize: 32, color: Color(0xFFE6EDF3)),
      headlineMedium: TextStyle(fontSize: 28, color: Color(0xFFE6EDF3)),
      headlineSmall: TextStyle(fontSize: 24, color: Color(0xFFE6EDF3)),
      titleLarge: TextStyle(
        fontSize: 22,
        color: Color(0xFFE6EDF3),
        fontWeight: FontWeight.w500,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        color: Color(0xFFE6EDF3),
        fontWeight: FontWeight.w500,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        color: Color(0xFFE6EDF3),
        fontWeight: FontWeight.w500,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        color: Color(0xFFE6EDF3),
        fontWeight: FontWeight.w500,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        color: Color(0xFFE6EDF3),
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        color: Color(0xFFE6EDF3),
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: Color(0xFFE6EDF3)),
      bodyMedium: TextStyle(fontSize: 14, color: Color(0xFFE6EDF3)),
      bodySmall: TextStyle(fontSize: 12, color: Color(0xFF8B949E)),
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF2F81F7),
      onPrimary: Colors.white,
      secondary: Color(0xFF8B949E),
      onSecondary: Color(0xFF0D1117),
      error: Color(0xFFF85149),
      onError: Colors.white,
      surface: Color(0xFF161B22),
      onSurface: Color(0xFFE6EDF3),
      surfaceContainerHigh: Color(0xFF30363D),
    ),
    iconTheme: const IconThemeData(size: 18, color: Color(0xFF8B949E)),
    listTileTheme: const ListTileThemeData(iconColor: Color(0xFF8B949E)),
    dialogTheme: const DialogThemeData(
      insetPadding: EdgeInsets.all(AppSpacing.dialogScreenInset),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFFE6EDF3),
        side: const BorderSide(color: Color(0xFF30363D)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.buttonVerticalPadding,
          horizontal: AppSpacing.buttonHorizontalPadding,
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFF2F81F7),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.buttonVerticalPadding,
          horizontal: AppSpacing.buttonHorizontalPadding,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2F81F7),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  );
}

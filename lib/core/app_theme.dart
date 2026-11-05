import 'package:flutter/material.dart';
import 'package:nonogram/core/app_spacing.dart';

/// Màu dùng riêng cho game, ngoài ColorScheme chuẩn.
@immutable
class GameColors extends ThemeExtension<GameColors> {
  const GameColors({
    required this.success,
    required this.reward,
    required this.cardBorder,
    required this.heroStart,
    required this.heroEnd,
    required this.clueBackground,
    required this.clueBand,
    required this.pictureInk,
    required this.picturePaper,
  });

  /// Hàng/cột đã khớp gợi ý, màn đã giải.
  final Color success;

  /// Cúp, ngôi sao, kỷ lục.
  final Color reward;
  final Color cardBorder;

  /// Gradient của thẻ "màn tiếp theo" trên dashboard.
  final Color heroStart;
  final Color heroEnd;

  /// Nền vùng ô số (gợi ý), tách hẳn khỏi nền trang và ô lưới trắng.
  final Color clueBackground;

  /// Dải tô xen kẽ mỗi nhóm 5 hàng/cột trong vùng ô số.
  final Color clueBand;

  /// Màu ô tô / ô trống khi vẽ bức tranh hoàn chỉnh (ảnh thu nhỏ, màn hoàn
  /// thành). Giữ kiểu "mực trên giấy" ở cả chế độ tối để tranh không bị đảo
  /// màu (ví dụ màn "White Dog": con chó là phần ô trống).
  final Color pictureInk;
  final Color picturePaper;

  @override
  GameColors copyWith({
    Color? success,
    Color? reward,
    Color? cardBorder,
    Color? heroStart,
    Color? heroEnd,
    Color? clueBackground,
    Color? clueBand,
    Color? pictureInk,
    Color? picturePaper,
  }) {
    return GameColors(
      success: success ?? this.success,
      reward: reward ?? this.reward,
      cardBorder: cardBorder ?? this.cardBorder,
      heroStart: heroStart ?? this.heroStart,
      heroEnd: heroEnd ?? this.heroEnd,
      clueBackground: clueBackground ?? this.clueBackground,
      clueBand: clueBand ?? this.clueBand,
      pictureInk: pictureInk ?? this.pictureInk,
      picturePaper: picturePaper ?? this.picturePaper,
    );
  }

  @override
  GameColors lerp(GameColors? other, double t) {
    if (other == null) return this;
    return GameColors(
      success: Color.lerp(success, other.success, t)!,
      reward: Color.lerp(reward, other.reward, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      heroStart: Color.lerp(heroStart, other.heroStart, t)!,
      heroEnd: Color.lerp(heroEnd, other.heroEnd, t)!,
      clueBackground: Color.lerp(clueBackground, other.clueBackground, t)!,
      clueBand: Color.lerp(clueBand, other.clueBand, t)!,
      pictureInk: Color.lerp(pictureInk, other.pictureInk, t)!,
      picturePaper: Color.lerp(picturePaper, other.picturePaper, t)!,
    );
  }
}

abstract final class AppTheme {
  static const fontFamily = 'Nunito';

  /// Màu chủ đạo, trùng với màu nền launcher icon.
  static const brand = Color(0xFF3B5BDB);

  static final lightTheme = _build(
    scheme: ColorScheme.fromSeed(
      seedColor: brand,
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    ).copyWith(
      primary: brand,
      onPrimary: Colors.white,
      surface: const Color(0xFFF5F6FA),
      onSurface: const Color(0xFF1B1F2A),
      onSurfaceVariant: const Color(0xFF5B6274),
      surfaceContainerLowest: Colors.white,
      surfaceContainerLow: Colors.white,
      surfaceContainer: const Color(0xFFEEF0F6),
      surfaceContainerHigh: const Color(0xFFE6E9F1),
      surfaceContainerHighest: const Color(0xFFDDE1EB),
      outline: const Color(0xFFB5BBCB),
      outlineVariant: const Color(0xFFDDE1EB),
    ),
    game: const GameColors(
      success: Color(0xFF1F9D63),
      reward: Color(0xFFF2A516),
      cardBorder: Color(0xFFE3E6EE),
      heroStart: Color(0xFF3B5BDB),
      heroEnd: Color(0xFF6741D9),
      clueBackground: Color(0xFFDDE4FB),
      clueBand: Color(0xFFCCD6F8),
      pictureInk: Color(0xFF1B1F2A),
      picturePaper: Colors.white,
    ),
  );

  static final darkTheme = _build(
    scheme: ColorScheme.fromSeed(
      seedColor: brand,
      brightness: Brightness.dark,
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    ).copyWith(
      primary: const Color(0xFF91A7FF),
      onPrimary: const Color(0xFF0F1A4A),
      surface: const Color(0xFF0F1218),
      onSurface: const Color(0xFFE6E8EF),
      onSurfaceVariant: const Color(0xFF9AA1B2),
      surfaceContainerLowest: const Color(0xFF0B0D12),
      surfaceContainerLow: const Color(0xFF171B23),
      surfaceContainer: const Color(0xFF1C212B),
      surfaceContainerHigh: const Color(0xFF242A35),
      surfaceContainerHighest: const Color(0xFF2E3542),
      outline: const Color(0xFF4A5263),
      outlineVariant: const Color(0xFF2E3542),
    ),
    game: const GameColors(
      success: Color(0xFF3DD68C),
      reward: Color(0xFFFFC53D),
      cardBorder: Color(0xFF262C38),
      heroStart: Color(0xFF3451C7),
      heroEnd: Color(0xFF5F3DC4),
      clueBackground: Color(0xFF232B4A),
      clueBand: Color(0xFF2B3458),
      pictureInk: Color(0xFF151922),
      picturePaper: Color(0xFFCDD2DD),
    ),
  );

  static ThemeData _build({
    required ColorScheme scheme,
    required GameColors game,
  }) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: scheme.brightness,
      colorScheme: scheme,
      fontFamily: fontFamily,
    );
    final text = base.textTheme.apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    );
    final cardShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: BorderSide(color: game.cardBorder),
    );

    return base.copyWith(
      scaffoldBackgroundColor: scheme.surface,
      extensions: [game],
      textTheme: text.copyWith(
        headlineMedium: text.headlineMedium?.copyWith(
          fontWeight: FontWeight.w800,
        ),
        headlineSmall: text.headlineSmall?.copyWith(
          fontWeight: FontWeight.w800,
        ),
        titleLarge: text.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        titleMedium: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        titleSmall: text.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        labelLarge: text.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        labelMedium: text.labelMedium?.copyWith(fontWeight: FontWeight.w600),
        labelSmall: text.labelSmall?.copyWith(fontWeight: FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        // textTheme của ThemeData chưa có cỡ chữ ở bước này (được ghép khi
        // Theme.of), nên đặt cỡ chữ rõ ràng.
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: scheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLow,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: cardShape,
        clipBehavior: Clip.antiAlias,
      ),
      iconTheme: IconThemeData(size: 20, color: scheme.onSurfaceVariant),
      dividerTheme: DividerThemeData(color: game.cardBorder, space: 1),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(AppSpacing.dialogScreenInset),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 52),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 48),
          foregroundColor: scheme.onSurface,
          side: BorderSide(color: game.cardBorder),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontWeight: FontWeight.w700,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8),
      ),
      chipTheme: ChipThemeData(
        side: BorderSide.none,
        shape: const StadiumBorder(),
        labelStyle: text.labelMedium,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}

extension GameColorsContext on BuildContext {
  GameColors get gameColors => Theme.of(this).extension<GameColors>()!;
}

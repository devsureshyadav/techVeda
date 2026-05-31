import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
abstract final class AppColors {
  static const background = Color(0xFF07070F);
  static const surface = Color(0xFF12121E);
  static const surfaceElevated = Color(0xFF1A1A2E);
  static const cardBorder = Color(0x33FFFFFF);
  static const textPrimary = Color(0xFFF4F4FF);
  static const textSecondary = Color(0xFF9B9BB8);
  static const accent = Color(0xFF7C4DFF);
  static const accentSecondary = Color(0xFF00E5FF);
  static const glow = Color(0xFF5B2EFF);

  static const heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1F0252),
      Color(0xFF3D1A78),
      Color(0xFF0D0D18),
    ],
  );

  static const cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF2A1B4E),
      Color(0xFF141428),
    ],
  );

  /// Profile hero on developer screen — teal/cyan, distinct from achievements purple.
  static const developerHeroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0E7490),
      Color(0xFF1E3A8A),
      Color(0xFF0C1222),
    ],
    stops: [0.0, 0.55, 1.0],
  );
}

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.dark(
      primary: AppColors.accent,
      secondary: AppColors.accentSecondary,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
    ),
  );

  return base.copyWith(
    textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme).apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.textPrimary,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
  );
}

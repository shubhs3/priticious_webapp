import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  const AppTheme._();

  // Signature Palette: Royal Warm Gold & Pearl White
  static const Color _primary = Color(0xFFC59B27);   // Royal Amber Gold
  static const Color _secondary = Color(0xFF7A5900); // Deep Golden Bronze
  static const Color _accent = Color(0xFFE8B830);    // Bright Champagne Accent

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isLight = brightness == Brightness.light;

    final scheme = ColorScheme.fromSeed(
      seedColor: _primary,
      brightness: brightness,
      primary: _primary,
      onPrimary: Colors.white,
      primaryContainer: isLight ? const Color(0xFFFFF6DF) : const Color(0xFF382A03),
      onPrimaryContainer: isLight ? const Color(0xFF4A3700) : const Color(0xFFFFEAA4),
      secondary: _secondary,
      onSecondary: Colors.white,
      secondaryContainer: isLight ? const Color(0xFFFFF0CC) : const Color(0xFF2C2000),
      onSecondaryContainer: isLight ? const Color(0xFF3D2C00) : const Color(0xFFFFE094),
      tertiary: _accent,
      surface: isLight ? const Color(0xFFFFFFFF) : const Color(0xFF1A160F),
      onSurface: isLight ? const Color(0xFF2B2213) : const Color(0xFFFAF5EC),
    );

    final baseTextTheme = isLight
        ? GoogleFonts.josefinSansTextTheme(Typography.material2021().black)
        : GoogleFonts.josefinSansTextTheme(Typography.material2021().white);

    final headingFont = GoogleFonts.josefinSans;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: isLight
          ? const Color(0xFFFFFDF9) // Bright Pearl Ivory Light Background
          : const Color(0xFF14110B), // Dark Velvet Gold
      textTheme: baseTextTheme.copyWith(
        displayLarge: headingFont(textStyle: baseTextTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold, color: _secondary)),
        displayMedium: headingFont(textStyle: baseTextTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold, color: _secondary)),
        displaySmall: headingFont(textStyle: baseTextTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold)),
        headlineLarge: headingFont(textStyle: baseTextTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
        headlineMedium: headingFont(textStyle: baseTextTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
        titleLarge: headingFont(textStyle: baseTextTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 20, color: const Color(0xFF4A3700))),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        color: scheme.surface,
        shadowColor: _primary.withAlpha(30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: isLight
                ? const Color(0xFFF2E6CD)
                : const Color(0xFF3D3219),
            width: 1,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isLight ? const Color(0xFFFAF5EC) : const Color(0xFF262016),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isLight ? const Color(0xFFE8DCC4) : const Color(0xFF3F3524),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primary, width: 1.8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: isLight ? const Color(0xFFFFFDF9) : const Color(0xFF14110B),
        scrolledUnderElevation: 2,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isLight ? const Color(0xFF4A3700) : const Color(0xFFFAF5EC),
        ),
        titleTextStyle: headingFont(
          textStyle: TextStyle(
            color: isLight ? const Color(0xFF4A3700) : const Color(0xFFFAF5EC),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        selectedColor: _primary,
        secondarySelectedColor: _secondary,
        backgroundColor: isLight ? const Color(0xFFF7EFDF) : const Color(0xFF2A2215),
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.josefinSans(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: Colors.white,
          elevation: 3,
          shadowColor: _primary.withAlpha(80),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.josefinSans(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}




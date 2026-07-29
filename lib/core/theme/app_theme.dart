import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const Color _primary = Color(0xFF8D5B4C); // Terracotta Brown
  static const Color _accent = Color(0xFFD4AF37);  // Amber Gold

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final scheme = ColorScheme.fromSeed(
      seedColor: _primary,
      brightness: brightness,
      primary: _primary,
      secondary: _accent,
      surface: isLight ? const Color(0xFFFFFFFF) : const Color(0xFF221E1B),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: isLight
          ? const Color(0xFFFAF6F0) // Warm Cream Background
          : const Color(0xFF181512), // Rich Dark Cocoa Background
      textTheme: (isLight
              ? Typography.material2021().black
              : Typography.material2021().white)
          .apply(fontFamily: 'System'),
      cardTheme: CardThemeData(
        elevation: 1,
        color: scheme.surface,
        shadowColor: isLight ? Colors.black.withAlpha(20) : Colors.black38,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isLight ? const Color(0xFFF2ECE4) : const Color(0xFF2A2522),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: isLight ? const Color(0xFF2E221D) : const Color(0xFFFAF6F0),
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

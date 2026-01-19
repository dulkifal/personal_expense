import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryColor = Color(0xFF6C63FF); // Modern Violet/Purple
  static const Color secondaryColor = Color(0xFF03DAC6); // Teal/Cyan accent
  static const Color errorColor = Color(0xFFCF6679);
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1E1E1E);

  static TextTheme _buildTextTheme(TextTheme base) {
    return GoogleFonts.poppinsTextTheme(base);
  }

  static ThemeData get lightTheme {
    final base = ThemeData.light();
    return base.copyWith(
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        background: backgroundLight,
        surface: surfaceLight,
        error: errorColor,
      ),
      scaffoldBackgroundColor: backgroundLight,
      textTheme: _buildTextTheme(base.textTheme),
      useMaterial3: true,
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: surfaceLight,
      ),
    );
  }

  static ThemeData get darkTheme {
    final base = ThemeData.dark();
    return base.copyWith(
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        background: backgroundDark,
        surface: surfaceDark,
        error: errorColor,
      ),
      scaffoldBackgroundColor: backgroundDark,
      textTheme: _buildTextTheme(base.textTheme).apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      useMaterial3: true,
       cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: surfaceDark,
      ),
    );
  }
}

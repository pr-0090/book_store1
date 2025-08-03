import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Color Palette from design.md
  static const Color primaryColor = Color(0xFF2E7D32); // Forest Green
  static const Color secondaryColor = Color(0xFFFF6B35); // Orange
  static const Color accentColor = Color(0xFFFFD700); // Gold
  static const Color backgroundColor = Color(0xFFFFFFFF); // White
  static const Color surfaceColor = Color(0xFFF5F5F5); // Light Gray
  static const Color textPrimaryColor = Color(0xFF212121); // Dark Gray
  static const Color textSecondaryColor = Color(0xFF757575); // Medium Gray
  static const Color errorColor = Color(0xFFD32F2F); // Red
  static const Color successColor = Color(0xFF4CAF50); // Green
  static const Color borderColor = Color(0xFFE0E0E0); // Light Gray

  static ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.green,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    textTheme: GoogleFonts.robotoTextTheme(),
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surfaceColor,
      background: backgroundColor,
      error: errorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textPrimaryColor,
      onBackground: textPrimaryColor,
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor),
      ),
    ),
  );
  
  static ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.green,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: const Color(0xFF121212),
    textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme),
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: Color(0xFF1E1E1E),
      background: Color(0xFF121212),
      error: errorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor),
      ),
    ),
  );
} 
import 'package:flutter/material.dart';

class AppTheme {
  // static const Color backgroundDark = Color(0xFF0F0F11); // Deep street black
  // static const Color accentPurple = Color(0xFF5B2EA8);   // Deep accent color
  static const Color successColor = Colors.green;
  static const Color errorColor = Colors.red;

  // New Brand Color Palette extracted from screenshots
  static const Color brandViolet = Color(
    0xFF5B2EA8,
  ); // Vibrant Purple background
  // static const Color brandViolet = Color(0xFF5A24B3);    // Vibrant Purple background
  static const Color backgroundWhite = Color(
    0xFFFFFFFF,
  ); // Clean White header sections
  static const Color deepBlack = Color(
    0xFF0D0D0D,
  ); // Shadow borders and primary typography

  static ThemeData get brandTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: brandViolet,
      cardColor: backgroundWhite,

      fontFamily: 'Poppins',

      // Crisp White Header Top Bar matching the new desktop navigation layout
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundWhite,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: deepBlack),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: backgroundWhite,
        contentTextStyle: const TextStyle(
          color: deepBlack,
          fontWeight: FontWeight.bold,
        ),
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Rounded capsule pill shape
          side: const BorderSide(color: deepBlack, width: 2.5),
        ),
      ),

      // Neo-brutalism Card Style (White background with thick black borders)
      cardTheme: CardThemeData(
        color: backgroundWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: deepBlack,
            width: 2.5,
          ), // Thick black silhouette stroke
        ),
      ),

      // "Open It" Capsule Buttons (White Pill with a thick bottom border layout)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundWhite,
          foregroundColor: deepBlack,
          minimumSize: const Size(double.infinity, 50),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              30,
            ), // Rounded capsule pill shape
            side: const BorderSide(color: deepBlack, width: 2.5),
          ),
          elevation: 0,
        ),
      ),

      // Custom Typography mapping for the bold headlines (like "Our Boxes")
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontFamily: 'Anton',
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: backgroundWhite,
          letterSpacing: 0.5,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: deepBlack,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          color: deepBlack,
          height: 1.4,
        ),
      ),
    );
  }
}

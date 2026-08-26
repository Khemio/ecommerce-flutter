import 'package:flutter/material.dart';

class AppTheme {
  // static const Color backgroundDark = Color(0xFF0F0F11); // Deep street black
  static const Color backgroundDark = accentPurple; // Deep street black
  // static const Color surfaceCard = Color(0xFF18181C);    // Card container background
  // static const Color surfaceCard = accentPurple;    // Card container background
  static const Color surfaceCard = Color(0xFFFFFFFF);    // Card container background
  // static const Color primaryNeon = Color.fromRGBO(204, 255, 0, 1);   // Electric yellow/green highlight
  static const Color primaryNeon = accentColor;    // Electric yellow/green highlight
  static const Color accentPurple = Color(0xFF5B2EA8);   // Deep accent color
  static const Color accentColor = Color(0xFF6200EE);   // Deep accent color
  static const Color successColor = Colors.green;
  static const Color errorColor = Colors.red;
  static const Color textMain = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFF8E8E93);

// New Brand Color Palette extracted from screenshots
  static const Color brandViolet = Color(0xFF5B2EA8);    // Vibrant Purple background
  // static const Color brandViolet = Color(0xFF5A24B3);    // Vibrant Purple background
  static const Color backgroundWhite = Color(0xFFFFFFFF); // Clean White header sections
  static const Color deepBlack = Color(0xFF0D0D0D);       // Shadow borders and primary typography
  static const Color flashBlack = Color(0xFF000000);      // Flash offer top strip background

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
        backgroundColor: surfaceCard,
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
          side: const BorderSide(color: deepBlack, width: 2.5), // Thick black silhouette stroke
        ),
      ),

      // "Open It" Capsule Buttons (White Pill with a thick bottom border layout)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundWhite,
          foregroundColor: deepBlack,
          minimumSize: const Size(double.infinity, 50),
          textStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Rounded capsule pill shape
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
        titleMedium: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: deepBlack),
        bodyMedium: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: deepBlack, height: 1.4),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,
      cardColor: surfaceCard,
    
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textMain,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
        iconTheme: IconThemeData(color: textMain),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryNeon,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: surfaceCard,
        contentTextStyle: const TextStyle(
          color: Colors.white, 
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      ),

      cardTheme: CardThemeData(
        color: surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.05), width: 1),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          // backgroundColor: primaryNeon,
          // foregroundColor: Colors.black, // Dark text contrast against neon buttons
          backgroundColor: accentColor,
          foregroundColor: textMain, // Dark text contrast against neon buttons
          minimumSize: const Size(double.infinity, 54),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
      ),

      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: textMain),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textMain),
        bodyMedium: TextStyle(fontSize: 14, color: textMuted, height: 1.5),
      ),
    );
  }
}

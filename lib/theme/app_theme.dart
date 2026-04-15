import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color black = Color(0xFF1A1A1A);
  static const Color darkGray = Color(0xFF2C2C2A);
  static const Color medGray = Color(0xFF888780);
  static const Color lightGray = Color(0xFFD3D1C7);
  static const Color cream = Color(0xFFF5F4EF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color blue = Color(0xFF378ADD);
  static const Color blueSoft = Color(0xFFE6F1FB);
  static const Color green = Color(0xFF639922);
  static const Color greenSoft = Color(0xFFEAF3DE);
  static const Color amber = Color(0xFFEF9F27);
  static const Color amberSoft = Color(0xFFFAEEDA);
  static const Color red = Color(0xFFE24B4A);
  static const Color redSoft = Color(0xFFFCEBEB);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: darkGray,
        brightness: Brightness.light,
        background: cream,
        surface: white,
      ),
      scaffoldBackgroundColor: cream,
      textTheme: GoogleFonts.dmSansTextTheme().copyWith(
        displayLarge: GoogleFonts.dmSans(fontSize: 28, fontWeight: FontWeight.w600, color: black),
        titleLarge: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.w500, color: black),
        titleMedium: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w500, color: black),
        bodyLarge: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w400, color: black),
        bodyMedium: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w400, color: darkGray),
        bodySmall: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w400, color: medGray),
        labelSmall: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w500, letterSpacing: 0.5, color: medGray),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: cream,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.dmSans(fontSize: 17, fontWeight: FontWeight.w500, color: black),
        iconTheme: const IconThemeData(color: black),
      ),
      cardTheme: CardThemeData(
        color: white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: lightGray.withOpacity(0.8), width: 0.5),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: lightGray, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: lightGray, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkGray, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: GoogleFonts.dmSans(color: medGray, fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkGray,
          foregroundColor: white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w500),
          elevation: 0,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: white,
        selectedItemColor: black,
        unselectedItemColor: medGray,
        selectedLabelStyle: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w500),
        unselectedLabelStyle: GoogleFonts.dmSans(fontSize: 11),
        elevation: 0,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkGray,
        contentTextStyle: GoogleFonts.dmSans(color: white, fontSize: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        behavior: SnackBarBehavior.floating,
      ),
      dividerTheme: DividerThemeData(color: lightGray.withOpacity(0.7), thickness: 0.5),
    );
  }
}

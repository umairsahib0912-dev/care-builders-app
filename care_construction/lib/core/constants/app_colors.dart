import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Green Theme
  static const Color primaryGreen = Color(0xFF2E7D32); // Main Green
  static const Color lightGreen = Color(0xFF4CAF50);
  static const Color darkGreen = Color(0xFF1B5E20);
  static const Color accentGreen = Color(0xFF66BB6A);

  // Secondary Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF5F5F5);
  static const Color lightGrey = Color(0xFFE0E0E0);

  // Charcoal Shades
  static const Color charcoal = Color(0xFF2C3E50);
  static const Color darkCharcoal = Color(0xFF1A252F);
  static const Color lightCharcoal = Color(0xFF34495E);

  // Gold Accents
  static const Color gold = Color(0xFFFFD700);
  static const Color lightGold = Color(0xFFFFE55C);
  static const Color darkGold = Color(0xFFB8860B);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFF9E9E9E);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFEF5350);
  static const Color info = Color(0xFF42A5F5);

  // Background Colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE0E0E0);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryGreen, lightGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [darkGold, gold, lightGold],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [darkCharcoal, charcoal],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Shadow Colors
  static const Color shadow = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowHeavy = Color(0x4D000000);
}

import 'package:flutter/material.dart';

class AppColors {
  // Default Primary Colors (will be overridden by dynamic branding)
  static const Color primary = Color(0xFF1565C0);
  static const Color primaryDark = Color(0xFF0D47A1);
  static const Color primaryLight = Color(0xFF42A5F5);
  
  // Default Secondary Colors
  static const Color secondary = Color(0xFF0D47A1);
  static const Color secondaryDark = Color(0xFF01579B);
  static const Color secondaryLight = Color(0xFF1976D2);
  
  // Accent Colors
  static const Color accent = Color(0xFFFF9800);
  static const Color accentLight = Color(0xFFFFB74D);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);
  
  // Background Colors - Light Theme
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  
  // Background Colors - Dark Theme
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color cardDark = Color(0xFF2C2C2C);
  
  // Text Colors - Light Theme
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textDisabledLight = Color(0xFFBDBDBD);
  
  // Text Colors - Dark Theme
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);
  static const Color textDisabledDark = Color(0xFF666666);
  
  // Border Colors
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderDark = Color(0xFF424242);
  
  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowDark = Color(0x40000000);
  
  // Specific Feature Colors
  static const Color projectPending = Color(0xFFFFA726);
  static const Color projectInProgress = Color(0xFF42A5F5);
  static const Color projectFinished = Color(0xFF66BB6A);
  static const Color projectOnHold = Color(0xFFEF5350);
  
  static const Color billPaid = Color(0xFF66BB6A);
  static const Color billUnpaid = Color(0xFFEF5350);
  
  static const Color complaintReceived = Color(0xFF42A5F5);
  
  static const Color requestPending = Color(0xFFFFA726);
  static const Color requestApproved = Color(0xFF66BB6A);
  static const Color requestRejected = Color(0xFFEF5350);
  static const Color requestInfoNeeded = Color(0xFF29B6F6);
  
  // Chart Colors
  static const List<Color> chartColors = [
    Color(0xFF1565C0),
    Color(0xFF0D47A1),
    Color(0xFF42A5F5),
    Color(0xFF1976D2),
    Color(0xFF1E88E5),
    Color(0xFF2196F3),
    Color(0xFF64B5F6),
    Color(0xFF90CAF9),
  ];
}

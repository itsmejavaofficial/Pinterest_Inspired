import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF1A1A1A);
  static const Color accent = Color(0xFFE07A5F);
  static const Color secondaryAccent = Color(0xFF81B29A);
  static const Color background = Color(0xFFF8F7F4);
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF0EFEB);
  static const Color border = Color(0xFFEDEDE9);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textHint = Color(0xFF9E9E9E);
  static const Color iconDefault = Color(0xFF424242);
  static const Color shadow = Color(0xFF000000);

  static LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [shadow.withOpacity(0.0), shadow.withOpacity(0.15)],
  );
}

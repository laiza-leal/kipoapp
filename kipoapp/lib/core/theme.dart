import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFFEEEEEE);
  static const cardGray = Color(0xFFD9E2E9);
  static const cardBlue = Color(0x808ED6ED);
  static const primary = Color(0xFF9BC044);
  static const primaryDark = Color(0xFF205A24);
  static const action = Color(0xFF28829F);
  static const danger = Color(0xFFDF5C4B);
  static const inactive = Color(0xFF8FA2A8);
  static const textPrimary = Color(0xFF11162D);
}

ThemeData buildAppTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
    ),
    scaffoldBackgroundColor: AppColors.background,
  );
}

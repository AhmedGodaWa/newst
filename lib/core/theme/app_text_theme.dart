import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextTheme {
  AppTextTheme._();

  static const TextTheme lightTextTheme = TextTheme(
    // 20 Bold
    displayLarge: TextStyle(
      fontFamily: 'Times New Roman',
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
    ),

    // 16 Bold
    titleLarge: TextStyle(
      fontFamily: 'Times New Roman',
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
    ),

    // 16 Regular
    titleMedium: TextStyle(
      fontFamily: 'Times New Roman',
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: AppColors.textPrimary,
    ),

    // 14 Regular
    bodyLarge: TextStyle(
      fontFamily: 'Times New Roman',
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: AppColors.textPrimary,
    ),

    // 12 Regular
    bodyMedium: TextStyle(
      fontFamily: 'Times New Roman',
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: AppColors.textSecondary,
    ),

    // 14 Bold
    labelLarge: TextStyle(
      fontFamily: 'Times New Roman',
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
    ),

    // 12 Bold
    labelMedium: TextStyle(
      fontFamily: 'Times New Roman',
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: AppColors.textSecondary,
    ),
  );
}

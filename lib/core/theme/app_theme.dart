import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    textTheme: AppTextTheme.lightTextTheme,

    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: AppBarTheme(
      titleTextStyle: AppTextTheme.lightTextTheme.titleLarge,
      centerTitle: true,
      backgroundColor: AppColors.white,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        textStyle: AppTextTheme.lightTextTheme.titleMedium!.copyWith(
          color: AppColors.onPrimary,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTextTheme.lightTextTheme.bodyLarge,
      ),
    ),

    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,

      hintStyle: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),

      contentPadding: EdgeInsets.all(16),

      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.borderLight, width: 1),
      ),

      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.borderLight, width: 1),
      ),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,

      selectedLabelStyle: AppTextTheme.lightTextTheme.labelMedium!.copyWith(
        color: AppColors.primary,
      ),

      unselectedLabelStyle: AppTextTheme.lightTextTheme.labelMedium,
    ),
  );
}

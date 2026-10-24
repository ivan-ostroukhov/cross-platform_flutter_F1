import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract final class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.racingRed,
      surface: AppColors.pureWhite,
      onSurface: AppColors.carbonBlack,
      surfaceContainerHighest: Color(0xFFF0F0F0),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.racingRed,
      surface: AppColors.carbonBlack,
      onSurface: AppColors.pureWhite,
      surfaceContainerHighest: AppColors.asphaltGrey,
    ),
  );
}
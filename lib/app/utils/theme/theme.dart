// app/utils/theme/theme.dart
import 'package:flutter/material.dart';
import 'package:listatarefa1/app/utils/constants/colors.dart';

class TAppTheme {
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: TColors.primary,
    scaffoldBackgroundColor: TColors.primaryBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: TColors.primary,
      foregroundColor: TColors.textWhite,
      elevation: 2,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: TColors.textPrimary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: TColors.buttonPrimary,
        foregroundColor: TColors.textWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    cardTheme: CardThemeData(
      color: TColors.lightContainer,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: TColors.borderPrimary),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: TColors.primary,
    scaffoldBackgroundColor: TColors.dark,
    appBarTheme: const AppBarTheme(
      backgroundColor: TColors.primary,
      foregroundColor: TColors.textWhite,
      elevation: 2,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: TColors.textWhite),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: TColors.buttonSecondary,
        foregroundColor: TColors.textWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    cardTheme: CardThemeData(
      color: TColors.darkContainer,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: TColors.borderSecondary),
      ),
    ),
  );
}
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/colors.dart';

class Themes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: WhatsAppColors.primary,
    scaffoldBackgroundColor: WhatsAppColors.background,
    fontFamily: "AlbertSans",
    appBarTheme: const AppBarTheme(
      backgroundColor: WhatsAppColors.background,
      foregroundColor: WhatsAppColors.textPrimary,
      surfaceTintColor: WhatsAppColors.emerald,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: WhatsAppColors.primary,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: WhatsAppColors.primaryDark,
    scaffoldBackgroundColor: WhatsAppColors.darkBackground,
    fontFamily: "AlbertSans",
    appBarTheme: const AppBarTheme(
      backgroundColor: WhatsAppColors.darkBackground,
      foregroundColor: WhatsAppColors.darkTextPrimary,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: WhatsAppColors.primaryDark,
    ),
  );
}

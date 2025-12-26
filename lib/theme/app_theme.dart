import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color _lightBlue = Color(0xFF448AFF);
  static const Color _green = Color(0xFF4CAF50);
  static const Color _purple = Color(0xFF9C27B0);
  static const Color _orange = Color(0xFFFF9800);
  static const Color _red = Color(0xFFFF5252);
  static const Color _teal = Color(0xFF009688);
  static const Color _pink = Color(0xFFE91E63);
  static const Color _indigo = Color(0xFF3F51B5);
  static const Color _cyan = Color(0xFF00BCD4);
  static const Color _deepOrange = Color(0xFFFF5722);
  static const Color _black = Color(0xFF000000);
  static const Color _blue = Color(0xFF2196F3);
  static const Color _amber = Color(0xFFFFC107);

  static const Color primaryBlue = Color(0xFF2F80ED);

  static const Color background = Color(0xFFF5F5F5);
  static const Color white = Colors.white;
  static const Color receiverBubble = Color(0xFFE0E0E0);

  static const Color textMain = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF757575);

  static const Color border = Color(0xFFE0E0E0);
  static const Color unselectedItem = Colors.grey;

  static const Color avatarGradientStart = Color(0xFF5B7FFF);
  static const Color avatarGradientEnd = Color(0xFF9F5BFF);

  static const Color onlineIndicator = _green;
  static const Color chatAvatarGradientStart = Color(0xFF25D366);
  static const Color chatAvatarGradientEnd = Color(0xFF0F9D58);
  static const Color unreadBadge = Color(0xFF1A73E8);
  static const Color tabBarShadow = Color.fromRGBO(0, 0, 0, 0.05);
  static const Color tabBarBackground = Color(0xFFEEEEEE);

  static const List<Color> userAvatarColors = [
    _lightBlue,
    _green,
    _purple,
    _orange,
    _red,
    _teal,
    _pink,
    _indigo,
    _cyan,
    _deepOrange,
    _black,
    _blue,
    _amber,
  ];
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryBlue,
        primary: AppColors.primaryBlue,
        surface: AppColors.white,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: GoogleFonts.interTextTheme().apply(
        bodyColor: AppColors.textMain,
        displayColor: AppColors.textMain,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: AppColors.unselectedItem,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.textMain,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: AppColors.textMain),
      ),
    );
  }
}

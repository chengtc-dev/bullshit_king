import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// 應用程式主題類
///
/// 定義全域顏色、字體和主題樣式
class AppTheme {
  // --- 顏色定義 ---
  static const Color primaryColor = Color(0xFF6200EA); // 深紫色
  static const Color accentColor = Color(0xFFFFD700); // 金色
  static const Color backgroundColor = Color(0xFF121212); // 深色背景
  static const Color surfaceColor = Color(0xFF1E1E1E); // 稍亮的表面色
  static const Color errorColor = Color(0xFFCF6679); // 錯誤紅
  static const Color successColor = Color(0xFF00E676); // 成功綠

  /// 獲取深色主題配置
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColor,
        surface: surfaceColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: Colors.white,
      ),
      // 字體設定
      textTheme: TextTheme(
        displayLarge: GoogleFonts.outfit(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        displayMedium: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.outfit(fontSize: 18, color: Colors.white70),
        bodyMedium: GoogleFonts.outfit(fontSize: 16, color: Colors.white60),
        labelLarge: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      // 按鈕主題
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // 卡片主題
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

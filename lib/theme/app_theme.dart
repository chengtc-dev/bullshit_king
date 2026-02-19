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
  static const Color deepBlue = Color(0xFF1A237E); // 深藍色 (用於漸層)
  static const Color deepPurple = Color(0xFF2E004F); // 更深的紫色 (用於漸層)
  static const Color dialogBackgroundColor = Color(0xFF1A0B2E); // 對話框背景色

  /// 獲取深色主題配置
  static ThemeData get darkTheme {
    final baseTextTheme = GoogleFonts.outfitTextTheme(
      ThemeData.dark().textTheme,
    );

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
      textTheme: baseTextTheme.copyWith(
        displayLarge: GoogleFonts.outfit(
          fontSize: 72,
          fontWeight: FontWeight.bold,
          color: accentColor,
          shadows: [
            const Shadow(
              blurRadius: 20,
              color: Color(0x88FFD700),
              offset: Offset(0, 0),
            ),
          ],
        ),
        displayMedium: GoogleFonts.outfit(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headlineMedium: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: accentColor,
        ),
        headlineSmall: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titleLarge: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.outfit(fontSize: 18, color: Colors.white70),
        bodyMedium: GoogleFonts.outfit(fontSize: 16, color: Colors.white60),
        labelLarge: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 8,
          color: Colors.white54,
        ),
      ),
      // 按鈕主題
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.black,
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
      // 文字按鈕主題
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentColor,
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // 卡片主題
      cardTheme: CardThemeData(
        color: Colors.white.withValues(alpha: 0.1),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Colors.white10),
        ),
      ),
      // 對話框主題
      dialogTheme: DialogThemeData(
        backgroundColor: dialogBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: accentColor.withValues(alpha: 0.5)),
        ),
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: accentColor,
        ),
        contentTextStyle: GoogleFonts.outfit(
          fontSize: 16,
          color: Colors.white70,
        ),
      ),
      // 輸入框主題
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        hintStyle: GoogleFonts.outfit(color: Colors.white38),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentColor, width: 2),
        ),
      ),
      // 分隔線主題
      dividerTheme: const DividerThemeData(color: Colors.white24, thickness: 1),
      // 圖示主題
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }
}

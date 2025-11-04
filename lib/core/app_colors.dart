import 'package:flutter/material.dart';

/// Цвета приложения
class AppColors {
  AppColors._();

  // Основные цвета
  static const primary = Color(0xFF766DFF);
  static const primaryDark = Color(0xFF726AFF);
  static const background = Colors.white;
  static const textPrimary = Color(0xFF282828);
  static const textSecondary = Color(0xFF717171);
  static const textLight = Colors.white;

  // Акцентные цвета
  static const accent = Color(0xFFFFD580);
  static const accentText = Color(0xFF59523A);
  static const dotActive = Color(0xFFEABC60);
  static const dotInactive = Color(0xFFF1F1F1);
  static const dotInactiveDark = Color(0xFF333333);

  // Градиенты
  static const gradientStart = Color(0xFF6C63FF);
  static const gradientEnd = Color(0xFF8982FF);

  // Вспомогательные
  static const defaultBadge = Color(0xFF33A6FF);
  static const grey300 = Color(0xFFF1F1F1);

  /// Конвертация hex строки в Color
  static Color fromHex(String hex) {
    final v = hex.replaceAll('#', '');
    if (v.length == 6) return Color(int.parse('FF$v', radix: 16));
    if (v.length == 8) return Color(int.parse(v, radix: 16));
    return defaultBadge;
  }
}


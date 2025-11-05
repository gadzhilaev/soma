import 'package:flutter/material.dart';

/// Утилиты для адаптивности экранов
/// Помогает адаптировать размеры под разные устройства
class ScreenUtils {
  ScreenUtils._();

  /// Базовая ширина для дизайна (iPhone 14 Pro = 393)
  static const double baseWidth = 393.0;
  
  /// Базовая высота для дизайна (iPhone 14 Pro = 852)
  static const double baseHeight = 852.0;

  /// Получить масштаб для текущего экрана
  static double getScale(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final scale = width / baseWidth;
    
    // Ограничиваем масштаб для очень маленьких и очень больших экранов
    return scale.clamp(0.75, 1.5);
  }

  /// Получить масштаб высоты
  static double getHeightScale(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final scale = height / baseHeight;
    return scale.clamp(0.75, 1.5);
  }

  /// Адаптивный размер на основе ширины экрана
  static double adaptiveWidth(BuildContext context, double size) {
    return size * getScale(context);
  }

  /// Адаптивный размер на основе высоты экрана
  static double adaptiveHeight(BuildContext context, double size) {
    return size * getHeightScale(context);
  }

  /// Адаптивный размер (использует меньший из масштабов)
  static double adaptiveSize(BuildContext context, double size) {
    final widthScale = getScale(context);
    final heightScale = getHeightScale(context);
    return size * (widthScale < heightScale ? widthScale : heightScale);
  }

  /// Адаптивный размер шрифта
  static double adaptiveFontSize(BuildContext context, double fontSize) {
    final scale = getScale(context);
    // Для шрифтов используем более мягкий масштаб
    return fontSize * (scale * 0.9 + 0.1).clamp(0.85, 1.15);
  }

  /// Проверка, маленький ли экран (меньше 360dp)
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 360;
  }

  /// Проверка, средний ли экран (360-414dp)
  static bool isMediumScreen(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 360 && width < 414;
  }

  /// Проверка, большой ли экран (больше 414dp)
  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 414;
  }

  /// Адаптивные отступы
  static EdgeInsets adaptivePadding(BuildContext context, {
    double? horizontal,
    double? vertical,
    double? all,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    final scale = getScale(context);
    return EdgeInsets.only(
      left: (left ?? all ?? horizontal ?? 0) * scale,
      right: (right ?? all ?? horizontal ?? 0) * scale,
      top: (top ?? all ?? vertical ?? 0) * scale,
      bottom: (bottom ?? all ?? vertical ?? 0) * scale,
    );
  }

  /// Адаптивный размер для карточек
  static double adaptiveCardSize(BuildContext context, double baseSize) {
    final scale = getScale(context);
    // Для карточек используем более мягкий масштаб
    return baseSize * (scale * 0.95 + 0.05).clamp(0.9, 1.1);
  }

  /// Адаптивный размер для иконок
  static double adaptiveIconSize(BuildContext context, double baseSize) {
    final scale = getScale(context);
    return baseSize * scale.clamp(0.9, 1.1);
  }
}


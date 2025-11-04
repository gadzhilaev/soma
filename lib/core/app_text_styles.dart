import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Текстовые стили приложения
class AppTextStyles {
  AppTextStyles._();

  // Заголовки секций (20px)
  static const sectionTitle = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 20,
    height: 22 / 20,
    letterSpacing: -0.41,
    color: AppColors.textPrimary,
  );

  static const sectionTitleCompact = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 20,
    height: 1.0,
    letterSpacing: -0.41,
    color: AppColors.textPrimary,
  );

  // Заголовки карточек (14-16px)
  static const cardTitle = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    fontSize: 14,
    height: 1.1,
    color: AppColors.textPrimary,
  );

  static const cardTitleLarge = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    fontSize: 16,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static const cardTitleWhite = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    fontSize: 14,
    height: 1.1,
    color: AppColors.textLight,
  );

  // Описания
  static const description = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  static const descriptionWhite = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.4,
    color: AppColors.textLight,
  );

  // Мета-информация (время, длительность)
  static const meta = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 1.0,
    color: AppColors.textSecondary,
  );

  // Капсулы/бейджи
  static const capsule = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 10,
    height: 1.0,
    color: AppColors.textLight,
  );

  static const capsuleSmall = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 10,
    height: 1.3,
    color: AppColors.textLight,
  );

  // Кнопки
  static const button = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 12,
    height: 1.0,
    letterSpacing: 0.48,
    color: AppColors.accentText,
  );

  // Hero заголовки
  static const heroTitle = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    fontSize: 18,
    height: 1.0,
    color: AppColors.textLight,
  );

  static const heroSubtitle = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 19 / 12,
    color: AppColors.textLight,
  );

  // Музыка карточки
  static const musicTitle = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    fontSize: 14,
    height: 1.0,
    color: AppColors.textLight,
  );

  static const musicDescription = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 10,
    height: 14 / 10,
    color: AppColors.textLight,
  );

  // Плеер
  static const playerTitle = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    fontSize: 22,
    height: 1.0,
    color: AppColors.textLight,
  );

  static const playerTime = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.0,
    color: AppColors.textLight,
  );
}


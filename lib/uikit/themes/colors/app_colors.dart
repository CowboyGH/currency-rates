import 'package:flutter/material.dart';

/// Цвета приложения
abstract class AppColors {
  // Общие
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);

  // Для светлой темы
  static const lightPrimary = Color(0xFF2D5BFF); // брендовый синий
  static const lightOnPrimary = white;

  static const lightSecondary = Color(0xFF4CAF8F); // мягкий зеленовато-бирюзовый
  static const lightOnSecondary = white;

  static const lightError = Color(0xFFD32F2F); // глубокий красный
  static const lightWarning = Color(0xFFFFB300); // теплый янтарный
  static const lightSuccess = Color(0xFF2E7D32); // насыщенный зеленый

  static const lightBackground = Color(0xFFF7F8FA); // мягкий серо-голубой фон
  static const lightOnBackground = Color(0xFF1A1C1E);

  static const lightSurface = white; // карточки, панели
  static const lightOnSurface = Color(0xFF1A1C1E);

  static const lightDivider = Color(0xFFE0E3E7); // светло-серый
  static const lightDisabled = Color(0xFFB0B3B8); // приглушенный серый
  static const lightShadow = Color(0x1A000000); // легкая тень

  // Для темной темы
  static const darkPrimary = Color(0xFF5C7CFF); // брендовый, но чуть светлее
  static const darkOnPrimary = black;

  static const darkSecondary = Color(0xFF6FC1A5); // светлый акцентный зеленый
  static const darkOnSecondary = black;

  static const darkError = Color(0xFFF28B82); // светлый коралловый для ошибок
  static const darkWarning = Color(0xFFFFD54F); // мягкий желтый
  static const darkSuccess = Color(0xFF81C784); // светло-зеленый

  static const darkBackground = Color(0xFF121417); // мягкий угольно-серый фон
  static const darkOnBackground = Color(0xFFE4E6EB);

  static const darkSurface = Color(0xFF1E2024); // чуть светлее фона
  static const darkOnSurface = Color(0xFFE4E6EB);

  static const darkDivider = Color(0xFF3A3C40); // темно-серый
  static const darkDisabled = Color(0xFF6E7074); // приглушенный серый
  static const darkShadow = Color(0x66000000); // более плотная тень
}

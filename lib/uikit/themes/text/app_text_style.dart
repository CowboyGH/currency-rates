import 'package:flutter/material.dart';

const _fontFamily = 'Roboto';

/// Стили текстов
enum AppTextStyle {
  // Заголовок
  headline(
    TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      height: 1.3,
      fontFamily: _fontFamily,
    ),
  ),

  // Подзаголовок
  subtitle(
    TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 1.25,
      fontFamily: _fontFamily,
    ),
  ),

  // Основной текст
  body(
    TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.25,
      fontFamily: _fontFamily,
    ),
  ),

  // Мелкий текст / вспомогательные подписи
  caption(
    TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.2,
      fontFamily: _fontFamily,
    ),
  ),

  // Значения валют / цифры
  number(
    TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 1.3,
      fontFamily: _fontFamily,
      letterSpacing: 0.5,
    ),
  ),

  // Текст кнопок
  button(
    TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      height: 1.25,
      fontFamily: _fontFamily,
      letterSpacing: 1.25,
    ),
  );

  // Значение TextStyle
  final TextStyle value;

  const AppTextStyle(this.value);
}

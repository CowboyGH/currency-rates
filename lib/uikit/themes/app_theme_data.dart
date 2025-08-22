import 'package:currency_rates/uikit/themes/colors/app_color_theme.dart';
import 'package:currency_rates/uikit/themes/text/app_text_theme.dart';
import 'package:flutter/material.dart';

/// Тема приложения
abstract class AppThemeData {
  static const _lightColorTheme = AppColorTheme.light();
  static const _darkColorTheme = AppColorTheme.dark();
  static final _textTheme = AppTextTheme.base();

  /// Светлая тема
  static final lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: _lightColorTheme.background,
    colorScheme: ColorScheme.light(
      primary: _lightColorTheme.primary,
      onPrimary: _lightColorTheme.onPrimary,
      secondary: _lightColorTheme.secondary,
      onSecondary: _lightColorTheme.onSecondary,
      error: _lightColorTheme.error,
      surface: _lightColorTheme.surface,
      onSurface: _lightColorTheme.onSurface,
    ),
    disabledColor: _lightColorTheme.disabled,
    dividerColor: _lightColorTheme.divider,
    splashFactory: NoSplash.splashFactory,
    extensions: [_lightColorTheme, _textTheme],
  );

  /// Темная тема
  static final darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: _darkColorTheme.background,
    colorScheme: ColorScheme.dark(
      primary: _darkColorTheme.primary,
      onPrimary: _darkColorTheme.onPrimary,
      secondary: _darkColorTheme.secondary,
      onSecondary: _darkColorTheme.onSecondary,
      error: _darkColorTheme.error,
      surface: _darkColorTheme.surface,
      onSurface: _darkColorTheme.onSurface,
    ),
    disabledColor: _darkColorTheme.disabled,
    dividerColor: _darkColorTheme.divider,
    splashFactory: NoSplash.splashFactory,
    extensions: [_darkColorTheme, _textTheme],
  );
}

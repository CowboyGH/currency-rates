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
    cardTheme: CardThemeData(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      shadowColor: _lightColorTheme.shadow.withValues(alpha: 0.3),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _lightColorTheme.onSurface.withValues(alpha: 0.05),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(8),
      ),
      hintStyle: _textTheme.body.copyWith(
        color: _lightColorTheme.onSurface.withValues(alpha: 0.5),
      ),
      errorStyle: _textTheme.caption.copyWith(
        color: _lightColorTheme.error,
        overflow: TextOverflow.ellipsis,
      ),
      errorMaxLines: 2,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _lightColorTheme.primary,
        disabledBackgroundColor: _lightColorTheme.disabled,
        overlayColor: _lightColorTheme.onPrimary.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    dividerTheme: DividerThemeData(color: _lightColorTheme.divider),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: _lightColorTheme.primary,
      contentTextStyle: _textTheme.body.copyWith(
        color: _lightColorTheme.onPrimary,
        overflow: TextOverflow.ellipsis,
      ),
    ),
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
    cardTheme: CardThemeData(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      shadowColor: _darkColorTheme.shadow.withValues(alpha: 0.3),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _darkColorTheme.onSurface.withValues(alpha: 0.05),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(8),
      ),
      hintStyle: _textTheme.body.copyWith(
        color: _darkColorTheme.onSurface.withValues(alpha: 0.5),
      ),
      errorStyle: _textTheme.caption.copyWith(
        color: _darkColorTheme.error,
        overflow: TextOverflow.ellipsis,
      ),
      errorMaxLines: 2,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _darkColorTheme.primary,
        disabledBackgroundColor: _darkColorTheme.disabled,
        overlayColor: _darkColorTheme.onPrimary.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    dividerTheme: DividerThemeData(color: _darkColorTheme.divider),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: _darkColorTheme.primary,
      contentTextStyle: _textTheme.body.copyWith(
        color: _darkColorTheme.onPrimary,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  );
}

import 'package:currency_rates/uikit/themes/colors/app_colors.dart';
import 'package:flutter/material.dart';

/// Тема для цветов приложения.
@immutable
class AppColorTheme extends ThemeExtension<AppColorTheme> {
  /// Получить [AppColorTheme] из [context].
  static AppColorTheme of(BuildContext context) =>
      Theme.of(context).extension<AppColorTheme>() ?? _throwThemeNotFound(context);

  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;
  final Color error;
  final Color warning;
  final Color success;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color divider;
  final Color disabled;
  final Color shadow;

  const AppColorTheme._({
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.error,
    required this.warning,
    required this.success,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.divider,
    required this.disabled,
    required this.shadow,
  });

  /// Светлая тема
  const AppColorTheme.light()
    : primary = AppColors.lightPrimary,
      onPrimary = AppColors.lightOnPrimary,
      secondary = AppColors.lightSecondary,
      onSecondary = AppColors.lightOnSecondary,
      error = AppColors.lightError,
      warning = AppColors.lightWarning,
      success = AppColors.lightSuccess,
      background = AppColors.lightBackground,
      onBackground = AppColors.lightOnBackground,
      surface = AppColors.lightSurface,
      onSurface = AppColors.lightOnSurface,
      divider = AppColors.lightDivider,
      disabled = AppColors.lightDisabled,
      shadow = AppColors.lightShadow;

  /// Темная тема
  const AppColorTheme.dark()
    : primary = AppColors.darkPrimary,
      onPrimary = AppColors.darkOnPrimary,
      secondary = AppColors.darkSecondary,
      onSecondary = AppColors.darkOnSecondary,
      error = AppColors.darkError,
      warning = AppColors.darkWarning,
      success = AppColors.darkSuccess,
      background = AppColors.darkBackground,
      onBackground = AppColors.darkOnBackground,
      surface = AppColors.darkSurface,
      onSurface = AppColors.darkOnSurface,
      divider = AppColors.darkDivider,
      disabled = AppColors.darkDisabled,
      shadow = AppColors.darkShadow;

  @override
  ThemeExtension<AppColorTheme> copyWith({
    Color? primary,
    Color? onPrimary,
    Color? secondary,
    Color? onSecondary,
    Color? error,
    Color? warning,
    Color? success,
    Color? background,
    Color? onBackground,
    Color? surface,
    Color? onSurface,
    Color? divider,
    Color? disabled,
    Color? shadow,
  }) {
    return AppColorTheme._(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      error: error ?? this.error,
      warning: warning ?? this.warning,
      success: success ?? this.success,
      background: background ?? this.background,
      onBackground: onBackground ?? this.onBackground,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      divider: divider ?? this.divider,
      disabled: disabled ?? this.disabled,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  ThemeExtension<AppColorTheme> lerp(ThemeExtension<AppColorTheme>? other, double t) {
    if (other is! AppColorTheme) {
      return this;
    }

    return AppColorTheme._(
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t)!,
      error: Color.lerp(error, other.error, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      success: Color.lerp(success, other.success, t)!,
      background: Color.lerp(background, other.background, t)!,
      onBackground: Color.lerp(onBackground, other.onBackground, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
    );
  }
}

Never _throwThemeNotFound(BuildContext context) =>
    throw Exception('$AppColorTheme not found in $context.');

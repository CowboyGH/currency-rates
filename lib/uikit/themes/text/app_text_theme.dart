import 'package:currency_rates/uikit/themes/text/app_text_style.dart';
import 'package:flutter/material.dart';

/// {@template app_text_theme.class}
/// Тема для текстов приложения.
/// {@endtemplate}
class AppTextTheme extends ThemeExtension<AppTextTheme> {
  /// Получить [AppTextTheme] из [context].
  static AppTextTheme of(BuildContext context) =>
      Theme.of(context).extension<AppTextTheme>() ?? _throwThemeNotFound(context);

  final TextStyle headline;
  final TextStyle subtitle;
  final TextStyle body;
  final TextStyle caption;
  final TextStyle number;
  final TextStyle button;

  const AppTextTheme._({
    required this.headline,
    required this.subtitle,
    required this.body,
    required this.caption,
    required this.number,
    required this.button,
  });

  /// {@macro app_text_theme.class}
  AppTextTheme.base()
    : headline = AppTextStyle.headline.value,
      subtitle = AppTextStyle.subtitle.value,
      body = AppTextStyle.body.value,
      caption = AppTextStyle.caption.value,
      number = AppTextStyle.number.value,
      button = AppTextStyle.button.value;

  @override
  AppTextTheme copyWith({
    TextStyle? headline,
    TextStyle? subtitle,
    TextStyle? body,
    TextStyle? caption,
    TextStyle? number,
    TextStyle? button,
  }) {
    return AppTextTheme._(
      headline: headline ?? this.headline,
      subtitle: subtitle ?? this.subtitle,
      body: body ?? this.body,
      caption: caption ?? this.caption,
      number: number ?? this.number,
      button: button ?? this.button,
    );
  }

  @override
  AppTextTheme lerp(ThemeExtension<AppTextTheme>? other, double t) {
    if (other is! AppTextTheme) return this;
    return AppTextTheme._(
      headline: TextStyle.lerp(headline, other.headline, t)!,
      subtitle: TextStyle.lerp(subtitle, other.subtitle, t)!,
      body: TextStyle.lerp(body, other.body, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
      number: TextStyle.lerp(number, other.number, t)!,
      button: TextStyle.lerp(button, other.button, t)!,
    );
  }
}

Never _throwThemeNotFound(BuildContext context) =>
    throw Exception('$AppTextTheme not found in $context.');

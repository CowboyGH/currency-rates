import 'package:currency_rates/assets/strings/app_strings.dart';
import 'package:currency_rates/uikit/themes/colors/app_color_theme.dart';
import 'package:currency_rates/uikit/themes/text/app_text_theme.dart';
import 'package:flutter/material.dart';

/// Виджет ошибки загрузки данных.
class LoadErrorWidget extends StatelessWidget {
  final String? message;

  const LoadErrorWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Card(
          color: colorTheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  color: colorTheme.error,
                  size: 72,
                ),
                const SizedBox(height: 16),
                Text(
                  message ?? AppStrings.unknownError,
                  style: textTheme.body.copyWith(color: colorTheme.onBackground),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

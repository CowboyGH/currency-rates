import 'package:currency_rates/assets/strings/app_strings.dart';
import 'package:currency_rates/uikit/themes/colors/app_color_theme.dart';
import 'package:currency_rates/uikit/themes/text/app_text_theme.dart';
import 'package:flutter/material.dart';

/// Виджет ошибки загрузки курсов валют.
class CurrencyRatesLoadErrorWidget extends StatelessWidget {
  final String? message;
  final VoidCallback onRetry;

  const CurrencyRatesLoadErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: colorTheme.error,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              message ?? AppStrings.unknownError,
              style: textTheme.body.copyWith(color: colorTheme.onBackground),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              child: Text(AppStrings.retry, style: textTheme.button),
            ),
          ],
        ),
      ),
    );
  }
}

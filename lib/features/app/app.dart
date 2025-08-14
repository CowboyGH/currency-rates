import 'package:currency_rates/core/router/router.dart';
import 'package:currency_rates/uikit/themes/app_theme_data.dart';
import 'package:flutter/material.dart';

class CurrencyRatesApp extends StatelessWidget {
  const CurrencyRatesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppThemeData.lightTheme,
      darkTheme: AppThemeData.darkTheme,
      routerConfig: router,
    );
  }
}

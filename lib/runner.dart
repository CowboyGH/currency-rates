import 'package:currency_rates/features/app/app.dart';
import 'package:currency_rates/features/app/di/di.dart';
import 'package:flutter/material.dart';

void run() {
  WidgetsFlutterBinding.ensureInitialized();
  initDi();
  runApp(const CurrencyRatesApp());
}

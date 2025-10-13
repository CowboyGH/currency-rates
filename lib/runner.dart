import 'package:currency_rates/features/app/app.dart';
import 'package:currency_rates/features/app/di/di.dart';
import 'package:flutter/material.dart';

Future<void> run() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDi();
  runApp(const CurrencyRatesApp());
}

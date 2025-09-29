import 'package:currency_rates/features/history/presentation/conversion_history_screen_builder.dart';
import 'package:currency_rates/features/rates/presentation/currency_rates_screen_builder.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => CurrencyRatesScreenBuilder(),
      routes: [
        GoRoute(path: 'history', builder: (context, state) => ConversionHistoryScreenBuilder()),
      ],
    ),
  ],
);

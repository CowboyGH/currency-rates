import 'package:currency_rates/features/about/presentation/about_screen.dart';
import 'package:currency_rates/features/history/presentation/screens/conversion_history_screen_builder.dart';
import 'package:currency_rates/features/rates/presentation/screens/currency_rates_screen_builder.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => CurrencyRatesScreenBuilder(),
      routes: [
        GoRoute(path: 'history', builder: (context, state) => ConversionHistoryScreenBuilder()),
        GoRoute(path: 'about', builder: (context, state) => AboutScreen()),
      ],
    ),
  ],
);

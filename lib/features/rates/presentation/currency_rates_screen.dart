import 'package:currency_rates/features/rates/presentation/cubit/rates_cubit.dart';
import 'package:currency_rates/features/rates/presentation/widgets/currency_card_widget.dart';
import 'package:currency_rates/features/rates/presentation/widgets/currency_rates_load_error_widget.dart';
import 'package:currency_rates/uikit/themes/colors/app_color_theme.dart';
import 'package:currency_rates/uikit/themes/text/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Экран курсов валют.
class CurrencyRatesScreen extends StatefulWidget {
  const CurrencyRatesScreen({super.key});

  @override
  State<CurrencyRatesScreen> createState() => _CurrencyRatesScreenState();
}

class _CurrencyRatesScreenState extends State<CurrencyRatesScreen> {
  @override
  void initState() {
    _loadRates();
    super.initState();
  }

  void _loadRates() {
    context.read<RatesCubit>().loadRates();
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: colorTheme.surface,
        title: BlocBuilder<RatesCubit, RatesState>(
          builder: (context, state) {
            if (state is RatesLoaded) {
              String date = state.snapshot.date;
              return Text(
                'Курсы валют на $date',
                style: textTheme.subtitle.copyWith(color: colorTheme.onBackground),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              );
            }
            return const SizedBox.shrink();
          },
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () async => _loadRates(),
        child: BlocBuilder<RatesCubit, RatesState>(
          builder: (context, state) {
            if (state is RatesLoading) {
              return Center(child: CircularProgressIndicator.adaptive());
            }
            if (state is RatesLoaded) {
              final snapshot = state.snapshot;
              return ListView.separated(
                itemCount: snapshot.currencies.length,
                padding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 16,
                ),
                itemBuilder: (context, index) {
                  final currency = snapshot.currencies[index];
                  return CurrencyCardWidget(currency: currency);
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 8);
                },
              );
            }
            if (state is RatesFailure) {
              return CurrencyRatesLoadErrorWidget(
                message: state.failure.message,
                onRetry: _loadRates,
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

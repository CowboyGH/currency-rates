import 'package:currency_rates/features/rates/presentation/cubit/rates_cubit.dart';
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
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    shadowColor: colorTheme.shadow.withValues(alpha: 0.3),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Код валюты с акцентным фоном
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: colorTheme.primary,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              currency.charCode,
                              style: textTheme.number.copyWith(
                                color: colorTheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Информация о валюте
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  currency.name,
                                  style: textTheme.subtitle.copyWith(
                                    color: colorTheme.onSurface,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${currency.nominal} ${currency.charCode} = ${currency.value} ₽',
                                  style: textTheme.number.copyWith(
                                    color: colorTheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                if (currency.nominal != 1)
                                  Text(
                                    '1 ${currency.charCode} = ${currency.unitRate} ₽',
                                    style: textTheme.body.copyWith(
                                      color: colorTheme.onSurface.withValues(alpha: 0.7),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 8);
                },
              );
            }
            if (state is RatesFailure) {
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
                        state.failure.message ?? 'Неизвестная ошибка',
                        style: textTheme.body.copyWith(color: colorTheme.onBackground),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _loadRates,
                        child: Text('Повторить', style: textTheme.button),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

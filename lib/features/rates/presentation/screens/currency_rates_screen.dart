import 'package:currency_rates/assets/strings/app_strings.dart';
import 'package:currency_rates/features/common/presentation/widgets/app_drawer.dart';
import 'package:currency_rates/features/common/presentation/widgets/load_error_widget.dart';
import 'package:currency_rates/features/common/presentation/widgets/show_app_snackbar.dart';
import 'package:currency_rates/features/rates/presentation/cubits/rates/rates_cubit.dart';
import 'package:currency_rates/features/rates/presentation/widgets/currency_card_widget.dart';
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

  void _loadRates({bool isRefresh = false}) {
    context.read<RatesCubit>().loadRates(isRefresh: isRefresh);
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: colorTheme.surface,
        title: BlocBuilder<RatesCubit, RatesState>(
          buildWhen: (_, current) => current is RatesLoaded,
          builder: (_, state) {
            if (state is RatesLoaded) {
              return Text(
                '${AppStrings.currencyRatesOn} ${state.snapshot.date}',
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              ),
            ),
          ),
        ],
      ),
      endDrawer: const AppDrawer(),
      body: BlocListener<RatesCubit, RatesState>(
        listener: (_, state) {
          if (state is RatesUnchanged) {
            showAppSnackBar(context, AppStrings.refreshSuccess);
          }
        },
        child: BlocBuilder<RatesCubit, RatesState>(
          builder: (_, state) {
            switch (state) {
              case RatesLoading():
                return Center(child: CircularProgressIndicator.adaptive());
              case RatesLoaded():
                return RefreshIndicator.adaptive(
                  onRefresh: () async => _loadRates(isRefresh: true),
                  child: ListView.separated(
                    itemCount: state.snapshot.currencies.length,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    itemBuilder: (_, index) {
                      final currency = state.snapshot.currencies[index];
                      return CurrencyCardWidget(currency: currency);
                    },
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                  ),
                );
              case RatesLoadError():
                return LoadErrorWidget(message: state.failure.message);
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}

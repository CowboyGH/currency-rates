import 'package:currency_rates/assets/strings/app_strings.dart';
import 'package:currency_rates/features/history/presentation/cubits/save_record/save_record_cubit.dart';
import 'package:currency_rates/features/rates/domain/entities/currency_entity.dart';
import 'package:currency_rates/features/rates/presentation/cubits/conversion/conversion_cubit.dart';
import 'package:currency_rates/features/rates/presentation/widgets/currency_conversion_dialog.dart';
import 'package:currency_rates/uikit/themes/colors/app_color_theme.dart';
import 'package:currency_rates/uikit/themes/text/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Виджет карточки валюты.
class CurrencyCardWidget extends StatelessWidget {
  final CurrencyEntity currency;
  const CurrencyCardWidget({super.key, required this.currency});

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<ConversionCubit>()),
            BlocProvider.value(value: context.read<SaveRecordCubit>()),
          ],
          child: CurrencyConversionDialog(
            charCode: currency.charCode,
            unitRate: currency.unitRate.toString(),
          ),
        ),
        animationStyle: AnimationStyle(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        ),
      ),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                      '${currency.nominal} ${currency.charCode} = ${currency.value} ${AppStrings.ruble}',
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
                        '1 ${currency.charCode} = ${currency.unitRate} ${AppStrings.ruble}',
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
      ),
    );
  }
}

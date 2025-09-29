import 'dart:ui';

import 'package:currency_rates/assets/strings/app_strings.dart';
import 'package:currency_rates/features/common/domain/entities/conversion_record_entity.dart';
import 'package:currency_rates/features/history/presentation/cubits/save_record/save_record_cubit.dart';
import 'package:currency_rates/features/rates/presentation/cubits/conversion/conversion_cubit.dart';
import 'package:currency_rates/features/rates/presentation/widgets/currency_section_widget.dart';
import 'package:currency_rates/uikit/themes/colors/app_color_theme.dart';
import 'package:currency_rates/uikit/themes/text/app_text_theme.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Диалоговое окно для конвертации валют.
class CurrencyConversionDialog extends StatefulWidget {
  final String unitRate;
  final String charCode;

  const CurrencyConversionDialog({
    super.key,
    required this.unitRate,
    required this.charCode,
  });

  @override
  State<CurrencyConversionDialog> createState() => _CurrencyConversionDialogState();
}

class _CurrencyConversionDialogState extends State<CurrencyConversionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _resultController = TextEditingController();
  bool _canConvert = false;

  @override
  void initState() {
    super.initState();
    context.read<ConversionCubit>().reset();
    _amountController.addListener(() {
      final text = _amountController.text;
      final isNotEmpty = text.isNotEmpty;
      final isValidNumber = Decimal.tryParse(text) != null;
      if (mounted) {
        setState(() {
          _canConvert = isNotEmpty && isValidNumber;
        });
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _resultController.dispose();
    super.dispose();
  }

  /// Логика конвертации.
  /// Валидирует введённое число и запускает конвертацию через Cubit.
  void _convert() {
    if (_formKey.currentState?.validate() ?? false) {
      final amount = Decimal.tryParse(_amountController.text);
      if (amount != null) {
        context.read<ConversionCubit>().convert(
          amount: amount,
          unitRate: Decimal.parse(widget.unitRate),
        );
      }
    }
  }

  /// Форматирует число для отображения в UI:
  /// - Если число < 1e-6 → экспоненциальная форма.
  /// - Иначе → фиксированная форма (2 знаков) с обрезкой незначащих нулей.
  String _formatForDisplay(Decimal number) {
    const double minExponentialThreshold = 1e-6;
    const int fixedPrecision = 2;

    final doubleValue = number.toDouble();
    if (doubleValue.abs() < minExponentialThreshold) {
      return doubleValue.toStringAsExponential(1);
    }

    return doubleValue
        .toStringAsFixed(fixedPrecision)
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
  }

  void _showSnackBar({required String message}) {
    if (!mounted) return;
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        width: MediaQuery.sizeOf(context).width * 0.6,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: colorTheme.primary,
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: textTheme.body.copyWith(color: colorTheme.onPrimary),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);
    const targetCurrencyCharCode = AppStrings.ruble;

    return BlocListener<ConversionCubit, ConversionState>(
      listener: (_, state) {
        if (state is ConversionSuccess) {
          context.read<SaveRecordCubit>().saveRecord(
            ConversionRecordEntity(
              charCode: widget.charCode,
              amount: Decimal.parse(_amountController.text),
              result: state.result,
              unitRate: Decimal.parse(widget.unitRate),
              timestamp: DateTime.now(),
            ),
          );
          _resultController.text = _formatForDisplay(state.result);
        }
      },
      child: BlocListener<SaveRecordCubit, SaveRecordState>(
        listener: (context, state) {
          if (state is SaveRecordFailure) {
            _showSnackBar(message: state.failure.message!);
          }
        },
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
          child: AlertDialog(
            insetPadding: EdgeInsets.zero,
            titlePadding: EdgeInsets.only(left: 24, top: 16, right: 16),
            contentPadding: EdgeInsets.all(8),
            actionsPadding: EdgeInsets.only(left: 32, right: 32, bottom: 16),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: Text(
                    AppStrings.conversion,
                    style: textTheme.headline.copyWith(color: colorTheme.onSurface),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(Icons.close, color: colorTheme.onSurface),
                    onPressed: () => context.pop(),
                  ),
                ),
              ],
            ),
            content: SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.7,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Блок исходной валюты
                    CurrencySectionWidget(
                      charCode: widget.charCode,
                      hintText: '1',
                      controller: _amountController,
                      isReadOnly: false,
                    ),
                    const SizedBox(height: 8),
                    // Блок целевой валюты
                    CurrencySectionWidget(
                      charCode: targetCurrencyCharCode,
                      hintText: widget.unitRate,
                      controller: _resultController,
                      isReadOnly: true,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canConvert ? _convert : null,
                  child: Text(
                    AppStrings.convert,
                    style: textTheme.button.copyWith(
                      color: _canConvert
                          ? colorTheme.onPrimary
                          : colorTheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

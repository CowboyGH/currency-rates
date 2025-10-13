import 'package:currency_rates/features/rates/presentation/cubits/conversion/conversion_cubit.dart';
import 'package:currency_rates/uikit/themes/colors/app_color_theme.dart';
import 'package:currency_rates/uikit/themes/text/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Виджет для отображения секции валюты (исходной или целевой).
class CurrencySectionWidget extends StatelessWidget {
  final String charCode;
  final String hintText;
  final TextEditingController controller;
  final bool isReadOnly;

  const CurrencySectionWidget({
    super.key,
    required this.charCode,
    required this.hintText,
    required this.controller,
    required this.isReadOnly,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Код валюты
          Column(
            children: [
              Container(
                height: 50,
                width: 75,
                decoration: BoxDecoration(
                  color: colorTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    charCode,
                    style: textTheme.subtitle.copyWith(color: colorTheme.primary),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Поле ввода/отображения суммы
          Expanded(
            child: BlocBuilder<ConversionCubit, ConversionState>(
              buildWhen: (_, state) => state is ConversionError || state is ConversionSuccess,
              builder: (_, state) {
                String? error;
                if (!isReadOnly && state is ConversionError) {
                  error = state.failure.message;
                }
                return TextFormField(
                  controller: controller,
                  readOnly: isReadOnly,
                  autofocus: !isReadOnly,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  maxLines: 1,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                    LengthLimitingTextInputFormatter(30),
                  ],
                  style: textTheme.body.copyWith(color: colorTheme.onSurface),
                  cursorErrorColor: colorTheme.primary,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(hintText: hintText, errorText: error),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:currency_rates/assets/strings/app_strings.dart';
import 'package:currency_rates/features/history/domain/entities/conversion_record_entity.dart';
import 'package:currency_rates/uikit/themes/colors/app_color_theme.dart';
import 'package:currency_rates/uikit/themes/text/app_text_theme.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Виджет карточки записи истории конвертаций.
class ConversionHistoryRecordCardWidget extends StatelessWidget {
  final ConversionRecordEntity record;
  const ConversionHistoryRecordCardWidget({super.key, required this.record});

  String _formatDecimalWithSpaces(Decimal value) {
    final parts = value.toString().split('.');

    final integerPart = parts[0];
    final decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

    final buffer = StringBuffer();
    for (var i = 0; i < integerPart.length; i++) {
      if (i > 0 && (integerPart.length - i) % 3 == 0) {
        buffer.write(' '); // пробел каждые 3 цифры
      }
      buffer.write(integerPart[i]);
    }
    buffer.write(decimalPart);
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);
    final formattedAmount = _formatDecimalWithSpaces(record.amount);
    final formattedResult = _formatDecimalWithSpaces(record.result);
    final formattedTimestamp = DateFormat('dd.MM.yyyy HH:mm').format(record.timestamp);

    return Card(
      elevation: 2,
      shadowColor: colorTheme.shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: colorTheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Количество и Результат
            Column(
              children: [
                Text(
                  '$formattedAmount ${record.charCode}',
                  style: textTheme.headline.copyWith(color: colorTheme.onSurface),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '=',
                  style: textTheme.headline.copyWith(
                    color: colorTheme.onSurface.withValues(alpha: 0.6),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '$formattedResult RUB',
                  style: textTheme.headline.copyWith(color: colorTheme.primary),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Разделитель
            Divider(color: colorTheme.divider, height: 1),
            const SizedBox(height: 12),
            // Курс и Дата
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Rate
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.rate,
                      style: textTheme.caption.copyWith(
                        color: colorTheme.onSurface.withValues(alpha: 0.6),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '1 ${record.charCode} = ${record.unitRate} RUB',
                      style: textTheme.body.copyWith(color: colorTheme.onSurface),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                // Дата и время
                Text(
                  formattedTimestamp,
                  style: textTheme.caption.copyWith(
                    color: colorTheme.onSurface.withValues(alpha: 0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

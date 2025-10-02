import 'package:currency_rates/features/history/data/models/conversion_record_dto.dart';
import 'package:currency_rates/features/history/domain/entities/conversion_record_entity.dart';
import 'package:decimal/decimal.dart';

/// Маппер для преобразования [ConversionRecordDto] в [ConversionRecordEntity].
extension ConversionRecordDtoMapper on ConversionRecordDto {
  ConversionRecordEntity toEntity() {
    return ConversionRecordEntity(
      charCode: charCode,
      amount: Decimal.parse(amount),
      result: Decimal.parse(result),
      unitRate: Decimal.parse(unitRate),
      timestamp: DateTime.parse(timestamp),
    );
  }
}

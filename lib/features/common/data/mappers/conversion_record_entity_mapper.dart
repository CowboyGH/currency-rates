import 'package:currency_rates/features/common/data/models/conversion_record_dto.dart';
import 'package:currency_rates/features/common/domain/entities/conversion_record_entity.dart';

/// Маппер для преобразования [ConversionRecordEntity] в [ConversionRecordDto].
extension ConversionRecordEntityMapper on ConversionRecordEntity {
  ConversionRecordDto toDto() {
    return ConversionRecordDto(
      charCode: charCode,
      amount: amount.toString(),
      result: result.toString(),
      unitRate: unitRate.toString(),
      timestamp: timestamp.toIso8601String(),
    );
  }
}

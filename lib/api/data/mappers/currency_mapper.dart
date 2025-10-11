import 'package:currency_rates/api/data/currency_dto.dart';
import 'package:currency_rates/features/rates/domain/entities/currency_entity.dart';

/// Маппер для преобразования [CurrencyDto] в [CurrencyEntity].
extension CurrencyMapper on CurrencyDto {
  CurrencyEntity toEntity() => CurrencyEntity(
    charCode: charCode,
    nominal: nominal,
    name: name,
    value: value,
    unitRate: unitRate,
  );
}

import 'package:currency_rates/api/data/currency_dto.dart';
import 'package:currency_rates/features/rates/domain/entities/currency_entity.dart';

extension CurrencyMapper on CurrencyDto {
  CurrencyEntity toEntity() => CurrencyEntity(
    id: id,
    numCode: numCode,
    charCode: charCode,
    nominal: nominal,
    name: name,
    value: value,
    unitRate: unitRate,
  );
}

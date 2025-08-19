import 'package:currency_rates/api/data/mappers/currency_mapper.dart';
import 'package:currency_rates/api/data/rates_snapshot_dto.dart';
import 'package:currency_rates/features/rates/domain/entities/rates_snapshot_entity.dart';

extension RatesSnapshotMapper on RatesSnapshotDto {
  RatesSnapshotEntity toEntity() => RatesSnapshotEntity(
    date: date,
    name: name,
    currencies: currencies.map((e) => e.toEntity()).toList(),
  );
}

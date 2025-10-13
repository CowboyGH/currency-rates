import 'package:currency_rates/features/rates/domain/entities/currency_entity.dart';
import 'package:equatable/equatable.dart';

/// Сущность снимка курсов валют.
class RatesSnapshotEntity extends Equatable {
  /// Дата, за которую получены курсы валют.
  final String date;

  /// Название источника.
  final String name;

  /// Cписок валют.
  final List<CurrencyEntity> currencies;

  const RatesSnapshotEntity({
    required this.date,
    required this.name,
    required this.currencies,
  });

  @override
  List<Object?> get props => [
    date,
    name,
    currencies,
  ];
}

import 'package:equatable/equatable.dart';

/// Сущность валюты.
class CurrencyEntity extends Equatable {
  /// Текстовый код.
  final String charCode;

  /// Номинал.
  final int nominal;

  /// Название.
  final String name;

  /// Значение.
  final double value;

  /// Стоимость за единицу валюты.
  final double unitRate;

  const CurrencyEntity({
    required this.charCode,
    required this.nominal,
    required this.name,
    required this.value,
    required this.unitRate,
  });

  @override
  List<Object?> get props => [
    charCode,
    nominal,
    name,
    value,
    unitRate,
  ];
}

import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';

/// Сущность записи операции конвертации валют.
class ConversionRecordEntity extends Equatable {
  /// Текстовый код валюты.
  final String charCode;

  /// Количество исходной валюты.
  final Decimal amount;

  /// Результат конвертации в рубли.
  final Decimal result;

  /// Курс валюты на момент конвертации.
  final Decimal unitRate;

  /// Дата и время конвертации.
  final DateTime timestamp;

  const ConversionRecordEntity({
    required this.charCode,
    required this.amount,
    required this.result,
    required this.unitRate,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
    charCode,
    amount,
    result,
    unitRate,
    timestamp,
  ];
}

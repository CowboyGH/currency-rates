import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'conversion_record_dto.g.dart';

/// DTO записи операции конвертации валют.
@JsonSerializable()
class ConversionRecordDto extends Equatable {
  /// Текстовый код валюты.
  final String charCode;

  /// Количество исходной валюты.
  final String amount;

  /// Результат конвертации в рубли.
  final String result;

  /// Курс валюты на момент конвертации.
  final String unitRate;

  /// Дата и время конвертации.
  final String timestamp;

  const ConversionRecordDto({
    required this.charCode,
    required this.amount,
    required this.result,
    required this.unitRate,
    required this.timestamp,
  });

  factory ConversionRecordDto.fromJson(Map<String, dynamic> json) =>
      _$ConversionRecordDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ConversionRecordDtoToJson(this);

  @override
  List<Object?> get props => [
    charCode,
    amount,
    result,
    unitRate,
    timestamp,
  ];
}

import 'package:currency_rates/features/history/data/mappers/conversion_record_dto_mapper.dart';
import 'package:currency_rates/features/history/data/models/conversion_record_dto.dart';
import 'package:currency_rates/features/history/domain/entities/conversion_record_entity.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final String testCharCode = 'AUD';
  final String testAmount = '1';
  final String testConversionResult = '56.1801';
  final String testUnitRate = '56.1801';
  final String testTimestamp = '1969-07-20T20:18:04.000Z';

  late final ConversionRecordDto dto;
  late final ConversionRecordEntity entity;

  setUp(() {
    dto = ConversionRecordDto(
      charCode: testCharCode,
      amount: testAmount,
      result: testConversionResult,
      unitRate: testUnitRate,
      timestamp: testTimestamp,
    );

    entity = ConversionRecordEntity(
      charCode: testCharCode,
      amount: Decimal.parse(testAmount),
      result: Decimal.parse(testConversionResult),
      unitRate: Decimal.parse(testUnitRate),
      timestamp: DateTime.parse(testTimestamp),
    );
  });

  group('ConversionRecordDtoMapper', () {
    test('Корректный маппинг из DTO в Entity', () {
      final result = dto.toEntity();
      expect(result, entity);
    });
  });
}

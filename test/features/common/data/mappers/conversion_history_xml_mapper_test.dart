import 'package:currency_rates/features/common/data/mappers/conversion_history_xml_mapper.dart';
import 'package:currency_rates/features/common/data/models/conversion_record_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final String testCharCode = 'AUD';
  final String testAmount = '1';
  final String testConversionResult = '56.1801';
  final String testUnitRate = '56.1801';
  final String testTimestamp = '1969-07-20T20:18:04.000Z';

  late ConversionRecordDto dto;

  setUp(() {
    dto = ConversionRecordDto(
      charCode: testCharCode,
      amount: testAmount,
      result: testConversionResult,
      unitRate: testUnitRate,
      timestamp: testTimestamp,
    );
  });

  group('ConversionHistoryXmlMapper', () {
    test('Корректная сериализация одной записи в XML', () {
      final records = [dto];
      final xml = records.toXml();
      expect(xml, contains('<History>'));
      expect(xml, contains('<Record>'));
      expect(xml, contains('<CharCode>${dto.charCode}</CharCode>'));
      expect(xml, contains('<Amount>${dto.amount}</Amount>'));
      expect(xml, contains('<Result>${dto.result}</Result>'));
      expect(xml, contains('<UnitRate>${dto.unitRate}</UnitRate>'));
      expect(xml, contains('<Timestamp>${dto.timestamp}</Timestamp>'));
    });

    test('Корректная сериализация нескольких записей в XML', () {
      final dto2 = ConversionRecordDto(
        charCode: 'USD',
        amount: '2',
        result: '100.00',
        unitRate: '50.00',
        timestamp: '2020-01-01T00:00:00.000Z',
      );
      final records = [dto, dto2];
      final xml = records.toXml();
      expect(xml, contains('<History>'));
      expect(xml, contains('<Record>'));
      expect(xml.split('<Record>').length - 1, 2); // two records
      expect(xml, contains('<CharCode>${dto.charCode}</CharCode>'));
      expect(xml, contains('<CharCode>${dto2.charCode}</CharCode>'));
    });

    test('Пустой список формирует ровно <History></History>', () {
      final records = <ConversionRecordDto>[];
      final xml = records.toXml();

      expect(xml, contains('<History>'));
      expect(xml, contains('</History>'));
      expect(xml.contains('<Record>'), isFalse);
    });
  });
}

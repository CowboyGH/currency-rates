import 'package:currency_rates/core/domain/entities/failure/history/history_failure.dart';
import 'package:currency_rates/core/domain/entities/failure/unknown_failure.dart';
import 'package:currency_rates/features/history/data/models/conversion_record_dto.dart';
import 'package:currency_rates/features/history/data/sources/history_local_data_source_impl.dart';
import 'package:currency_rates/features/history/domain/sources/i_history_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'history_local_data_source_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Box<Map<String, dynamic>>>()])
void main() {
  late IHistoryLocalDataSource historyLocalDataSource;
  late MockBox mockBox;

  setUp(() async {
    mockBox = MockBox();
    historyLocalDataSource = HistoryLocalDataSourceImpl(mockBox);
  });

  group('HistoryLocalDataSourceImpl.readAll', () {
    test('возвращает пустой список, если box пустой', () {
      // Arrange
      when(mockBox.values).thenReturn(<Map<String, dynamic>>[]);

      // Act
      final result = historyLocalDataSource.readAllRecords();

      // Assert
      expect(result, isEmpty);
    });

    test('возвращает список с данными, если box не пустой', () {
      // Arrange
      final json1 = {
        'charCode': 'USD',
        'amount': '100',
        'result': '7500',
        'unitRate': '75',
        'timestamp': '2025-09-18T10:00:00Z',
      };
      final json2 = {
        'charCode': 'EUR',
        'amount': '50',
        'result': '4500',
        'unitRate': '90',
        'timestamp': '2025-09-18T10:05:00Z',
      };
      when(mockBox.values).thenReturn([json1, json2]);

      // Act
      final result = historyLocalDataSource.readAllRecords();

      // Assert
      expect(result.length, 2);
      expect(result[0].charCode, 'EUR');
      expect(result[1].charCode, 'USD');
    });

    test('readAllRecords корректно парсит Map<dynamic,dynamic> из бокса', () {
      // Arrange
      final dynamicMap = <dynamic, dynamic>{
        'charCode': 'USD',
        'amount': '100',
        'result': '10000',
        'unitRate': '100',
        'timestamp': '2025-09-18T10:05:00Z',
      };
      when(mockBox.values).thenReturn([Map<String, dynamic>.from(dynamicMap)]);

      // Act
      final result = historyLocalDataSource.readAllRecords();

      // Assert
      expect(result.length, 1);
      expect(result.first.charCode, 'USD');
    });

    test('возвращает HistoryStorageFailure при ошибке локального хранилища', () async {
      // Arrange
      when(mockBox.values).thenThrow(HiveError(''));

      // Act & Assert
      expect(
        () => historyLocalDataSource.readAllRecords(),
        throwsA(isA<HistoryStorageFailure>()),
      );
    });

    test('возвращает UnknownFailure при неизвестной ошибке', () async {
      // Arrange
      when(mockBox.values).thenThrow(Object());

      // Act & Assert
      expect(
        () => historyLocalDataSource.readAllRecords(),
        throwsA(isA<UnknownFailure>()),
      );
    });
  });

  group('HistoryLocalDataSourceImpl.save', () {
    late ConversionRecordDto dto;

    setUp(() {
      dto = ConversionRecordDto(
        charCode: 'USD',
        amount: '100',
        result: '10000',
        unitRate: '100',
        timestamp: '2025-09-18T10:05:00Z',
      );
    });

    test('вызывает add один раз при сохранении одного элемента', () async {
      // Arrange
      when(mockBox.add(any)).thenAnswer((_) async => 0);

      // Act
      await historyLocalDataSource.saveRecord(dto);

      // Assert
      verify(mockBox.add(dto.toJson())).called(1);
    });

    test('возвращает HistorySaveFailure при ошибке сохранения', () async {
      // Arrange
      when(mockBox.add(any)).thenThrow(HiveError(''));

      // Act & Assert
      expect(
        () => historyLocalDataSource.saveRecord(dto),
        throwsA(isA<HistorySaveFailure>()),
      );
    });

    test('возвращает UnknownFailure при неизвестной ошибке', () async {
      // Arrange
      when(mockBox.add(any)).thenThrow(Object());

      // Act & Assert
      expect(
        () => historyLocalDataSource.saveRecord(dto),
        throwsA(isA<UnknownFailure>()),
      );
    });
  });

  group('HistoryLocalDataSourceImpl.getHistoryAsXmlString', () {
    test('создает корректный XML для одной записи', () async {
      // Arrange
      final dto = ConversionRecordDto(
        charCode: 'USD',
        amount: '100',
        result: '7500',
        unitRate: '75',
        timestamp: '2025-09-18T10:00:00Z',
      );
      when(mockBox.values).thenReturn([dto.toJson()]);

      // Act
      final xml = await historyLocalDataSource.getHistoryAsXmlString();

      // Assert
      expect(xml, contains('<History>'));
      expect(xml, contains('</History>'));
      expect(xml, contains('<Result>7500</Result>'));
    });

    test('создает корректный XML для нескольких записей', () async {
      // Arrange
      final dto1 = ConversionRecordDto(
        charCode: 'USD',
        amount: '100',
        result: '7500',
        unitRate: '75',
        timestamp: '2025-09-18T10:00:00Z',
      );
      final dto2 = ConversionRecordDto(
        charCode: 'EUR',
        amount: '50',
        result: '4500',
        unitRate: '90',
        timestamp: '2025-09-18T10:05:00Z',
      );
      when(mockBox.values).thenReturn([dto1.toJson(), dto2.toJson()]);

      // Act
      final xml = await historyLocalDataSource.getHistoryAsXmlString();

      // Assert
      expect(xml, contains('<History>'));
      expect(xml, contains('</History>'));
      expect(xml, contains('<Result>7500</Result>'));
      expect(xml, contains('<Result>4500</Result>'));
    });

    test('возвращает XML только с корневым тегом, когда список пуст', () async {
      // Arrange
      when(mockBox.values).thenReturn([]);

      // Act
      final xml = await historyLocalDataSource.getHistoryAsXmlString();

      // Assert
      expect(xml, contains('<History>'));
      expect(xml, contains('</History>'));
      expect(xml, isNot(contains('<Record>')));
    });

    test('возвращает HistoryExportFailure при ошибке экспорта истории в XML-строку', () async {
      // Arrange
      when(mockBox.values).thenThrow(Object());

      // Act & Assert
      await expectLater(
        historyLocalDataSource.getHistoryAsXmlString(),
        throwsA(isA<HistoryExportFailure>()),
      );
    });
  });
}

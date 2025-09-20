import 'dart:io';

import 'package:currency_rates/features/common/data/models/conversion_record_dto.dart';
import 'package:currency_rates/features/common/data/sources/history_local_data_source_impl.dart';
import 'package:currency_rates/features/common/domain/sources/i_history_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'history_local_data_source_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Box<Map<String, dynamic>>>()])
void main() {
  late IHistoryLocalDataSource historyLocalDataSource;
  late MockBox mockBox;
  late Directory tempDir;

  setUp(() async {
    mockBox = MockBox();
    historyLocalDataSource = HistoryLocalDataSourceImpl(mockBox);
    tempDir = await Directory.systemTemp.createTemp('test_');
  });

  tearDown(() async {
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('HistoryLocalDataSourceImpl.readAll', () {
    test('возвращает пустой список, если box пустой', () {
      // Arrange
      when(mockBox.values).thenReturn(<Map<String, dynamic>>[]);

      // Act
      final result = historyLocalDataSource.readAll();

      // Assert
      expect(result, isEmpty);
    });

    test('возвращает пустой список, если в box есть данные', () {
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
      final result = historyLocalDataSource.readAll();

      // Assert
      expect(result.length, 2);
      expect(result[0].charCode, 'USD');
      expect(result[1].charCode, 'EUR');
    });
  });

  group('HistoryLocalDataSourceImpl.save', () {
    test('вызывает add один раз при сохранении одного элемента', () async {
      // Arrange
      final dto = ConversionRecordDto(
        charCode: 'USD',
        amount: '100',
        result: '10000',
        unitRate: '100',
        timestamp: '2025-09-18T10:05:00Z',
      );
      when(mockBox.add(any)).thenAnswer((_) async => 0);

      // Act
      await historyLocalDataSource.save(dto);

      // Assert
      verify(mockBox.add(dto.toJson())).called(1);
    });
  });

  group('HistoryLocalDataSourceImpl.exportXml', () {
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

      final filePath = '${tempDir.path}/test_single.xml';

      // Act
      await historyLocalDataSource.exportXml(filePath);

      // Assert
      final content = await File(filePath).readAsString();
      expect(content, contains('<History>'));
      expect(content, contains('</History>'));
      expect(content, contains('<Result>7500</Result>'));
    });

    test('должен создать XML с несколькими записями', () async {
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

      final filePath = '${tempDir.path}/test_multiply.xml';

      // Act
      await historyLocalDataSource.exportXml(filePath);

      // Assert
      final content = await File(filePath).readAsString();
      expect(content, contains('<History>'));
      expect(content, contains('</History>'));
      expect(content, contains('<Result>7500</Result>'));
      expect(content, contains('<Result>4500</Result>'));
    });

    test('должен создать XML только с корневым тегом, когда список пуст', () async {
      // Arrange
      when(mockBox.values).thenReturn([]);

      final filePath = '${tempDir.path}/test_empty.xml';

      // Act
      await historyLocalDataSource.exportXml(filePath);

      // Assert
      final content = await File(filePath).readAsString();
      expect(content, contains('<History>'));
      expect(content, contains('</History>'));
      expect(content, isNot(contains('<Record>')));
    });
  });
}

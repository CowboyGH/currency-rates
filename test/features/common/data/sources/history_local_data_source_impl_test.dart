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

  setUp(() {
    mockBox = MockBox();
    historyLocalDataSource = HistoryLocalDataSourceImpl(mockBox);
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
}

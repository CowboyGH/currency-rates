import 'package:currency_rates/core/domain/entities/failure/history/history_failure.dart';
import 'package:currency_rates/core/domain/entities/failure/unknown_failure.dart';
import 'package:currency_rates/features/common/data/models/conversion_record_dto.dart';
import 'package:currency_rates/features/common/data/repositories/history_repository_impl.dart';
import 'package:currency_rates/features/common/domain/repositories/i_history_repository.dart';
import 'package:currency_rates/features/common/domain/sources/i_history_local_data_source.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'history_repository_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<IHistoryLocalDataSource>()])
void main() {
  late IHistoryLocalDataSource historyLocalDataSource;
  late IHistoryRepository historyRepository;

  setUp(() {
    historyLocalDataSource = MockIHistoryLocalDataSource();
    historyRepository = HistoryRepositoryImpl(localDataSource: historyLocalDataSource);
  });

  group('HistoryRepositoryImpl.getAll', () {
    test('возвращает список с сущностями', () async {
      // Arrange
      final dto = ConversionRecordDto(
        charCode: 'USD',
        amount: '100',
        result: '10000',
        unitRate: '100',
        timestamp: '2025-09-18T10:05:00Z',
      );
      when(historyLocalDataSource.readAll()).thenAnswer(
        (_) => <ConversionRecordDto>[dto],
      );

      // Act
      final result = await historyRepository.getAll();
      final entities = result.success!;

      // Assert
      expect(result.isSuccess, isTrue);
      expect(entities[0].charCode, 'USD');
      expect(entities[0].result, Decimal.fromInt(10000));

      verify(historyLocalDataSource.readAll()).called(1);
    });

    test('возвращает HistoryEmptyFailure при пустом списке', () async {
      // Arrange
      when(historyLocalDataSource.readAll()).thenAnswer((_) => <ConversionRecordDto>[]);

      // Act
      final result = await historyRepository.getAll();
      final failure = result.failure!;

      // Assert
      expect(result.isFailure, isTrue);
      expect(failure, isA<HistoryEmptyFailure>());

      verify(historyLocalDataSource.readAll()).called(1);
    });

    test('возвращает HistoryStorageFailure при ошибке локального хранилища', () async {
      // Arrange
      when(historyLocalDataSource.readAll()).thenThrow(HiveError(''));

      // Act
      final result = await historyRepository.getAll();
      final failure = result.failure!;

      // Assert
      expect(result.isFailure, isTrue);
      expect(failure, isA<HistoryStorageFailure>());

      verify(historyLocalDataSource.readAll()).called(1);
    });

    test('возвращает UnknownFailure при неизвестной ошибке', () async {
      // Arrange
      when(historyLocalDataSource.readAll()).thenThrow(Object());

      // Act
      final result = await historyRepository.getAll();
      final failure = result.failure!;

      // Assert
      expect(result.isFailure, isTrue);
      expect(failure, isA<UnknownFailure>());

      verify(historyLocalDataSource.readAll()).called(1);
    });
  });
}

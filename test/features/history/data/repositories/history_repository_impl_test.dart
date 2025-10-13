import 'package:currency_rates/core/domain/entities/failure/app_failure.dart';
import 'package:currency_rates/core/domain/entities/failure/history/history_failure.dart';
import 'package:currency_rates/core/domain/entities/failure/unknown_failure.dart';
import 'package:currency_rates/features/history/data/mappers/conversion_record_dto_mapper.dart';
import 'package:currency_rates/features/history/data/mappers/conversion_record_entity_mapper.dart';
import 'package:currency_rates/features/history/data/models/conversion_record_dto.dart';
import 'package:currency_rates/features/history/data/repositories/history_repository_impl.dart';
import 'package:currency_rates/features/history/domain/entities/conversion_record_entity.dart';
import 'package:currency_rates/features/history/domain/repositories/i_history_repository.dart';
import 'package:currency_rates/features/history/domain/sources/i_history_local_data_source.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
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
      when(historyLocalDataSource.readAllRecords()).thenAnswer(
        (_) => <ConversionRecordDto>[dto],
      );

      // Act
      final result = await historyRepository.getAllRecords();
      final entities = result.success!;

      // Assert
      expect(result.isSuccess, isTrue);
      expect(entities[0].charCode, 'USD');
      expect(entities[0].result, Decimal.fromInt(10000));

      verify(historyLocalDataSource.readAllRecords()).called(1);
    });

    test('возвращает HistoryEmptyFailure при пустом списке', () async {
      // Arrange
      when(historyLocalDataSource.readAllRecords()).thenAnswer((_) => <ConversionRecordDto>[]);

      // Act
      final result = await historyRepository.getAllRecords();
      final failure = result.failure!;

      // Assert
      expect(result.isFailure, isTrue);
      expect(failure, isA<HistoryEmptyFailure>());

      verify(historyLocalDataSource.readAllRecords()).called(1);
    });

    test('возвращает HistoryFailure при ошибке чтения данных', () async {
      // Arrange
      when(historyLocalDataSource.readAllRecords()).thenThrow(HistoryStorageFailure());

      // Act
      final result = await historyRepository.getAllRecords();
      final failure = result.failure!;

      // Assert
      expect(result.isFailure, isTrue);
      expect(failure, isA<HistoryFailure>());

      verify(historyLocalDataSource.readAllRecords()).called(1);
    });

    test('возвращает AppFailure при неизвестной ошибке источника данных', () async {
      // Arrange
      when(historyLocalDataSource.readAllRecords()).thenThrow(UnknownFailure());

      // Act
      final result = await historyRepository.getAllRecords();
      final failure = result.failure!;

      // Assert
      expect(result.isFailure, isTrue);
      expect(failure, isA<AppFailure>());

      verify(historyLocalDataSource.readAllRecords()).called(1);
    });
  });

  group('HistoryRepositoryImpl.save', () {
    late ConversionRecordEntity entity;
    late ConversionRecordDto dto;

    setUp(() {
      entity = ConversionRecordEntity(
        charCode: 'USD',
        amount: Decimal.parse('100'),
        result: Decimal.parse('10000'),
        unitRate: Decimal.parse('100'),
        timestamp: DateTime.parse('2025-09-18T10:05:00Z'),
      );
      dto = entity.toDto();
    });

    test('корректно сохраняет запись конвертации', () async {
      // Arrange
      when(historyLocalDataSource.saveRecord(dto)).thenAnswer((_) async {});

      // Act
      final result = await historyRepository.saveRecord(entity);

      // Assert
      expect(result.isSuccess, isTrue);
      verify(historyLocalDataSource.saveRecord(dto)).called(1);
    });

    test('возвращает HistoryFailure при ошибке сохранения данных', () async {
      // Arrange
      when(historyLocalDataSource.saveRecord(dto)).thenThrow(HistorySaveFailure());

      // Act
      final result = await historyRepository.saveRecord(dto.toEntity());
      final failure = result.failure!;

      // Assert
      expect(result.isFailure, isTrue);
      expect(failure, isA<HistoryFailure>());

      verify(historyLocalDataSource.saveRecord(dto)).called(1);
    });

    test('возвращает AppFailure при неизвестной ошибке источника данных', () async {
      // Arrange
      when(historyLocalDataSource.saveRecord(dto)).thenThrow(UnknownFailure());

      // Act
      final result = await historyRepository.saveRecord(dto.toEntity());
      final failure = result.failure!;

      // Assert
      expect(result.isFailure, isTrue);
      expect(failure, isA<UnknownFailure>());

      verify(historyLocalDataSource.saveRecord(dto)).called(1);
    });
  });

  group('HistoryRepositoryImpl.getHistoryAsXmlString', () {
    test('возвращает успешный результат в виде XML-строки', () async {
      // Arrange
      const xmlString = '<History></History>';
      when(historyLocalDataSource.getHistoryAsXmlString()).thenAnswer((_) async => xmlString);

      // Act
      final result = await historyRepository.getHistoryAsXmlString();

      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.success, xmlString);
      verify(historyLocalDataSource.getHistoryAsXmlString()).called(1);
    });

    test('возвращает HistoryFailure при ошибке экспорта данных', () async {
      // Arrange
      when(historyLocalDataSource.getHistoryAsXmlString()).thenThrow(HistoryExportFailure());

      // Act
      final result = await historyRepository.getHistoryAsXmlString();
      final failure = result.failure!;

      // Assert
      expect(result.isFailure, isTrue);
      expect(failure, isA<HistoryExportFailure>());

      verify(historyLocalDataSource.getHistoryAsXmlString()).called(1);
    });

    test('возвращает AppFailure при ошибке источника данных', () async {
      // Arrange
      when(historyLocalDataSource.getHistoryAsXmlString()).thenThrow(UnknownFailure());

      // Act
      final result = await historyRepository.getHistoryAsXmlString();
      final failure = result.failure!;

      // Assert
      expect(result.isFailure, isTrue);
      expect(failure, isA<AppFailure>());
      expect(failure, isA<UnknownFailure>());

      verify(historyLocalDataSource.getHistoryAsXmlString()).called(1);
    });
  });
}

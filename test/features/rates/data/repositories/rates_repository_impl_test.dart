import 'package:currency_rates/api/data/currency_dto.dart';
import 'package:currency_rates/api/data/rates_snapshot_dto.dart';
import 'package:currency_rates/core/domain/entities/failure/network/network_failure.dart';
import 'package:currency_rates/core/domain/entities/failure/unknown_failure.dart';
import 'package:currency_rates/features/rates/data/repositories/rates_repository_impl.dart';
import 'package:currency_rates/features/rates/data/sources/rates_remote_data_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'rates_repository_impl_test.mocks.dart';

@GenerateMocks([RatesRemoteDataSource])
void main() {
  late RatesRepositoryImpl ratesRepository;
  late RatesRemoteDataSource mockRatesRemoteDataSource;
  const RatesSnapshotDto snapshotDto = RatesSnapshotDto(
    date: '16.08.2025',
    name: 'Foreign Currency Market',
    currencies: [
      CurrencyDto(
        id: 'R01010',
        numCode: 036,
        charCode: 'AUD',
        nominal: 1,
        name: 'Австралийский доллар',
        value: 52.0546,
        unitRate: 52.0546,
      ),
    ],
  );
  setUp(() {
    mockRatesRemoteDataSource = MockRatesRemoteDataSource();
    ratesRepository = RatesRepositoryImpl(remoteDataSource: mockRatesRemoteDataSource);
  });

  group('RatesRepositoryImpl', () {
    test('возвращает SnapshotEntity при успешном ответе DataSource', () async {
      // Arrange
      when(mockRatesRemoteDataSource.getRates()).thenAnswer((_) async => snapshotDto);

      // Act
      final result = await ratesRepository.getRates();
      final snapshot = result.success!;

      // Assert
      expect(result.isSuccess, true);
      expect(snapshot.date, '16.08.2025');
      expect(snapshot.name, 'Foreign Currency Market');
      expect(snapshot.currencies.length, 1);
      expect(snapshot.currencies[0].charCode, 'AUD');

      verify(mockRatesRemoteDataSource.getRates()).called(1);
    });

    test('возвращает NoNetworkFailure при ошибке сети', () async {
      // Arrange
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.connectionError,
      );
      when(
        mockRatesRemoteDataSource.getRates(),
      ).thenThrow(dioException);

      // Act
      final result = await ratesRepository.getRates();
      final fail = result.failure!;

      // Assert
      expect(result.isFailure, true);
      expect(fail, isA<NoNetworkFailure>());
      expect(fail.message, isNotEmpty);

      verify(mockRatesRemoteDataSource.getRates()).called(1);
    });

    test('возвращает UnknownNetworkFailure при неизвестной ошибке сети', () async {
      // Arrange
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.unknown,
      );
      when(
        mockRatesRemoteDataSource.getRates(),
      ).thenThrow(dioException);

      // Act
      final result = await ratesRepository.getRates();
      final fail = result.failure!;

      // Assert
      expect(result.isFailure, true);
      expect(fail, isA<UnknownNetworkFailure>());
      expect(fail.message, isNotEmpty);
      expect(fail.parentException, equals(dioException));

      verify(mockRatesRemoteDataSource.getRates()).called(1);
    });

    test('возвращает UnknownFailure при неизвестной ошибке', () async {
      // Arrange
      final unknownError = Object();
      when(
        mockRatesRemoteDataSource.getRates(),
      ).thenThrow(unknownError);

      // Act
      final result = await ratesRepository.getRates();
      final fail = result.failure!;

      // Assert
      expect(result.isFailure, true);
      expect(fail, isA<UnknownFailure>());
      expect(fail.message, isNotEmpty);
      expect(fail.parentException, isNull);

      verify(mockRatesRemoteDataSource.getRates()).called(1);
    });
  });
}

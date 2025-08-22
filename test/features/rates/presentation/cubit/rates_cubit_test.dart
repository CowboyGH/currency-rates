import 'package:bloc_test/bloc_test.dart';
import 'package:currency_rates/core/domain/entities/failure/app_failure.dart';
import 'package:currency_rates/core/domain/entities/failure/network/network_failure.dart';
import 'package:currency_rates/core/domain/entities/failure/unknown_failure.dart';
import 'package:currency_rates/core/domain/entities/result/result.dart';
import 'package:currency_rates/features/rates/domain/entities/currency_entity.dart';
import 'package:currency_rates/features/rates/domain/entities/rates_snapshot_entity.dart';
import 'package:currency_rates/features/rates/domain/usecases/get_rates_usecase.dart';
import 'package:currency_rates/features/rates/presentation/cubit/rates_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'rates_cubit_test.mocks.dart';

@GenerateMocks([GetRatesUsecase])
void main() {
  late GetRatesUsecase mockGetRatesUsecase;

  const snapshot = RatesSnapshotEntity(
    date: '16.08.2025',
    name: 'Foreign Currency Market',
    currencies: [
      CurrencyEntity(
        id: 'R01010',
        numCode: 36,
        charCode: 'AUD',
        nominal: 1,
        name: 'Австралийский доллар',
        value: 52.0546,
        unitRate: 52.0546,
      ),
    ],
  );

  provideDummy<Result<RatesSnapshotEntity, AppFailure>>(const Success(snapshot));

  setUp(() {
    mockGetRatesUsecase = MockGetRatesUsecase();
  });

  group('RatesCubit.loadRates', () {
    blocTest<RatesCubit, RatesState>(
      'при вызове loadRates эмитит [RatesLoading, RatesLoaded] при успешном ответе use case',
      build: () {
        when(mockGetRatesUsecase()).thenAnswer((_) async => Success(snapshot));
        return RatesCubit(mockGetRatesUsecase);
      },
      act: (cubit) => cubit.loadRates(),
      expect: () => [
        RatesLoading(),
        const RatesLoaded(snapshot),
      ],
      verify: (_) {
        verify(mockGetRatesUsecase()).called(1);
        verifyNoMoreInteractions(mockGetRatesUsecase);
      },
    );

    blocTest(
      'при вызове loadRates эмитит [RatesLoading, RatesError] при отсутствии интернет-соединения',
      build: () {
        when(mockGetRatesUsecase()).thenAnswer((_) async => Failure(NoNetworkFailure()));
        return RatesCubit(mockGetRatesUsecase);
      },
      act: (cubit) => cubit.loadRates(),
      expect: () => [
        RatesLoading(),
        isA<RatesFailure>().having((s) => s.failure, 'failure', isA<NoNetworkFailure>()),
      ],
      verify: (_) {
        verify(mockGetRatesUsecase()).called(1);
        verifyNoMoreInteractions(mockGetRatesUsecase);
      },
    );

    blocTest(
      'при вызове loadRates эмитит [RatesLoading, RatesError] при неизвестной ошибке сети',
      build: () {
        when(
          mockGetRatesUsecase(),
        ).thenAnswer((_) async => Failure(UnknownNetworkFailure(Exception())));
        return RatesCubit(mockGetRatesUsecase);
      },
      act: (cubit) => cubit.loadRates(),
      expect: () => [
        RatesLoading(),
        isA<RatesFailure>().having((s) => s.failure, 'failure', isA<UnknownNetworkFailure>()),
      ],
      verify: (_) {
        verify(mockGetRatesUsecase()).called(1);
        verifyNoMoreInteractions(mockGetRatesUsecase);
      },
    );

    blocTest(
      'при вызове loadRates эмитит [RatesLoading, RatesError] при неизвестной ошибке',
      build: () {
        when(mockGetRatesUsecase()).thenAnswer((_) async => Failure(UnknownFailure()));
        return RatesCubit(mockGetRatesUsecase);
      },
      act: (cubit) => cubit.loadRates(),
      expect: () => [
        RatesLoading(),
        isA<RatesFailure>().having((s) => s.failure, 'failure', isA<UnknownFailure>()),
      ],
      verify: (_) {
        verify(mockGetRatesUsecase()).called(1);
        verifyNoMoreInteractions(mockGetRatesUsecase);
      },
    );
  });
}

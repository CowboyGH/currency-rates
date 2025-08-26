import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:currency_rates/core/domain/entities/failure/app_failure.dart';
import 'package:currency_rates/core/domain/entities/failure/network/network_failure.dart';
import 'package:currency_rates/core/domain/entities/failure/unknown_failure.dart';
import 'package:currency_rates/core/domain/entities/result/result.dart';
import 'package:currency_rates/core/services/network_service.dart';
import 'package:currency_rates/features/rates/domain/entities/currency_entity.dart';
import 'package:currency_rates/features/rates/domain/entities/rates_snapshot_entity.dart';
import 'package:currency_rates/features/rates/domain/usecases/get_rates_usecase.dart';
import 'package:currency_rates/features/rates/presentation/cubit/rates_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'rates_cubit_test.mocks.dart';

@GenerateMocks([NetworkService, GetRatesUsecase])
void main() {
  late NetworkService mockNetworkService;
  late GetRatesUsecase mockGetRatesUsecase;
  late StreamController<ConnectivityResult> connectivityController;

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
    mockNetworkService = MockNetworkService();
    mockGetRatesUsecase = MockGetRatesUsecase();
    connectivityController = StreamController<ConnectivityResult>();
    when(mockNetworkService.onStatusChange).thenAnswer((_) => connectivityController.stream);
    when(mockNetworkService.getCurrentStatus()).thenAnswer((_) async => ConnectivityResult.wifi);
  });

  tearDown(() {
    connectivityController.close();
  });

  group('RatesCubit.loadRates', () {
    blocTest<RatesCubit, RatesState>(
      'эмитит [RatesLoading, RatesLoaded] при наличии интернет-соединения',
      build: () {
        when(mockGetRatesUsecase()).thenAnswer((_) async => Success(snapshot));
        return RatesCubit(mockNetworkService, mockGetRatesUsecase);
      },
      act: (cubit) async => await cubit.loadRates(),
      expect: () => [
        const RatesLoading(),
        const RatesLoaded(snapshot),
      ],
      verify: (_) {
        verify(mockGetRatesUsecase()).called(1);
        verifyNoMoreInteractions(mockGetRatesUsecase);
      },
    );

    blocTest<RatesCubit, RatesState>(
      'эмитит [RatesUnchanged, RatesLoaded] при обновлении без изменения данных после первой загрузки',
      build: () {
        when(mockGetRatesUsecase()).thenAnswer((_) async => Success(snapshot));
        return RatesCubit(mockNetworkService, mockGetRatesUsecase);
      },
      act: (cubit) async {
        await cubit.loadRates(); // первая загрузка
        await cubit.loadRates(isRefresh: true); // refresh без изменений
      },
      expect: () => [
        const RatesLoading(),
        const RatesLoaded(snapshot),
        const RatesUnchanged(),
        const RatesLoaded(snapshot),
      ],
      verify: (_) {
        verify(mockGetRatesUsecase()).called(2);
        verifyNoMoreInteractions(mockGetRatesUsecase);
      },
    );

    blocTest(
      'эмитит [RatesLoading, RatesFailure] при отсутствии интернет-соединения',
      build: () {
        when(mockGetRatesUsecase()).thenAnswer((_) async => Failure(NoNetworkFailure()));
        return RatesCubit(mockNetworkService, mockGetRatesUsecase);
      },
      act: (cubit) async => await cubit.loadRates(),
      expect: () => [
        const RatesLoading(),
        isA<RatesFailure>().having((s) => s.failure, 'failure', isA<NoNetworkFailure>()),
      ],
      verify: (_) {
        verify(mockGetRatesUsecase()).called(1);
        verifyNoMoreInteractions(mockGetRatesUsecase);
      },
    );

    blocTest<RatesCubit, RatesState>(
      'эмитит [RatesFailure] при старте без сети и [RatesLoaded] после восстановления',
      build: () {
        when(
          mockNetworkService.getCurrentStatus(),
        ).thenAnswer((_) async => ConnectivityResult.none);
        when(mockGetRatesUsecase()).thenAnswer((_) async => Success(snapshot));
        return RatesCubit(mockNetworkService, mockGetRatesUsecase);
      },
      act: (cubit) async {
        connectivityController.add(ConnectivityResult.wifi);
      },
      expect: () => [
        isA<RatesFailure>().having((s) => s.failure, 'failure', isA<NoNetworkFailure>()),
        const RatesLoaded(snapshot),
      ],
      verify: (_) {
        verify(mockGetRatesUsecase()).called(1);
      },
    );

    blocTest(
      'эмитит [RatesLoading, RatesFailure] при неизвестной ошибке сети',
      build: () {
        when(
          mockGetRatesUsecase(),
        ).thenAnswer((_) async => Failure(UnknownNetworkFailure(Exception())));
        return RatesCubit(mockNetworkService, mockGetRatesUsecase);
      },
      act: (cubit) async => await cubit.loadRates(),
      expect: () => [
        const RatesLoading(),
        isA<RatesFailure>().having((s) => s.failure, 'failure', isA<UnknownNetworkFailure>()),
      ],
      verify: (_) {
        verify(mockGetRatesUsecase()).called(1);
        verifyNoMoreInteractions(mockGetRatesUsecase);
      },
    );

    blocTest(
      'эмитит [RatesLoading, RatesFailure] при неизвестной ошибке',
      build: () {
        when(mockGetRatesUsecase()).thenAnswer((_) async => Failure(UnknownFailure()));
        return RatesCubit(mockNetworkService, mockGetRatesUsecase);
      },
      act: (cubit) async => await cubit.loadRates(),
      expect: () => [
        const RatesLoading(),
        isA<RatesFailure>().having((s) => s.failure, 'failure', isA<UnknownFailure>()),
      ],
      verify: (_) {
        verify(mockGetRatesUsecase()).called(1);
        verifyNoMoreInteractions(mockGetRatesUsecase);
      },
    );
  });
}

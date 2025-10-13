import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:currency_rates/core/domain/entities/failure/app_failure.dart';
import 'package:currency_rates/core/domain/entities/failure/network/network_failure.dart';
import 'package:currency_rates/core/domain/entities/failure/unknown_failure.dart';
import 'package:currency_rates/core/domain/entities/result/result.dart';
import 'package:currency_rates/core/services/network_service.dart';
import 'package:currency_rates/features/rates/domain/entities/rates_snapshot_entity.dart';
import 'package:currency_rates/features/rates/domain/usecases/get_rates_usecase.dart';
import 'package:currency_rates/features/rates/presentation/cubits/rates/rates_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'rates_cubit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<NetworkService>(),
  MockSpec<GetRatesUsecase>(),
])
void main() {
  late NetworkService mockNetworkService;
  late GetRatesUsecase mockGetRatesUsecase;
  late StreamController<ConnectivityResult> connectivityController;
  late RatesCubit ratesCubit;

  const snapshot = RatesSnapshotEntity(
    date: '16.08.2025',
    name: 'Foreign Currency Market',
    currencies: [],
  );
  const changedSnapshot = RatesSnapshotEntity(
    date: '17.08.2025',
    name: 'Foreign Currency Market',
    currencies: [],
  );

  setUp(() {
    mockNetworkService = MockNetworkService();
    mockGetRatesUsecase = MockGetRatesUsecase();

    connectivityController = StreamController<ConnectivityResult>();

    when(mockNetworkService.onStatusChange).thenAnswer((_) => connectivityController.stream);

    ratesCubit = RatesCubit(mockNetworkService, mockGetRatesUsecase);

    provideDummy<Result<RatesSnapshotEntity, AppFailure>>(const Success(snapshot));
  });

  tearDown(() {
    connectivityController.close();
    ratesCubit.close();
  });

  group('RatesCubit', () {
    test('эмитит RatesInitial как начальное состояние', () {
      expect(ratesCubit.state, const RatesInitial());
    });

    group('Инициализация и загрузка данных', () {
      blocTest<RatesCubit, RatesState>(
        'игнорирует повторный вызов init',
        setUp: () {
          when(
            mockNetworkService.getCurrentStatus(),
          ).thenAnswer((_) async => ConnectivityResult.wifi);
          when(mockGetRatesUsecase()).thenAnswer((_) async => const Success(snapshot));
        },
        build: () => ratesCubit,
        act: (cubit) {
          cubit.init();
          cubit.init(); // Повторный вызов
        },
        expect: () => [
          const RatesLoading(),
          const RatesLoaded(snapshot),
        ],
        verify: (_) {
          verify(mockNetworkService.getCurrentStatus()).called(1);
          verify(mockGetRatesUsecase()).called(1);
        },
      );

      blocTest<RatesCubit, RatesState>(
        'эмитит [RatesLoading, RatesLoaded] при наличии сети',
        setUp: () {
          when(
            mockNetworkService.getCurrentStatus(),
          ).thenAnswer((_) async => ConnectivityResult.wifi);
          when(mockGetRatesUsecase()).thenAnswer((_) async => Success(snapshot));
        },
        build: () => ratesCubit,
        act: (cubit) => cubit.init(),
        expect: () => [
          const RatesLoading(),
          const RatesLoaded(snapshot),
        ],
      );

      blocTest<RatesCubit, RatesState>(
        'эмитит [RatesLoadError] при отсутствии сети',
        setUp: () => when(
          mockNetworkService.getCurrentStatus(),
        ).thenAnswer((_) async => ConnectivityResult.none),
        build: () => ratesCubit,
        act: (cubit) => cubit.init(),
        expect: () => [
          isA<RatesLoadError>().having((s) => s.failure, 'failure', isA<NoNetworkFailure>()),
        ],
        verify: (_) => verifyNever(mockGetRatesUsecase()),
      );

      group('Реакция на изменение сети', () {
        blocTest<RatesCubit, RatesState>(
          'эмитит [RatesLoaded] при восстановлении сети',
          setUp: () {
            when(
              mockNetworkService.getCurrentStatus(),
            ).thenAnswer((_) async => ConnectivityResult.none);
            when(mockGetRatesUsecase()).thenAnswer((_) async => Success(snapshot));
          },
          build: () => ratesCubit,
          act: (cubit) async {
            cubit.init();
            connectivityController.add(ConnectivityResult.wifi);
          },
          expect: () => [
            isA<RatesLoadError>().having((s) => s.failure, 'failure', isA<NoNetworkFailure>()),
            const RatesLoaded(snapshot),
          ],
        );

        blocTest<RatesCubit, RatesState>(
          'эмитит [RatesUnchanged] при обновлении, если данные не изменились',
          setUp: () {
            when(
              mockNetworkService.getCurrentStatus(),
            ).thenAnswer((_) async => ConnectivityResult.wifi);
            when(mockGetRatesUsecase()).thenAnswer((_) async => Success(snapshot));
          },
          build: () => ratesCubit,
          act: (cubit) async {
            cubit.init();
            connectivityController.add(ConnectivityResult.wifi);
          },
          expect: () => [
            const RatesLoading(),
            const RatesLoaded(snapshot),
            const RatesUnchanged(),
            const RatesLoaded(snapshot),
          ],
          verify: (_) => verify(mockGetRatesUsecase()).called(2),
        );

        blocTest<RatesCubit, RatesState>(
          'эмитит новое состояние [RatesLoaded] при обновлении, если данные изменились',
          setUp: () {
            when(
              mockNetworkService.getCurrentStatus(),
            ).thenAnswer((_) async => ConnectivityResult.wifi);
            final responses = <Result<RatesSnapshotEntity, AppFailure>>[
              const Success(snapshot),
              const Success(changedSnapshot),
            ];
            final iterator = responses.iterator;

            when(mockGetRatesUsecase()).thenAnswer((_) async {
              iterator.moveNext();
              return iterator.current;
            });
          },
          build: () => ratesCubit,
          act: (cubit) {
            cubit.init();
            connectivityController.add(ConnectivityResult.wifi);
          },
          expect: () => [
            const RatesLoading(),
            const RatesLoaded(snapshot),
            const RatesLoaded(changedSnapshot),
          ],
          verify: (_) => verify(mockGetRatesUsecase()).called(2),
        );

        blocTest(
          'эмитит RatesLoadError при неизвестной ошибке сети',
          setUp: () => when(
            mockGetRatesUsecase(),
          ).thenAnswer((_) async => Failure(UnknownNetworkFailure(Exception()))),
          build: () => ratesCubit,
          act: (cubit) async => await cubit.loadRates(),
          expect: () => [
            const RatesLoading(),
            isA<RatesLoadError>().having((s) => s.failure, 'failure', isA<UnknownNetworkFailure>()),
          ],
        );

        blocTest(
          'эмитит RatesLoadError при неизвестной ошибке',
          setUp: () =>
              when(mockGetRatesUsecase()).thenAnswer((_) async => Failure(UnknownFailure())),
          build: () => ratesCubit,
          act: (cubit) async => await cubit.loadRates(),
          expect: () => [
            const RatesLoading(),
            isA<RatesLoadError>().having((s) => s.failure, 'failure', isA<UnknownFailure>()),
          ],
        );
      });
    });
  });
}

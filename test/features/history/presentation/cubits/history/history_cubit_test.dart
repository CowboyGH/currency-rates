import 'package:bloc_test/bloc_test.dart';
import 'package:currency_rates/core/domain/entities/failure/app_failure.dart';
import 'package:currency_rates/core/domain/entities/failure/unknown_failure.dart';
import 'package:currency_rates/core/domain/entities/result/result.dart';
import 'package:currency_rates/features/history/domain/entities/conversion_record_entity.dart';
import 'package:currency_rates/features/history/domain/usecases/get_history_usecase.dart';
import 'package:currency_rates/features/history/presentation/cubits/history/history_cubit.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'history_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<GetHistoryUsecase>()])
void main() {
  late GetHistoryUsecase getHistoryUsecase;
  late HistoryCubit historyCubit;

  final records = <ConversionRecordEntity>[
    ConversionRecordEntity(
      charCode: 'USD',
      amount: Decimal.parse('100'),
      result: Decimal.parse('10000'),
      unitRate: Decimal.parse('100'),
      timestamp: DateTime.parse('2025-09-18T10:05:00Z'),
    ),
  ];

  provideDummy<Result<List<ConversionRecordEntity>, AppFailure>>(Success(records));

  setUp(() {
    getHistoryUsecase = MockGetHistoryUsecase();
    historyCubit = HistoryCubit(getHistoryUsecase);
  });

  group('HistoryCubit', () {
    blocTest(
      'эмитит HistoryLoadSuccess при успешной загрузке истории',
      setUp: () {
        when(getHistoryUsecase()).thenAnswer((_) async => Success(records));
      },
      build: () => historyCubit,
      act: (cubit) async => await cubit.loadHistory(),
      expect: () => [
        const HistoryLoading(),
        HistoryLoadSuccess(records),
      ],
    );

    blocTest(
      'эмитит HistoryLoadError при ошибке загрузке истории',
      setUp: () {
        when(getHistoryUsecase()).thenAnswer((_) async => Failure(UnknownFailure()));
      },
      build: () => historyCubit,
      act: (cubit) async => await cubit.loadHistory(),
      expect: () => [
        const HistoryLoading(),
        isA<HistoryLoadError>().having((s) => s.failure, 'failure', isA<UnknownFailure>()),
      ],
    );
  });
}

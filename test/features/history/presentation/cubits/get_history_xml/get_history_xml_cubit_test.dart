import 'package:bloc_test/bloc_test.dart';
import 'package:currency_rates/core/domain/entities/failure/app_failure.dart';
import 'package:currency_rates/core/domain/entities/failure/history/history_failure.dart';
import 'package:currency_rates/core/domain/entities/result/result.dart';
import 'package:currency_rates/features/history/domain/usecases/get_history_as_xml_string_usecase.dart';
import 'package:currency_rates/features/history/presentation/cubits/get_history_xml/get_history_xml_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_history_xml_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<GetHistoryAsXmlStringUsecase>()])
void main() {
  late MockGetHistoryAsXmlStringUsecase mockExportHistoryUsecase;
  late GetHistoryXmlCubit exportHistoryCubit;
  const xmlString = '<History></History>';

  provideDummy<Result<String, AppFailure>>(const Success(xmlString));

  setUp(() {
    mockExportHistoryUsecase = MockGetHistoryAsXmlStringUsecase();
    exportHistoryCubit = GetHistoryXmlCubit(mockExportHistoryUsecase);
  });

  group('GetHistoryXmlCubit', () {
    blocTest<GetHistoryXmlCubit, GetHistoryXmlState>(
      'эмитит GetHistoryXmlSuccess при успешном экспорте истории',
      setUp: () {
        when(mockExportHistoryUsecase()).thenAnswer((_) async => const Success(xmlString));
      },
      build: () => exportHistoryCubit,
      act: (cubit) async => await cubit.fetchXmlString(),
      expect: () => [
        const GetHistoryXmlLoading(),
        const GetHistoryXmlSuccess(xmlString),
      ],
      verify: (_) {
        verify(mockExportHistoryUsecase()).called(1);
      },
    );

    blocTest<GetHistoryXmlCubit, GetHistoryXmlState>(
      'эмитит GetHistoryXmlFailure при ошибке экспорта истории',
      setUp: () {
        when(mockExportHistoryUsecase()).thenAnswer((_) async => Failure(HistoryExportFailure()));
      },
      build: () => exportHistoryCubit,
      act: (cubit) async => await cubit.fetchXmlString(),
      expect: () => [
        const GetHistoryXmlLoading(),
        isA<GetHistoryXmlFailure>().having(
          (s) => s.failure,
          'failure',
          isA<HistoryExportFailure>(),
        ),
      ],
    );
  });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:currency_rates/core/domain/entities/failure/app_failure.dart';
import 'package:currency_rates/core/domain/entities/failure/unknown_failure.dart';
import 'package:currency_rates/core/domain/entities/result/result.dart';
import 'package:currency_rates/features/history/domain/usecases/export_history_to_xml_usecase.dart';
import 'package:currency_rates/features/history/presentation/cubits/export_history/export_history_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'export_history_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ExportHistoryToXmlUsecase>()])
void main() {
  late MockExportHistoryToXmlUsecase mockExportHistoryUsecase;
  late ExportHistoryCubit exportHistoryCubit;

  const path = 'test';

  provideDummy<Result<void, AppFailure>>(const Success(null));

  setUp(() {
    mockExportHistoryUsecase = MockExportHistoryToXmlUsecase();
    exportHistoryCubit = ExportHistoryCubit(mockExportHistoryUsecase);
  });

  group('ExportHistoryCubit', () {
    blocTest<ExportHistoryCubit, ExportHistoryState>(
      'эмитит ExportHistorySuccess при успешном экспорте истории',
      setUp: () {
        when(mockExportHistoryUsecase(any)).thenAnswer((_) async => const Success(null));
      },
      build: () => exportHistoryCubit,
      act: (cubit) async => await cubit.exportHistory(path),
      expect: () => [
        const ExportInProgress(),
        const ExportHistorySuccess(),
      ],
      verify: (_) {
        verify(mockExportHistoryUsecase(path)).called(1);
      },
    );

    blocTest<ExportHistoryCubit, ExportHistoryState>(
      'эмитит ExportHistoryFailure при ошибке экспорта истории',
      setUp: () {
        when(mockExportHistoryUsecase(any)).thenAnswer((_) async => Failure(UnknownFailure()));
      },
      build: () => exportHistoryCubit,
      act: (cubit) async => await cubit.exportHistory(path),
      expect: () => [
        const ExportInProgress(),
        isA<ExportHistoryFailure>().having((s) => s.failure, 'failure', isA<UnknownFailure>()),
      ],
    );
  });
}

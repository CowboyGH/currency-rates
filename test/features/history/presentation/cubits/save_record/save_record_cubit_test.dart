import 'package:bloc_test/bloc_test.dart';
import 'package:currency_rates/core/domain/entities/failure/app_failure.dart';
import 'package:currency_rates/core/domain/entities/failure/unknown_failure.dart';
import 'package:currency_rates/core/domain/entities/result/result.dart';
import 'package:currency_rates/features/history/domain/entities/conversion_record_entity.dart';
import 'package:currency_rates/features/history/domain/usecases/save_record_usecase.dart';
import 'package:currency_rates/features/history/presentation/cubits/save_record/save_record_cubit.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'save_record_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SaveRecordUsecase>()])
void main() {
  late MockSaveRecordUsecase mockSaveRecordUsecase;
  late SaveRecordCubit saveRecordCubit;

  final record = ConversionRecordEntity(
    charCode: 'USD',
    amount: Decimal.parse('100'),
    result: Decimal.parse('10000'),
    unitRate: Decimal.parse('100'),
    timestamp: DateTime.parse('2025-09-18T10:05:00Z'),
  );

  provideDummy<Result<void, AppFailure>>(const Success(null));

  setUp(() {
    mockSaveRecordUsecase = MockSaveRecordUsecase();
    saveRecordCubit = SaveRecordCubit(mockSaveRecordUsecase);
  });

  group('SaveRecordCubit', () {
    blocTest<SaveRecordCubit, SaveRecordState>(
      'эмитит SaveRecordSuccess при успешном сохранении записи',
      setUp: () {
        when(mockSaveRecordUsecase(any)).thenAnswer((_) async => const Success(null));
      },
      build: () => saveRecordCubit,
      act: (cubit) async => await cubit.saveRecord(record),
      expect: () => [
        const SaveInProgress(),
        const SaveRecordSuccess(),
      ],
      verify: (_) {
        verify(mockSaveRecordUsecase(record)).called(1);
      },
    );

    blocTest<SaveRecordCubit, SaveRecordState>(
      'эмитит SaveRecordError при ошибке сохранения записи',
      setUp: () {
        when(mockSaveRecordUsecase(any)).thenAnswer((_) async => Failure(UnknownFailure()));
      },
      build: () => saveRecordCubit,
      act: (cubit) async => await cubit.saveRecord(record),
      expect: () => [
        const SaveInProgress(),
        isA<SaveRecordFailure>().having((s) => s.failure, 'failure', isA<UnknownFailure>()),
      ],
    );
  });
}

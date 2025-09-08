import 'package:bloc_test/bloc_test.dart';
import 'package:currency_rates/core/domain/entities/failure/app_failure.dart';
import 'package:currency_rates/core/domain/entities/failure/conversion/conversion_failure.dart';
import 'package:currency_rates/core/domain/entities/result/result.dart';
import 'package:currency_rates/features/rates/domain/usecases/convert_currency_usecase.dart';
import 'package:currency_rates/features/rates/presentation/cubits/conversion/conversion_cubit.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'conversion_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ConvertCurrencyUsecase>()])
void main() {
  late MockConvertCurrencyUsecase mockConvertCurrencyUsecase;
  late ConversionCubit conversionCubit;

  final Decimal amount = Decimal.parse('100');
  final Decimal unitRate = Decimal.parse('52.0546');
  final Decimal expectedResult = amount * unitRate;

  setUp(() {
    mockConvertCurrencyUsecase = MockConvertCurrencyUsecase();
    conversionCubit = ConversionCubit(mockConvertCurrencyUsecase);

    provideDummy<Result<Decimal, AppFailure>>(Success(unitRate * amount));
  });

  tearDown(() {
    conversionCubit.close();
  });

  group('ConversionCubit', () {
    test('начальное состояние должно быть ConversionInitial', () {
      expect(conversionCubit.state, const ConversionInitial());
    });

    group('ConversionCubit.convert', () {
      blocTest<ConversionCubit, ConversionState>(
        'эмитит [ConversionSuccess] при успешной конвертации',
        setUp: () {
          when(
            mockConvertCurrencyUsecase(amount: amount, unitRate: unitRate),
          ).thenReturn(Success(expectedResult));
        },
        build: () => conversionCubit,
        act: (cubit) => cubit.convert(amount: amount, unitRate: unitRate),
        expect: () => [
          isA<ConversionSuccess>().having((s) => s.result, 'result', expectedResult),
        ],
      );

      blocTest<ConversionCubit, ConversionState>(
        'эмитит [ConversionFailure] при ошибке конвертации',
        setUp: () {
          final failure = NegativeAmountFailure();
          when(
            mockConvertCurrencyUsecase(amount: amount, unitRate: unitRate),
          ).thenReturn(Failure(failure));
        },
        build: () => conversionCubit,
        act: (cubit) => cubit.convert(amount: amount, unitRate: unitRate),
        expect: () => [
          isA<ConversionError>().having(
            (s) => s.failure,
            'failure',
            isA<NegativeAmountFailure>(),
          ),
        ],
      );

      blocTest<ConversionCubit, ConversionState>(
        'эмитит [ConversionInitial] после [ConversionError]',
        setUp: () {
          when(
            mockConvertCurrencyUsecase(amount: amount, unitRate: unitRate),
          ).thenReturn(Success(expectedResult));
        },
        build: () => conversionCubit,
        act: (cubit) {
          cubit.convert(amount: amount, unitRate: unitRate);
          cubit.reset();
        },
        expect: () => [
          isA<ConversionSuccess>().having((s) => s.result, 'result', expectedResult),
          const ConversionInitial(),
        ],
      );

      blocTest<ConversionCubit, ConversionState>(
        'эмитит [ConversionInitial] после [ConversionError]',
        setUp: () {
          final failure = NegativeAmountFailure();
          when(
            mockConvertCurrencyUsecase(amount: amount, unitRate: unitRate),
          ).thenReturn(Failure(failure));
        },
        build: () => conversionCubit,
        act: (cubit) {
          cubit.convert(amount: amount, unitRate: unitRate);
          cubit.reset();
        },
        expect: () => [
          isA<ConversionError>().having(
            (s) => s.failure,
            'failure',
            isA<NegativeAmountFailure>(),
          ),
          const ConversionInitial(),
        ],
      );
    });
  });
}

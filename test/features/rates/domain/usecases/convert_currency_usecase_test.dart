import 'package:currency_rates/core/domain/entities/failure/conversion/conversion_failure.dart';
import 'package:currency_rates/features/rates/domain/usecases/convert_currency_usecase.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ConvertCurrencyUsecase convertCurrency;
  late final Decimal unitRate;

  setUpAll(() {
    convertCurrency = ConvertCurrencyUsecase();
    unitRate = Decimal.parse('52.0546');
  });

  group('ConvertCurrencyUsecase', () {
    group('Success', () {
      test('успешно конвертирует валюту', () {
        final result = convertCurrency.call(
          unitRate: unitRate,
          amount: Decimal.parse('100'),
        );

        expect(result.isSuccess, isTrue);
        expect(result.success, Decimal.parse('5205.46'));
      });

      test('успешно конвертирует валюту при максимально допустимом количестве', () {
        final result = convertCurrency.call(
          unitRate: unitRate,
          amount: Decimal.parse('1e29'),
        );

        expect(result.isSuccess, isTrue);
        expect(result.success, unitRate * Decimal.parse('1e29'));
      });

      test('успешно конвертирует валюту при минимально допустимом количестве', () {
        final result = convertCurrency.call(
          unitRate: unitRate,
          amount: Decimal.parse('1e-28'),
        );

        expect(result.isSuccess, isTrue);
        expect(result.success, unitRate * Decimal.parse('1e-28'));
      });
    });

    group('Failure', () {
      test('выбрасывает NegativeAmountFailure при отрицательном количестве', () {
        final result = convertCurrency.call(
          unitRate: unitRate,
          amount: Decimal.parse('-100'),
        );

        expect(result.isFailure, isTrue);
        expect(result.failure, isA<NegativeAmountFailure>());
      });

      test('выбрасывает ZeroAmountFailure при количестве равном нулю', () {
        final result = convertCurrency.call(
          unitRate: unitRate,
          amount: Decimal.zero,
        );

        expect(result.isFailure, isTrue);
        expect(result.failure, isA<ZeroAmountFailure>());
      });

      test('выбрасывает OverflowFailure при слишком большом количестве', () {
        final result = convertCurrency.call(
          unitRate: unitRate,
          amount: Decimal.parse('1e30'),
        );

        expect(result.isFailure, isTrue);
        expect(result.failure, isA<OverflowFailure>());
      });

      test('выбрасывает UnderflowFailure при слишком маленьком количестве', () {
        final result = convertCurrency.call(
          unitRate: unitRate,
          amount: Decimal.parse('1e-29'),
        );

        expect(result.isFailure, isTrue);
        expect(result.failure, isA<UnderflowFailure>());
      });
    });
  });
}

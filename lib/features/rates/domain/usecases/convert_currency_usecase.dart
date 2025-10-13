import 'package:currency_rates/core/domain/entities/failure/app_failure.dart';
import 'package:currency_rates/core/domain/entities/failure/conversion/conversion_failure.dart';
import 'package:currency_rates/core/domain/entities/result/result.dart';
import 'package:decimal/decimal.dart';

/// Конвертирует сумму из выбранной валюты в рубли.
/// Параметры:
/// - [unitRate]: Курс валюты по отношению к рублю.
/// - [amount]: Количество выбранной валюты.
class ConvertCurrencyUsecase {
  const ConvertCurrencyUsecase();

  // Минимально допустимое положительное значение
  static final Decimal minPositive = Decimal.parse(
    '1e-28',
  );

  Result<Decimal, AppFailure> call({
    required Decimal unitRate,
    required Decimal amount,
  }) {
    // Отрицательное значение
    if (amount < Decimal.zero) return Result.failure(NegativeAmountFailure());
    // Нулевое значение
    if (amount == Decimal.zero) return Result.failure(ZeroAmountFailure());
    // Слишком маленькое значение
    if (amount < minPositive) return Result.failure(UnderflowFailure());
    // Слишком большое значение
    final digitsOnly = amount.toString().replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.length > 30) return Result.failure(OverflowFailure());

    return Result.success(unitRate * amount);
  }
}

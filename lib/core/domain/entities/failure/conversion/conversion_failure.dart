import 'package:currency_rates/core/domain/entities/failure/app_failure.dart';
import 'package:flutter/foundation.dart';

/// Базовый класс для ошибок, связанных с конвертацией валют.
@immutable
sealed class ConversionFailure extends AppFailure {
  const ConversionFailure({super.message, super.parentException, super.stackTrace});
}

/// Ошибка, возникающая при попытке ввести отрицательную сумму.
final class NegativeAmountFailure extends ConversionFailure {
  const NegativeAmountFailure() : super(message: 'Сумма не может быть отрицательной');
}

/// Ошибка, возникающая при попытке ввести нулевую сумму.
final class ZeroAmountFailure extends ConversionFailure {
  const ZeroAmountFailure() : super(message: 'Сумма не может быть равна нулю');
}

/// Ошибка, возникающая если введённая сумма слишком велика.
final class OverflowFailure extends ConversionFailure {
  const OverflowFailure() : super(message: 'Сумма слишком велика');
}

/// Ошибка, возникающая если введённая сумма слишком мала.
final class UnderflowFailure extends ConversionFailure {
  const UnderflowFailure() : super(message: 'Сумма слишком мала');
}

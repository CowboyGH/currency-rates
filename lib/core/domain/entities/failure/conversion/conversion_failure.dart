import 'package:currency_rates/core/domain/entities/failure/app_failure.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class ConversionFailure extends AppFailure {
  const ConversionFailure({super.message, super.parentException, super.stackTrace});
}

final class NegativeAmountFailure extends ConversionFailure {
  const NegativeAmountFailure() : super(message: 'Сумма не может быть отрицательной');
}

final class ZeroAmountFailure extends ConversionFailure {
  const ZeroAmountFailure() : super(message: 'Сумма не может быть равна нулю');
}

final class OverflowFailure extends ConversionFailure {
  const OverflowFailure() : super(message: 'Сумма слишком велика');
}

final class UnderflowFailure extends ConversionFailure {
  const UnderflowFailure() : super(message: 'Сумма слишком мала');
}

final class UnknownConversionFailure extends ConversionFailure {
  const UnknownConversionFailure(Exception exception)
    : super(
        message: 'Неизвестная ошибка конвертации',
        parentException: exception,
      );
}

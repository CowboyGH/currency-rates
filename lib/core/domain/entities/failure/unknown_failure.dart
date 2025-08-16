import 'package:currency_rates/core/domain/entities/failure/app_failure.dart';

/// Неизвестная ошибка.
final class UnknownFailure extends AppFailure {
  const UnknownFailure({super.message, super.stackTrace});
}

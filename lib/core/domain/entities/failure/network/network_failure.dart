import 'package:currency_rates/core/domain/entities/failure/app_failure.dart';

/// Базовый класс для ошибок сети.
sealed class NetworkFailure extends AppFailure {
  const NetworkFailure({super.message, super.parentException, super.stackTrace});
}

/// Ошибка, возникающая при отсутствии интернет-соединения.
final class NoNetworkFailure extends NetworkFailure {
  const NoNetworkFailure() : super(message: 'No network connection');
}

/// Неизвестная ошибка сети.
final class UnknownNetworkFailure extends NetworkFailure {
  const UnknownNetworkFailure(Exception exception)
    : super(message: 'Unknown network error', parentException: exception);
}

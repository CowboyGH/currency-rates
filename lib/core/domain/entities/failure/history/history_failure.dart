import 'package:currency_rates/core/domain/entities/failure/app_failure.dart';
import 'package:flutter/foundation.dart';

/// Базовый класс для ошибок, связанных с историей конвертаций.
@immutable
sealed class HistoryFailure extends AppFailure {
  const HistoryFailure({super.message, super.parentException, super.stackTrace});
}

/// Ошибка доступа к локальному хранилищу истории.
class HistoryStorageFailure extends HistoryFailure {
  const HistoryStorageFailure({
    super.parentException,
    super.stackTrace,
  }) : super(message: 'Ошибка доступа к локальному хранилищу');
}

/// Ошибка, возникающая если история операций пуста.
final class HistoryEmptyFailure extends HistoryFailure {
  const HistoryEmptyFailure({
    super.parentException,
    super.stackTrace,
  }) : super(message: 'История операций пуста');
}

/// Ошибка при попытке сохранить запись в историю.
class HistorySaveFailure extends HistoryFailure {
  const HistorySaveFailure({
    super.parentException,
    super.stackTrace,
  }) : super(message: 'Не удалось сохранить запись');
}

/// Ошибка при экспорте истории в XML-строку.
class HistoryExportFailure extends HistoryFailure {
  const HistoryExportFailure({
    super.parentException,
    super.stackTrace,
  }) : super(message: 'Не удалось сохранить историю в файл');
}

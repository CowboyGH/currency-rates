import 'package:currency_rates/core/domain/entities/failure/app_failure.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class HistoryFailure extends AppFailure {
  const HistoryFailure({super.message, super.parentException, super.stackTrace});
}

class HistoryStorageFailure extends HistoryFailure {
  const HistoryStorageFailure() : super(message: 'Ошибка доступа к локальному хранилищу.');
}

final class HistoryEmptyFailure extends HistoryFailure {
  const HistoryEmptyFailure() : super(message: 'История операций пуста.');
}

class HistorySaveFailure extends HistoryFailure {
  const HistorySaveFailure() : super(message: 'Не удалось сохранить запись.');
}

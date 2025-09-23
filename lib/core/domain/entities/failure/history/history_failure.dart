import 'package:currency_rates/core/domain/entities/failure/app_failure.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class HistoryFailure extends AppFailure {
  const HistoryFailure({super.message, super.parentException, super.stackTrace});
}

import 'package:currency_rates/core/domain/entities/failure/app_failure.dart';
import 'package:flutter/widgets.dart';

void logFailure(AppFailure failure) {
  debugPrint('Failure: ${failure.message}');
  debugPrint('Parent Exception: ${failure.parentException ?? 'null'}');
  debugPrint('StackTrace: ${failure.stackTrace ?? 'null'}');
}

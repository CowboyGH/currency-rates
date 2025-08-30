import 'package:currency_rates/core/domain/entities/failure/app_failure.dart';
import 'package:currency_rates/core/domain/entities/result/result.dart';
import 'package:currency_rates/features/rates/domain/usecases/convert_currency_usecase.dart';
import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'conversion_state.dart';

/// Кубит для управления состоянием конвертации валют.
class ConversionCubit extends Cubit<ConversionState> {
  final ConvertCurrencyUsecase _usecase;

  ConversionCubit(this._usecase) : super(ConversionInitial());

  /// Конвертация валюты.
  void convert({required Decimal amount, required Decimal unitRate}) async {
    final result = _usecase(amount: amount, unitRate: unitRate);
    switch (result) {
      case Success(:final data):
        emit(ConversionSuccess(data));
      case Failure(:final error):
        emit(ConversionError(error));
    }
  }
}

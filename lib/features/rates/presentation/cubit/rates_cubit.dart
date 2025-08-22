import 'package:currency_rates/core/domain/entities/failure/app_failure.dart';
import 'package:currency_rates/core/domain/entities/result/result.dart';
import 'package:currency_rates/features/rates/domain/entities/rates_snapshot_entity.dart';
import 'package:currency_rates/features/rates/domain/usecases/get_rates_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'rates_state.dart';

/// Кубит для управления состоянием экрана курсов валют.
class RatesCubit extends Cubit<RatesState> {
  final GetRatesUsecase _getRates;
  RatesCubit(this._getRates) : super(const RatesInitial());

  Future<void> loadRates() async {
    if (state is RatesLoading) return;

    emit(RatesLoading());

    final result = await _getRates();
    switch (result) {
      case Success(:final data):
        emit(RatesLoaded(data));
      case Failure(:final error):
        emit(RatesFailure(error));
    }
  }
}

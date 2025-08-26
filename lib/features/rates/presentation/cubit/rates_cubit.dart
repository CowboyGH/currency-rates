import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:currency_rates/core/domain/entities/failure/app_failure.dart';
import 'package:currency_rates/core/domain/entities/failure/network/network_failure.dart';
import 'package:currency_rates/core/domain/entities/result/result.dart';
import 'package:currency_rates/core/services/network_service.dart';
import 'package:currency_rates/features/rates/domain/entities/rates_snapshot_entity.dart';
import 'package:currency_rates/features/rates/domain/usecases/get_rates_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'rates_state.dart';

/// Кубит для управления состоянием экрана курсов валют.
class RatesCubit extends Cubit<RatesState> {
  final NetworkService _networkService;
  late final StreamSubscription<ConnectivityResult> _subscription;
  final GetRatesUsecase _getRates;
  RatesCubit(this._networkService, this._getRates) : super(const RatesInitial()) {
    _init();
  }

  Future<void> _init() async {
    final initialStatus = await _networkService.getCurrentStatus();
    if (initialStatus == ConnectivityResult.none) {
      emit(RatesLoadError(NoNetworkFailure()));
    } else {
      loadRates();
    }

    _subscription = _networkService.onStatusChange.listen((status) {
      if (status != ConnectivityResult.none) {
        loadRates(isRefresh: true);
      } else {
        emit(RatesLoadError(NoNetworkFailure()));
      }
    });
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  /// Загрузка курсов валют.
  Future<void> loadRates({bool isRefresh = false}) async {
    // Сохраняем предыдущее состояние
    final previousState = state;

    // Если уже идет загрузка, игнорируем повторный вызов
    if (previousState is RatesLoading) return;

    // Первая загрузка — полноэкранный лоадер
    if (!isRefresh) emit(const RatesLoading());

    final result = await _getRates();
    switch (result) {
      case Success(:final data):
        // Если до запроса на экране уже был список, проверяем, изменились ли данные
        if (previousState is RatesLoaded && previousState.snapshot == data) {
          // Ничего не поменялось: сообщаем об актуальности
          emit(const RatesUnchanged());
          emit(previousState);
        } else {
          // Если данные изменились или загружаются в первый раз, то обновляем состояние
          emit(RatesLoaded(data));
        }
      case Failure(:final error):
        emit(RatesLoadError(error));
    }
  }
}

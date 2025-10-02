import 'package:currency_rates/core/domain/entities/failure/app_failure.dart';
import 'package:currency_rates/core/domain/entities/result/result.dart';
import 'package:currency_rates/features/history/domain/entities/conversion_record_entity.dart';
import 'package:currency_rates/features/history/domain/usecases/get_history_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'history_state.dart';

/// Кубит для управления состоянием истории конвертаций.
class HistoryCubit extends Cubit<HistoryState> {
  final GetHistoryUsecase _getHistoryUsecase;

  HistoryCubit(this._getHistoryUsecase) : super(HistoryInitial());

  /// Загрузка истории конвертаций.
  Future<void> loadHistory() async {
    emit(HistoryLoading());
    final result = await _getHistoryUsecase();
    switch (result) {
      case Success(:final data):
        emit(HistoryLoadSuccess(data));
      case Failure(:final error):
        emit(HistoryLoadError(error));
    }
  }
}

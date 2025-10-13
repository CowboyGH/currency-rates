import 'package:currency_rates/core/domain/entities/failure/app_failure.dart';
import 'package:currency_rates/core/domain/entities/result/result.dart';
import 'package:currency_rates/features/history/domain/usecases/get_history_as_xml_string_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'get_history_xml_state.dart';

/// Кубит для управления состоянием получения XML-строки истории конвертаций.
class GetHistoryXmlCubit extends Cubit<GetHistoryXmlState> {
  final GetHistoryAsXmlStringUsecase _getHistoryAsXmlStringUsecase;

  GetHistoryXmlCubit(this._getHistoryAsXmlStringUsecase) : super(GetHistoryXmlInitial());

  /// Загружает историю конвертаций и преобразует её в XML-строку.
  Future<void> fetchXmlString() async {
    emit(GetHistoryXmlLoading());
    final result = await _getHistoryAsXmlStringUsecase();
    switch (result) {
      case Success(:final data):
        emit(GetHistoryXmlSuccess(data));
      case Failure(:final error):
        emit(GetHistoryXmlFailure(error));
    }
  }
}

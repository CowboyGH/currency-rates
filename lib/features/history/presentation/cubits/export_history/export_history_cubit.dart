import 'package:currency_rates/core/domain/entities/failure/app_failure.dart';
import 'package:currency_rates/core/domain/entities/result/result.dart';
import 'package:currency_rates/features/history/domain/usecases/export_history_to_xml_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'export_history_state.dart';

/// Кубит для управления состоянием экспорта истории.
class ExportHistoryCubit extends Cubit<ExportHistoryState> {
  final ExportHistoryToXmlUsecase _exportHistoryUsecase;

  ExportHistoryCubit(this._exportHistoryUsecase) : super(ExportHistoryInitial());

  /// Экспорт истории конвертаций.
  Future<void> exportHistory(String path) async {
    emit(ExportInProgress());
    final result = await _exportHistoryUsecase(path);
    switch (result) {
      case Success():
        emit(ExportHistorySuccess());
      case Failure(:final error):
        emit(ExportHistoryFailure(error));
    }
  }
}

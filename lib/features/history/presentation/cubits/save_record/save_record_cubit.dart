import 'package:currency_rates/core/domain/entities/failure/app_failure.dart';
import 'package:currency_rates/core/domain/entities/result/result.dart';
import 'package:currency_rates/features/common/domain/entities/conversion_record_entity.dart';
import 'package:currency_rates/features/history/domain/usecases/save_record_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'save_record_state.dart';

/// Кубит для управления состоянием сохранения записи конвертации.
class SaveRecordCubit extends Cubit<SaveRecordState> {
  final SaveRecordUsecase _saveRecordUsecase;

  SaveRecordCubit(this._saveRecordUsecase) : super(SaveRecordInitial());

  /// Сохранение записи конвертации.
  Future<void> saveRecord(ConversionRecordEntity record) async {
    emit(SaveInProgress());
    final result = await _saveRecordUsecase(record);
    switch (result) {
      case Success():
        emit(SaveRecordSuccess());
      case Failure(:final error):
        emit(SaveRecordFailure(error));
    }
  }
}

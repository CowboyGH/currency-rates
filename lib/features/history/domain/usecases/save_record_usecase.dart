import 'package:currency_rates/core/domain/entities/failure/app_failure.dart';
import 'package:currency_rates/core/domain/entities/result/result.dart';
import 'package:currency_rates/features/history/domain/entities/conversion_record_entity.dart';
import 'package:currency_rates/features/history/domain/repositories/i_history_repository.dart';

/// Сохраняет запись конвертации в историю.
class SaveRecordUsecase {
  final IHistoryRepository _repository;

  SaveRecordUsecase({required IHistoryRepository repository}) : _repository = repository;

  Future<Result<void, AppFailure>> call(ConversionRecordEntity record) =>
      _repository.saveRecord(record);
}

import 'package:currency_rates/core/domain/entities/result/async_result.dart';
import 'package:currency_rates/features/common/domain/entities/conversion_record_entity.dart';
import 'package:currency_rates/features/common/domain/repositories/i_history_repository.dart';

/// Получает все записи истории конвертаций из репозитория.
class GetHistoryUsecase {
  final IHistoryRepository _repository;

  GetHistoryUsecase({required IHistoryRepository repository}) : _repository = repository;

  AsyncResult<List<ConversionRecordEntity>> call() => _repository.getAllRecords();
}

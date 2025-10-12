import 'package:currency_rates/core/domain/entities/failure/app_failure.dart';
import 'package:currency_rates/core/domain/entities/result/result.dart';
import 'package:currency_rates/features/history/domain/repositories/i_history_repository.dart';

/// Возвращает историю конвертаций в виде XML-строки для последующего экспорта.
class GetHistoryAsXmlStringUsecase {
  final IHistoryRepository _repository;

  GetHistoryAsXmlStringUsecase({required IHistoryRepository repository}) : _repository = repository;

  Future<Result<String, AppFailure>> call() => _repository.getHistoryAsXmlString();
}

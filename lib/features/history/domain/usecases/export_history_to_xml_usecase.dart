import 'package:currency_rates/core/domain/entities/failure/app_failure.dart';
import 'package:currency_rates/core/domain/entities/result/result.dart';
import 'package:currency_rates/features/common/domain/repositories/i_history_repository.dart';

/// Экспортирует историю конвертаций в XML-файл по указанному пути.
class ExportHistoryToXmlUsecase {
  final IHistoryRepository _repository;

  ExportHistoryToXmlUsecase({required IHistoryRepository repository}) : _repository = repository;

  Future<Result<void, AppFailure>> call(String path) => _repository.exportHistoryToXml(path);
}

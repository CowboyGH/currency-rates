import 'package:currency_rates/core/domain/entities/result/async_result.dart';
import 'package:currency_rates/features/history/domain/entities/conversion_record_entity.dart';

/// Интерфейс репозитория для работы с историей конвертаций.
abstract interface class IHistoryRepository {
  /// Возвращает список всех записей истории конвертаций.
  AsyncResult<List<ConversionRecordEntity>> getAllRecords();

  /// Сохраняет запись конвертации в историю.
  AsyncResult<void> saveRecord(ConversionRecordEntity record);

  /// Экспортирует историю конвертаций в XML-файл по указанному пути.
  AsyncResult<void> exportHistoryToXml(String path);
}

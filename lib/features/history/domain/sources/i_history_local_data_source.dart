import 'package:currency_rates/features/history/data/models/conversion_record_dto.dart';

/// Интерфейс для работы с локальным источником данных истории конвертаций.
abstract interface class IHistoryLocalDataSource {
  /// Возвращает все сохранённые записи истории конвертаций из локального хранилища.
  List<ConversionRecordDto> readAllRecords();

  /// Сохраняет запись о конвертации валюты в локальное хранилище.
  Future<void> saveRecord(ConversionRecordDto dto);

  /// Экспортирует историю конвертаций в XML-файл и сохраняет его по указанному пути.
  Future<void> exportRecordsToXml(String path);
}

import 'package:currency_rates/features/common/data/models/conversion_record_dto.dart';

/// Локальный источник данных о истории конвертаций.
abstract interface class IHistoryLocalDataSource {
  List<ConversionRecordDto> readAll();
  Future<void> save(ConversionRecordDto dto);
  Future<void> exportXml(String path);
}

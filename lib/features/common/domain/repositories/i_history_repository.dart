import 'package:currency_rates/core/domain/entities/result/async_result.dart';
import 'package:currency_rates/features/common/domain/entities/conversion_record_entity.dart';

abstract interface class IHistoryRepository {
  AsyncResult<List<ConversionRecordEntity>> getAll();
  AsyncResult<void> save(ConversionRecordEntity record);
  AsyncResult<void> exportXml(String path);
}

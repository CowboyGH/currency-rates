import 'package:currency_rates/core/domain/entities/result/async_result.dart';
import 'package:currency_rates/features/rates/domain/entities/rates_snapshot_entity.dart';

/// Интерфейс репозитория для получения курсов валют.
abstract class IRatesRepository {
  /// Получить актуальные курсы валют.
  AsyncResult<RatesSnapshotEntity> getRates();
}

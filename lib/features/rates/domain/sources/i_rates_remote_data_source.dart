import 'package:currency_rates/api/data/rates_snapshot_dto.dart';

/// Интерфейс для работы с удаленным источником данных курсов валют.
abstract interface class IRatesRemoteDataSource {
  /// Получает список валют.
  Future<RatesSnapshotDto> getRates();
}

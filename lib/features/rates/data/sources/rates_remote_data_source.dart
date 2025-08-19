import 'package:currency_rates/api/data/rates_snapshot_dto.dart';
import 'package:currency_rates/api/services/api_client.dart';

/// Удаленный источник данных о курсах.
class RatesRemoteDataSource {
  final ApiClient apiClient;

  const RatesRemoteDataSource({required this.apiClient});

  /// Получает список валют из внешнего [ApiClient].
  Future<RatesSnapshotDto> getRates() async {
    final response = await apiClient.getCurrencies();
    final xml = response.data;
    return RatesSnapshotDto.fromXml(xml);
  }
}

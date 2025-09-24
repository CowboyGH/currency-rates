import 'package:currency_rates/api/data/rates_snapshot_dto.dart';
import 'package:currency_rates/api/services/api_client.dart';
import 'package:currency_rates/features/rates/domain/sources/i_rates_remote_data_source.dart';
import 'package:windows1251/windows1251.dart';

/// Реализация [IRatesRemoteDataSource].
class RatesRemoteDataSourceImpl implements IRatesRemoteDataSource {
  final ApiClient apiClient;

  const RatesRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<RatesSnapshotDto> getRates() async {
    final response = await apiClient.getCurrencies();
    final xml = windows1251.decode(response.data);
    return RatesSnapshotDto.fromXml(xml);
  }
}

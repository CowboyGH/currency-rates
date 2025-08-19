import 'package:currency_rates/api/services/api_client.dart';
import 'package:currency_rates/features/rates/data/sources/rates_remote_data_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:retrofit/dio.dart';

import 'rates_remote_data_source_test.mocks.dart';

@GenerateMocks([ApiClient])
void main() {
  late RatesRemoteDataSource ratesRemoteDataSource;
  late MockApiClient mockApiClient;
  const xml = '''
<ValCurs Date="16.08.2025" name="Foreign Currency Market">
<Valute ID="R01010">
<NumCode>036</NumCode>
<CharCode>AUD</CharCode>
<Nominal>1</Nominal>
<Name>Австралийский доллар</Name>
<Value>52,0546</Value>
<VunitRate>52,0546</VunitRate>
</Valute>
<Valute ID="R01020A">
<NumCode>944</NumCode>
<CharCode>AZN</CharCode>
<Nominal>1</Nominal>
<Name>Азербайджанский манат</Name>
<Value>47,0720</Value>
<VunitRate>47,072</VunitRate>
</Valute>
</ValCurs>
''';
  final HttpResponse<String> response = HttpResponse<String>(
    xml,
    Response(requestOptions: RequestOptions(path: '/'), statusCode: 200),
  );

  setUp(() {
    mockApiClient = MockApiClient();
    ratesRemoteDataSource = RatesRemoteDataSource(apiClient: mockApiClient);
  });
  group('RatesRemoteDataSource', () {
    test('возвращает Snapshot при успешном ответе API', () async {
      // Arrange
      when(mockApiClient.getCurrencies()).thenAnswer(
        (_) async => response,
      );

      // Act
      final snapshot = await ratesRemoteDataSource.getRates();

      // Assert
      expect(snapshot, isNotNull);
      expect(snapshot.currencies, isNotEmpty);
    });

    test('возвращает ошибку при неуспешном ответе API', () async {
      when(
        mockApiClient.getCurrencies(),
      ).thenThrow(DioException(requestOptions: RequestOptions(path: '/')));

      expect(ratesRemoteDataSource.getRates(), throwsA(isA<DioException>()));
    });
  });
}

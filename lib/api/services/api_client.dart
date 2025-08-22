import 'package:currency_rates/api/services/api_urls.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';

/// REST-клиент._
@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  /// Получение списка валют
  @GET(ApiUrls.currencies)
  @DioResponseType(ResponseType.bytes)
  Future<HttpResponse<List<int>>> getCurrencies();
}

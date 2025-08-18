import 'package:currency_rates/api/services/api_client.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

/// Глобальный экземпляр сервис-локатора GetIt для управления зависимостями.
final di = GetIt.instance;

/// Инициализирует зависимости приложения с помощью GetIt.
/// Включает регистрацию слоёв data, domain, presentation.
void initDi() {
  // ApiClient
  const sendTimeout = Duration(seconds: 10);
  const connectTimeout = Duration(seconds: 10);
  const receiveTimeout = Duration(seconds: 20);

  final dio = Dio();
  dio.options
    ..baseUrl = 'http://www.cbr.ru/'
    ..sendTimeout = sendTimeout
    ..connectTimeout = connectTimeout
    ..receiveTimeout = receiveTimeout;

  final ApiClient apiClient = ApiClient(dio);
  di.registerLazySingleton(() => apiClient);
}

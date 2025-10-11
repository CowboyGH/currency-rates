import 'package:currency_rates/api/services/api_client.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Глобальный экземпляр сервис-локатора GetIt для управления зависимостями.
final di = GetIt.instance;

/// Инициализирует зависимости приложения с помощью GetIt.
Future<void> initDi() async {
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
  di.registerLazySingleton<ApiClient>(() => apiClient);

  // Hive
  await Hive.initFlutter();
  final Box<dynamic> box = await Hive.openBox('history_box_v1');
  di.registerLazySingleton<Box<dynamic>>(() => box);
}

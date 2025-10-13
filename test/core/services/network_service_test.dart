import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:currency_rates/core/services/network_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'network_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Connectivity>()])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockConnectivity = MockConnectivity();
    when(mockConnectivity.onConnectivityChanged).thenAnswer(
      (_) => Stream<List<ConnectivityResult>>.empty(),
    );
  });

  group('NetworkService.getCurrentStatus', () {
    test('getCurrentStatus возвращает ConnectivityResult.none при отсутствии соединения', () async {
      // Arrange
      when(mockConnectivity.checkConnectivity()).thenAnswer((_) async => [ConnectivityResult.none]);
      final networkService = NetworkService(connectivity: mockConnectivity);

      // Act
      final status = await networkService.getCurrentStatus();

      // Assert
      expect(status, ConnectivityResult.none);
    });

    test('getCurrentStatus возвращает ConnectivityResult.wifi при наличии соединения', () async {
      // Arrange
      when(mockConnectivity.checkConnectivity()).thenAnswer((_) async => [ConnectivityResult.wifi]);
      final networkService = NetworkService(connectivity: mockConnectivity);

      // Act
      final status = await networkService.getCurrentStatus();

      // Assert
      expect(status, ConnectivityResult.wifi);
    });
  });

  group('NetworkService.onStatusChange', () {
    test('уведомляет слушателя при изменении состояния подключения', () async {
      // Arrange
      final controller = StreamController<List<ConnectivityResult>>();
      when(mockConnectivity.onConnectivityChanged).thenAnswer((_) => controller.stream);
      final networkService = NetworkService(connectivity: mockConnectivity);

      final events = <ConnectivityResult>[]; // Создаем список для хранения событий
      // Подписываемся на изменения состояния
      final sub = networkService.onStatusChange.listen(events.add);

      // Act
      controller.add([ConnectivityResult.mobile]); // Добавляем новое событие
      await Future.delayed(Duration.zero); // Даем циклу событий обработать

      // Assert
      expect(events, [ConnectivityResult.mobile]);

      await sub.cancel();
      await controller.close();
    });

    test('dispose отменяет подписку на изменения состояния подключения', () async {
      // Arrange
      final controller = StreamController<List<ConnectivityResult>>();
      when(mockConnectivity.onConnectivityChanged).thenAnswer((_) => controller.stream);
      final networkService = NetworkService(connectivity: mockConnectivity);

      final events = <ConnectivityResult>[]; // Создаем список для хранения событий
      // Подписываемся на изменения состояния
      final sub = networkService.onStatusChange.listen(events.add);

      // Act
      networkService.dispose(); // Отменяем подписку
      controller.add([ConnectivityResult.wifi]); // Добавляем новое событие
      await Future.delayed(Duration.zero); // Даем циклу событий обработать

      // Assert
      expect(events, isEmpty);

      await sub.cancel();
      await controller.close();
    });
  });
}

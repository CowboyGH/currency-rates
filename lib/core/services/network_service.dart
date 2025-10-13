import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Сервис для управления состоянием интернет-соединения.
class NetworkService {
  final Connectivity _connectivity;

  final _controller = StreamController<ConnectivityResult>.broadcast();
  late final StreamSubscription<List<ConnectivityResult>> _subscription;
  ConnectivityResult? _lastStatus;

  NetworkService({Connectivity? connectivity}) : _connectivity = connectivity ?? Connectivity() {
    _subscription = _connectivity.onConnectivityChanged.listen(_onConnectivityChanged);
  }

  Future<void> _onConnectivityChanged(List<ConnectivityResult> results) async {
    // Если wifi/mobile — проверяем наличие доступа в интернет, иначе сразу none
    if (results.contains(ConnectivityResult.none)) {
      _emit(ConnectivityResult.none);
    } else {
      _emit(results.first);
    }
  }

  void _emit(ConnectivityResult status) {
    if (_lastStatus == status) return;
    _lastStatus = status;
    if (!_controller.isClosed) _controller.add(status);
  }

  /// Текущий статус подключения (wifi/mobile/none).
  Future<ConnectivityResult> getCurrentStatus() async {
    final results = await _connectivity.checkConnectivity();
    if (results.contains(ConnectivityResult.none)) {
      return ConnectivityResult.none;
    } else {
      return results.first;
    }
  }

  /// Поток изменений статуса подключения.
  Stream<ConnectivityResult> get onStatusChange => _controller.stream;

  Future<void> dispose() async {
    await _subscription.cancel();
    await _controller.close();
  }
}

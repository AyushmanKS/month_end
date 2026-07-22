import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  ConnectivityService({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;
  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  Timer? _retryTimer;
  bool _online = true;
  bool _started = false;

  Stream<bool> get onStatusChange => _controller.stream;
  bool get isOnline => _online;

  void start() {
    if (_started) return;
    _started = true;
    unawaited(_check());
    _subscription = _connectivity.onConnectivityChanged.listen(
      (results) => unawaited(_check(results)),
    );
  }

  Future<bool> _hasInternet() async {
    if (kIsWeb) return true;
    try {
      final result = await InternetAddress.lookup(
        'one.one.one.one',
      ).timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _isOnline(List<ConnectivityResult>? results) async {
    final transports = results ?? await _connectivity.checkConnectivity();
    final hasTransport = transports.any((r) => r != ConnectivityResult.none);
    if (!hasTransport) return false;
    return _hasInternet();
  }

  Future<void> _check([List<ConnectivityResult>? results]) async {
    final online = await _isOnline(results);
    _emit(online);
    _retryTimer?.cancel();
    if (!online) {
      _retryTimer = Timer.periodic(
        const Duration(seconds: 5),
        (_) => unawaited(_recheck()),
      );
    }
  }

  Future<void> _recheck() async {
    final online = await _isOnline(null);
    if (online) _retryTimer?.cancel();
    _emit(online);
  }

  void _emit(bool online) {
    _online = online;
    if (!_controller.isClosed) _controller.add(online);
  }

  void dispose() {
    _subscription?.cancel();
    _retryTimer?.cancel();
    _controller.close();
  }
}

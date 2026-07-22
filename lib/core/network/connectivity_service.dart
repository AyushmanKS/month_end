import 'dart:async';
import 'dart:io';
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
      (_) => unawaited(_check()),
    );
  }

  Future<bool> _hasInternet() async {
    try {
      final result = await InternetAddress.lookup(
        'one.one.one.one',
      ).timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<void> _check() async {
    final online = await _hasInternet();
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
    final online = await _hasInternet();
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

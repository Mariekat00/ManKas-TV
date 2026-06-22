import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';

enum NetworkQuality { none, poor, fair, good }

class ConnectivityService extends ChangeNotifier {
  bool _isConnected = true;
  NetworkQuality _quality = NetworkQuality.good;
  int _latencyMs = 0;
  Timer? _timer;
  bool _disposed = false;

  bool get isConnected => _isConnected;
  NetworkQuality get quality => _quality;
  int get latencyMs => _latencyMs;

  ConnectivityService();

  Future<void> _check() async {
    if (_disposed) return;
    final stopwatch = Stopwatch()..start();
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));
      if (_disposed) return;
      stopwatch.stop();
      _latencyMs = stopwatch.elapsedMilliseconds;
      _isConnected = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      if (_latencyMs < 150) {
        _quality = NetworkQuality.good;
      } else if (_latencyMs < 400) {
        _quality = NetworkQuality.fair;
      } else {
        _quality = NetworkQuality.poor;
      }
    } catch (e) {
      if (_disposed) return;
      stopwatch.stop();
      debugPrint('ConnectivityService._check failed: $e');
      _isConnected = false;
      _quality = NetworkQuality.none;
      _latencyMs = -1;
    }
    if (!_disposed) notifyListeners();
  }

  void startMonitoring() {
    _timer?.cancel();
    _check();
    _timer = Timer.periodic(const Duration(seconds: 60), (_) => _check());
  }

  void stopMonitoring() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _disposed = true;
    stopMonitoring();
    super.dispose();
  }
}

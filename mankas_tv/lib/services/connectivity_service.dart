import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';

class ConnectivityService extends ChangeNotifier {
  bool _isConnected = true;
  Timer? _timer;

  bool get isConnected => _isConnected;

  ConnectivityService() {
    _check();
  }

  Future<void> _check() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));
      _isConnected = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      _isConnected = false;
    }
    notifyListeners();
  }

  void startMonitoring() {
    _timer?.cancel();
    _check();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => _check());
  }

  void stopMonitoring() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    stopMonitoring();
    super.dispose();
  }
}

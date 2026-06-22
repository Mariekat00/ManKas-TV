import 'package:flutter_test/flutter_test.dart';
import 'package:mankas_tv/services/connectivity_service.dart';

void main() {
  group('ConnectivityService', () {
    test('initial state has default values', () {
      final service = ConnectivityService();
      expect(service.isConnected, isTrue);
      expect(service.latencyMs, 0);
      expect(service.quality, NetworkQuality.good);
      service.dispose();
    });

    test('NetworkQuality enum ordering', () {
      expect(NetworkQuality.values.length, 4);
      expect(NetworkQuality.none.index, 0);
      expect(NetworkQuality.poor.index, 1);
      expect(NetworkQuality.fair.index, 2);
      expect(NetworkQuality.good.index, 3);
    });

    test('startMonitoring and stopMonitoring do not crash', () {
      final service = ConnectivityService();
      service.startMonitoring();
      service.stopMonitoring();
      service.dispose();
    });

    test('dispose is safe to call once', () {
      final service = ConnectivityService();
      service.dispose();
    });
  });
}

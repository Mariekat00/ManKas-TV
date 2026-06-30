import 'dart:async';

class CastService {
  CastService._();
  static final CastService instance = CastService._();

  bool _initialized = false;

  final StreamController<CastState> _stateController =
      StreamController<CastState>.broadcast();
  Stream<CastState> get stateStream => _stateController.stream;

  CastState _state = CastState.idle;
  CastState get state => _state;

  bool get isConnected => false;

  List<CastDevice> _devices = [];
  List<CastDevice> get devices => _devices;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
  }

  void startDiscovery() {}

  void stopDiscovery() {}

  Future<void> connectToDevice(CastDevice device) async {}

  Future<void> castMedia({
    required String url,
    required String title,
    String? subtitle,
    String? imageUrl,
  }) async {}

  Future<void> togglePlayPause() async {}

  Future<void> stop() async {}

  Future<void> disconnect() async {
    _state = CastState.idle;
    _stateController.add(_state);
  }

  void dispose() {
    _stateController.close();
  }
}

enum CastState {
  idle,
  connecting,
  connected,
  playing,
  paused,
  buffering,
  error,
}

class CastDevice {
  final String name;
  final String? id;

  CastDevice({required this.name, this.id});
}

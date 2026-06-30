import 'package:flutter/material.dart';

enum SnackBarType { info, success, warning, error }

class AppSnackBarService {
  AppSnackBarService._();
  static final AppSnackBarService _instance = AppSnackBarService._();
  static AppSnackBarService get instance => _instance;

  static ScaffoldMessengerState? _messenger;
  static void setMessenger(ScaffoldMessengerState messenger) => _messenger = messenger;

  ScaffoldMessengerState get _msg {
    assert(_messenger != null, 'AppSnackBarService: messenger not set.');
    return _messenger!;
  }

  void show({
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _msg.hideCurrentSnackBar();
    _msg.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(_iconFor(type), color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: _colorFor(type),
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12),
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onAction ?? () {},
              )
            : null,
      ),
    );
  }

  void info(String message) => show(message: message, type: SnackBarType.info);
  void success(String message) => show(message: message, type: SnackBarType.success);
  void warning(String message) => show(message: message, type: SnackBarType.warning);
  void error(String message) => show(message: message, type: SnackBarType.error);

  void hide() => _msg.hideCurrentSnackBar();

  IconData _iconFor(SnackBarType type) {
    switch (type) {
      case SnackBarType.info:
        return Icons.info_outline;
      case SnackBarType.success:
        return Icons.check_circle_outline;
      case SnackBarType.warning:
        return Icons.warning_amber_rounded;
      case SnackBarType.error:
        return Icons.error_outline;
    }
  }

  Color _colorFor(SnackBarType type) {
    switch (type) {
      case SnackBarType.info:
        return const Color(0xFF3B82F6);
      case SnackBarType.success:
        return const Color(0xFF10B981);
      case SnackBarType.warning:
        return const Color(0xFFF59E0B);
      case SnackBarType.error:
        return const Color(0xFFEF4444);
    }
  }
}

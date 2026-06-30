import 'package:flutter/material.dart';

enum DialogType { info, success, warning, error, confirm }

enum DialogResult { yes, no, cancel, ok }

class AppDialogService {
  AppDialogService._();
  static final AppDialogService _instance = AppDialogService._();
  static AppDialogService get instance => _instance;

  static BuildContext? _context;
  static void setContext(BuildContext context) => _context = context;

  BuildContext get _ctx {
    assert(_context != null, 'AppDialogService: context not set. Call setContext() first.');
    return _context!;
  }

  Future<DialogResult> show({
    required String title,
    required String message,
    DialogType type = DialogType.info,
    String? confirmText,
    String? cancelText,
    bool barrierDismissible = true,
  }) async {
    final result = await showDialog<DialogResult>(
      context: _ctx,
      barrierDismissible: barrierDismissible,
      builder: (context) => _AppDialog(
        title: title,
        message: message,
        type: type,
        confirmText: confirmText,
        cancelText: cancelText,
      ),
    );
    return result ?? DialogResult.cancel;
  }

  Future<void> info({
    required String title,
    required String message,
    String? confirmText,
  }) async {
    await show(
      title: title,
      message: message,
      type: DialogType.info,
      confirmText: confirmText,
    );
  }

  Future<void> success({
    required String title,
    required String message,
    String? confirmText,
  }) async {
    await show(
      title: title,
      message: message,
      type: DialogType.success,
      confirmText: confirmText,
    );
  }

  Future<void> warning({
    required String title,
    required String message,
    String? confirmText,
  }) async {
    await show(
      title: title,
      message: message,
      type: DialogType.warning,
      confirmText: confirmText,
    );
  }

  Future<void> error({
    required String title,
    required String message,
    String? confirmText,
  }) async {
    await show(
      title: title,
      message: message,
      type: DialogType.error,
      confirmText: confirmText,
    );
  }

  Future<bool> confirm({
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
  }) async {
    final result = await show(
      title: title,
      message: message,
      type: DialogType.confirm,
      confirmText: confirmText,
      cancelText: cancelText,
    );
    return result == DialogResult.yes;
  }
}

class _AppDialog extends StatelessWidget {
  final String title;
  final String message;
  final DialogType type;
  final String? confirmText;
  final String? cancelText;

  const _AppDialog({
    required this.title,
    required this.message,
    required this.type,
    this.confirmText,
    this.cancelText,
  });

  IconData get _icon {
    switch (type) {
      case DialogType.info:
        return Icons.info_outline;
      case DialogType.success:
        return Icons.check_circle_outline;
      case DialogType.warning:
        return Icons.warning_amber_rounded;
      case DialogType.error:
        return Icons.error_outline;
      case DialogType.confirm:
        return Icons.help_outline;
    }
  }

  Color _iconColor(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    switch (type) {
      case DialogType.info:
        return scheme.primary;
      case DialogType.success:
        return const Color(0xFF10B981);
      case DialogType.warning:
        return const Color(0xFFF59E0B);
      case DialogType.error:
        return const Color(0xFFEF4444);
      case DialogType.confirm:
        return scheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: scheme.surface,
      icon: Icon(_icon, size: 48, color: _iconColor(context)),
      title: Text(title, textAlign: TextAlign.center),
      content: Text(message, textAlign: TextAlign.center),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        if (type == DialogType.confirm)
          TextButton(
            onPressed: () => Navigator.of(context).pop(DialogResult.no),
            child: Text(cancelText ?? 'Annuler'),
          ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(
            type == DialogType.confirm ? DialogResult.yes : DialogResult.ok,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: _iconColor(context),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(
            confirmText ?? (type == DialogType.confirm ? 'Confirmer' : 'OK'),
          ),
        ),
      ],
    );
  }
}

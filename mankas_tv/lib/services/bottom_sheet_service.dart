import 'package:flutter/material.dart';

class BottomSheetService {
  BottomSheetService._();
  static final BottomSheetService _instance = BottomSheetService._();
  static BottomSheetService get instance => _instance;

  static BuildContext? _context;
  static void setContext(BuildContext context) => _context = context;

  BuildContext get _ctx {
    assert(_context != null, 'BottomSheetService: context not set.');
    return _context!;
  }

  Future<T?> show<T>({
    required Widget child,
    String? title,
    bool isScrollControlled = false,
  }) {
    return showModalBottomSheet<T>(
      context: _ctx,
      isScrollControlled: isScrollControlled,
      backgroundColor: Theme.of(_ctx).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _BottomSheetShell(title: title, child: child),
    );
  }

  Future<bool> confirm({
    required String title,
    required String message,
    String confirmText = 'Confirmer',
    String cancelText = 'Annuler',
  }) async {
    final result = await show<bool>(
      child: _ConfirmContent(
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
      ),
    );
    return result ?? false;
  }

  Future<void> showList({
    required String title,
    required List<BottomSheetItem> items,
  }) {
    return show(
      title: title,
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: items.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            leading: item.icon != null ? Icon(item.icon, color: item.iconColor) : null,
            title: Text(item.title),
            subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
            onTap: () {
              Navigator.of(context).pop();
              item.onTap?.call();
            },
          );
        },
      ),
    );
  }
}

class _ConfirmContent extends StatelessWidget {
  final String message;
  final String confirmText;
  final String cancelText;

  const _ConfirmContent({
    required this.message,
    required this.confirmText,
    required this.cancelText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(cancelText),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(confirmText),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BottomSheetItem {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onTap;

  const BottomSheetItem({
    required this.title,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.onTap,
  });
}

class _BottomSheetShell extends StatelessWidget {
  final String? title;
  final Widget child;

  const _BottomSheetShell({this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: title != null ? 0.5 : 0.4,
      minChildSize: 0.2,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            if (title != null) ...[
              const SizedBox(height: 16),
              Text(
                title!,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
            ],
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: child,
              ),
            ),
          ],
        );
      },
    );
  }
}

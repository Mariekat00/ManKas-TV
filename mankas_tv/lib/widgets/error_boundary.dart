import 'package:flutter/material.dart';
import '../utils/app_strings.dart';

class ErrorBoundary extends StatelessWidget {
  final String? error;
  final VoidCallback? onRetry;
  final Widget child;

  const ErrorBoundary({
    super.key,
    this.error,
    this.onRetry,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent, size: 48),
              const SizedBox(height: 12),
              Text(
                error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: Text(AppStrings.of(context).retry),
                ),
              ],
            ],
          ),
        ),
      );
    }
    return child;
  }
}

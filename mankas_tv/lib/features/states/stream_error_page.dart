import 'package:flutter/material.dart';
import '../../core/widgets/app_state_page.dart';

/// Page « Chaîne indisponible » (erreur de lecture)
class StreamErrorPage extends StatelessWidget {
  final VoidCallback? onRetry;
  final VoidCallback? onBack;
  final VoidCallback? onReport;

  const StreamErrorPage({
    super.key,
    this.onRetry,
    this.onBack,
    this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    return AppStatePage(
      icon: Icons.tv_off_rounded,
      iconColor: const Color(0xFFF59E0B),
      title: 'Impossible de lire cette chaîne',
      description:
          'Cette chaîne est temporairement indisponible.',
      actions: [
        AppStateAction(
          label: 'Réessayer',
          onPressed: onRetry,
          isPrimary: true,
        ),
        AppStateAction(
          label: 'Retour aux chaînes',
          onPressed: onBack ?? () => Navigator.of(context).pop(),
        ),
        AppStateAction(
          label: 'Signaler la chaîne',
          onPressed: onReport,
        ),
      ],
    );
  }
}

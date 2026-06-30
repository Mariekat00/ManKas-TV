import 'package:flutter/material.dart';
import '../../core/widgets/app_state_page.dart';

/// Page « Erreur inattendue »
class UnexpectedErrorPage extends StatelessWidget {
  final VoidCallback? onRetry;
  final VoidCallback? onBack;

  const UnexpectedErrorPage({
    super.key,
    this.onRetry,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return AppStatePage(
      icon: Icons.warning_amber_rounded,
      iconColor: const Color(0xFFEF4444),
      title: 'Une erreur est survenue',
      description:
          'Une erreur inattendue s\'est produite.',
      actions: [
        AppStateAction(
          label: 'Réessayer',
          onPressed: onRetry,
          isPrimary: true,
        ),
        AppStateAction(
          label: 'Retour',
          onPressed: onBack ?? () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

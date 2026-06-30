import 'package:flutter/material.dart';
import '../../core/widgets/app_state_page.dart';

/// Page « Connexion trop lente / Timeout »
class TimeoutPage extends StatelessWidget {
  final VoidCallback? onRetry;

  const TimeoutPage({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return AppStatePage(
      icon: Icons.schedule_rounded,
      iconColor: const Color(0xFFF59E0B),
      title: 'Connexion trop lente',
      description:
          'Le serveur met trop de temps à répondre.',
      actions: [
        AppStateAction(
          label: 'Réessayer',
          onPressed: onRetry,
          isPrimary: true,
        ),
      ],
    );
  }
}

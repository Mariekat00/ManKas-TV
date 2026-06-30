import 'package:flutter/material.dart';
import '../../core/widgets/app_state_page.dart';

/// Page « Erreur serveur »
class ServerErrorPage extends StatelessWidget {
  final VoidCallback? onRetry;

  const ServerErrorPage({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return AppStatePage(
      icon: Icons.dns_rounded,
      iconColor: const Color(0xFFEF4444),
      title: 'Serveur indisponible',
      description:
          'Nos serveurs ne répondent pas actuellement.',
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

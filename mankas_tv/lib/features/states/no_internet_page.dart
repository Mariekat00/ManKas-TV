import 'package:flutter/material.dart';
import '../../core/widgets/app_state_page.dart';

/// Page « Aucune connexion Internet »
class NoInternetPage extends StatelessWidget {
  final VoidCallback? onRetry;
  final VoidCallback? onNetworkSettings;

  const NoInternetPage({
    super.key,
    this.onRetry,
    this.onNetworkSettings,
  });

  @override
  Widget build(BuildContext context) {
    return AppStatePage(
      icon: Icons.wifi_off_rounded,
      iconColor: const Color(0xFFEF4444),
      title: 'Aucune connexion Internet',
      description:
          'Vérifiez votre connexion puis réessayez.',
      actions: [
        AppStateAction(
          label: 'Réessayer',
          onPressed: onRetry,
          isPrimary: true,
        ),
        AppStateAction(
          label: 'Paramètres réseau',
          onPressed: onNetworkSettings,
        ),
      ],
    );
  }
}

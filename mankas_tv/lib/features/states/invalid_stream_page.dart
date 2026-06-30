import 'package:flutter/material.dart';
import '../../core/widgets/app_state_page.dart';

/// Page « Flux IPTV invalide »
class InvalidStreamPage extends StatelessWidget {
  final VoidCallback? onRetry;
  final VoidCallback? onReport;

  const InvalidStreamPage({
    super.key,
    this.onRetry,
    this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    return AppStatePage(
      icon: Icons.live_tv_rounded,
      iconColor: const Color(0xFFEF4444),
      title: 'Flux vidéo invalide',
      description:
          'Le lien de cette chaîne semble expiré ou incorrect.',
      actions: [
        AppStateAction(
          label: 'Réessayer',
          onPressed: onRetry,
          isPrimary: true,
        ),
        AppStateAction(
          label: 'Signaler',
          onPressed: onReport,
        ),
      ],
    );
  }
}

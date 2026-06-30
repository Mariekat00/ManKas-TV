import 'package:flutter/material.dart';
import '../../core/widgets/app_state_page.dart';

/// Page « Chaîne non disponible — Géoblocage »
class GeoBlockPage extends StatelessWidget {
  final VoidCallback? onBack;

  const GeoBlockPage({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return AppStatePage(
      icon: Icons.public_off_rounded,
      iconColor: const Color(0xFF8B5CF6),
      title: 'Chaîne non disponible',
      description:
          'Cette chaîne n\'est pas accessible dans votre région.',
      actions: [
        AppStateAction(
          label: 'Retour',
          onPressed: onBack ?? () => Navigator.of(context).pop(),
          isPrimary: true,
        ),
      ],
    );
  }
}

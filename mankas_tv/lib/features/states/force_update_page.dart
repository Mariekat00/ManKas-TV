import 'package:flutter/material.dart';
import '../../core/widgets/app_state_page.dart';

/// Page « Mise à jour obligatoire »
class ForceUpdatePage extends StatelessWidget {
  final VoidCallback? onUpdate;

  const ForceUpdatePage({super.key, this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return AppStatePage(
      icon: Icons.system_update_rounded,
      iconColor: const Color(0xFF6366F1),
      title: 'Nouvelle version disponible',
      description:
          'Veuillez mettre à jour ManKas TV pour continuer.',
      actions: [
        AppStateAction(
          label: 'Mettre à jour',
          onPressed: onUpdate,
          isPrimary: true,
        ),
      ],
    );
  }
}

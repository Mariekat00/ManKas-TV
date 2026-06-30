import 'package:flutter/material.dart';
import '../../core/widgets/app_state_page.dart';

/// Page « Téléchargements vides »
class DownloadsEmptyPage extends StatelessWidget {
  final VoidCallback? onExplore;

  const DownloadsEmptyPage({super.key, this.onExplore});

  @override
  Widget build(BuildContext context) {
    return AppStatePage(
      icon: Icons.download_done_rounded,
      iconColor: const Color(0xFF10B981),
      title: 'Aucun téléchargement',
      description:
          'Vous n\'avez encore téléchargé aucun contenu.',
      actions: [
        AppStateAction(
          label: 'Explorer',
          onPressed: onExplore,
          isPrimary: true,
        ),
      ],
    );
  }
}

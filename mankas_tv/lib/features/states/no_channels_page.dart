import 'package:flutter/material.dart';
import '../../core/widgets/app_state_page.dart';

/// Page « Aucune chaîne disponible » (catégorie vide)
class NoChannelsAvailablePage extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onRefresh;

  const NoChannelsAvailablePage({
    super.key,
    this.onBack,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return AppStatePage(
      icon: Icons.menu_book_rounded,
      iconColor: const Color(0xFF6366F1),
      title: 'Aucune chaîne disponible',
      description:
          'Cette catégorie ne contient actuellement aucune chaîne.',
      actions: [
        AppStateAction(
          label: 'Retour',
          onPressed: onBack ?? () => Navigator.of(context).pop(),
          isPrimary: true,
        ),
        AppStateAction(
          label: 'Actualiser',
          onPressed: onRefresh,
        ),
      ],
    );
  }
}

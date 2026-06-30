import 'package:flutter/material.dart';
import '../../core/widgets/app_state_page.dart';

/// Page « Aucun favori »
class EmptyFavoritesPage extends StatelessWidget {
  final VoidCallback? onExplore;

  const EmptyFavoritesPage({super.key, this.onExplore});

  @override
  Widget build(BuildContext context) {
    return AppStatePage(
      icon: Icons.favorite_border_rounded,
      iconColor: const Color(0xFFEC4899),
      title: 'Aucun favori',
      description:
          'Ajoutez vos chaînes préférées pour les retrouver ici.',
      actions: [
        AppStateAction(
          label: 'Explorer les chaînes',
          onPressed: onExplore,
          isPrimary: true,
        ),
      ],
    );
  }
}

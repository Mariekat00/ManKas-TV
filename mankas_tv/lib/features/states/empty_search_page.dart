import 'package:flutter/material.dart';
import '../../core/widgets/app_state_page.dart';

/// Page « Aucun résultat trouvé » (recherche vide)
class EmptySearchPage extends StatelessWidget {
  final VoidCallback? onClear;

  const EmptySearchPage({super.key, this.onClear});

  @override
  Widget build(BuildContext context) {
    return AppStatePage(
      icon: Icons.search_off_rounded,
      iconColor: const Color(0xFF6366F1),
      title: 'Aucun résultat trouvé',
      description:
          'Essayez un autre mot-clé.',
      actions: [
        AppStateAction(
          label: 'Effacer la recherche',
          onPressed: onClear,
          isPrimary: true,
        ),
      ],
    );
  }
}

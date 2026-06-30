import 'package:flutter/material.dart';
import '../../core/widgets/app_state_page.dart';

/// Page « Historique vide »
class HistoryEmptyPage extends StatelessWidget {
  final VoidCallback? onHome;

  const HistoryEmptyPage({super.key, this.onHome});

  @override
  Widget build(BuildContext context) {
    return AppStatePage(
      icon: Icons.history_rounded,
      iconColor: const Color(0xFF3B82F6),
      title: 'Aucun historique',
      description:
          'Les chaînes que vous regarderez apparaîtront ici.',
      actions: [
        AppStateAction(
          label: 'Accueil',
          onPressed: onHome ?? () => Navigator.of(context).popUntil((r) => r.isFirst),
          isPrimary: true,
        ),
      ],
    );
  }
}

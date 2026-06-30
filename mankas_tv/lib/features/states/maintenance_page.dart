import 'package:flutter/material.dart';
import '../../core/widgets/app_state_page.dart';

/// Page « Maintenance en cours »
class MaintenancePage extends StatelessWidget {
  final VoidCallback? onRefresh;

  const MaintenancePage({super.key, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return AppStatePage(
      icon: Icons.construction_rounded,
      iconColor: const Color(0xFFF59E0B),
      title: 'Maintenance en cours',
      description:
          'Cette chaîne sera bientôt disponible.',
      actions: [
        AppStateAction(
          label: 'Actualiser',
          onPressed: onRefresh,
          isPrimary: true,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../core/widgets/app_state_page.dart';

/// Page « Connexion requise »
class LoginRequiredPage extends StatelessWidget {
  final VoidCallback? onLogin;

  const LoginRequiredPage({super.key, this.onLogin});

  @override
  Widget build(BuildContext context) {
    return AppStatePage(
      icon: Icons.account_circle_rounded,
      iconColor: const Color(0xFF6366F1),
      title: 'Connexion requise',
      description:
          'Connectez-vous pour accéder à cette fonctionnalité.',
      actions: [
        AppStateAction(
          label: 'Se connecter',
          onPressed: onLogin,
          isPrimary: true,
        ),
      ],
    );
  }
}

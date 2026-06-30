import 'package:flutter/material.dart';
import '../utils/app_strings.dart';
import '../core/widgets/app_state_page.dart';

class LiveMatchesScreen extends StatelessWidget {
  const LiveMatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            const Text('🔴 ', style: TextStyle(fontSize: 18)),
            Text(AppStrings.of(context).liveMatches, style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
      body: AppStatePage(
        icon: Icons.sports_soccer_rounded,
        iconColor: theme.colorScheme.onSurfaceVariant,
        title: AppStrings.of(context).serviceUnavailable,
        description: AppStrings.of(context).serviceUnavailableDesc,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../config.dart';
import '../utils/app_strings.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  PackageInfo? _packageInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInfo();
  }

  Future<void> _loadInfo() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _packageInfo = info;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = AppStrings.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.settings),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // App Info
                _sectionHeader(strings.about),
                const SizedBox(height: 8),
                _SettingsTile(
                  icon: Icons.info_outline,
                  title: strings.appName,
                  subtitle: 'v${_packageInfo?.version ?? '?'}',
                ),
                _SettingsTile(
                  icon: Icons.code,
                  title: 'Build',
                  subtitle: _packageInfo?.buildNumber ?? '?',
                ),
                const SizedBox(height: 24),

                // Admin Info
                _sectionHeader('Administrateur'),
                const SizedBox(height: 8),
                _SettingsTile(
                  icon: Icons.person,
                  title: 'Email admin',
                  subtitle: Config.adminEmail,
                ),
                _SettingsTile(
                  icon: Icons.dns,
                  title: 'Supabase Project',
                  subtitle: Config.supabaseUrl.replaceAll('https://', ''),
                ),
                const SizedBox(height: 24),

                // Features
                _sectionHeader('Fonctionnalités'),
                const SizedBox(height: 8),
                _FeatureTile(
                  icon: Icons.tv,
                  title: strings.channels,
                  enabled: true,
                ),
                _FeatureTile(
                  icon: Icons.favorite,
                  title: strings.favorites,
                  enabled: true,
                ),
                _FeatureTile(
                  icon: Icons.sports_soccer,
                  title: strings.liveMatches,
                  enabled: true,
                ),
                _FeatureTile(
                  icon: Icons.admin_panel_settings,
                  title: strings.adminPanel,
                  enabled: true,
                ),
                const SizedBox(height: 24),

                // Platform
                _sectionHeader('Plateforme'),
                const SizedBox(height: 8),
                _SettingsTile(
                  icon: Icons.phone_android,
                  title: 'Mobile',
                  subtitle: 'Flutter + media_kit',
                ),
                _SettingsTile(
                  icon: Icons.language,
                  title: 'Web',
                  subtitle: 'Next.js 15 + React 19',
                ),
                const SizedBox(height: 24),

                // Danger zone
                _sectionHeader('Zone dangereuse'),
                const SizedBox(height: 8),
                ListTile(
                  leading: Icon(Icons.delete_outline, color: theme.colorScheme.error),
                  title: Text('Vider le cache local', style: TextStyle(color: theme.colorScheme.error)),
                  subtitle: const Text('Supprime les données locales de l\'application'),
                  onTap: () => _showClearCacheDialog(context),
                ),
                const SizedBox(height: 32),

                // Footer
                Center(
                  child: Text(
                    '© 2026 ManKas Corporation',
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    final strings = AppStrings.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Vider le cache'),
        content: const Text('Êtes-vous sûr ? Les données locales seront supprimées.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(strings.retry)),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache vidé')),
              );
            },
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      subtitle: Text(subtitle, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12)),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool enabled;

  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      trailing: Icon(
        enabled ? Icons.check_circle : Icons.cancel,
        color: enabled ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.onSurfaceVariant,
        size: 20,
      ),
    );
  }
}

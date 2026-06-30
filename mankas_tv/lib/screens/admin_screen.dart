import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config.dart';
import '../services/auth_service.dart';
import '../services/snackbar_service.dart';
import '../utils/app_strings.dart';
import 'channel_management_screen.dart';
import 'admin_statistics_screen.dart';
import 'admin_settings_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = true;
  bool _isLoginMode = true;
  User? _user;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _checkAuth() {
    setState(() {
      _user = _auth.currentUser;
      _isLoading = false;
    });
  }

  Future<void> _signInWithGoogle() async {
    try {
      setState(() => _isLoading = true);
      await _auth.signInWithGoogle();
      _checkAuth();
    } catch (e) {
      if (mounted) {
        AppSnackBarService.instance.error('${AppStrings.of(context).connectionFailed} $e');
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signInWithEmail() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      setState(() => _isLoading = true);
      await _auth.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      );
      _checkAuth();
    } catch (e) {
      if (mounted) {
        AppSnackBarService.instance.error('${AppStrings.of(context).connectionFailed} $e');
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signUpWithEmail() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      setState(() => _isLoading = true);
      await _auth.signUpWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (mounted) {
        AppSnackBarService.instance.success('Compte créé. Vérifiez votre email.');
        setState(() {
          _isLoginMode = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        AppSnackBarService.instance.error('${AppStrings.of(context).connectionFailed} $e');
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    _checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_user == null || !_auth.isAdmin) {
      return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              children: [
                const SizedBox(height: 24),
                Icon(
                  Icons.admin_panel_settings_rounded,
                  size: 64,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  AppStrings.of(context).adminPanel,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (_user != null && !_auth.isAdmin)
                  Text(
                    '${AppStrings.of(context).accountUnauthorized}.\n${AppStrings.of(context).adminAccessRestricted.replaceAll('%s', Config.adminEmail)}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                  )
                else
                  Text(
                    AppStrings.of(context).loginRequired,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                  ),
                const SizedBox(height: 32),

                // Email/Password form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: AppStrings.of(context).email,
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: const OutlineInputBorder(),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Champ requis';
                          if (!v.contains('@')) return 'Email invalide';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: AppStrings.of(context).password,
                          prefixIcon: const Icon(Icons.lock_outlined),
                          border: const OutlineInputBorder(),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Champ requis';
                          if (v.length < 6) return '6 caractères minimum';
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          if (_isLoginMode) {
                            _signInWithEmail();
                          } else {
                            _signUpWithEmail();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Login / Signup button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    onPressed: _isLoginMode ? _signInWithEmail : _signUpWithEmail,
                    child: Text(
                      _isLoginMode
                          ? AppStrings.of(context).login
                          : AppStrings.of(context).createAccount,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Toggle login/signup
                TextButton(
                  onPressed: () => setState(() => _isLoginMode = !_isLoginMode),
                  child: Text(
                    _isLoginMode
                        ? AppStrings.of(context).noAccount
                        : AppStrings.of(context).login,
                  ),
                ),

                const SizedBox(height: 24),

                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        AppStrings.of(context).or,
                        style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 24),

                // Google Sign-In button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: _signInWithGoogle,
                    icon: const Icon(Icons.g_mobiledata, size: 24),
                    label: Text(AppStrings.of(context).loginWithGoogle),
                  ),
                ),

                if (_user != null && !_auth.isAdmin) ...[
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: _signOut,
                      child: Text(AppStrings.of(context).logout),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }

    return _buildAdminPanel(theme);
  }

  Widget _buildAdminPanel(ThemeData theme) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.of(context).adminPanel),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: theme.colorScheme.error, size: 16),
                const SizedBox(width: 4),
                Text(
                  _user?.email ?? '',
                  style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 12),
                ),
                Semantics(
                  label: AppStrings.of(context).logout,
                  child: IconButton(
                    icon: const Icon(Icons.logout, size: 18),
                    onPressed: _signOut,
                    tooltip: AppStrings.of(context).logout,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          // Header
          Center(
            child: Column(
              children: [
                Icon(Icons.verified_user, color: theme.colorScheme.error, size: 48),
                const SizedBox(height: 8),
                Text(
                  AppStrings.of(context).connectedAs.replaceAll('%s', _user?.email ?? ''),
                  style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Divider(height: 1),
          // Menu items
          _AdminMenuItem(
            icon: Icons.tv,
            title: AppStrings.of(context).manageChannels,
            subtitle: AppStrings.of(context).channels,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChannelManagementScreen()),
            ),
          ),
          _AdminMenuItem(
            icon: Icons.bar_chart,
            title: AppStrings.of(context).statistics,
            subtitle: 'Utilisateurs, chaînes, favoris',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AdminStatisticsScreen()),
            ),
          ),
          _AdminMenuItem(
            icon: Icons.settings,
            title: AppStrings.of(context).settings,
            subtitle: 'Configuration de l\'application',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AdminSettingsScreen()),
            ),
          ),
          const Divider(height: 1),
          const SizedBox(height: 16),
          // Logout button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: _signOut,
              icon: const Icon(Icons.logout),
              label: Text(AppStrings.of(context).logout),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AdminMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(title),
      subtitle: Text(subtitle, style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 12)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart' show adminEmail;
import '../services/auth_service.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final AuthService _auth = AuthService();
  bool _isLoading = true;
  User? _user;

  @override
  void initState() {
    super.initState();
    _checkAuth();
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connexion échouée : $e'), backgroundColor: Colors.red),
        );
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
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: const Center(child: CircularProgressIndicator(color: Colors.white54)),
      );
    }

    if (_user == null || !_auth.isAdmin) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.admin_panel_settings, color: Colors.redAccent, size: 64),
                const SizedBox(height: 24),
                const Text(
                  'Accès Admin',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  _user == null
                      ? 'Connectez-vous avec votre compte Google autorisé.'
                      : 'Compte non autorisé.\nSeul $adminEmail peut accéder à l\'admin.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                ),
                const SizedBox(height: 32),
                if (_user == null)
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _signInWithGoogle,
                      icon: const Icon(Icons.g_mobiledata, size: 24),
                      label: const Text('Se connecter avec Google'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E1E2E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _signOut,
                      icon: const Icon(Icons.logout, size: 18),
                      label: const Text('Déconnexion'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E1E2E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return _buildAdminPanel();
  }

  Widget _buildAdminPanel() {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2E),
        title: const Text('Panneau Admin'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.green.withValues(alpha: 0.8), size: 16),
                const SizedBox(width: 4),
                Text(
                  _user?.email ?? '',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12),
                ),
                IconButton(
                  icon: const Icon(Icons.logout, size: 18),
                  onPressed: _signOut,
                  tooltip: 'Déconnexion',
                ),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.verified_user, color: Colors.green.withValues(alpha: 0.8), size: 64),
            const SizedBox(height: 16),
            const Text(
              'Mode Admin actif',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Connecté en tant que ${_user?.email}',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
            ),
          ],
        ),
      ),
    );
  }
}

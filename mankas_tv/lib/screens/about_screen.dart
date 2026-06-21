import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF11111B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text('À propos', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.info_outline, color: Color(0xFF6366F1), size: 36),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'À propos de l\'application',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Présentation
            _sectionTitle('Présentation'),
            _card(
              child: const Text(
                'ManKas TV est une application conçue pour offrir une expérience streaming simple, rapide et efficace. Elle permet aux utilisateurs de regarder leurs chaînes IPTV favorites, de découvrir des matchs en direct et de profiter d\'une interface moderne adaptée aux appareils mobiles.',
                style: TextStyle(color: Colors.white70, height: 1.6),
              ),
            ),
            const SizedBox(height: 24),

            // Fonctionnalités
            _sectionTitle('Fonctionnalités principales'),
            _card(
              child: Column(
                children: [
                  _feature('📺', 'Plus de 4500 chaînes IPTV publiques'),
                  _feature('⚽', 'Matchs en direct via StreamFree'),
                  _feature('🏆', 'Suivi FIFA World Cup 2026'),
                  _feature('❤️', 'Système de favoris'),
                  _feature('🔍', 'Recherche par nom, pays, langue'),
                  _feature('🎨', 'Thème sombre / clair'),
                  _feature('📱', 'Application mobile Flutter'),
                  _feature('🌐', 'Version web Next.js'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Développeur
            _sectionTitle('Développeur'),
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Moïse Manda', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  const Text('ManKas Corporation', style: TextStyle(color: Color(0xFF6366F1), fontSize: 13)),
                  const SizedBox(height: 12),
                  const Text(
                    'Graphiste designer, développeur web et mobile, fondateur de ManKas Corporation.',
                    style: TextStyle(color: Colors.white70, height: 1.5),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _skillTag('Développement Flutter'),
                      _skillTag('Développement Web'),
                      _skillTag('Design graphique'),
                      _skillTag('Intelligence artificielle'),
                      _skillTag('Formation informatique'),
                      _skillTag('Solutions numériques'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ManKas Corporation
            _sectionTitle('ManKas Corporation'),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  const Text(
                    '"L\'innovation créatif, rapide et efficace"',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF6366F1),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  _serviceItem(Icons.phone_android, 'Développement d\'applications mobiles'),
                  _serviceItem(Icons.language, 'Création de sites web'),
                  _serviceItem(Icons.qr_code, 'Solutions QR Code'),
                  _serviceItem(Icons.palette, 'Design graphique'),
                  _serviceItem(Icons.school, 'Formation informatique'),
                  _serviceItem(Icons.lightbulb_outline, 'Conseil numérique'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Contact
            _sectionTitle('Contact'),
            _contactTile(Icons.phone, 'Téléphone', '+243 974 037 169', () => _launchUrl('tel:+243974037169')),
            const SizedBox(height: 8),
            _contactTile(Icons.email, 'Email', 'moisemanda2000@gmail.com', () => _launchUrl('mailto:moisemanda2000@gmail.com')),
            const SizedBox(height: 24),

            // Réseaux sociaux
            _sectionTitle('Réseaux sociaux'),
            _socialTile('WhatsApp', 'https://wa.me/message/J7SLDL3BFZFGI1', Colors.green),
            const SizedBox(height: 8),
            _socialTile('Telegram', 'https://t.me/MANKAS1', Colors.blue),
            const SizedBox(height: 8),
            _socialTile('LinkedIn', 'https://www.linkedin.com/in/moïse-manda-499982218', Colors.blue.shade700),
            const SizedBox(height: 8),
            _socialTile('Instagram', 'https://www.instagram.com/mankascorporation', Colors.pink),
            const SizedBox(height: 8),
            _socialTile('GitHub', 'https://github.com/Mariekat00', Colors.white),
            const SizedBox(height: 32),

            // Footer
            Center(
              child: Column(
                children: [
                  const Text('Version 1.0.0', style: TextStyle(color: Colors.white54, fontSize: 13)),
                  const SizedBox(height: 4),
                  const Text(
                    '© 2026 ManKas Corporation. Tous droits réservés.',
                    style: TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  static Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      ),
    );
  }

  static Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A3E)),
      ),
      child: child,
    );
  }

  static Widget _feature(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 14))),
        ],
      ),
    );
  }

  static Widget _skillTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2A2A3E)),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 12)),
    );
  }

  static Widget _serviceItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF6366F1), size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 14))),
        ],
      ),
    );
  }

  static Widget _contactTile(IconData icon, String label, String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2A2A3E)),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF6366F1), size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                  const SizedBox(height: 2),
                  Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _socialTile(String label, String url, Color color) {
    return GestureDetector(
      onTap: () => _launchUrl(url),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2A2A3E)),
        ),
        child: Row(
          children: [
            Icon(Icons.link, color: color, size: 20),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
            const Spacer(),
            const Icon(Icons.open_in_new, color: Colors.white38, size: 16),
          ],
        ),
      ),
    );
  }

  static Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

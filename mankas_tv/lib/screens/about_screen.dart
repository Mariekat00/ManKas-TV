import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/app_strings.dart';

const _appVersion = '1.0.0';
const _developerName = 'Moïse Manda';
const _developerCompany = 'ManKas Corporation';
const _developerBio = 'Graphiste designer, développeur web et mobile, fondateur de ManKas Corporation.';
const _phone = '+243 974 037 169';
const _phoneUri = 'tel:+243974037169';
const _email = 'moisemanda2000@gmail.com';
const _emailUri = 'mailto:moisemanda2000@gmail.com';
const _whatsappUrl = 'https://wa.me/message/J7SLDL3BFZFGI1';
const _telegramUrl = 'https://t.me/MANKAS1';
const _linkedinUrl = 'https://www.linkedin.com/in/moïse-manda-499982218';
const _instagramUrl = 'https://www.instagram.com/mankascorporation';
const _githubUrl = 'https://github.com/Mariekat00';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF11111B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Text(AppStrings.of(context).about, style: const TextStyle(fontWeight: FontWeight.w700)),
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
                  Text(
                    AppStrings.of(context).about,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Présentation
            _sectionTitle('Overview'),
            _card(
              child: const Text(
                'ManKas TV is designed to offer a simple, fast, and efficient streaming experience. It lets users watch their favorite IPTV channels, discover live matches, and enjoy a modern interface optimized for mobile devices.',
                style: TextStyle(color: Colors.white70, height: 1.6),
              ),
            ),
            const SizedBox(height: 24),

            // Fonctionnalités
            _sectionTitle('Features'),
            _card(
              child: Column(
                children: [
                  _feature('📺', '4500+ public IPTV channels'),
                  _feature('⚽', 'Live matches via StreamFree'),
                  _feature('🏆', 'FIFA World Cup 2026 tracking'),
                  _feature('❤️', 'Favorites system'),
                  _feature('🔍', 'Search by name, country, language'),
                  _feature('🎨', 'Dark / Light theme'),
                  _feature('📱', 'Flutter mobile app'),
                  _feature('🌐', 'Next.js web version'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Développeur
            _sectionTitle('Developer'),
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_developerName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(_developerCompany, style: const TextStyle(color: Color(0xFF6366F1), fontSize: 13)),
                  const SizedBox(height: 12),
                  Text(
                    _developerBio,
                    style: const TextStyle(color: Colors.white70, height: 1.5),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                  _skillTag('Flutter Development'),
                  _skillTag('Web Development'),
                  _skillTag('Graphic Design'),
                  _skillTag('Artificial Intelligence'),
                  _skillTag('IT Training'),
                  _skillTag('Digital Solutions'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ManKas Corporation
            _sectionTitle('About ManKas Corporation'),
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
                    '"Creative, fast, and effective innovation"',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF6366F1),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  _serviceItem(Icons.phone_android, 'Mobile app development'),
                  _serviceItem(Icons.language, 'Website creation'),
                  _serviceItem(Icons.qr_code, 'QR Code solutions'),
                  _serviceItem(Icons.palette, 'Graphic design'),
                  _serviceItem(Icons.school, 'IT training'),
                  _serviceItem(Icons.lightbulb_outline, 'Digital consulting'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Contact
            _sectionTitle('Contact'), // keep English
            _contactTile(Icons.phone, 'Phone', _phone, () => _launchUrl(_phoneUri)),
            const SizedBox(height: 8),
            _contactTile(Icons.email, 'Email', _email, () => _launchUrl(_emailUri)),
            const SizedBox(height: 24),

            // Réseaux sociaux
            _sectionTitle('Social Networks'),
            _socialTile('WhatsApp', _whatsappUrl, Colors.green),
            const SizedBox(height: 8),
            _socialTile('Telegram', _telegramUrl, Colors.blue),
            const SizedBox(height: 8),
            _socialTile('LinkedIn', _linkedinUrl, Colors.blue.shade700),
            const SizedBox(height: 8),
            _socialTile('Instagram', _instagramUrl, Colors.pink),
            const SizedBox(height: 8),
            _socialTile('GitHub', _githubUrl, Colors.white),
            const SizedBox(height: 32),

            // Footer
            Center(
              child: Column(
                children: [
                  Text('Version $_appVersion', style: const TextStyle(color: Colors.white54, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(
                    '© 2026 $_developerCompany. All rights reserved.',
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
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

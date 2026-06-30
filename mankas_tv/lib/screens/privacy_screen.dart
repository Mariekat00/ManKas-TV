import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/app_strings.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final surface = theme.colorScheme.surface;
    final border = theme.colorScheme.surface.withAlpha(178);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: surface,
        title: Text(
          AppStrings.of(context).privacyPolicy,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: primary.withAlpha(38),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.shield, color: primary, size: 32),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                AppStrings.of(context).privacyPolicy,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                AppStrings.of(context).privacyLastUpdated,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ),
            const SizedBox(height: 28),
            _intro(AppStrings.of(context).privacyIntro),
            const SizedBox(height: 24),
            _sectionTitle(AppStrings.of(context).privacyDataCollected, primary),
            const SizedBox(height: 8),
            _text(AppStrings.of(context).privacyDataCollectedDesc),
            _bullet(AppStrings.of(context).privacyItem1),
            _bullet(AppStrings.of(context).privacyItem2),
            _bullet(AppStrings.of(context).privacyItem3),
            _bullet(AppStrings.of(context).privacyItem4),
            const SizedBox(height: 8),
            _highlight(AppStrings.of(context).privacyNoData),
            const SizedBox(height: 24),
            _sectionTitle(AppStrings.of(context).privacyUsage, primary),
            const SizedBox(height: 8),
            _text(AppStrings.of(context).privacyUsageDesc),
            _bullet(AppStrings.of(context).privacyUsage1),
            _bullet(AppStrings.of(context).privacyUsage2),
            _bullet(AppStrings.of(context).privacyUsage3),
            const SizedBox(height: 24),
            _sectionTitle(AppStrings.of(context).privacyThirdParties, primary),
            const SizedBox(height: 8),
            _text(AppStrings.of(context).privacyThirdPartiesDesc),
            _bullet(AppStrings.of(context).privacyThirdItem1),
            _bullet(AppStrings.of(context).privacyThirdItem2),
            _bullet(AppStrings.of(context).privacyThirdItem3),
            const SizedBox(height: 24),
            _sectionTitle(AppStrings.of(context).privacySecurity, primary),
            const SizedBox(height: 8),
            _text(AppStrings.of(context).privacySecurityDesc),
            const SizedBox(height: 24),
            _sectionTitle(AppStrings.of(context).privacyContact, primary),
            const SizedBox(height: 8),
            _text(AppStrings.of(context).privacyContactDesc),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _launchUrl('mailto:moisemanda2000@gmail.com'),
              child: Text(
                'moisemanda2000@gmail.com',
                style: TextStyle(color: primary, fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: GestureDetector(
                onTap: () => _launchUrl('https://mankas-tv.vercel.app/privacy/'),
                child: Text(
                  'Voir en ligne →',
                  style: TextStyle(color: primary, fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  static Widget _sectionTitle(String title, Color color) {
    return Text(
      title,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: color),
    );
  }

  static Widget _intro(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.6),
    );
  }

  static Widget _text(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
      ),
    );
  }

  static Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  ', style: TextStyle(color: Colors.white54, fontSize: 14)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _highlight(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.withAlpha(60)),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.amber, fontSize: 13, fontWeight: FontWeight.w600),
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

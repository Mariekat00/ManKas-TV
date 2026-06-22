import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'config.dart';
import 'providers/tv_provider.dart';
import 'services/notification_service.dart';
import 'services/connectivity_service.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  await Supabase.initialize(url: Config.supabaseUrl, anonKey: Config.supabaseAnonKey);

  await NotificationService().init();

  final prefs = await SharedPreferences.getInstance();
  final onboardingDone = prefs.getBool('onboarding_done') ?? false;

  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://24657fff14de777517ebd835fa6f360d@o4511609466388480.ingest.de.sentry.io/4511609494503504';
      options.tracesSampleRate = 0.2;
    },
    appRunner: () => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => TvProvider()),
          ChangeNotifierProvider(create: (_) => ConnectivityService()..startMonitoring()),
        ],
        child: ManKasTvApp(onboardingDone: onboardingDone),
      ),
    ),
  );
}

class ManKasTvApp extends StatelessWidget {
  final bool onboardingDone;
  const ManKasTvApp({super.key, required this.onboardingDone});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ManKas TV',
      locale: const Locale('fr', 'FR'),
      supportedLocales: const [Locale('fr', 'FR'), Locale('en', 'US')],
      theme: AppTheme.dark,
      debugShowCheckedModeBanner: false,
      home: onboardingDone ? const HomeScreen() : const OnboardingScreen(),
    );
  }
}

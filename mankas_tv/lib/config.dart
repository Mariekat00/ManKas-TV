import 'package:flutter/foundation.dart';

class Config {
  Config._();

  static String get supabaseUrl {
    const v = String.fromEnvironment('SUPABASE_URL');
    if (v.isNotEmpty) return v;
    if (kReleaseMode) return '';
    return 'https://mpodxxqzjsbojmkirsdz.supabase.co';
  }

  static String get supabaseAnonKey {
    const v = String.fromEnvironment('SUPABASE_ANON_KEY');
    if (v.isNotEmpty) return v;
    if (kReleaseMode) return '';
    return 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1wb2R4eHF6anNib2pta2lyc2R6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE2Mzc1MTgsImV4cCI6MjA5NzIxMzUxOH0.JUViDdrIW4BwPuZ7g--CjbTBa8XdY7iDhliZ6TahSPk';
  }

  static String get adminEmail {
    const v = String.fromEnvironment('ADMIN_EMAIL');
    if (v.isNotEmpty) return v;
    if (kReleaseMode) return '';
    return 'moisemanda2000@gmail.com';
  }

  static String get googleWebClientId {
    const v = String.fromEnvironment('GOOGLE_WEB_CLIENT_ID');
    if (v.isNotEmpty) return v;
    if (kReleaseMode) return '';
    return '451865698298-626fm5kgu56hd23tn9uphqd51u40l4j7.apps.googleusercontent.com';
  }

  static String get sentryDsn {
    const v = String.fromEnvironment('SENTRY_DSN');
    if (v.isNotEmpty) return v;
    if (kReleaseMode) return '';
    return 'https://24657fff14de777517ebd835fa6f360d@o4511609466388480.ingest.de.sentry.io/4511609494503504';
  }

  static bool get isConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}

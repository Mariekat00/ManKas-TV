import 'package:flutter/foundation.dart';

class Config {
  Config._();

  static String get supabaseUrl {
    if (kReleaseMode) {
      const v = String.fromEnvironment('SUPABASE_URL');
      if (v.isNotEmpty) return v;
    }
    return 'https://mpodxxqzjsbojmkirsdz.supabase.co';
  }

  static String get supabaseAnonKey {
    if (kReleaseMode) {
      const v = String.fromEnvironment('SUPABASE_ANON_KEY');
      if (v.isNotEmpty) return v;
    }
    return 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1wb2R4eHF6anNib2pta2lyc2R6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE2Mzc1MTgsImV4cCI6MjA5NzIxMzUxOH0.JUViDdrIW4BwPuZ7g--CjbTBa8XdY7iDhliZ6TahSPk';
  }

  static String get adminEmail {
    if (kReleaseMode) {
      const v = String.fromEnvironment('ADMIN_EMAIL');
      if (v.isNotEmpty) return v;
    }
    return 'moisemanda2000@gmail.com';
  }

  static const String googleWebClientId = '451865698298-626fm5kgu56hd23tn9uphqd51u40l4j7.apps.googleusercontent.com';
}

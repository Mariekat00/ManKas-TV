import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'providers/tv_provider.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';

const supabaseUrl = 'https://mpodxxqzjsbojmkirsdz.supabase.co';
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1wb2R4eHF6anNib2pta2lyc2R6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE2Mzc1MTgsImV4cCI6MjA5NzIxMzUxOH0.JUViDdrIW4BwPuZ7g--CjbTBa8XdY7iDhliZ6TahSPk';
const adminEmail = 'moisemanda2000@gmail.com';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  runApp(
    ChangeNotifierProvider(
      create: (_) => TvProvider(),
      child: const ManKasTvApp(),
    ),
  );
}

class ManKasTvApp extends StatelessWidget {
  const ManKasTvApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ManKas TV',
      theme: AppTheme.dark,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

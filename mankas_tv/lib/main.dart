import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:provider/provider.dart';
import 'providers/tv_provider.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

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

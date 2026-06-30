import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:media_kit/media_kit.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'config.dart';
import 'providers/tv_provider.dart';
import 'services/notification_service.dart';
import 'services/connectivity_service.dart';
import 'services/dialog_service.dart';
import 'services/snackbar_service.dart';
import 'services/toast_service.dart';
import 'services/bottom_sheet_service.dart';
import 'services/cast_service.dart';
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

  if (Config.sentryDsn.isNotEmpty) {
    await SentryFlutter.init(
      (options) {
        options.dsn = Config.sentryDsn;
        options.tracesSampleRate = 0.2;
      },
      appRunner: () => runApp(_buildApp(onboardingDone)),
    );
  } else {
    runApp(_buildApp(onboardingDone));
  }
}

Widget _buildApp(bool onboardingDone) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => TvProvider()),
      ChangeNotifierProvider(create: (_) => ConnectivityService()..startMonitoring()),
    ],
    child: ManKasTvApp(onboardingDone: onboardingDone),
  );
}

class ManKasTvApp extends StatefulWidget {
  final bool onboardingDone;
  const ManKasTvApp({super.key, required this.onboardingDone});

  @override
  State<ManKasTvApp> createState() => _ManKasTvAppState();
}

class _ManKasTvAppState extends State<ManKasTvApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initServices();
    });
  }

  void _initServices() {
    final navigator = _navigatorKey.currentState;
    if (navigator == null) return;

    final context = navigator.context;
    AppDialogService.setContext(context);
    BottomSheetService.setContext(context);

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    AppSnackBarService.setMessenger(scaffoldMessenger);

    final overlay = Overlay.of(context);
    AppToastService.setOverlay(overlay);

    CastService.instance.init();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ManKas TV',
      locale: const Locale('fr', 'FR'),
      supportedLocales: const [Locale('fr', 'FR'), Locale('en', 'US')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.dark,
      debugShowCheckedModeBanner: false,
      navigatorKey: _navigatorKey,
      home: widget.onboardingDone ? const HomeScreen() : const OnboardingScreen(),
    );
  }
}

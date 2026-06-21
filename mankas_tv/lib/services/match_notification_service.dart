import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import '../models/football_match.dart';

class MatchNotificationService {
  static final MatchNotificationService _instance = MatchNotificationService._();
  factory MatchNotificationService() => _instance;
  MatchNotificationService._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.local);

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    await _plugin.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
    );

    const channel = AndroidNotificationChannel(
      'match_reminders',
      'Rappels de matchs',
      description: 'Notifications de rappel 15 minutes avant les matchs',
      importance: Importance.high,
      enableVibration: true,
    );
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    _initialized = true;
  }

  Future<void> scheduleMatchReminders(List<FootballMatch> matches) async {
    await cancelAll();

    final now = DateTime.now();
    final upcoming = matches.where((m) {
      if (m.hasStarted || m.isFinished) return false;
      final matchTime = _parseMatchDateTime(m);
      if (matchTime == null) return false;
      final reminderTime = matchTime.subtract(const Duration(minutes: 15));
      return reminderTime.isAfter(now);
    }).toList();

    for (int i = 0; i < upcoming.length; i++) {
      final match = upcoming[i];
      final matchTime = _parseMatchDateTime(match);
      if (matchTime == null) continue;

      final reminderTime = matchTime.subtract(const Duration(minutes: 15));
      final tzDateTime = tz.TZDateTime.from(reminderTime, tz.local);

      await _plugin.zonedSchedule(
        match.id.hashCode,
        '⚽ Match dans 15 minutes !',
        '${match.homeTeamName} vs ${match.awayTeamName}',
        tzDateTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'match_reminders',
            'Rappels de matchs',
            channelDescription: 'Notifications de rappel 15 minutes avant les matchs',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  DateTime? _parseMatchDateTime(FootballMatch match) {
    try {
      final parts = match.localDate.split(' ');
      if (parts.length < 2) return null;

      final dateParts = parts[0].split('/');
      if (dateParts.length < 3) return null;

      final month = int.parse(dateParts[0]);
      final day = int.parse(dateParts[1]);
      final year = int.parse(dateParts[2]);

      final timeParts = parts[1].split(':');
      final hour = int.parse(timeParts[0]);
      final minute = timeParts.length > 1 ? int.parse(timeParts[1]) : 0;

      return DateTime(year, month, day, hour, minute);
    } catch (_) {
      return null;
    }
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'mengxing_main';
  static const String _channelName = 'MengXing Reminders';

  Future<void> init() async {
    tz.initializeTimeZones();

    const android =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    // v22: all named params
    await _plugin.initialize(
      settings: const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: (_) {},
    );
  }

  Future<bool> requestPermissions() async {
    final ios = await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    final android = await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    return ios ?? android ?? false;
  }

  static const _androidDetails = AndroidNotificationDetails(
    _channelId,
    _channelName,
    importance: Importance.high,
    priority: Priority.high,
    icon: '@mipmap/ic_launcher',
  );

  static const _iosDetails =
      DarwinNotificationDetails(presentAlert: true, presentSound: true);

  static const _notifDetails = NotificationDetails(
    android: _androidDetails,
    iOS: _iosDetails,
  );

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) =>
      _plugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: _notifDetails,
        payload: payload,
      );

  Future<void> scheduleDaily({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    String? payload,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduled,
      notificationDetails: _notifDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
    );
  }

  Future<void> cancel(int id) => _plugin.cancel(id: id);
  Future<void> cancelAll() => _plugin.cancelAll();

  static const int idDailyWorkout = 1;
  static const int idWalkReminder = 2;
  static const int idStepGoal = 4;
  static const int idStreakReminder = 5;
  static const int idGoalCompletion = 6;

  Future<void> showStepGoalReminder(int remaining) => showNotification(
        id: idStepGoal,
        title: 'Almost there! 🎯',
        body: 'Only $remaining steps away from your daily goal!',
      );

  Future<void> showGoalCompleted() => showNotification(
        id: idGoalCompletion,
        title: 'Goal Completed! 🎉',
        body: "You've reached your daily goal. Amazing! 🖤",
      );

  Future<void> showStreakReminder(int streak) => showNotification(
        id: idStreakReminder,
        title: 'Keep your streak alive! 🔥',
        body: "You have a $streak-day streak. Don't break it!",
      );
}

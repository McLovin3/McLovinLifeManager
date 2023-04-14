import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as timezone;
import 'package:timezone/data/latest.dart' as timezone_data;

class NotificationsService {
  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    timezone_data.initializeTimeZones();
    await _localNotifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings(
          "@mipmap/ic_launcher",
        ),
      ),
    );
  }

  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  Future<void> createNotification(
      {required int id,
      required String title,
      required String body,
      required DateTime dateTime}) async {
    _localNotifications.cancel(id);
    final scheduleTime = timezone.TZDateTime.fromMillisecondsSinceEpoch(
        timezone.local, dateTime.millisecondsSinceEpoch);

    const noticeDetail = NotificationDetails(
      android: AndroidNotificationDetails("main", "main"),
    );

    await _localNotifications.zonedSchedule(
      id,
      title,
      body,
      scheduleTime,
      noticeDetail,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }
}

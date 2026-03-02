import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> onDidReceiveNotification(
      NotificationResponse notificationResponse) async {}

  Future<void> init() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    const DarwinInitializationSettings darwinInitializationSettings =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: androidInitializationSettings,
            iOS: darwinInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(settings: initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotification,
        onDidReceiveBackgroundNotificationResponse: onDidReceiveNotification);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> showInstantNotification(
      String body, int minutes, int idNotification,
      {String title = "Recordatorio"}) async {
    Timer.periodic(Duration(seconds: minutes), (Timer timer) async {
      const NotificationDetails plaformChannelSpecifics = NotificationDetails(
          android: AndroidNotificationDetails("channel_id", "channel_name",
              importance: Importance.high, priority: Priority.high),
          iOS: DarwinNotificationDetails());

      await flutterLocalNotificationsPlugin.show(
          id: idNotification, title: title, body: body, notificationDetails: plaformChannelSpecifics,
          payload: 'payload');
    });
  }

  Future<void> scheduleNotification(int idNotification,
      String body, int scheduleDate,  {String title = "Recordatorio"}) async {
    tz.initializeTimeZones();
    const NotificationDetails plaformChannelSpecifics = NotificationDetails(
        android: AndroidNotificationDetails("channel_id", "channel_name",
            importance: Importance.high, priority: Priority.high),
        iOS: DarwinNotificationDetails());

    await flutterLocalNotificationsPlugin.zonedSchedule(
        id: idNotification,
        title: title,
        body: body,
        scheduledDate: tz.TZDateTime.now(tz.local).add(Duration(seconds: scheduleDate)),
        notificationDetails: plaformChannelSpecifics,
        matchDateTimeComponents: DateTimeComponents.time,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
  }

  Future<void> intervalNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'repeating channel id', 'repeating channel name',
            channelDescription: 'repeating description');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.periodicallyShow(
        id: 1,
        title: 'intervalNotification',
        body: 'intervalNotification body',
        repeatInterval: RepeatInterval.everyMinute,
        notificationDetails: notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
  }

  Future<void> periodicallyNotification(int idNotification,
      String body, RepeatInterval scheduleDate,  {String title = "Recordatorio"}) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'repeating channel id', 'repeating channel name',
            channelDescription: 'repeating description');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.periodicallyShow(
        id: idNotification,
        title: title,
        body: body,
        repeatInterval: scheduleDate,
        notificationDetails: notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
  }

  Future<void> cancelNotification(int id) async {
    print(id);
    await flutterLocalNotificationsPlugin.cancel(id: id);
  }

  Future<void> cancelAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> getAllNotification() async {
    List<ActiveNotification> listNotification = await flutterLocalNotificationsPlugin.getActiveNotifications();
    print("getAllNotification---------------------------");
    for(ActiveNotification noti in listNotification){
      print(noti.id);
      print(noti.title);
      print(noti.body);
    }
    print("end getAllNotification---------------------------");

  }
}

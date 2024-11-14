import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService() {
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    if (!kIsWeb) {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);

      await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    }
  }

  // Future<void> requestPermission() async {
  //   if (kIsWeb) {
  //     if (html.Notification.permission != 'granted') {
  //       final permission = await html.Notification.requestPermission();
  //       if (permission == 'granted') {
  //         debugPrint("Notification permission granted.");
  //       } else {
  //         debugPrint("Notification permission denied.");
  //       }
  //     } else {
  //       debugPrint("Notification permission already granted.");
  //     }
  //   }
  // }

  Future<void> showNotification() async {
    if (kIsWeb) {
      // if (html.Notification.permission == 'granted') {
      //   _showBrowserNotification();
      // } else {
      //   debugPrint("Notification permission not granted.");
      // }
    } else {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'sync_channel',
        'Sync Notifications',
        channelDescription: 'Notification channel for sync reminders',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
      );

      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.show(
        0,
        'Sync Data',
        'It\'s time to sync your data!',
        platformChannelSpecifics,
        payload: 'sync_data',
      );
    }
  }

  void _showBrowserNotification() {
   // html.Notification('Sync Data', body: "It's time to sync your data!");
  }
}

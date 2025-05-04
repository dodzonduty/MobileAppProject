import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:project/features/database/Database.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<void> init() async {
    // Initialize timezone data
    tz.initializeTimeZones();

    // Request notification permissions for Android 13+
    if (Platform.isAndroid) {
      final status = await Permission.notification.request();
      if (status.isDenied) {
        print("Notification permission denied");
        return;
      }
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }



Future<void> setupNotifications() async {
  final notificationService = NotificationService();
  await notificationService.init();
}}
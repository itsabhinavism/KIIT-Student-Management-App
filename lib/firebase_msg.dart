import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Global instance for local notifications
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class FirebaseMsg {
  final msgService = FirebaseMessaging.instance;

  initFCM() async {
    debugPrint('🔔 Starting FCM initialization...');
    
    try {
      // Create notification channel for Android
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // name
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
      );

      // Initialize local notifications plugin
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      
      const InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);
      
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);

      // Create the notification channel on the device
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      // Request permissions
      final settings = await msgService.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
      debugPrint('🔔 Permission status: ${settings.authorizationStatus}');

      // Set foreground notification presentation options
      await msgService.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      var token = await msgService.getToken();
      debugPrint('🔔 FCM Token: $token');
      
      if (token == null) {
        debugPrint('⚠️ FCM Token is null!');
      }

      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(handleBackgroundNotification);
      
      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('📩 Foreground notification received');
        debugPrint('   Title: ${message.notification?.title}');
        debugPrint('   Body: ${message.notification?.body}');
        debugPrint('   Data: ${message.data}');
        
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        // If notification exists and android notification exists, show it
        if (notification != null && android != null) {
          _showNotification(message);
        }
      });
      
      // Handle notification taps when app is in background
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('📱 Notification tapped: ${message.notification?.title}');
        // TODO: Navigate to specific screen based on notification data
      });

      // Check if app was opened from a terminated state via notification
      RemoteMessage? initialMessage = await msgService.getInitialMessage();
      if (initialMessage != null) {
        debugPrint('📱 App opened from notification: ${initialMessage.notification?.title}');
        // TODO: Handle the initial message
      }
      
      debugPrint('✅ FCM initialized successfully');
    } catch (e) {
      debugPrint('❌ FCM initialization error: $e');
    }
  }

  // Show notification when app is in foreground
  Future<void> _showNotification(RemoteMessage message) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'high_importance_channel', // Must match the channel id above
        'High Importance Notifications', // Must match the channel name above
        channelDescription: 'This channel is used for important notifications.',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
        icon: '@mipmap/ic_launcher',
      );

      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.show(
        message.hashCode,
        message.notification?.title ?? 'New Notification',
        message.notification?.body ?? '',
        platformChannelSpecifics,
        payload: message.data.toString(),
      );
      
      debugPrint('✅ Notification displayed successfully');
    } catch (e) {
      debugPrint('❌ Error showing notification: $e');
    }
  }
}

// Handle notifications when app is in background/terminated
Future<void> handleBackgroundNotification(RemoteMessage message) async {
  debugPrint('📩 Background notification: ${message.notification?.title}');
}
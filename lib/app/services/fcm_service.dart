import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/services/notification_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  debugPrint("Background Message");
  debugPrint(message.messageId);
  debugPrint(message.data.toString());
}

class FCMService extends GetxService {
  static FCMService get to => Get.find();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  Future<FCMService> init() async {
    await _requestPermission();

    await _initializeLocalNotification();

    await _getToken();

    _listenTokenRefresh();

    _registerBackgroundHandler();

    _listenForeground();

    _listenNotificationTap();

    await _handleInitialMessage();

    return this;
  }

  //==============================
  // Permission
  //==============================

  Future<void> _requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
  }

  //==============================
  // Local Notification
  //==============================

  Future<void> _initializeLocalNotification() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(
      android: android,
      iOS: DarwinInitializationSettings(),
    );

    await _local.initialize(
      onDidReceiveNotificationResponse: (payload) {
        if (payload.payload != null) {
          _handlePayload(payload.payload!);
        }
      },
      settings: settings,
    );

    const channel = AndroidNotificationChannel(
      'chat_channel',
      'Chat Notifications',
      description: 'Quick Gari Notifications',
      importance: Importance.max,
    );

    await _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  //==============================
  // Device Token
  //==============================

  Future<void> _getToken() async {
    String? token = await _messaging.getToken();

    debugPrint("FCM Token:");
    debugPrint(token);

    if (token != null) {
      await _updateTokenToServer(token);
    }
  }

  void _listenTokenRefresh() {
    _messaging.onTokenRefresh.listen((token) async {
      debugPrint("Token Refreshed");
      await _updateTokenToServer(token);
    });
  }

  Future<void> _updateTokenToServer(String token) async {
    // ApiService.updateFcmToken(token);
  }

  //==============================
  // Background
  //==============================

  void _registerBackgroundHandler() {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  //==============================
  // Foreground
  //==============================

  void _listenForeground() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint("Foreground Notification");

      if (message.notification != null) {
        await _showLocalNotification(message);
      }

      // Refresh notification list
      if (Get.isRegistered<NotificationService>()) {
        Get.find<NotificationService>().refresh();
      }
    });
  }

  //==============================
  // Tap From Background
  //==============================

  void _listenNotificationTap() {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleNavigation(message.data);
    });
  }

  //==============================
  // App Killed
  //==============================

  Future<void> _handleInitialMessage() async {
    final message = await _messaging.getInitialMessage();

    if (message != null) {
      _handleNavigation(message.data);
    }
  }

  //==============================
  // Local Notification
  //==============================

  Future<void> _showLocalNotification(RemoteMessage message) async {
    await _local.show(
      id: message.hashCode,
      title: message.notification?.title,
      body: message.notification?.body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'chat_channel',
          'Chat Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      payload: message.data.toString(),
    );
  }

  //==============================
  // Navigation
  //==============================

  void _handleNavigation(Map<String, dynamic> data) {
    final type = data["type"];

    switch (type) {
      case "chat":
        // Get.toNamed(Routes.CHAT, arguments: data);
        break;

      case "ride":
        // Get.toNamed(Routes.RIDE_DETAILS, arguments: data);
        break;

      default:
        // Get.toNamed(Routes.NOTIFICATION);
        break;
    }
  }

  void _handlePayload(String payload) {
    debugPrint(payload);
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/models/notification_model.dart';
import 'package:quick_gari/app/services/api_service.dart';
import 'package:quick_gari/app/services/notification_service.dart';

@pragma('vm:entry-point')
class FCMService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  RemoteMessage? initialMessage;

  NotificationService get notificationService => Get.find();
  // Background handler
  @pragma('vm:entry-point')
  static Future<void> backgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();

    // final notificationService = NotificationService();

    // await notificationService.localNotificationInitialize();
    // await notificationService.showNotification(
    //   id: message.hashCode,
    //   title: message.notification?.title ?? "New Message",
    //   body: message.notification?.body ?? "",
    //   payload: message.data,
    // );
  }

  Future<void> initialize() async {
    // Permission
    await _fcm.requestPermission(alert: true, badge: true, sound: true);

    _fcm.onTokenRefresh.listen((newToken) async {
      await ApiService.patchFCM(newToken);
    });

    //await Clipboard.setData(ClipboardData(text: token));

    // Foreground message
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Use your existing local notification
      NotificationService().showNotification(
        id: message.hashCode,
        title: message.notification?.title ?? "Title",
        body: message.notification?.body ?? "Body",
        payload: message.data,
      );
    });

    // Notification click when app in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleNotificationClick(message);
    });
  }

  void handleNotificationClick(RemoteMessage message) async {
    final notification = NotificationModel.fromRemoteMessage(message);
    print(888888888888888888);
    print(message.messageId);
    print(message.senderId);
    print(message.senderId);
    print(message.data);
    await notificationService.notificationRedirect(notification);
  }
}

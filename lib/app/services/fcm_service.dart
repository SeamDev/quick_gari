import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/modules/ride/views/ride_proposal_view.dart';
import 'package:quick_gari/app/routes/app_pages.dart';
import 'package:quick_gari/app/services/hive_service.dart';
import 'package:quick_gari/app/services/notification_service.dart';

class FCMService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  RemoteMessage? initialMessage;

  // Background handler
  static Future<void> backgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();

    final notificationService = NotificationService();

    await notificationService.localNotificationInitialize();

    await notificationService.showNotification(
      id: message.hashCode,
      title: message.notification?.title ?? "New Message",
      body: message.notification?.body ?? "",
      payload: message.data,
    );
  }

  Future<void> initialize() async {
    // Permission
    await _fcm.requestPermission(alert: true, badge: true, sound: true);

    // Token
    final token = await _fcm.getToken() ?? "Empty";

    await HiveService.put("fcm", token);
    debugPrint("FCM TOKEN: $token");

    await Clipboard.setData(ClipboardData(text: token));

    // Foreground message
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Use your existing local notification
      NotificationService().showNotification(
        id: message.hashCode,
        title: message.notification?.title ?? "Notification",
        body: message.notification?.body ?? "",
        payload: message.data,
      );
    });

    // Notification click when app in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleNotificationClick(message);
    });

    // Notification click when app killed
    initialMessage = await _fcm.getInitialMessage();
  }

  void handleNotificationClick(RemoteMessage message) {
    final data = message.data;

    switch (data["type"]) {
      case "NEW_PROPOSAL":
        Get.to(
          () => RideProposalView(
            id: data["rideId"] ?? "",
            proposalID: data["proposalId"] ?? "",
          ),
        );
        break;

      case "PAYMENT_APPROVED":
        // Get.to(() => PaymentView());
        break;

      default:
        Get.toNamed(Routes.NOTIFICATION);
    }
  }
}

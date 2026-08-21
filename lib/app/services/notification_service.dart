import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/models/notification_model.dart';
import 'package:quick_gari/app/modules/navbar/controllers/navbar_controller.dart';
import 'package:quick_gari/app/modules/ride/views/ride_proposal_view.dart';
import 'package:quick_gari/app/routes/app_pages.dart';
import 'package:quick_gari/app/services/api_service.dart';

class NotificationService extends GetxService with WidgetsBindingObserver {
  bool _initialized = false;

  final RxBool isLoading = false.obs;
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;

  final notificationCount = 0.obs;

  NotificationResponseModel? notificationResponse;

  NavbarController get navController => Get.find<NavbarController>();

  Future<void> initialize() async {
    if (_initialized) return;

    _initialized = true;
    WidgetsBinding.instance.addObserver(this);
    refresh();
  }

  Future<void> unInit() async {
    if (!_initialized) return;

    _initialized = false;

    WidgetsBinding.instance.removeObserver(this);

    notificationResponse = null;
    NotificationModel.fromJson({});
    NotificationResponseModel.fromJson({});
    notifications.clear();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;

      final response = await ApiService.getNotifications();

      notificationResponse = NotificationResponseModel.fromJson(response);

      notifications.assignAll(notificationResponse?.data ?? []);
      notificationCount.value = notifications
          .where((notification) => !notification.isRead)
          .length;
    } catch (e) {
      Get.log("Notification Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() async {
    await fetchNotifications();
  }

  Future<bool> markAsRead(String id) async {
    final success = await ApiService.markNotificationAsRead(id);

    if (success) {
      final index = notifications.indexWhere((e) => e.id == id);

      if (index != -1) {
        notifications[index] = notifications[index].copyWith(isRead: true);

        notifications.refresh();
      }
    }

    return success;
  }

  Future<bool> markAllAsRead() async {
    final success = await ApiService.markAllNotificationsAsRead();

    if (success) {
      for (int i = 0; i < notifications.length; i++) {
        notifications[i] = notifications[i].copyWith(isRead: true);
      }
      notifications.refresh();
    }

    return success;
  }

  ///                  Local Notification

  // ignore: non_constant_identifier_names
  final FlutterLocalNotificationsPlugin _notification_plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> localNotificationInitialize() async {
    // For Android
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings("icon_notification");

    // Combine settings
    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings);

    await _notification_plugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (details) =>
          handleReceiveNotification(details),
    );

    // Check notification permission
    final android = _notification_plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    final isGranted = await android?.areNotificationsEnabled();
    if (isGranted != true) {
      await android?.requestNotificationsPermission();
    }
  }

  Future<void> showNotification({
    int id = 0,
    String title = "Title",
    String body = "Body",
    Map<String, dynamic>? payload,
    String channelId = "notification",
    String channelName = "Notification",
  }) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          channelId,
          channelName,
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _notification_plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
      payload: jsonEncode(payload ?? {}),
    );
  }

  Future<void> cancelNotification(int id) async {
    await _notification_plugin.cancel(id: id);
  }

  Future<void> cancelAllNotification() async {
    await _notification_plugin.cancelAll();
  }
  //   Notification Redirect

  void handleReceiveNotification(NotificationResponse response) async {
    final notification = NotificationModel.fromNotificationResponse(response);
    Get.offAllNamed(Routes.NAVBAR);
    await notificationRedirect(notification);
  }

  Future<void> notificationRedirect(NotificationModel notification) async {
    // if not read mark as read
    if (!notification.isRead) {
      notificationCount.value--;
      await markAsRead(notification.id);
    }
    print(notification.toJson());
    // Handle Notification Type
    switch (notification.type) {
      case "CHAT_MESSAGE":
        break;

      case "RIDE_REQUEST":
        Get.to(
          () => RideProposalView(
            id: notification.payload['rideId'],
            isFromNotification: true,
          ),
        );
        break;

      case "PAYMENT_SUBMITTED": // Admin
        break;

      case "CAR_REGISTRATION": // Admin
        break;

      case "CAR_REGISTRATION_APPROVED":
        Get.toNamed(Routes.MY_VEHICLE);
        break;

      case "RIDE_ACCEPTED":
        Get.to(
          () => RideProposalView(
            id: notification.payload['rideId'],
            isFromNotification: true,
          ),
        );
        break;

      case "PAYMENT_VERIFIED":
        break;

      case "NEW_PROPOSAL":
        Get.to(
          () => RideProposalView(
            id: notification.payload['rideId'],
            proposalID: notification.payload['proposalID'],
            isFromNotification: true,
          ),
        );
        break;

      case "PROPOSAL_ACCEPTED":
        Get.to(
          () => RideProposalView(
            id: notification.payload['rideId'],
            proposalID: notification.payload['proposalID'],
            isFromNotification: true,
          ),
        );
        break;

      case "GOT_RETURN_TRIP_BOOKING":
        break;

      case "RIDE_TAKEN":
        Get.to(
          () => RideProposalView(
            id: notification.payload['rideId'],
            isFromNotification: true,
          ),
        );
        break;

      case "RIDE_EXPIRED":
        Get.to(
          () => RideProposalView(
            id: notification.payload['rideId'],
            isFromNotification: true,
          ),
        );
        break;

      case "RETURN_EXPIRED":
        break;

      case "RIDE_CANCELLED":
        Get.to(
          () => RideProposalView(
            id: notification.payload['rideId'],
            isFromNotification: true,
          ),
        );
        break;

      case "PAYMENT_APPROVED":
        navController.currentIndex = 2;
        Get.back();
        break;

      case "PAYMENT_REJECTED":
        break;

      case "RIDE_STARTED":
        Get.to(
          () => RideProposalView(
            id: notification.payload['rideId'],
            isFromNotification: true,
          ),
        );
        break;

      default:
        Get.offAll(Routes.NOTIFICATION);
        break;
    }

    return;
  }

  ///                  Fire Base FCM

  ///                  Dispose

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }
}

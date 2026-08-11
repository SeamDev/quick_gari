import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/models/notification_model.dart';
import 'package:quick_gari/app/modules/ride/views/ride_proposal_view.dart';
import 'package:quick_gari/app/routes/app_pages.dart';
import 'package:quick_gari/app/services/api_service.dart';

class NotificationService extends GetxService with WidgetsBindingObserver {
  bool _initialized = false;

  final RxBool isLoading = false.obs;
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;

  final notificationCount = 0.obs;

  NotificationResponseModel? notificationResponse;

  Future<void> initialize() async {
    if (_initialized) return;

    _initialized = true;
    WidgetsBinding.instance.addObserver(this);

    await fetchNotifications();
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
        notifications[index] = NotificationModel(
          id: notifications[index].id,
          userId: notifications[index].userId,
          audience: notifications[index].audience,
          type: notifications[index].type,
          message: notifications[index].message,
          rideId: notifications[index].rideId,
          isRead: true,
          createdAt: notifications[index].createdAt,
          updatedAt: notifications[index].updatedAt,
          v: notifications[index].v,
          proposalID: notifications[index].proposalID,
        );

        notifications.refresh();
      }
    }

    return success;
  }

  Future<bool> markAllAsRead() async {
    final success = await ApiService.markAllNotificationsAsRead();

    if (success) {
      for (int i = 0; i < notifications.length; i++) {
        notifications[i] = NotificationModel(
          id: notifications[i].id,
          userId: notifications[i].userId,
          audience: notifications[i].audience,
          type: notifications[i].type,
          message: notifications[i].message,
          rideId: notifications[i].rideId,
          isRead: true,
          createdAt: notifications[i].createdAt,
          updatedAt: notifications[i].updatedAt,
          v: notifications[i].v,
          proposalID: notifications[i].proposalID,
        );
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

  void handleReceiveNotification(NotificationResponse details) {
    final data = jsonDecode(details.payload!);
    switch (data["type"]) {
      case "NEW_PROPOSAL":
        Get.to(
          () => RideProposalView(
            id: details.id.toString(),
            proposalID: "6a53c71e3d7ef654a03e065a",
          ),
        );
        break;
      case "PAYMENT_APPROVED":
        NotificationService().showNotification();
        break;
      default:
        Get.toNamed(Routes.NOTIFICATION);
        break;
    }
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

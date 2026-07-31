import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/models/notification_model.dart';
import 'package:quick_gari/app/services/api_service.dart';

class NotificationService extends GetxService with WidgetsBindingObserver {
  bool _initialized = false;

  final RxBool isLoading = false.obs;
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;

  NotificationResponse? notificationResponse;

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
    NotificationResponse.fromJson({});
    notifications.clear();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;

      final response = await ApiService.getNotifications();

      notificationResponse = NotificationResponse.fromJson(response);

      notifications.assignAll(notificationResponse?.data ?? []);
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
        );
      }

      notifications.refresh();
    }

    return success;
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

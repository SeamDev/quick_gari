import 'package:get/get.dart';
import 'package:quick_gari/app/models/notification_model.dart';
import 'package:quick_gari/app/services/notification_service.dart';

class NotificationController extends GetxController {
  final NotificationService notificationService =
      Get.find<NotificationService>();
  RxList<NotificationModel> get notifications =>
      notificationService.notifications;

  RxBool get isLoading => notificationService.isLoading;

  int get unreadCount => notifications.where((e) => !e.isRead).length;

  List<String> notificationType = [
    //"CHAT_MESSAGE",
    "RIDE_REQUEST",
    //"PAYMENT_SUBMITTED",
    //"CAR_REGISTRATION",
    "CAR_REGISTRATION_APPROVED",
    "RIDE_ACCEPTED",
    //"PAYMENT_VERIFIED",
    "NEW_PROPOSAL",
    "PROPOSAL_ACCEPTED",
    //"GOT_RETURN_TRIP_BOOKING",
    "RIDE_TAKEN",
    "RIDE_EXPIRED",
    //"RETURN_EXPIRED",
    "RIDE_CANCELLED",
    //"PAYMENT_APPROVED",
    //"PAYMENT_REJECTED",
    "RIDE_STARTED",
  ];

  @override
  void onInit() {
    super.onInit();
    refreshNotifications();
    notificationService.initialize();
  }

  Future<void> refreshNotifications() async {
    await notificationService.refresh();
  }

  Future<void> markAsRead(String id) async {
    await notificationService.markAsRead(id);
  }

  Future<void> markAllAsRead() async {
    await notificationService.markAllAsRead();
  }
}

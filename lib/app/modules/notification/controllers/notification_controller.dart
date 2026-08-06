import 'package:get/get.dart';
import 'package:quick_gari/app/models/notification_model.dart';
import 'package:quick_gari/app/modules/ride/views/ride_proposal_view.dart';
import 'package:quick_gari/app/services/notification_service.dart';

class NotificationController extends GetxController {
  final NotificationService _service = Get.find<NotificationService>();

  RxList<NotificationModel> get notifications => _service.notifications;

  RxBool get isLoading => _service.isLoading;

  int get unreadCount => notifications.where((e) => !e.isRead).length;

  List<String> notificationType = ["NEW_PROPOSAL"];

  @override
  void onInit() {
    super.onInit();
    refreshNotifications();
    _service.initialize();
  }

  Future<void> refreshNotifications() async {
    await _service.refresh();
  }

  Future<void> markAsRead(String id) async {
    await _service.markAsRead(id);
  }

  Future<void> markAllAsRead() async {
    await _service.markAllAsRead();
  }

  // Notifications Type wise redirect
  Future<void> notificationRedirect(NotificationModel notification) async {
    // if not read mark as read
    if (!notification.isRead) {
      await markAsRead(notification.id);
    }
    // Handle Notification Type
    switch (notification.type) {
      case "NEW_PROPOSAL":
        Get.to(
          () => RideProposalView(
            id: notification.rideId,
            proposalID: notification.proposalID,
          ),
        );
        break;
      case "PAYMENT_APPROVED":
        NotificationService().showNotification();
        break;
      default:
        break;
    }

    return;
  }
}

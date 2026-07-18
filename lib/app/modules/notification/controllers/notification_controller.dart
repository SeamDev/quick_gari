import 'package:get/get.dart';
import 'package:quick_gari/app/models/notification_model.dart';
import 'package:quick_gari/app/services/notification_service.dart';

class NotificationController extends GetxController {
  final NotificationService _service = Get.find<NotificationService>();

  RxList<NotificationModel> get notifications => _service.notifications;

  RxBool get isLoading => _service.isLoading;

  int get unreadCount => notifications.where((e) => !e.isRead).length;

  @override
  void onInit() {
    super.onInit();

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
}

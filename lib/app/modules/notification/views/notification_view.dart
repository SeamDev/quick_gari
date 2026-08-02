import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Notification",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notifications.isEmpty) {
          return const Center(
            child: Text(
              "No notifications found",
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshNotifications,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            itemCount: controller.notifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 15),
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              bool  isClickAble =controller.notificationType.contains(notification.type);
              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () async {
                  await controller.notificationRedirect(notification);
                },
                child: _notificationCard(
                  title: notification.type.replaceAll('_', ' '),
                  message: notification.message,
                  time: _timeAgo(notification.createdAt),
                  highlight: !notification.isRead,
                  isClickAble: isClickAble
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _notificationCard({
    required String title,
    required String message,
    required String time,
    bool highlight = false,
    bool isClickAble = false
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: highlight ? const Color(0xFFDBF4E3) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: highlight ? Colors.transparent : Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if(isClickAble) Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            message,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            time,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  String _timeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} sec ago';
    }

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    }

    if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    }

    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}

import 'package:get/get.dart';
import 'package:quick_gari/app/services/chat_socket_service.dart';
import 'package:quick_gari/app/services/fcm_service.dart';
import 'package:quick_gari/app/services/notification_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    //Get.put(ChatSocketService(), permanent: true);

    Get.lazyPut<ChatSocketService>(() => ChatSocketService(), fenix: true);
    Get.lazyPut<NotificationService>(() => NotificationService(), fenix: true);
    // Get.putAsync<FCMService>(
    //   () async => await FCMService().init(),
    //   permanent: true,
    // );
  }
}

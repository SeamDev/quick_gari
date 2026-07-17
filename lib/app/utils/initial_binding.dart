import 'package:get/get.dart';
import 'package:quick_gari/app/services/chat_socket_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ChatSocketService(), permanent: true);
  }
}

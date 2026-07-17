import 'package:quick_gari/app/utils/socket_event.dart';

class NotificationSocketService {

  void initialize(){

    final socket = SocketManager.instance.socket!;

    socket.off("notification");

    socket.on("notification", (data){

      // Save notification

      // Show local notification

    });

  }

}
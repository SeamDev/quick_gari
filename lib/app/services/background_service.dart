// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:quick_gari/app/services/chat_socket_service.dart';
// import 'package:quick_gari/app/services/notification_socket_service.dart';
// import '../utils/socket_event.dart';

// Future<void> initializeBackgroundService() async {
//   final service = FlutterBackgroundService();

//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       onStart: onStart,
//       isForegroundMode: true,
//       autoStart: true,
//     ),

//     iosConfiguration: IosConfiguration(),
//   );

//   service.startService();
// }

// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   await SocketManager.instance.connect();

//   //ChatSocketService.instance.initialize();

//   NotificationSocketService().initialize();
// }

import 'package:quick_gari/app/services/hive_service.dart';
import 'package:quick_gari/app/utils/api_config.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketManager {
  SocketManager._();

  static final instance = SocketManager._();

  IO.Socket? socket;

  Future<void> connect() async {
    // Already connected
    if (socket?.connected == true) return;

    // Clean up old socket if it exists
    socket?.dispose();
    socket = null;

    socket = IO.io(
      Config.baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setExtraHeaders({
            'Authorization': 'Bearer ${HiveService.getToken()}',
          })
          .disableAutoConnect()
          .enableAutoConnect()
          .build(),
    );

    socket!.connect();
  }

  void disconnect() {
    if (socket == null) return;

    socket!.disconnect();

    socket!.clearListeners();
    socket!.dispose();

    socket = null;
  }
}

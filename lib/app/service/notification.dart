import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  late IO.Socket _socket;

  /// Connect to Socket.IO server and listen for notifications
  void connect({required String serverUrl}) {
    _socket = IO.io(
      serverUrl,
      IO.OptionBuilder()
          .setTransports(['websocket']) // Use WebSocket only
          .enableAutoConnect()
          .build(),
    );

    _socket.onConnect((_) {
      debugPrint('✅ Connected to Socket.IO server');
    });

    _socket.onDisconnect((_) {
      debugPrint('❌ Disconnected from server');
    });

    // Listen to all incoming notifications
    _socket.on('receive_notification', (data) {
      debugPrint('🔔 Notification received: $data');
    });
  }

  /// Send notification to server
  void sendNotification(String message) {
    _socket.emit('send_notification', {'message': message});
  }

  /// Disconnect from server
  void disconnect() {
    _socket.disconnect();
  }
}
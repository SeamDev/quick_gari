import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/config/app_config.dart';
import 'package:quick_gari/app/utils/socket_event.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatSocketService extends GetxService with WidgetsBindingObserver {
  IO.Socket get socket => SocketManager.instance.socket!;

  Timer? _typingTimer;
  bool _isTyping = false;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    _initialized = true;
    WidgetsBinding.instance.addObserver(this);

    await SocketManager.instance.connect();

    _registerSocketEvents();
  }

  void unInit() {
    _initialized = false;

    _typingTimer?.cancel();
    _typingTimer = null;

    _isTyping = false;

    socket.offAny();
    WidgetsBinding.instance.removeObserver(this);
    SocketManager.instance.disconnect();
  }

  ///////////////////////////
  ///

  VoidCallback? onTyping;
  VoidCallback? onStopTyping;
  void Function(Map<String, dynamic> message)? onNewMessage;

  void _registerSocketEvents() {
    socket.onConnect((_) {
      debugPrint('Socket connected: ${socket.id}');

      socket.emit('user:connect', {
        'userId': AppConfig().user.id,
        'role': AppConfig().user.role,
        'isCarOwner': AppConfig().user.isCarOwner,
      });
    });

    socket.on('chat:message', _onNewMessage);
    socket.on('chat:typing', _onTyping);
    socket.on('chat:stop_typing', _onStopTyping);
    socket.on('notification:new', _onNotification);

    socket.onDisconnect((_) {
      debugPrint('Socket disconnected');
    });

    socket.onConnectError((error) {
      debugPrint('Socket error: $error');
    });
  }

  void _onNewMessage(dynamic data) {
    debugPrint('New message: $data');
      onNewMessage?.call(Map<String, dynamic>.from(data));

  }

  void _onTyping(dynamic data) {
    debugPrint('Typing: $data');
    onTyping?.call();
  }

  void _onStopTyping(dynamic data) {
    debugPrint('Typing: $data');
    onStopTyping?.call();
  }

  void _onNotification(dynamic data) {
    debugPrint('Notification: $data');
  }

  void onTextChanged({
    required String text,
    required String contextType,
    required String contextId,
    required String senderId,
    required String receiverId,
  }) {
    if (text.trim().isEmpty) {
      stopTyping(
        contextType: contextType,
        contextId: contextId,
        senderId: senderId,
        receiverId: receiverId,
      );
      return;
    }

    if (!_isTyping) {
      _isTyping = true;

      socket.emit('chat:typing', {
        'contextType': contextType,
        'contextId': contextId,
        'senderId': senderId,
        'receiverId': receiverId,
      });
    }

    _typingTimer?.cancel();

    _typingTimer = Timer(
      const Duration(seconds: 2),
      () => stopTyping(
        contextType: contextType,
        contextId: contextId,
        senderId: senderId,
        receiverId: receiverId,
      ),
    );
  }

  void stopTyping({
    required String contextType,
    required String contextId,
    required String senderId,
    required String receiverId,
  }) {
    if (!_isTyping) return;

    _isTyping = false;

    socket.emit('chat:stop_typing', {
      'contextType': contextType,
      'contextId': contextId,
      'senderId': senderId,
      'receiverId': receiverId,
    });
  }

  void sendRead({
    required String contextType,
    required String contextId,
    required String userId,
  }) {
    socket.emit('chat:read', {
      'contextType': contextType,
      'contextId': contextId,
      'userId': userId,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // switch (state) {
    //   case AppLifecycleState.resumed:
    //     if (socket.connected != false) {
    //       socket.connect();
    //     }
    //     break;

    //   case AppLifecycleState.detached:
    //     socket.disconnect();
    //     break;

    //   default:
    //     break;
    // }
  }
}

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart' as core;
import 'package:get/get.dart';
import 'package:quick_gari/app/config/app_config.dart';
import 'package:quick_gari/app/services/api_service.dart';
import 'package:quick_gari/app/services/chat_socket_service.dart';

class ChatControllerGet extends GetxController {
  late String type;
  late String id;
  late String receiver;

  RxBool isLoading = true.obs;
  final _messageIds = <String>{};
  RxMap<String, dynamic> data = <String, dynamic>{}.obs;

  final isRemoteTyping = false.obs;

  Timer? _typingTimer;

  late final core.InMemoryChatController chatController;
  final textController = TextEditingController();
  final chatSocket = Get.find<ChatSocketService>();

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    type = args['type'].toString().toLowerCase();
    id = args['Id'];
    receiver = args['driverId'];

    createChat();
    chatController = core.InMemoryChatController();
    //_loadDummyMessages();
    textController.addListener(() {
      chatSocket.onTextChanged(
        text: textController.text,
        contextType: type,
        contextId: id,
        senderId: AppConfig().user.id,
        receiverId: receiver,
      );
    });

    /////

    chatSocket.onTyping = () => showTyping();
    chatSocket.onStopTyping = () => stopTyping();
    chatSocket.onNewMessage = _onNewMessage;
    chatSocket.onRefreash = () => _refresh();

    ////
    super.onInit();
  }

  @override
  void onClose() {
    _typingTimer?.cancel();
    chatSocket.onTyping = null;
    chatSocket.onStopTyping = null;
    chatSocket.onNewMessage = null;
    chatSocket.onRefreash = null; 

    super.onClose();
  }

  void showTyping() {
    isRemoteTyping.value = true;

    _typingTimer?.cancel();

    _typingTimer = Timer(const Duration(seconds: 5), () {
      isRemoteTyping.value = false;
    });
  }

  void stopTyping() {
    _typingTimer?.cancel();
    isRemoteTyping.value = false;
  }

  Future<void> sendMessage(String text) async {
    if (!await ApiService.sendMessage(type, id, receiver, text)) {
      Get.snackbar("Failed", "Can not send message !");
    }
  }

  Future<core.User> resolveUser(String id) async {
    if (id == "1") {
      return const core.User(id: "1", name: "Me");
    }

    return const core.User(id: "2", name: "John Doe");
  }

  // Api

  void _refresh() async {
    data.value = await ApiService.getChat(type, id);
    final List<dynamic> messages = data["data"]?["messages"] ?? [];

    for (final item in messages) {
      final msg = core.TextMessage(
        id: item["_id"],
        authorId: item["senderId"]["_id"] == AppConfig().user.id ? '1' : '2',
        text: item["message"],
        createdAt: DateTime.parse(item["createdAt"]),
      );
      await chatController.insertMessage(msg);
    }
  }

  void createChat() async {
    isLoading.value = true;
    if (await ApiService.createChat(type, id)) {
      data.value = await ApiService.getChat(type, id);
      final List<dynamic> messages = data["data"]?["messages"] ?? [];

      for (final item in messages) {
        final msg = core.TextMessage(
          id: item["_id"],
          authorId: item["senderId"]["_id"] == AppConfig().user.id ? '1' : '2',
          text: item["message"],
          createdAt: DateTime.parse(item["createdAt"]),
        );
        await chatController.insertMessage(msg);
      }
    } else {
      Get.back();
      Get.snackbar("Error", "Chat Create Failed !");
    }
  }

  Future<void> _onNewMessage(Map<String, dynamic> data) async {
    if (!_messageIds.add(data['_id'])) {
      return;
    }
    // Ignore messages from other chats
    if (data['contextType'] != type) return;

    if (data['contextId'] != id) return;

    final message = core.TextMessage(
      id: data['_id'],
      authorId: data['senderId'] == AppConfig().user.id ? '1' : '2',
      text: data['message'],
      createdAt: DateTime.parse(data['createdAt']),
    );

    await chatController.insertMessage(message);
    await chatController.scrollToMessage(message.id);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/widgets/typing_indicator.dart';

import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatControllerGet> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat")),
      body: Obx(() {
  return Stack(
    children: [
      Chat(
        currentUserId: "1",
        chatController: controller.chatController,
        
        resolveUser: controller.resolveUser,
        onMessageSend: controller.sendMessage,
        builders: Builders(
          composerBuilder: (context) {
            return Composer(
              textEditingController: controller.textController,
            );
          },
        ),
      ),

      if (controller.isRemoteTyping.value)
        const Positioned(
          left: 12,
          right: 12,
          bottom: 72,
          child: Align(
            alignment: Alignment.centerLeft,
            child: TypingIndicator(),
          ),
        ),
    ],
  );
}),
    );
  }
}

enum MessageType {
  text,
  image,
  audio,
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
}

class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime createdAt;
  final MessageType type;
  final MessageStatus status;
  final bool isMe;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.createdAt,
    required this.type,
    required this.status,
    required this.isMe,
  });

  ChatMessage copyWith({
    MessageStatus? status,
  }) {
    return ChatMessage(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      message: message,
      createdAt: createdAt,
      type: type,
      status: status ?? this.status,
      isMe: isMe,
    );
  }
}
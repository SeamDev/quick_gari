import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final List<NotificationModel> data;

  NotificationResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    return NotificationResponseModel(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => NotificationModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'statusCode': statusCode,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class NotificationModel {
  final String id;
  final String userId;
  final String audience;
  final String type;
  final String message;
  final bool isRead;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Notification-specific data
  final Map<String, dynamic> payload;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.audience,
    required this.type,
    required this.message,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
    this.payload = const {},
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    // Fields that belong directly to NotificationModel
    const modelFields = {
      '_id',
      'userId',
      'audience',
      'type',
      'message',
      'isRead',
      'createdAt',
      'updatedAt',
      'payload',
    };

    // Everything else goes into payload
    final payload = <String, dynamic>{};

    for (final entry in json.entries) {
      if (!modelFields.contains(entry.key)) {
        payload[entry.key] = entry.value;
      }
    }

    // If payload already exists, merge it too
    if (json['payload'] is Map) {
      payload.addAll(Map<String, dynamic>.from(json['payload']));
    }

    return NotificationModel(
      id: json['_id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      audience: json['audience']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      message: json['message']?.toString() ?? '',

      isRead: json['isRead'] ?? false,

      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),

      updatedAt:
          DateTime.tryParse(json['updatedAt']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),

      payload: payload,
    );
  }

  // ============================================================
  // FCM RemoteMessage
  // ============================================================

  factory NotificationModel.fromRemoteMessage(RemoteMessage message) {
    final data = Map<String, dynamic>.from(message.data);

    const modelFields = {
      'notificationId',
      '_id',
      'id',
      'userId',
      'audience',
      'type',
      'message',
      'title',
      'body',
      'isRead',
      'createdAt',
      'updatedAt',
      'payload',
    };

    final payload = <String, dynamic>{};

    for (final entry in data.entries) {
      if (!modelFields.contains(entry.key)) {
        payload[entry.key] = entry.value;
      }
    }

    // If FCM itself contains a payload object.
    if (data['payload'] is Map) {
      payload.addAll(Map<String, dynamic>.from(data['payload']));
    }

    return NotificationModel(
      id:
          data['notificationId']?.toString() ??
          data['_id']?.toString() ??
          data['id']?.toString() ??
          message.messageId ??
          '',

      userId: data['userId']?.toString() ?? '',

      audience: data['audience']?.toString() ?? '',

      type: data['type']?.toString() ?? '',

      message:
          message.notification?.body ??
          data['message']?.toString() ??
          data['body']?.toString() ??
          '',

      isRead: data['isRead']?.toString() == 'true',

      createdAt:
          DateTime.tryParse(data['createdAt']?.toString() ?? '') ??
          DateTime.now(),

      updatedAt:
          DateTime.tryParse(data['updatedAt']?.toString() ?? '') ??
          DateTime.now(),

      payload: payload,
    );
  }

  // ============================================================
  // Flutter Local Notification
  // ============================================================

  factory NotificationModel.fromNotificationResponse(
    NotificationResponse response,
  ) {
    Map<String, dynamic> data = {};

    if (response.payload != null && response.payload!.isNotEmpty) {
      try {
        final decoded = jsonDecode(response.payload!);

        if (decoded is Map) {
          data = Map<String, dynamic>.from(decoded);
        }
      } catch (_) {
        // Payload wasn't JSON.
        data = {'payload': response.payload};
      }
    }

    const modelFields = {
      'notificationId',
      '_id',
      'id',
      'userId',
      'audience',
      'type',
      'message',
      'title',
      'body',
      'isRead',
      'createdAt',
      'updatedAt',
      'payload',
    };

    final payload = <String, dynamic>{};

    for (final entry in data.entries) {
      if (!modelFields.contains(entry.key)) {
        payload[entry.key] = entry.value;
      }
    }

    if (data['payload'] is Map) {
      payload.addAll(Map<String, dynamic>.from(data['payload']));
    }

    // Local notification action information
    if (response.actionId != null) {
      payload['actionId'] = response.actionId;
    }

    return NotificationModel(
      id:
          data['notificationId']?.toString() ??
          data['_id']?.toString() ??
          data['id']?.toString() ??
          response.id?.toString() ??
          '',

      userId: data['userId']?.toString() ?? '',

      audience: data['audience']?.toString() ?? '',

      type: data['type']?.toString() ?? '',

      message:
          data['message']?.toString() ??
          data['body']?.toString() ??
          data['title']?.toString() ??
          '',

      isRead: data['isRead'] == true || data['isRead']?.toString() == 'true',

      createdAt:
          DateTime.tryParse(data['createdAt']?.toString() ?? '') ??
          DateTime.now(),

      updatedAt:
          DateTime.tryParse(data['updatedAt']?.toString() ?? '') ??
          DateTime.now(),

      payload: payload,
    );
  }

  // Other

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'audience': audience,
      'type': type,
      'message': message,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'payload': payload,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? userId,
    String? audience,
    String? type,
    String? message,
    bool? isRead,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? payload,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      audience: audience ?? this.audience,
      type: type ?? this.type,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      payload: payload ?? this.payload,
    );
  }
}

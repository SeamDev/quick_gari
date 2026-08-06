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
  final String rideId;
  final String proposalID;
  final bool isRead;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.audience,
    required this.type,
    required this.message,
    required this.rideId,
    required this.proposalID,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      audience: json['audience'] ?? '',
      type: json['type'] ?? '',
      message: json['message'] ?? '',
      rideId: json['rideId'] ?? '',
      proposalID: json['proposalId'] ?? '',
      isRead: json['isRead'] ?? false,
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt:
          DateTime.tryParse(json['updatedAt']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'audience': audience,
      'type': type,
      'message': message,
      'rideId': rideId,
      'proposalId': proposalID,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }
}

class UserModel {

  String id;
  String name;
  String email;
  String phoneNumber;

  String? role;
  String? gender;
  String avatar;

  bool isCarOwner;
  bool isVerified;

  String? token;

  DateTime? createdAt;
  DateTime? updatedAt;

  UserModel({
    this.id = "--ID--",
    this.name = "--Name--",
    this.email = "--Email--",
    this.phoneNumber = "017xxxxxxxx",
    this.role = "--Role--",
    this.gender = "Others",
    this.avatar =
        "https://www.shutterstock.com/image-vector/bus-driver-wand-icon-isolated-600nw-2600303135.jpg",
    this.isCarOwner = false,
    this.isVerified = false,
    this.token,
    this.createdAt,
    this.updatedAt,
  });

  /// Create from API JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["_id"] ?? "--ID--",
      name: json["name"] ?? "--Name--",
      email: json["email"] ?? "--Email--",
      phoneNumber: json["phoneNumber"] ?? "017xxxxxxxx",
      role: json["role"],
      gender: json["gender"],
      avatar: json["avatar"] ??
          "https://www.shutterstock.com/image-vector/bus-driver-wand-icon-isolated-600nw-2600303135.jpg",
      isCarOwner: json["isCarOwner"] ?? false,
      isVerified: json["isVerified"] ?? false,
      token: json["token"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "email": email,
      "phoneNumber": phoneNumber,
      "role": role,
      "gender": gender,
      "avatar": avatar,
      "isCarOwner": isCarOwner,
      "isVerified": isVerified,
      "token": token,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
    };
  }
}
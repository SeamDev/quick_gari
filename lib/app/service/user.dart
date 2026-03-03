class User {
  String? sId;
  String? name;
  String? email;
  String? role;
  String? phoneNumber;
  String? gender;
  bool? isCarOwner;
  bool? isVerified;
  String? createdAt;
  String? updatedAt;
  int? iV;

  User(
      {this.sId,
      this.name,
      this.email,
      this.role,
      this.phoneNumber,
      this.gender,
      this.isCarOwner,
      this.isVerified,
      this.createdAt,
      this.updatedAt,
      this.iV});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    role = json['role'];
    phoneNumber = json['phoneNumber'];
    gender = json['gender'];
    isCarOwner = json['isCarOwner'];
    isVerified = json['isVerified'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    data['role'] = role;
    data['phoneNumber'] = phoneNumber;
    data['gender'] = gender;
    data['isCarOwner'] = isCarOwner;
    data['isVerified'] = isVerified;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

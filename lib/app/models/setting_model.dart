class UserSettings {
  bool? carRegistrationRequest;

  UserSettings({this.carRegistrationRequest});

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      carRegistrationRequest: json['carRegistrationRequest'],
    );
  }

  Map<String, dynamic> toJson() => {
    'carRegistrationRequest': carRegistrationRequest,
  };
}

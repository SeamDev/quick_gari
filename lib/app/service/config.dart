class Config {
  static const String appName = "";
  static const String baseUrl = "http://127.0.0.1:3000";
  static const String apiVersion = "/api/v1";
  //Auth
  static const String loginAPI = "/auth/signin";
  static const String registerAPI = "/user/register";
  static const String verifyOTPAPI = "/auth/verify-otp";
  static const String reSendOTPAPI = "/auth/resend-otp";
  static const String getUserAPI = "/auth/user-info";
  //Car
  static const String carAPI = "/car";
  //
  static const String returnTripAPI = "/return-trip";

  //Ride
  static const String rideAPI = "/ride";
  static const String rideProposalAPI = "/ride/proposal";
  static const String acceptProposalAPI = "/ride/accept-proposal";
  //Share Vehicle
  static const String shareVehicleAPI = "/share-vehicle";
  static const String shareVAvailableAPI = "/share-vehicle";
  static const String shareVDriverAPI = "/share-vehicle/driver";
}

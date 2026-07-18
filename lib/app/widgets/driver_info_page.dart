import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:quick_gari/app/config/app_config.dart';
import 'package:quick_gari/app/routes/app_pages.dart';
import 'package:quick_gari/app/services/api_service.dart';
import 'package:quick_gari/app/services/external_app_open_service.dart';
import 'package:quick_gari/app/widgets/otp_input.dart';

class DriverInfoContainer extends StatelessWidget {
  final String tripType;
  final String carImage;
  final String id;
  final String driverID;
  final String vehicleName;
  final String image;
  final String name;
  final String phone;
  final String startPoint;
  final String endPoint;
  final String fare;
  final String status;
  final String date;
  final String startTime;
  final bool isVerified;
  final Function refresh;

  const DriverInfoContainer({
    super.key,
    this.tripType = "N/A",
    this.carImage = "N/A",
    this.vehicleName = "N/A",
    this.image = "N/A",
    this.name = "N/A",
    this.phone = "N/A",
    this.startPoint = "N/A",
    this.endPoint = "N/A",
    this.fare = "N/A",
    this.status = "N/A",
    this.date = "N/A",
    this.startTime = "N/A",
    this.id = "N/A",
    this.driverID = "N/A",
    this.isVerified = false,
    required this.refresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        //color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey, width: 2),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            tripType,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 10),

          /// MAP / CAR IMAGE
          Container(
            height: 270,
            width: double.infinity,
            decoration: const BoxDecoration(color: Colors.white),
            child: Image.network(
              carImage,
              height: 270,
              width: double.infinity,
              fit: BoxFit.cover,

              /// LOADING
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }

                return const Center(child: CircularProgressIndicator());
              },

              /// ERROR
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade300,
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 70,
                      color: Colors.grey,
                    ),
                  ),
                );
              },
            ),
          ),

          /// CONTENT
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                /// CARD
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      /// VEHICLE
                      if (!AppConfig().user.isCarOwner)
                        Row(
                          children: [
                            const Icon(
                              Icons.directions_car,
                              size: 34,
                              color: Colors.green,
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Text(
                                vehicleName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 20),

                      /// DRIVER INFO
                      Row(
                        children: [
                          /// DRIVER IMAGE
                          ClipOval(
                            child: Image.network(
                              image,
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,

                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 60,
                                  width: 60,
                                  color: Colors.grey.shade300,
                                  child: const Icon(Icons.person),
                                );
                              },
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${AppConfig().user.isCarOwner ? "Passenger" : "Driver"} : $name",
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  "Phone : $phone",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      /// START POINT
                      buildInfoRow(
                        icon: Icons.location_on,
                        iconColor: Colors.green,
                        title: "Starting Point",
                        value: startPoint,
                      ),

                      const SizedBox(height: 16),

                      /// END POINT
                      buildInfoRow(
                        icon: Icons.location_on_outlined,
                        iconColor: Colors.red,
                        title: "Ending Point",
                        value: endPoint,
                      ),

                      const SizedBox(height: 16),

                      /// TIME
                      buildInfoRow(
                        icon: Icons.access_time,
                        iconColor: Colors.orange,
                        title: "Date & Time",
                        value: DateFormat('yyyy-MM-dd hh:mm a').format(
                          DateTime.parse(
                            date,
                          ).toUtc().add(const Duration(hours: 6)),
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// FARE
                      buildInfoRow(
                        icon: Icons.currency_exchange,
                        iconColor: Colors.green,
                        title: "Fare",
                        value: fare,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// BUTTONS
                Row(
                  children: [
                    /// CALL
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ExternalAppOpenService.call(phone);
                        },
                        icon: const Icon(Icons.call),
                        label: const Text("Call Driver"),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// MESSAGE
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Get.toNamed(
                            Routes.CHAT,
                            arguments: {
                              'type': tripType,
                              'Id': id,
                              'driverId': driverID,
                            },
                          );
                        },
                        icon: const Icon(Icons.message),
                        label: const Text("Message"),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// CANCEL BUTTON
                /*SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
        
                      icon: const Icon(Icons.close),
        
                      label: const Text(
                        "Cancel Ride",
                        style: TextStyle(fontSize: 18),
                      ),
        
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),*/
                if (AppConfig().user.isCarOwner && !isVerified) ...[
                  Divider(),
                  const SizedBox(height: 10),
                  Text("Verification is required to complete the trip."),
                  const SizedBox(height: 10),
                  Text(
                    "Enter OTP:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  OtpInputWidget(
                    length: 6,
                    onSubmit: (value) async {
                      Map<dynamic, dynamic> response =
                          await ApiService.tripVerifyOtp(
                            tripType: tripType == "Ride"
                                ? "ride"
                                : "return-trip",
                            rideId: id,
                            otp: value,
                          );
                      Get.snackbar("Verification", response["message"]);
                      if (response["success"]) {
                        refresh();
                      }
                    },

                    validator: (value) {
                      if (value.length < 6) {
                        return "Please enter full OTP";
                      }

                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 24),

        const SizedBox(width: 10),

        Text(
          "$title :  ",
          style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
        ),

        //const Spacer(),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

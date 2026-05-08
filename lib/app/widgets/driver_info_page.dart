import 'package:flutter/material.dart';
import 'package:quick_gari/app/service/call_service.dart';
import 'package:quick_gari/app/service/message_service.dart';

class DriverInfoContainer extends StatelessWidget {
  final Map<String, dynamic> data;

  const DriverInfoContainer({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    /// DRIVER
    final String name = data["name"] ?? "Unknown Driver";
    final String phone = data["phone"] ?? "";
    final String image = data["image"] ?? "";

    /// RIDE
    final String startPoint = data["start_point"] ?? "";
    final String endPoint = data["end_point"] ?? "";
    final String travelTime = data["travel_time"] ?? "";
    final String fare = data["fare"] ?? "";

    /// CAR
    final String vehicleName = data["vehicle_name"] ?? "";
    final String carImage = "map.png";//data["car_image"] ?? "";

    return Scaffold(
      appBar: AppBar(title: const Text("Current Ride"), centerTitle: true),

      body: SingleChildScrollView(
        child: Column(
          children: [
            /// MAP / CAR IMAGE
            Container(
              height: 270,
              width: double.infinity,
              decoration: const BoxDecoration(color: Colors.white),
              child: Image.asset(carImage,fit: BoxFit.fitWidth,) /*Image.network(
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
              ),*/
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
                                    "Driver : $name",
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
                        /*buildInfoRow(
                          icon: Icons.access_time,
                          iconColor: Colors.orange,
                          title: "Travel Time",
                          value: travelTime,
                        ),

                        const SizedBox(height: 16),*/

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
                            PhoneCallService.call(phone);
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
                            MessageService.sendMessage(phoneNumber: phone,message: "Hello Driver");
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

                  const SizedBox(height: 20),

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
                ],
              ),
            ),
          ],
        ),
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
          "$title :",
          style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
        ),

        const Spacer(),

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

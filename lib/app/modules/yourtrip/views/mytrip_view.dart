import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/config/app_config.dart';
import 'package:quick_gari/app/widgets/driver_info_page.dart';

import '../controllers/mytrip_controller.dart';

class TripView extends GetView<WalletController> {
  const TripView({super.key});

  @override
  Widget build(BuildContext context) {
    final WalletController controller = Get.put(WalletController());
    bool isOwner = AppConfig().user.isCarOwner;

    return Scaffold(
      appBar: AppBar(title: const Text("Current Ride"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.fetchData();
          },
          child: Obx(
            () => controller.isLoading.value
                ? Center(child: CircularProgressIndicator())
                : controller.dataRide.isEmpty &&
                      controller.dataReturn.isEmpty &&
                      controller.dataSVehicle.isEmpty
                ? CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: const [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(child: Text("No Ride")),
                      ),
                    ],
                  )
                : ListView.builder(
                    itemCount:
                        controller.dataRide.length +
                        controller.dataReturn.length +
                        controller.dataSVehicle.length,
                    itemBuilder: (context, index) {
                      if (index < controller.dataRide.length) {
                        String key = isOwner ? "user" : "driver";
                        final item = controller.dataRide[index];
                        return DriverInfoContainer(
                          refresh: controller.fetchData,
                          tripType: "Ride",
                          name: item[key]?["name"] ?? "N/A",
                          phone: item[key]?["phoneNumber"] ?? "N/A",
                          image: item[key]?["avatar"] ?? "N/A",
                          vehicleName: item["car"]?["carName"] ?? "N/A",
                          fare: item["fare"]?.toString() ?? "0",
                          startPoint: item["startLocation"] ?? "N/A",
                          endPoint: item["endLocation"] ?? "N/A" ?? "N/A",
                          carImage:
                              item["car"]?["features"]?["images"]?[0] ?? "N/A",
                          id: item["_id"] ?? "N/A",
                          driverID: AppConfig().user.isCarOwner
                              ? (item["user"]?["_id"]) ?? "N/A"
                              : item["driver"]?["_id"] ?? "N/A",
                          status: item["status"] ?? "N/A",
                          date: item["startTime"] ?? DateTime.now().toString(),
                          isVerified: item["rideOtpVerified"] ?? false,
                          isPaymentComplete: item["payment"] == "APPROVED",
                        );
                      } else if (index <
                          controller.dataRide.length +
                              controller.dataReturn.length) {
                        String key = isOwner ? "user" : "driver";
                        final item = controller
                            .dataRide[index - controller.dataReturn.length];
                        return DriverInfoContainer(
                          refresh: controller.fetchData,
                          tripType: "Return",
                          name: item[key]?["name"] ?? "N/A",
                          phone: item[key]?["phoneNumber"] ?? "N/A",
                          image: item[key]?["avatar"] ?? "N/A",
                          vehicleName: item["car"]?["carName"] ?? "N/A",
                          fare: item["fare"]?.toString() ?? "0",
                          startPoint: item["startLocation"] ?? "N/A",
                          endPoint: item["endLocation"] ?? "N/A" ?? "N/A",
                          carImage:
                              item["car"]?["features"]?["images"]?[0] ?? "N/A",
                          id: item["_id"] ?? "N/A",
                          driverID: AppConfig().user.isCarOwner
                              ? (item["user"]?["_id"]) ?? "N/A"
                              : item["driver"]?["_id"] ?? "N/A",
                          status: item["status"] ?? "N/A",
                          date: item["startTime"] ?? DateTime.now().toString(),
                          isVerified: item["rideOtpVerified"] ?? false,
                          isPaymentComplete: item["payment"] == "APPROVED",
                        );
                      } else {
                        String key = isOwner ? "passenger" : "driver";
                        final item =
                            controller.dataSVehicle[index -
                                controller.dataRide.length -
                                controller.dataReturn.length];
                        return DriverInfoContainer(
                          refresh: controller.fetchData,
                          tripType: "Share Vehicle",
                          name: item[key]?["name"] ?? "N/A",
                          phone: item[key]?["phoneNumber"] ?? "N/A",
                          image: item[key]?["avatar"] ?? "N/A",
                          vehicleName:
                              item["shareVehicle"]?["vehicle"]?["carName"] ??
                              "N/A",
                          fare: item["totalPrice"]?.toString() ?? "0",
                          startPoint: item["pickupStop"] != null
                              ? item["pickupStop"][0].toUpperCase() +
                                    item["pickupStop"].substring(1)
                              : "N/A",
                          endPoint: item["dropStop"] != null
                              ? item["dropStop"][0].toUpperCase() +
                                    item["dropStop"].substring(1)
                              : "N/A",
                          carImage:
                              item["shareVehicle"]?["vehicle"]?["images"]?[0] ??
                              "N/A",
                          id: item["_id"] ?? "N/A",
                          driverID: isOwner
                              ? item["driver"] ?? "N/A"
                              : item["driver"]?["_id"] ?? "N/A",

                          passengerID: item[key]["userId"],
                          status: item["status"] ?? "N/A",
                          date: item["journeyStartedAt"] ?? "N/A",
                          isVerified: item["bookingOtpVerified"] ?? false,
                          isPaymentComplete: item["payment"] == "APPROVED",
                        );
                      }
                    },
                  ),
          ),
        ),
      ),
    );
  }
}

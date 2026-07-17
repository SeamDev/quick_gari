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
    return Scaffold(
      appBar: AppBar(title: const Text("Current Ride"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.fetchData();
          },
          child: Obx(
            () => controller.dataRide.isEmpty && controller.dataReturn.isEmpty
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
                        controller.dataReturn.length +
                        controller.dataRide.length,
                    itemBuilder: (context, index) {
                      bool isReturn = index < controller.dataReturn.length;
                      bool isOwner = AppConfig().user.isCarOwner;
                      final item = isReturn
                          ? controller.dataReturn[index]
                          : controller.dataRide[index -
                                controller.dataReturn.length];
                      //print(item);
                      return DriverInfoContainer(
                        refresh: controller.fetchData,
                        tripType: isReturn ? "Return" : "Ride",
                        name:
                            item[!isOwner
                                ? "driver"
                                : isReturn
                                ? "passenger"
                                : "user"]?["name"] ??
                            "N/A",
                        phone:
                            item[!isOwner
                                ? "driver"
                                : isReturn
                                ? "passenger"
                                : "user"]?["phoneNumber"] ??
                            "N/A",
                        image:
                            item[!isOwner
                                ? "driver"
                                : isReturn
                                ? "passenger"
                                : "user"]?["avatar"] ??
                            "N/A",
                        vehicleName: item["car"]?["carName"] ?? "N/A",
                        fare: item["fare"]?.toString() ?? "0",
                        startPoint: item["startLocation"] ?? "N/A",
                        endPoint: item["endLocation"] ?? "N/A" ?? "N/A",
                        carImage:
                            item["car"]?["features"]?["images"]?[0] ?? "N/A",
                        id: item["_id"] ?? "N/A",
                        driverID: AppConfig().user.isCarOwner ? (item["user"]?["_id"]) ?? "N/A" : item["driver"]?["_id"] ?? "N/A",
                        status: item["status"] ?? "N/A",
                        date: item["startTime"] ?? "N/A",
                        isVerified:
                            item[isReturn
                                ? "retfurnOtpVerified"
                                : "rideOtpVerified"] ??
                            false,
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}

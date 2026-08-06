import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:quick_gari/app/widgets/driver_info_page.dart';

import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("History"), centerTitle: true),
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
                        final item = controller.dataRide[index];
                        String key = controller.isOwner ? "user" : "driver";

                        return DriverInfoContainer(
                          refresh: controller.fetchData,
                          tripType: "Ride",
                          name: item[key]?["name"] ?? "N/A",
                          phone: item[key]?["phoneNumber"] ?? "N/A",
                          image: item[key]?["avatar"] ?? "N/A",
                          vehicleName:
                              "${(item["car"]?["features"]?["brand"] ?? "N/A")} ${(item["car"]?["features"]?["model"] ?? "N/A")}",
                          fare: item["fare"]?.toString() ?? "0",
                          startPoint: item["startLocation"] ?? "N/A",
                          endPoint: item["endLocation"] ?? "N/A" ?? "N/A",
                          carImage:
                              item["car"]?["features"]?["images"]?[0] ?? "N/A",
                          id: item["_id"] ?? "N/A",
                          status: item["status"] ?? "N/A",
                          date: item["startTime"] ?? "N/A",
                          isVerified: true,
                        );
                      } else if (index <
                          controller.dataRide.length +
                              controller.dataReturn.length) {
                        final item = controller
                            .dataReturn[index - controller.dataRide.length];
                        String key = controller.isOwner
                            ? "passenger"
                            : "driver";

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
                          status: item["status"] ?? "N/A",
                          date: item["startTime"] ?? "N/A",
                          isVerified: true,
                        );
                      } else {
                        final item =
                            controller.dataSVehicle[index -
                                controller.dataRide.length -
                                controller.dataReturn.length];
                        String key = controller.isOwner ? "pasenger" : "driver";
                        return DriverInfoContainer(
                          refresh: controller.fetchData,
                          tripType: "Share Vechile",
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
                          status: item["status"] ?? "N/A",
                          date: item["startTime"] ?? "N/A",
                          isVerified: true,
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

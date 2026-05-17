import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/widgets/driver_info_page.dart';

import '../controllers/history_controller.dart';

class WalletView extends GetView<WalletController> {
  const WalletView({super.key});

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
            () => controller.dataReturn.isEmpty
                ? CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: const [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(child: Text("No Ride")),
                      ),
                    ],
                  )
                : ListView(
                    children: [
                      if (controller.dataReturn.isNotEmpty)
                        DriverInfoContainer(
                          name: controller.dataReturn["driver"] ?? "N/A",
                          phone: controller.dataReturn["phone"] ?? "N/A",
                          vehicleName:
                              controller.dataReturn["vehicle_name"] ?? "N/A",
                          fare:
                              controller.dataReturn["fare"]?.toString() ?? "0",
                          startPoint:
                              controller.dataReturn["start_point"] ?? "N/A",
                          endPoint: controller.dataReturn["end_point"] ?? "N/A",
                          image: controller.dataReturn["image"] ?? "",
                          id:
                              controller.dataReturn["_id"]?.toString() ??
                              "",
                          status: controller.dataReturn["status"] ?? "",
                        ),
                      if (controller.dataRide.isNotEmpty) DriverInfoContainer(),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

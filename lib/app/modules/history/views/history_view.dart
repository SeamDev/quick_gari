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
            () => controller.data.isNotEmpty
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
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return DriverInfoContainer(refresh: (){});
                    },
                  ),
          ),
        ),
      ),
    );
  }
}

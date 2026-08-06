import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/modules/my_vehicle/controllers/my_vehicle_controller.dart';

class MyVehicleView extends GetView<MyVehicleController> {
  const MyVehicleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Vehicle"),
        centerTitle: true,
        actions: [
          ElevatedButton.icon(
            onPressed: () => controller.gotoUpdatePage(),
            label: Text("Update Car"),
            icon: Icon(Icons.edit),
            style: ElevatedButton.styleFrom(foregroundColor: Colors.black),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.vehicle.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final vehicle = controller.vehicle;
        final features = vehicle['features'] ?? {};
        final registration = vehicle['vehicleRegistration'] ?? {};
        final user = vehicle['user'] ?? {};

        final List images = (features['images'] as List?) ?? [];

        const imageTitles = [
          "Front View",
          "Back View",
          "Side View",
          "Interior",
        ];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// Vehicle Image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  (features['images'] as List?)?.isNotEmpty == true
                      ? features['images'][0]
                      : '',
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 220,
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Icon(Icons.directions_car, size: 80),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                vehicle['carName'] ?? '',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(label: Text(features['brand'] ?? '')),
                  Chip(label: Text(features['model'] ?? '')),
                  Chip(label: Text("${features['manufactureYear'] ?? ''}")),
                ],
              ),

              const SizedBox(height: 20),

              _sectionCard(
                title: "Vehicle Information",
                children: [
                  _tile("Vehicle Type", features['vehicleType']),
                  _tile("Fuel Type", features['fuelType']),
                  _tile("Gear Type", features['gearType']),
                  _tile("Seat Capacity", "${features['seatCapacity']}"),
                  _tile("Manufacture Year", "${features['manufactureYear']}"),
                ],
              ),

              const SizedBox(height: 16),

              _sectionCard(
                title: "Registration",
                children: [
                  _tile(
                    "Registration Number",
                    registration['registrationNumber'],
                  ),
                  _tile("Registration Year", "${registration['registration']}"),
                ],
              ),

              const SizedBox(height: 16),

              _sectionCard(
                title: "Owner",
                children: [
                  _tile("Name", user['name']),
                  _tile("Email", user['email']),
                ],
              ),

              const SizedBox(height: 16),

              Card(
                child: ListTile(
                  title: const Text("Approval Status"),
                  trailing: Chip(
                    backgroundColor: vehicle['isApproved'] == true
                        ? Colors.green.shade100
                        : Colors.orange.shade100,
                    label: Text(
                      vehicle['isApproved'] == true ? "Approved" : "Pending",
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              _sectionCard(
                title: "Documents",
                children: [
                  _documentTile(
                    context,
                    "Driving License",
                    vehicle['drivingLicensePhoto'],
                  ),
                  _documentTile(
                    context,
                    "Tax Token",
                    registration['taxTokenPhoto'],
                  ),
                  _documentTile(
                    context,
                    "Registration Card",
                    registration['registrationCardPhoto'],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _sectionCard(
                title: "Images",
                children: List.generate(
                  images.length > 4 ? 4 : images.length,
                  (index) =>
                      _documentTile(context, imageTitles[index], images[index]),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _sectionCard({required String title, required List<Widget> children}) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _tile(String title, dynamic value) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      trailing: Text(
        value?.toString() ?? "-",
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _documentTile(BuildContext context, String title, String? image) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.description_outlined),
      title: Text(title),
      trailing: const Icon(Icons.open_in_new),
      onTap: image == null || image.isEmpty
          ? null
          : () {
              showDialog(
                context: context,
                builder: (_) => Dialog(
                  child: InteractiveViewer(
                    child: Image.network(
                      image,
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
                ),
              );
            },
    );
  }
}

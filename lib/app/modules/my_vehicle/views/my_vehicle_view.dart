import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/modules/my_vehicle/views/my_vehicle_card.dart';
import '../controllers/my_vehicle_controller.dart';

class MyVehicleView extends GetView<MyVehicleController> {
  const MyVehicleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F9D8A),
        foregroundColor: Colors.white,
        leadingWidth: 20,
        elevation: 0,
        title: const Text(
          "My Vehicles",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                showVehicleDialog(context);
              },
              child: const Text(
                "Registration",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                showAddVehicleDialog(context);
              },
              child: const Text(
                "Add New Vehicle",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F9D8A), Color(0xFF0A7F6F)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                const Text(
                  "Welcome,\nmoimelon@gmail.com",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),

                const SizedBox(height: 30),

                /// Cards
                _buildStatCard(
                  icon: Icons.directions_car,
                  title: "Total Vehicles",
                  value: "4",
                ),
                const SizedBox(height: 15),
                _buildStatCard(
                  icon: Icons.attach_money,
                  title: "Total Earnings",
                  value: "£26,200",
                ),
                const SizedBox(height: 15),
                _buildStatCard(
                  icon: Icons.event_seat,
                  title: "Booked Seats",
                  value: "7",
                ),
                const SizedBox(height: 15),
                _buildStatCard(
                  icon: Icons.check_circle,
                  title: "Booked Vehicles",
                  value: "1",
                ),
                const SizedBox(height: 25),
                const Text(
                  "Vehicle List",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                /// Multiple Vehicle Cards
                VehicleCard(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildStatCard({
  required IconData icon,
  required String title,
  required String value,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

void showVehicleDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SizedBox(
          width: 500,
          height: 600,
          child: Column(
            children: [
              /// HEADER
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xff0F9D8A),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "My Vehicles",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Your registered vehicles",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),

              /// LIST
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: const [
                    VehicleItem(name: "Toyota Prius", reg: "DH-10-1234"),
                    VehicleItem(name: "Honda Civic", reg: "DH-10-5678"),
                    VehicleItem(name: "Nissan Altima", reg: "DH-10-9101"),
                    VehicleItem(name: "Mazda CX-5", reg: "DH-10-2468"),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class VehicleItem extends StatelessWidget {
  final String name;
  final String reg;

  const VehicleItem({super.key, required this.name, required this.reg});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          /// ICON
          Container(
            height: 50,
            width: 50,
            decoration: const BoxDecoration(
              color: Color(0xffDFF3EA),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.directions_car, color: Color(0xff0F9D8A)),
          ),

          const SizedBox(width: 14),

          /// TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Registration: $reg",
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 6),
                const Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Color(0xff0F9D8A),
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      "Status: Approved",
                      style: TextStyle(color: Color(0xff0F9D8A), fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}

void showAddVehicleDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      bool isShareVehicle = true;

      List<TextEditingController> stopControllers = List.generate(
        5,
        (_) => TextEditingController(),
      );

      List<TextEditingController> timeControllers = List.generate(
        5,
        (_) => TextEditingController(),
      );

      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              width: 650,
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    /// HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Add New Vehicle",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// Vehicle Name
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Vehicle Name *",
                        hintText: "e.g., Toyota Prius",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// Model + Registration
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: "Model *",
                              hintText: "e.g., 2022",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: "Registration Number *",
                              hintText: "e.g., DH-10-1234",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// Start + End Area
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: "Starting Area *",
                              hintText: "e.g., Mirpur",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: "Ending Area *",
                              hintText: "e.g., Motijheel",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// Date + Time
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: "Departure Date *",
                              hintText: "mm/dd/yyyy",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: "Departure Time *",
                              hintText: "--:-- --",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// Seats
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: "Total Seats *",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 4, child: Text("4 Seats")),
                        DropdownMenuItem(value: 6, child: Text("6 Seats")),
                        DropdownMenuItem(value: 8, child: Text("8 Seats")),
                      ],
                      onChanged: (v) {},
                    ),

                    const SizedBox(height: 16),

                    /// Image URL
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Image URL *",
                        hintText: "https://example.com/car-image.jpg",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Vehicle Type Toggle
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isShareVehicle = true;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isShareVehicle
                                    ? Colors.blue.shade50
                                    : Colors.grey.shade100,
                                border: Border.all(
                                  color: isShareVehicle
                                      ? Colors.blue
                                      : Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text("Share Vehicle"),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isShareVehicle = false;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: !isShareVehicle
                                    ? Colors.blue.shade50
                                    : Colors.grey.shade100,
                                border: Border.all(
                                  color: !isShareVehicle
                                      ? Colors.blue
                                      : Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text("Return Vehicle"),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// Share Vehicle Options
                    if (isShareVehicle) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Share Vehicle Options",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),

                            const SizedBox(height: 12),

                            /// Price per Seat
                            TextField(
                              decoration: InputDecoration(
                                labelText: "Price per Seat (\$) *",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            const Text("Select Route (5 Stops with Time) *"),

                            const SizedBox(height: 12),

                            /// Stops
                            for (int i = 0; i < 5; i++) ...[
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: stopControllers[i],
                                      decoration: InputDecoration(
                                        labelText: "Stop ${i + 1}",
                                        hintText: "Place name",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextField(
                                      controller: timeControllers[i],
                                      decoration: InputDecoration(
                                        hintText: "--:-- --",
                                        prefixIcon: const Icon(
                                          Icons.access_time,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                            ],

                            const Text(
                              "Enter 5 places on your route with arrival time at each stop",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    /// BUTTONS
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                Color(0xFF0F9D8A),
                              ),
                              foregroundColor: WidgetStateProperty.all(
                                Colors.white,
                              ),
                              side: WidgetStateProperty.all(
                                const BorderSide(color: Colors.grey),
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                Color(0xFF0F9D8A),
                              ),
                              foregroundColor: WidgetStateProperty.all(
                                Colors.white,
                              ),
                              side: WidgetStateProperty.all(
                                const BorderSide(color: Colors.grey),
                              ),
                            ),
                            onPressed: () {},
                            child: const Text("Add Vehicle"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

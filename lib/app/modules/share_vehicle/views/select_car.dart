import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';
import 'package:intl/intl.dart';
import 'package:quick_gari/app/config/app_config.dart';
import 'package:quick_gari/app/modules/share_vehicle/views/confirm_return.dart';
import 'package:quick_gari/app/service/api_service.dart';

class SelectCar extends StatefulWidget {
  final Map<String, dynamic> data;
  const SelectCar({super.key, required this.data});

  @override
  State<SelectCar> createState() => _SelectCarState();
}

class _SelectCarState extends State<SelectCar> {
  String formatJourneyDate(String date) {
    final DateTime dt = DateTime.parse(date).toLocal();

    return DateFormat('EEE, MMM dd - hh:mm a').format(dt);
  }

  // price per seat
  int costPerSeat = 0;
  var isLoading = false;
  int selectSeat = 1;

  late List<String> locations;
  late String pickup;
  late String drop;
  late String last;

  @override
  void initState() {
    super.initState();

    final stops = widget.data["stops"] as List;

    locations = stops.map((e) => e['location'].toString()).toList();

    pickup = locations.first;
    last = drop = locations.last;

    // remove last AFTER saving it
    locations.removeLast();
    initCost();
  }

  void initCost() async {
    Map<String, dynamic> data = await ApiService.getSVCostPer(pickup, drop);
    costPerSeat = data["perSeatFare"] ?? 0;
    setState(() {});
  }

  void getCost() async {
    setState(() {
      isLoading = true;
    });
    if (pickup.isNotEmpty && drop.isNotEmpty) {
      Map<String, dynamic> data = await ApiService.getSVCostPer(pickup, drop);
      costPerSeat = data["perSeatFare"] ?? 0;
      if (data["success"] == false) {
        Get.snackbar("Failed", data["message"]);
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  List<String> getDropList(List stops, String pickup) {
    int pickupIndex = stops.indexWhere((e) => e['location'] == pickup);

    if (pickupIndex == -1) return [];

    return stops
        .skip(pickupIndex + 1)
        .map<String>((e) => e['location'].toString())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const Text(
          'Select Share Vehicle Info',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _vehicleCard(widget.data["vehicle"]["images"][0]),
          const SizedBox(height: 16),
          _driverInfo(
            widget.data["vehicle"]["carName"],
            widget.data["vehicle"]["driverName"],
          ),
          const SizedBox(height: 20),
          _dateTime(formatJourneyDate(widget.data["journeyDate"])),
          const SizedBox(height: 16),
          _routeInfo(widget.data["stops"]),
          const SizedBox(height: 16),
          _seatInfo(widget.data["availableSeats"].toString()),
          if (!AppConfig().user.isCarOwner) const SizedBox(height: 24),
          if (!AppConfig().user.isCarOwner)
            _locationField(
              title: "Pickup Location",
              icon: Icons.location_on,
              iconColor: Colors.green,
              items: locations,
              selectedValue: pickup,
              onChanged: (value) {
                setState(() {
                  pickup = value ?? locations.first;
                  drop = last;
                  getCost();
                });
              },
            ),
          if (!AppConfig().user.isCarOwner) const SizedBox(height: 16),
          if (!AppConfig().user.isCarOwner)
            _locationField(
              title: "Pickup Location",
              icon: Icons.location_on,
              iconColor: Colors.green,
              items: getDropList(widget.data["stops"], pickup),
              selectedValue: drop,
              onChanged: (value) {
                setState(() {
                  drop = value ?? last;
                  getCost();
                });
              },
            ),
          if (!AppConfig().user.isCarOwner) const SizedBox(height: 20),

          if (!AppConfig().user.isCarOwner)
            const Text(
              'Number of Seats',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          if (!AppConfig().user.isCarOwner) const SizedBox(height: 8),

          if (!AppConfig().user.isCarOwner)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: selectSeat,
                  isExpanded: true,
                  items: List.generate(
                    widget.data["availableSeats"],
                    (index) => DropdownMenuItem(
                      value: index + 1,
                      child: Text('${index + 1}'),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectSeat = value ?? 1;
                    });
                  },
                ),
              ),
            ),

          const SizedBox(height: 24),

          if (AppConfig().user.isCarOwner)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Passenger Information',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const SizedBox(height: 16),
                if ((widget.data["passengers"] as List).isEmpty)
                  Center(child: Text("No Passenger")),

                ...widget.data["passengers"].map<Widget>(
                  (stop) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _infoField(
                      label: stop['location'].toString(),
                      value: stop['arrivalTime'].toString(),
                      icon: Icons.location_on_outlined,
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 14),

          if (!AppConfig().user.isCarOwner)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  _priceRow('Price per seat', '৳$costPerSeat'),
                  const SizedBox(height: 8),
                  _priceRow('Number of seats', '×$selectSeat'),
                  const Divider(height: 24),
                  _priceRow(
                    'Total Price',
                    '৳${costPerSeat * selectSeat}',
                    isBold: true,
                  ),
                ],
              ),
            ),
          const SizedBox(height: 24),

          if (!AppConfig().user.isCarOwner)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const BookingConfirmedDialog(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(0, 153, 102, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Confirm Booking',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 🚐 Vehicle preview card
  Widget _vehicleCard(String image) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Image.network(image, height: 160, fit: BoxFit.contain),
      ),
    );
  }

  /// 👤 Driver info
  Widget _driverInfo(String carName, String driverName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          carName,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 4),
        Text('Driver: $driverName', style: TextStyle(color: Colors.black54)),
      ],
    );
  }

  /// 📅 Date & departure time
  Widget _dateTime(String date) {
    return Row(
      children: [
        Icon(Icons.access_time, color: Colors.green),
        SizedBox(width: 10),
        Text(date, style: TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  /// 📍 Route info
  Widget _routeInfo(List stops) {
    return Column(
      children: stops.map<Widget>((stop) {
        return _RouteRow(
          place: stop['location'].toString(),
          time: stop['arrivalTime'].toString(),
        );
      }).toList(),
    );
  }

  /// 👥 Seats
  Widget _seatInfo(String seat) {
    return Row(
      children: [
        Icon(Icons.person, color: Colors.green),
        SizedBox(width: 10),
        Text('Available: $seat', style: TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _locationField({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<String> items,
    required String? selectedValue,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 10),

              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedValue,
                    isExpanded: true,
                    hint: const Text(
                      "Select location",
                      style: TextStyle(color: Colors.black54),
                    ),
                    items: items.map((e) {
                      return DropdownMenuItem(value: e, child: Text(e));
                    }).toList(),
                    onChanged: onChanged,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // end
}

/// 📌 Route row widget
class _RouteRow extends StatelessWidget {
  final String place;
  final String time;

  const _RouteRow({required this.place, required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.location_on, size: 18, color: Colors.green),
          const SizedBox(width: 10),
          Text(place, style: const TextStyle(fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(time, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}

Widget _infoField({
  required String label,
  required String value,
  required IconData icon,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey),
            const SizedBox(width: 12),
            Expanded(child: Text(value)),
          ],
        ),
      ),
    ],
  );
}

Widget _priceRow(String title, String value, {bool isBold = false}) {
  return Row(
    children: [
      Text(
        title,
        style: TextStyle(
          fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      const Spacer(),
      Text(
        value,
        style: TextStyle(
          fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    ],
  );
}

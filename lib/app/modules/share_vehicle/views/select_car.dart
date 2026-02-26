import 'package:flutter/material.dart';
import 'package:quick_gari/app/modules/share_vehicle/views/confirm_return.dart';

class SelectCar extends StatelessWidget {
  const SelectCar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const Text(
          'Book Your Ride',
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
          _vehicleCard(),
          const SizedBox(height: 16),
          _driverInfo(),
          const SizedBox(height: 20),
          _dateTime(),
          const SizedBox(height: 16),
          _routeInfo(),
          const SizedBox(height: 16),
          _seatInfo(),
          const SizedBox(height: 24),
          _locationField(
            title: 'Pickup Location',
            hint: 'Select pickup location',
            icon: Icons.location_on,
            iconColor: Colors.green,
          ),
          const SizedBox(height: 16),
          _locationField(
            title: 'Drop Location',
            hint: 'Select drop location',
            icon: Icons.location_on,
            iconColor: Colors.red,
          ),
          const SizedBox(height: 20),

          const Text(
            'Number of Seats',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: 1,
                isExpanded: true,
                items: List.generate(
                  8,
                  (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Text('${index + 1}'),
                  ),
                ),
                onChanged: (value) {},
              ),
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            'Passenger Information',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),

          const SizedBox(height: 16),
          _textField(
            label: 'Full Name',
            hint: 'Enter your name',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 14),

          _textField(
            label: 'Phone Number',
            hint: '+880 1234567890',
            icon: Icons.call_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 14),

          _textField(
            label: 'Email (Optional)',
            hint: 'your@email.com',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                _priceRow('Price per seat', '৳250'),
                const SizedBox(height: 8),
                _priceRow('Number of seats', '×1'),
                const Divider(height: 24),
                _priceRow('Total Price', '৳250', isBold: true),
              ],
            ),
          ),
          const SizedBox(height: 24),

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
                backgroundColor: Color.fromRGBO(0, 153, 102,1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Confirm Booking',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
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
  Widget _vehicleCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Image.network(
          'https://loremflickr.com/150/150/profile', // replace with asset if needed
          height: 160,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  /// 👤 Driver info
  Widget _driverInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Toyota Hiace',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 4),
        Text('Driver: Abdul Rahman', style: TextStyle(color: Colors.black54)),
      ],
    );
  }

  /// 📅 Date & departure time
  Widget _dateTime() {
    return Row(
      children: const [
        Icon(Icons.access_time, color: Colors.green),
        SizedBox(width: 10),
        Text('Tue, Apr 30', style: TextStyle(fontWeight: FontWeight.w600)),
        Spacer(),
        Text('Departure: 09:10', style: TextStyle(color: Colors.black54)),
      ],
    );
  }

  /// 📍 Route info
  Widget _routeInfo() {
    return Column(
      children: const [
        _RouteRow(place: 'Rajshahi', time: '09:10'),
        _RouteRow(place: 'Godagari', time: '09:40'),
        _RouteRow(place: 'Copalpur', time: '09:00'),
      ],
    );
  }

  /// 👥 Seats
  Widget _seatInfo() {
    return Row(
      children: const [
        Icon(Icons.person, color: Colors.green),
        SizedBox(width: 10),
        Text(
          'Available: 3 / 8 seats',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  /// 📍 Pickup / Drop fields
  Widget _locationField({
    required String title,
    required String hint,
    required IconData icon,
    required Color iconColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 10),
              Text(hint, style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ),
      ],
    );
  }
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

Widget _textField({
  required String label,
  required String hint,
  required IconData icon,
  TextInputType keyboardType = TextInputType.text,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      TextField(
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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

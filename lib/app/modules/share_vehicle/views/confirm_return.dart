import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';

class BookingConfirmedDialog extends StatelessWidget {
  const BookingConfirmedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _successIcon(),
            const SizedBox(height: 16),

            const Text(
              'Booking Confirmed!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),

            const Text(
              'Your seat has been reserved. You will receive a\nconfirmation message shortly.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),

            const SizedBox(height: 20),
            _detailsCard(),
            const SizedBox(height: 20),

            _doneButton(context),
          ],
        ),
      ),
    );
  }

  /// ✅ Green success icon
  Widget _successIcon() {
    return Container(
      height: 72,
      width: 72,
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.check, size: 36, color: Colors.green),
    );
  }

  /// 📋 Booking details card
  Widget _detailsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Booking Details:',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),

          const Text('Name: MD. SEAM'),
          const SizedBox(height: 4),
          const Text('Phone: 0150'),

          const Divider(height: 24),

          _locationRow(
            icon: Icons.location_on,
            iconColor: Colors.green,
            text: 'Rajshahi',
          ),
          const SizedBox(height: 6),
          _locationRow(
            icon: Icons.location_on,
            iconColor: Colors.red,
            text: 'Godagari',
          ),

          const Divider(height: 24),

          const Text('Seats: 1'),
          const SizedBox(height: 4),
          const Text('Total: ৳250'),
        ],
      ),
    );
  }

  Widget _locationRow({
    required IconData icon,
    required Color iconColor,
    required String text,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }

  /// 🔘 Done button
  Widget _doneButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: () {
          Get.offAllNamed("/home");
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromRGBO(0, 153, 102, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          'Home',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

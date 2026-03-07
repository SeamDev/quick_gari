import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';
import 'package:intl/intl.dart';
import 'package:quick_gari/app/routes/app_pages.dart';

void showPaymentSuccessDialog(BuildContext context, int data) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => PaymentSuccessDialog(data),
  );
}

class ConfirmBookingView extends StatelessWidget {
  final Map<dynamic, dynamic> data;
  const ConfirmBookingView(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 30,
        leading: const BackButton(),
        title: const Text('Booking'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Car Info Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE9FAF3),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green.shade300),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${data["car"]["carName"]}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.orange, size: 14),
                            SizedBox(width: 4),
                            Text(
                              '4.9 (531 reviews)',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Image.network(
                    data["car"]?["features"]?["images"]?[0] ??
                        'assets/car3.png',
                    height: 45,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Starting point
            _locationRow(
              icon: Icons.location_on,
              iconColor: Colors.red,
              title: 'Starting point',
              value: '${data["startLocation"]}',
            ),

            const SizedBox(height: 12),

            // Ending point
            _locationRow(
              icon: Icons.location_on,
              iconColor: Colors.green,
              title: 'Ending point',
              value: '${data["endLocation"]}',
              trailing: const Text(
                '1.1km',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),

            const SizedBox(height: 16),

            _infoBox(
              'Date',
              DateFormat('dd-MM-yyyy').format(
                DateTime.parse(data["startTime"] ?? "2000-01-01T00:00:00.000Z"),
              ),
            ),
            const SizedBox(height: 10),
            _infoBox(
              'Time',
              DateFormat('hh-mm a').format(
                DateTime.parse(data["startTime"] ?? "2000-01-01T00:00:00.000Z"),
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Select payment method',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                _paymentCard('assets/bkash.png'),
                const SizedBox(width: 12),
                _paymentCard('assets/cash.png'),
              ],
            ),

            const SizedBox(height: 16),

            // Fare summary
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE9FAF3),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color.fromRGBO(0, 137, 85, 1)),
              ),
              child: Column(
                children: [
                  _fareRow('Driver Fare', '৳', '${data["fare"]}'),
                  _fareRow('Service Fee', '৳', '${data["fare"]}'),
                  const Divider(),
                  _fareRow('Total', '৳', '${data["fare"]}', bold: true),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Confirm button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(0, 137, 85, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () =>
                    showPaymentSuccessDialog(context, data["fare"]),
                child: const Text(
                  'Confirm Booking',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Widgets ----------------

  Widget _locationRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    Widget? trailing,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _infoBox(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$title :'),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _paymentCard(String asset) {
    return Expanded(
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Image.asset(asset, fit: BoxFit.contain),
      ),
    );
  }

  Widget _fareRow(
    String title,
    String symbol,
    String value, {
    bool bold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: bold ? FontWeight.w600 : null),
          ),
          Text(
            '$symbol $value',
            style: TextStyle(fontWeight: bold ? FontWeight.w600 : null),
          ),
        ],
      ),
    );
  }
}

class PaymentSuccessDialog extends StatelessWidget {
  final int data;
  const PaymentSuccessDialog(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success Icon
                Container(
                  height: 100,
                  width: 100,
                  decoration: const BoxDecoration(
                    color: Color(0xFFC6EEDB),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 48,
                    color: Color(0xFF00B37E),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Payment Success',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Your money has been successfully sent',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 20),

                const Text('Amount', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 6),

                Text(
                  '\$${data.toString()}',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 20),

                // Dashed Divider
                Row(
                  children: List.generate(
                    30,
                    (index) => Expanded(
                      child: Container(
                        height: 1,
                        color: index.isEven
                            ? Colors.transparent
                            : Colors.grey.shade400,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'How is your trip?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),

                const SizedBox(height: 6),

                const Text(
                  'Your feedback will help us to improve your driving experience better',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 24),

                // Feedback Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A8F55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Get.offAllNamed(Routes.NAVBAR);
                    },
                    child: const Text(
                      'Please Feedback',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:quick_gari/app/routes/app_pages.dart';
import 'package:quick_gari/app/service/api_service.dart';

class PaymentView extends StatefulWidget {
  final String name;
  final String number;
  final String fare;
  final String id;
  final String serviceFor;

  const PaymentView({
    super.key,
    required this.name,
    required this.number,
    required this.fare,
    required this.id,
    required this.serviceFor,
  });

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  final TextEditingController trxController = TextEditingController();

  void copyNumber() {
    Clipboard.setData(ClipboardData(text: "01570269334"));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Driver number copied")));
  }

  void submitPayment() async {
    if (trxController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter transaction ID")),
      );
      return;
    }

    // submit logic
    Map<String, String> body = {
      widget.serviceFor: widget.id,
      "transactionId": trxController.text.trim(),
    };
    Map response = await ApiService.postPayment(
      trxController.text.toString(),
      body,
    );
    if (!mounted) return;
    if (response['success'] ?? false) {
      showBookingSuccessDialog(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response['message'].toString())));
      return;
    }
  }

  @override
  void dispose() {
    trxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Payment", style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Payment Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Driver Information",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Number: 01570269334",
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      IconButton(
                        onPressed: copyNumber,
                        icon: const Icon(Icons.copy, size: 20),
                      ),
                    ],
                  ),

                  const Divider(height: 30),

                  Text(
                    "Fare: ৳ ${int.parse(widget.fare)*1.1}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const Divider(height: 30),

                  Text(
                    "**Please send the payment to this number and paste the transaction ID. Your request will remain pending until we receive confirmation.**",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  Text(
                    "**Payment method : Send Money**",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// Transaction ID Field
            TextField(
              controller: trxController,
              decoration: InputDecoration(
                labelText: "Transaction ID",
                hintText: "Enter your payment transaction ID",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.payment),
              ),
            ),

            const SizedBox(height: 30),

            /// Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: submitPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Submit Payment",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showBookingSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ---------- Checkmark Image ----------
                Image.asset("assets/check.png", width: 120, height: 120),

                const SizedBox(height: 25),

                // ---------- Title ----------
                const Text(
                  "Thank you",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 8),

                // ---------- Subtitle ----------
                Text(
                  "Your request is in pending",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),

                const SizedBox(height: 35),

                // ---------- Close Button ----------
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.offAllNamed(Routes.HOME);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF007F4F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      "Okay",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

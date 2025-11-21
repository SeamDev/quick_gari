import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddMoneyView extends StatelessWidget {
  const AddMoneyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Back + Title
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 20),
                    onPressed: () => Get.back(),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    "Amount",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Amount TextField
              TextField(
                decoration: InputDecoration(
                  hintText: "Enter Amount",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                ),
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 8),

              /// Add Payment Link
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Add payment Method",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// Section Title
              const Text(
                "Select Payment Method",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              /// PAYMENT CARDS

              _paymentTile(
                isSelected: true,
                logo: Image.asset("assets/visa_card.png", height: 26),
                text1: "**** **** **** 8970",
                text2: "Expires: 12/26",
              ),

              _paymentTile(
                isSelected: false,
                logo: Image.asset("assets/master_card.png", height: 26),
                text1: "**** **** **** 8970",
                text2: "Expires: 12/26",
              ),

              _paymentTile(
                isSelected: false,
                logo: Image.asset("assets/bkash_logo.png", height: 26),
                text1: "mailaddress@mail.com",
                text2: "Expires: 12/26",
              ),

              _paymentTile(
                isSelected: false,
                logo: Image.asset("assets/nagad_logo.png", height: 26),
                text1: "Cash",
                text2: "Expires: 12/26",
              ),

              const SizedBox(height: 40),

              /// CONFIRM BUTTON
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xff00894C),
                ),
                alignment: Alignment.center,
                child: const Text(
                  "Confirm",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Payment Tile Widget
  Widget _paymentTile({
    required bool isSelected,
    required Widget logo,
    required String text1,
    required String text2,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Colors.green : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          logo,
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text1,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                text2,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

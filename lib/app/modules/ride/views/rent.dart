import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/modules/ride/controllers/rent_controller.dart';

class RequestForRentPage extends StatelessWidget {
  RequestForRentPage({super.key});
  final RentController controller = Get.put(RentController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 40,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          "Request for rent",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -------- Location Cards --------
              locationCard(
                icon: Icons.location_on,
                title: "Current location",
                subtitle: "2972 Westheimer Rd. Santa Ana, Illinois 85486",
                distance: "1.1km",
                iconColor: Colors.red,
              ),

              const SizedBox(height: 12),

              locationCard(
                icon: Icons.place,
                title: "Office",
                subtitle: "1901 Thornridge Cir. Shiloh, Hawaii 81063",
                distance: "",
                iconColor: Color(0xFF007F4F),
              ),

              const SizedBox(height: 20),

              // -------- Car Card --------
              carCard(),

              const SizedBox(height: 20),

              // ---------- IF block ----------
              if (controller.charge.value) ...[
                inputField(hint: "Date"),
                const SizedBox(height: 12),

                inputField(hint: "Time"),
                const SizedBox(height: 22),
              ] else ...[
                // ---------- ELSE block ----------
                Text(
                  "No charge selected",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(90, 90, 90, 1),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Mustang/per hours",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(90, 90, 90, 1),
                      ),
                    ),
                    Text(
                      "\$200",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(90, 90, 90, 1),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Vat (5%)",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(90, 90, 90, 1),
                      ),
                    ),
                    Text(
                      "\$20",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(90, 90, 90, 1),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 22),

              const Text(
                "Select payment method",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 14),

              // ---------------- PAYMENT CARDS ----------------
              paymentCard(
                brand: "Visa",
                lastDigits: "8970",
                expiry: "Expires: 12/26",
                isSelected: true,
                color: const Color(0xFFD9F4E7),
                icon: Icons.credit_card,
              ),

              paymentCard(
                brand: "Mastercard",
                lastDigits: "8970",
                expiry: "Expires: 12/26",
                color: const Color(0xFFF3DADF),
                icon: Icons.credit_card,
              ),

              paymentCard(
                brand: "mailaddress@mail.com",
                lastDigits: "",
                expiry: "Expires: 12/26",
                color: const Color(0xFFE2EDF6),
                icon: Icons.email,
              ),

              paymentCard(
                brand: "Cash",
                lastDigits: "",
                expiry: "Expires: 12/26",
                color: const Color(0xFFECECEC),
                icon: Icons.money,
              ),

              const SizedBox(height: 24),

              // -------- Confirm Booking Button --------
              ElevatedButton(
                onPressed: () {
                  if (controller.clicked()) {
                    showBookingSuccessDialog(context, "Md. Sharif Ahmed");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF007F4F),
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Confirm Booking",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          );
        }),
      ),
    );
  }

  // ------------------ LOCATION CARD ------------------
  Widget locationCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String distance,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Color(0xFF007F4F).withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF007F4F)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),

          if (distance != "")
            Text(
              distance,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
        ],
      ),
    );
  }

  // ------------------ CAR CARD ------------------
  Widget carCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Color(0xFF007F4F).withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF007F4F)),
      ),
      child: Row(
        children: [
          // Car Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Mustang Shelby GT",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 4),
                    Text("4.9", style: TextStyle(fontSize: 13)),
                    SizedBox(width: 4),
                    Text(
                      "(531 reviews)",
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Car Image
          Image.asset(
            "assets/car3.png",
            width: 80,
            height: 50,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  // ------------------ INPUT FIELD ------------------
  Widget inputField({required String hint}) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.deepPurple, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        hint,
        style: const TextStyle(color: Colors.grey, fontSize: 15),
      ),
    );
  }

  // ------------------ PAYMENT CARD ------------------
  Widget paymentCard({
    required String brand,
    required String lastDigits,
    required String expiry,
    required IconData icon,
    required Color color,
    bool isSelected = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Color(0xFF007F4F) : Colors.transparent,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 28),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lastDigits.isNotEmpty ? "$brand •••• $lastDigits" : brand,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  expiry,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void showBookingSuccessDialog(BuildContext context, String name) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                "Your booking has been placed sent to\n$name",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),

              const SizedBox(height: 35),

              // ---------- Close Button ----------
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/modules/ride/controllers/rent_controller.dart';
import 'package:quick_gari/app/widgets/payment_widgets.dart';

class RequestForRentPage extends StatelessWidget {
  final Map<String, dynamic> data;
  final List<String> mainList;
  final String id;
  RequestForRentPage(this.data, this.mainList, this.id, {super.key});
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
          "Back",
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color.fromRGBO(226, 245, 237, 1),
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${data["car"]["carName"]} || ${data["car"]["features"]["vehicleType"]}",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "⭐ 4.9 (531 reviews)",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Image.network(
                    data["car"]["features"]["images"][0] ?? "assets/car3.png",
                    width: 110,
                  ),
                ],
              ),
            ),
            //location
            const SizedBox(height: 12),

            Row(
              children: [
                Icon(Icons.location_pin, color: Colors.red, size: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Starting point",
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                    Text(mainList[0], style: TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.location_pin, color: Colors.green, size: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ending point",
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                    Text(mainList[1], style: TextStyle(fontSize: 16)),
                  ],
                ),
                Spacer(),
                Text(
                  "11km",
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 24),
            //Date Time
            Container(
              padding: EdgeInsets.all(15),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black45),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Date          :  ${mainList[3]}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(15),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black45),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Start Time :  ${mainList[2]}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Select payment method",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset("assets/bkash.png", height: 90),
                //Image.asset("assets/cash.png", height: 90),
              ],
            ),
            const SizedBox(height: 24),
            //Detail
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Text(
                      "Driver Fare : ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Image.asset("assets/taka.png", width: 20),
                  ],
                ),

                Text(
                  data["fare"].toString(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Text(
                      "Service Fee : ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Image.asset("assets/taka.png", width: 20),
                  ],
                ),

                Text(
                  data["fare"].toString(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Text(
                      "Total \t\t\t\t\t\t\t\t\t\t\t: ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Image.asset("assets/taka.png", width: 20),
                  ],
                ),

                Text(
                  data["fare"].toString(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 24),
            const SizedBox(height: 10),

            // -------- Confirm Booking Button --------
            ElevatedButton(
              onPressed: () {
                String name = data['driver']?['name'];
                String number = data['driver']?['phoneNumber'];
                String fare = data['fare'].toString();
                Get.to(
                  () => PaymentView(
                    name: name,
                    number: number,
                    fare: fare,
                    id: id,
                  ),
                );
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
        ),
      ),
    );
  }
}

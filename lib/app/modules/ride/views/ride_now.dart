import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/modules/ride/controllers/ride_now_controller.dart';
import 'package:quick_gari/app/modules/ride/views/rent.dart';

class CarDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;
  final List<String> mainList;
  final String id;
  CarDetailPage(this.data, this.mainList, this.id, {super.key});
  final controller = Get.put(RideNowController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 30,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text("Back", style: TextStyle(color: Colors.black)),
      ),

      body: controller.isLoading.value
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    data["car"]["carName"],
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 6),

                  // Rating
                  Row(
                    children: const [
                      Icon(Icons.star, color: Colors.amber, size: 18),
                      SizedBox(width: 4),
                      Text("4.9", style: TextStyle(fontSize: 14)),
                      SizedBox(width: 4),
                      Text(
                        "(531 reviews)",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Car image + arrows
                  CarCarousel(
                    images: List<String>.from(
                      data["car"]["features"]["images"],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Specifications Title
                  /*const Text(
              "Specifications",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 12),

            // Specs Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                SpecCard(title: "Max. power", value: "250hp"),
                SpecCard(title: "Fuel", value: "10km per litre"),
                SpecCard(title: "Max. speed", value: "220km/h"),
                SpecCard(title: "0–60mph", value: "3 sec"),
              ],
            ),

            const SizedBox(height: 24),*/

                  // Car features Title
                  const Text(
                    "Car features",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 12),

                  FeatureItem(
                    title: "Model",
                    value: data["car"]?["features"]?["model"] ?? "--Error--",
                  ),
                  FeatureItem(
                    title: "Seat Capacity",
                    value:
                        "${data["car"]?["features"]?["seatCapacity"] ?? "0"}",
                  ),
                  FeatureItem(title: "AC Available", value: "Yes"),
                  FeatureItem(
                    title: "Fuel type",
                    value: data["car"]?["features"]?["fuelType"] ?? "--Error--",
                  ),
                  FeatureItem(
                    title: "Gear type",
                    value: data["car"]?["features"]?["gearType"] ?? "--Error--",
                  ),

                  const SizedBox(height: 12),

                  // Driver Information
                  const Text(
                    "Driver Info.",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Center(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Image.network(
                            data["driver"]?["avatar"] ?? "https://www.shutterstock.com/image-vector/bus-driver-wand-icon-isolated-600nw-2600303135.jpg",
                            width: 100,
                            height: 100,
                          ),
                          Text(
                            "Driver Name :  ${data["driver"]?["name"]}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            "Phone Number :   ${data["driver"]?["phoneNumber"]}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF007F4F)),
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text(
                            "Book later",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF007F4F),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF007F4F),

                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () =>
                              Get.to(() => RequestForRentPage(data, mainList,id)),
                          child: const Text(
                            'Ride Now',
                            style: TextStyle(fontSize: 22, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }
}

class SpecCard extends StatelessWidget {
  final String title;
  final String value;

  const SpecCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFF007F4F)),
      ),
      child: Column(
        children: [
          const Icon(Icons.directions_car, size: 20, color: Color(0xFF007F4F)),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final String title;
  final String value;
  final Color borderColor;

  const FeatureItem({
    super.key,
    required this.title,
    required this.value,
    this.borderColor = const Color(0xFF007F4F),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class CarCarousel extends StatefulWidget {
  final List<String> images; // List of image paths
  const CarCarousel({super.key, required this.images});
  @override
  State<CarCarousel> createState() => _CarCarouselState();
}

class _CarCarouselState extends State<CarCarousel> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  void _previousImage() {
    if (currentIndex > 0) {
      currentIndex--;
      _pageController.animateToPage(
        currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {}); // Update UI to hide/show buttons
    }
  }

  void _nextImage() {
    if (currentIndex < widget.images.length - 1) {
      currentIndex++;
      _pageController.animateToPage(
        currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {}); // Update UI to hide/show buttons
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200, // Adjust as needed
      child: Row(
        children: [
          // Previous button: hide if first image
          if (currentIndex != 0)
            IconButton(
              onPressed: _previousImage,
              icon: const Icon(Icons.arrow_left, size: 40),
            )
          else
            const SizedBox(width: 40), // Keep spacing
          // Carousel
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: (index) {
                setState(() => currentIndex = index);
              },
              itemBuilder: (context, index) {
                return Image.network(
                  widget.images[currentIndex],
                  fit: BoxFit.contain,
                );
              },
            ),
          ),

          // Next button: hide if last image
          if (currentIndex != widget.images.length - 1)
            IconButton(
              onPressed: _nextImage,
              icon: const Icon(Icons.arrow_right, size: 40),
            )
          else
            const SizedBox(width: 40), // Keep spacing
        ],
      ),
    );
  }
}

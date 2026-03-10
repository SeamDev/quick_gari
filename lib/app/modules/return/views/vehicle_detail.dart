import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/modules/return/views/book_now.dart';

class CarDetailsView extends StatelessWidget {
  final Map<dynamic, dynamic> data;
  const CarDetailsView(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text(''),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              '${data["car"]["carName"]}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),

            Row(
              children: const [
                Icon(Icons.star, color: Colors.orange, size: 16),
                SizedBox(width: 4),
                Text('4.9 (531 reviews)', style: TextStyle(color: Colors.grey)),
              ],
            ),

            const SizedBox(height: 16),

            // Car image + arrows
            CarCarousel(
              images: List<String>.from(data["car"]["features"]["images"]),
            ),

            const SizedBox(height: 16),

            const Text(
              'Car features',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),

            _featureRow('Model', '${data["car"]["features"]["model"]}'),
            _featureRow('Seat Capacity', '${data["car"]["features"]["seatCapacity"]} seat'),
            _featureRow('AC Available', 'Yes/No'),
            _featureRow('Fuel type', '${data["car"]["features"]["fuelType"]}'),
            _featureRow('Gear type', '${data["car"]["features"]["gearType"]}'),

            const SizedBox(height: 16),

            const Text(
              'Driver Info.',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE9FAF3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage( data["driver"]["avatar"] ?? "https://www.shutterstock.com/image-vector/bus-driver-wand-icon-isolated-600nw-2600303135.jpg"),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Driver Name : ${data["driver"]?["name"]}'),
                      SizedBox(height: 4),
                      Text(
                        'Phone : ${data["driver"]?["phoneNumber"]}',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color.fromRGBO(0, 137, 85, 1),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      fixedSize: Size(0, 50),
                    ),
                    onPressed: () => Get.back(),
                    child: const Text(
                      'book late',
                      style: TextStyle(color: Color.fromRGBO(0, 137, 85, 1)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(0, 137, 85, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      fixedSize: Size(0, 50),
                    ),

                    onPressed: () => Get.to(() => ConfirmBookingView(data)),
                    child: const Text(
                      'Book Now',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureRow(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE9FAF3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
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

import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:quick_gari/app/service/api_service.dart';
import 'package:quick_gari/app/widgets/driver_info_page.dart';

class WalletController extends GetxController {
  RxList<Map<String, dynamic>> rides = <Map<String, dynamic>>[].obs;

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  /// FETCH ALL RIDES
  Future<void> fetchData() async {
    try {
      isLoading.value = true;

      final results = await Future.wait([
        ApiService.getUserRideList(),
        ApiService.getAllReturnTrip(),
      ]);

      /// FILTER ACCEPTED RIDES
      List<Map<String, dynamic>> filterAccepted(dynamic rawList) {
        if (rawList == null || rawList is! Iterable) {
          return [];
        }

        return rawList
            .where((ride) => ride["status"] == "ACCEPTED")
            .map<Map<String, dynamic>>(
              (ride) => Map<String, dynamic>.from(ride),
            )
            .toList();
      }

      final userRides = filterAccepted(results[0]);
      final returnTrips = filterAccepted(results[1]);

      rides.assignAll([
        ...userRides,
        ...returnTrips,
      ]);
    } catch (e) {
      debugPrint("Fetch Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// GO TO DRIVER PAGE
  Future<void> gotoDriver({
    required String rideId,
    required String driverId,
  }) async {
    try {
      isLoading.value = true;

      /// API CALL
      final response =
          await ApiService.getUserRideProposalList(rideId);

      /// API DATA
      final ride = response["data"] ?? response;

      /// PROPOSALS
      final List proposals = ride["proposals"] ?? [];

      Map<String, dynamic>? selectedProposal;

      /// FIND DRIVER
      for (var item in proposals) {
        if (item["driver"]["_id"] == driverId) {
          selectedProposal = item;
          break;
        }
      }

      if (selectedProposal == null) {
        Get.snackbar(
          "Error",
          "Driver not found",
        );
        return;
      }

      /// DRIVER
      final driver = selectedProposal["driver"] ?? {};

      /// CAR
      final car = selectedProposal["car"] ?? {};

      /// FEATURES
      final features = car["features"] ?? {};

      /// CAR IMAGES
      final List images = features["images"] ?? [];

      final String carImage =
          images.isNotEmpty ? images.first : "";

      /// UI DATA
      final Map<String, dynamic> data = {
        /// DRIVER
        "name": driver["name"] ?? "",
        "phone": driver["phoneNumber"] ?? "",
        "image": driver["avatar"] ?? "",

        /// RIDE
        "start_point": ride["startLocation"] ?? "",
        "end_point": ride["endLocation"] ?? "",

        /// CAR
        "vehicle_name": car["carName"] ?? "",
        "car_image": carImage,

        /// FARE
        "fare": "${selectedProposal["fare"] ?? 0} tk",

        /// EXTRA
        "travel_time": "4h 35 min",
      };

      /// NAVIGATE
      Get.to(
        () => DriverInfoContainer(
          data: data,
        ),
      );
    } catch (e) {
      debugPrint("Goto Driver Error: $e");

      Get.snackbar(
        "Error",
        "Something went wrong",
      );
    } finally {
      isLoading.value = false;
    }
  }
}
import 'package:get/get.dart';
import 'package:quick_gari/app/service/api_service.dart';

class RideProposalController extends GetxController {
  RxBool isLoading = false.obs;
  RxMap<String, dynamic> dataList = <String, dynamic>{
    "_id": "69a833548ff2811a1ee7e6cd",
    "user": "698b0a7a8a0e47d876e665a0",
    "startLocation": "Rajshahi University",
    "endLocation": "Shaheb Bazar",
    "date": "2026-03-03T18:00:00.000Z",
    "startTime": "2026-03-04T13:27:00.000Z",
    "proposals": [
      {
        "driver": {
          "_id": "698b0a7a8a0e47d876e665a0",
          "name": "Shahin Ali",
          "phoneNumber": "01723981861",
        },
        "car": {
          "_id": "698b0d428a0e47d876e665a7",
          "carName": "Toyota Corolla 2020",
          "features": {
            "vehicleType": "Sedan",
            "model": "Corolla",
            "brand": "Toyota",
            "fuelType": "Petrol",
            "gearType": "Automatic",
            "images": [
              "https://res.cloudinary.com/dgx2bfnii/image/upload/v1770720577/car-images/epadlgoiuonk4xofhgbb.webp",
              "https://res.cloudinary.com/dgx2bfnii/image/upload/v1770720577/car-images/qs0ityolsydxqda3skll.jpg",
            ],
            "seatCapacity": 5,
            "manufactureYear": 2020,
            "_id": "698b0d428a0e47d876e665a8",
          },
          "user": "698b0a7a8a0e47d876e665a0",
        },
        "fare": 400,
        "createdAt": "2026-03-06T05:19:14.185Z",
        "_id": "69aa63d20178450a8f48eaa2",
      },
    ],
  }.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void rideInfo() async {
    String rideID = "69a832478ff2811a1ee7e6c3";
    await ApiService.getRideByID(rideID);
  }
}

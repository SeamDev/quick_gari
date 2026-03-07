import 'package:get/get.dart';

class ReturnController extends GetxController {
  List<Map> data = [
    {
      "_id": "69ac002192380ff8b4927b85",
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
        "vehicleRegistration": {
          "registrationNumber": "DHAKA-MA-11-2234",
          "registration": 2020,
          "taxTokenPhoto":
              "https://res.cloudinary.com/dgx2bfnii/image/upload/v1770720577/car-images/b0sfa3mlqlmx5dzdxstv.jpg",
          "registrationCardPhoto":
              "https://res.cloudinary.com/dgx2bfnii/image/upload/v1770720577/car-images/xyrzj8eiccqhli1cjfdc.webp",
          "_id": "698b0d428a0e47d876e665a9",
        },
        "drivingLicensePhoto":
            "https://res.cloudinary.com/dgx2bfnii/image/upload/v1770720577/car-images/croavlfznlti2gqoah7m.webp",
        "user": "698b0a7a8a0e47d876e665a0",
        "isApproved": true,
        "isDeleted": false,
        "createdAt": "2026-02-10T10:49:38.906Z",
        "updatedAt": "2026-02-10T10:55:01.885Z",
        "__v": 0,
      },
      "driver": {
        "avatar": null,
        "_id": "698b0a7a8a0e47d876e665a0",
        "name": "Shahin Ali",
        "phoneNumber": "01723981861",
      },
      "startLocation": "Rajshahi University",
      "endLocation": "Shaheb Bazar",
      "date": "2026-02-10T00:00:00.000Z",
      "startTime": "2026-02-01T10:30:00.000Z",
      "fare": 500,
      "payment": "PENDING",
      "status": "AVAILABLE",
      "createdAt": "2026-03-07T10:38:25.170Z",
      "updatedAt": "2026-03-07T10:38:25.170Z",
    },
  ];

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
}

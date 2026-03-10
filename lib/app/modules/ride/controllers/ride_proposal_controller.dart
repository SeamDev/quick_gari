import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quick_gari/app/service/api_service.dart';

class RideProposalController extends GetxController {
  bool isLoading = true;
  Map<String, dynamic> dataList = <String, dynamic>{};
  List<String> mainList = [];



  final String id;
  RideProposalController(this.id);

  @override
  void onInit() {
    getUserRideProposalList();
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

  void getUserRideProposalList() async {
    dataList = await ApiService.getUserRideProposalList(id);
    isLoading = false;
    mainList = [
      dataList["startLocation"] ?? "--Error--",
      dataList["endLocation"] ?? "--Error--",
      DateFormat("dd-MM-yyyy   hh:mm a").format(
        DateTime.parse(
          dataList["startTime"] ?? "2000-01-01T00:00:00.000Z",
        ).toLocal(),
      ),
      DateFormat("dd-MM-yyyy   hh:mm a").format(
        DateTime.parse(
          dataList["date"] ?? "2000-01-01T00:00:00.000Z",
        ).toLocal(),
      ),
    ];
    update();
  }
}

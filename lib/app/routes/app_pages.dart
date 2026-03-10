import 'package:get/get.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/emergency/bindings/emergency_binding.dart';
import '../modules/emergency/views/emergency_view.dart';
import '../modules/favourite/bindings/favourite_binding.dart';
import '../modules/favourite/views/favourite_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/load/bindings/load_binding.dart';
import '../modules/load/views/load_view.dart';
import '../modules/my_vehicle/bindings/my_vehicle_binding.dart';
import '../modules/my_vehicle/views/my_vehicle_view.dart';
import '../modules/navbar/bindings/navbar_binding.dart';
import '../modules/navbar/views/navbar_view.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/offer/bindings/offer_binding.dart';
import '../modules/offer/views/offer_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/register_vehicle/bindings/register_vehicle_binding.dart';
import '../modules/register_vehicle/views/register_vehicle_view.dart';
import '../modules/return/bindings/return_binding.dart';
import '../modules/return/views/return_view.dart';
import '../modules/ride/bindings/ride_binding.dart';
import '../modules/ride/views/ride_view.dart';
import '../modules/share_vehicle/bindings/share_vehicle_binding.dart';
import '../modules/share_vehicle/views/share_vehicle_view.dart';
import '../modules/wallet/bindings/wallet_binding.dart';
import '../modules/wallet/views/wallet_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.AUTH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.NAVBAR,
      page: () => const NavbarView(),
      binding: NavbarBinding(),
    ),
    GetPage(
      name: _Paths.RIDE,
      page: () => const RideView(),
      binding: RideBinding(),
    ),
    GetPage(
      name: _Paths.LOAD,
      page: () => const LoadView(),
      binding: LoadBinding(),
    ),
    GetPage(
      name: _Paths.EMERGENCY,
      page: () => const EmergencyView(),
      binding: EmergencyBinding(),
    ),
    GetPage(
      name: _Paths.RETURN,
      page: () => const ReturnView(),
      binding: ReturnBinding(),
    ),
    GetPage(
      name: _Paths.SHARE_VEHICLE,
      page: () => const ShareVehicleView(),
      binding: ShareVehicleBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.FAVOURITE,
      page: () => const FavouriteView(),
      binding: FavouriteBinding(),
    ),
    GetPage(
      name: _Paths.OFFER,
      page: () => const OfferView(),
      binding: OfferBinding(),
    ),
    GetPage(
      name: _Paths.WALLET,
      page: () => const WalletView(),
      binding: WalletBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER_VEHICLE,
      page: () =>  RegisterVehicleView(),
      binding: RegisterVehicleBinding(),
    ),
    GetPage(
      name: _Paths.MY_VEHICLE,
      page: () => const MyVehicleView(),
      binding: MyVehicleBinding(),
    ),
  ];
}

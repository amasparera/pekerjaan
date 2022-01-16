import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/onboard/bindings/onboard_binding.dart';
import '../modules/onboard/views/onboard_view.dart';
import '../modules/pekerjaan/bindings/pekerjaan_binding.dart';
import '../modules/pekerjaan/views/pekerjaan_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/seacrh/bindings/seacrh_binding.dart';
import '../modules/seacrh/views/seacrh_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // ignore: non_constant_identifier_names
  static String? INITIAL() {
    // AuthUser().signOut();
    User? auth = FirebaseAuth.instance.currentUser;
    return (auth == null) ? Routes.ONBOARD : Routes.HOME;
  }

  static final routes = [
    GetPage(
        name: _Paths.HOME,
        page: () => const HomeView(),
        binding: HomeBinding(),
        transition: Transition.fade),
    GetPage(
        name: _Paths.PEKERJAAN,
        page: () => const PekerjaanView(),
        binding: PekerjaanBinding(),
        transition: Transition.rightToLeft),
    GetPage(
        name: _Paths.LOGIN,
        page: () => const LoginView(),
        binding: LoginBinding(),
        transition: Transition.fadeIn),
    GetPage(
        name: _Paths.PROFILE,
        page: () => const ProfileView(),
        binding: ProfileBinding(),
        transition: Transition.fadeIn),
    GetPage(
      name: _Paths.SEACRH,
      page: () => const SeacrhView(),
      binding: SeacrhBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARD,
      page: () => OnboardView(),
      binding: OnboardBinding(),
    ),
  ];
}

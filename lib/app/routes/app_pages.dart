import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'package:pekerjaan/app/modules/profile/bindings/profile_binding.dart';
import 'package:pekerjaan/app/modules/profile/views/profile_view.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/pekerjaan/bindings/pekerjaan_binding.dart';
import '../modules/pekerjaan/views/pekerjaan_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // ignore: non_constant_identifier_names
  static String? INITIAL() {
    // AuthUser().signOut();
    User? auth = FirebaseAuth.instance.currentUser;
    return (auth == null) ? Routes.LOGIN : Routes.HOME;
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
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
  ];
}

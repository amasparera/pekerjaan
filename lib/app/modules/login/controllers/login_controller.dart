import 'package:get/get.dart';
import 'package:pekerjaan/app/data/firebase/auth_google.dart';

class LoginController extends GetxController with GetTickerProviderStateMixin {
  double opacity = 0.0;

  void login() {
    AuthUser().signInWithGoogle();
  }

  @override
  void onReady() {
    Future.delayed(const Duration(seconds: 3), () {
      opacity = 1;
      update();
    });
    super.onReady();
  }
}

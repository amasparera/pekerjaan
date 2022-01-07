import 'package:get/get.dart';
import 'package:pekerjaan/app/data/firebase/auth_google.dart';

class LoginController extends GetxController {
  void login() {
    AuthUser().signInWithGoogle();
  }
}

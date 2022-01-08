import 'package:get/get.dart';
import 'package:pekerjaan/app/data/firebase/auth_google.dart';
import 'package:pekerjaan/app/data/getstore/myuser.dart';
import 'package:pekerjaan/app/data/model/myuser.dart';

class ProfileController extends GetxController {
  UserModel myUser = UserModel();

  iniUser() {
    Myuser ini = Myuser();
    myUser.email = ini.loadEmail();
    myUser.id = ini.loadUserId();
    myUser.name = ini.loadDisplayName();
    myUser.username = ini.loadUserName();
  }

  void logOut() {
    AuthUser().signOut();
  }

  @override
  void onInit() async {
    await iniUser();
    super.onInit();
  }
}
